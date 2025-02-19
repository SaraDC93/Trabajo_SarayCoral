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

header("Content-Type: application/json");

// Encabezados CORS (si es necesario, agregar aquí)

$headers = getallheaders();
$pdo = conectarDB();

if (!isset($headers['Authorization'])) {
    die(json_encode(["error" => "Acceso denegado"]));
}

$token = str_replace("Bearer ", "", $headers['Authorization']);
try {
    $decoded = JWT::decode($token, new Key($_ENV['JWT_SECRET'], 'HS256'));

    // Obtener alquileres del usuario (método GET)
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $stmt = $pdo->prepare("SELECT * FROM alquileres WHERE usuario_id = ?");
        $stmt->execute([$decoded->user_id]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    }

    // Realizar un alquiler de película (método POST)
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents("php://input"), true);

        if (!isset($input['pelicula_id'])) {
            echo json_encode(["error" => "Faltan datos"]);
            exit;
        }

        // Verificar si el usuario ya tiene alquilada la misma película y no la ha devuelto
        $stmt = $pdo->prepare("SELECT * FROM alquileres WHERE usuario_id = ? AND pelicula_id = ? AND estado = 'Alquilada'");
        $stmt->execute([$decoded->user_id, $input['pelicula_id']]);
        $alquilerExistente = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($alquilerExistente) {
            echo json_encode(["error" => "Ya tienes esta película alquilada"]);
            exit;
        }

        // Verificar que la película está disponible en el inventario
        $stmt = $pdo->prepare("SELECT cantidad_disponible FROM inventario_peliculas WHERE pelicula_id = ?");
        $stmt->execute([$input['pelicula_id']]);
        $inventario = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($inventario && $inventario['cantidad_disponible'] > 0) {
            // Calcular fechas: se alquila hoy y se establece fecha de devolución en 7 días
            $fecha_alquiler = new DateTime();
            // Para guardar la fecha de alquiler actual, reiniciamos el objeto después de modificarlo para la devolución:
            $fecha_alquiler_str = $fecha_alquiler->format('Y-m-d');
            $fecha_devolucion = (new DateTime())->modify('+7 day')->format('Y-m-d');

            // Insertar alquiler en la base de datos
            $stmt = $pdo->prepare("INSERT INTO alquileres (usuario_id, pelicula_id, fecha_alquiler, fecha_devolucion) VALUES (?, ?, ?, ?)");
            $stmt->execute([$decoded->user_id, $input['pelicula_id'], $fecha_alquiler_str, $fecha_devolucion]);

            // Actualizar inventario, reducir la cantidad disponible en 1
            $stmt = $pdo->prepare("UPDATE inventario_peliculas SET cantidad_disponible = cantidad_disponible - 1 WHERE pelicula_id = ?");
            $stmt->execute([$input['pelicula_id']]);

            echo json_encode(["message" => "Película alquilada hasta $fecha_devolucion"]);
        } else {
            echo json_encode(["error" => "La película no está disponible para alquiler en este momento."]);
        }
    }

    // Devolver una película (método PUT)
    if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
        $input = json_decode(file_get_contents("php://input"), true);

        if (!isset($input['alquiler_id'])) {
            echo json_encode(["error" => "Faltan datos"]);
            exit;
        }

        $stmt = $pdo->prepare("UPDATE alquileres SET estado = 'Devuelta', fecha_devolucion = CURRENT_TIMESTAMP WHERE id = ?");
        $stmt->execute([$input['alquiler_id']]);

        // Actualizar inventario: Incrementar la cantidad disponible de la película
        $pdo->prepare("UPDATE inventario_peliculas SET cantidad_disponible = cantidad_disponible + 1 WHERE pelicula_id = (SELECT pelicula_id FROM alquileres WHERE id = ?)")
            ->execute([$input['alquiler_id']]);

        echo json_encode(["message" => "Película devuelta"]);
    }
} catch (Exception $e) {
    echo json_encode(["error" => "Token inválido"]);
}
?>
