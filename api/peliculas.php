<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/error.log');
error_reporting(E_ALL);

require_once 'database.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Obtener token del usuario desde la cabecera de autorización
$headers = getallheaders();
$token = isset($headers['Authorization']) ? str_replace('Bearer ', '', $headers['Authorization']) : null;

try {
    $pdo = conectarDB();

    // Decodificar el token para obtener el ID del usuario (asumiendo que el token tiene un campo 'user_id')
    if ($token) {
        // Agrega tu lógica aquí para decodificar el token (JWT) y obtener el 'user_id'
        // Ejemplo (puedes usar la librería de Firebase JWT como lo hiciste anteriormente)
        // $decoded = JWT::decode($token, new Key($_ENV['JWT_SECRET'], 'HS256'));
        // $user_id = $decoded->user_id;

        // Para este ejemplo, asumimos que el user_id está disponible en la variable $user_id
        // Aquí deberías reemplazar $user_id con el valor real del usuario (de tu lógica JWT)

        $user_id = 1; // REEMPLAZA con el valor de user_id del token JWT real
    } else {
        $user_id = null;
    }

    // Modificar la consulta para obtener la fecha_devolucion del alquiler solo si el usuario ya la alquiló
    $stmt = $pdo->query("
        SELECT p.*, a.fecha_devolucion 
        FROM peliculas p 
        LEFT JOIN alquileres a ON p.id = a.pelicula_id AND a.usuario_id = $user_id
    ");
    
    $peliculas = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode(["status" => "success", "peliculas" => $peliculas]);
} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
