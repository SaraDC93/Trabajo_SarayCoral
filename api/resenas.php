<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/error.log');
error_reporting(E_ALL);

require 'database.php';
require_once '../vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// Agregar cabeceras CORS para permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Manejo de solicitudes OPTIONS (preflight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

header("Content-Type: application/json");

$headers = getallheaders();
$pdo = conectarDB();

if (!isset($headers['Authorization'])) {
    die(json_encode(["error" => "Acceso denegado"]));
}

$token = str_replace("Bearer ", "", $headers['Authorization']);

try {
    $decoded = JWT::decode($token, new Key($_ENV['JWT_SECRET'], 'HS256'));

    // Obtener reseñas de una película (método GET)
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['pelicula_id'])) {
        // Consultar reseñas sin necesidad de mostrar nombre de usuario
        $pelicula_id = $_GET['pelicula_id'];
        
        // Modificación: solo seleccionamos la calificación y el comentario
        $stmt = $pdo->prepare("SELECT calificacion, comentario FROM resenas WHERE pelicula_id = ?");
        $stmt->execute([$pelicula_id]);

        // Obtenemos todas las reseñas de la película
        $resenas = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if (empty($resenas)) {
            echo json_encode(["message" => "No hay reseñas para esta película"]);
        } else {
            // Devolver las reseñas con su calificación y comentario
            echo json_encode(['resenas' => $resenas]);
        }
        exit;
    }

    // Agregar reseña (método POST)
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents("php://input"), true);

        if (!isset($input['pelicula_id'], $input['calificacion'])) {
            echo json_encode(["error" => "Faltan datos"]);
            exit;
        }

        if ($input['calificacion'] < 1 || $input['calificacion'] > 5) {
            echo json_encode(["error" => "La calificación debe estar entre 1 y 5"]);
            exit;
        }

        // Verificar si el usuario ya ha calificado esta película
        $stmt = $pdo->prepare("SELECT id FROM resenas WHERE usuario_id = ? AND pelicula_id = ?");
        $stmt->execute([$decoded->user_id, $input['pelicula_id']]);
        $existingReview = $stmt->fetch();

        if ($existingReview) {
            echo json_encode(["error" => "Ya has calificado esta película anteriormente"]);
            exit;
        }

        // Si no ha calificado, insertar la reseña
        $stmt = $pdo->prepare("INSERT INTO resenas (usuario_id, pelicula_id, calificacion, comentario) VALUES (?, ?, ?, ?)");
        $stmt->execute([$decoded->user_id, $input['pelicula_id'], $input['calificacion'], $input['comentario'] ?? null]);

        echo json_encode(["message" => "Reseña agregada"]);
        exit;
    }

    // Si se usa otro método HTTP, se devuelve error
    echo json_encode(["error" => "Método no permitido"]);
} catch (Exception $e) {
    echo json_encode(["error" => "Token inválido"]);
}
?>
