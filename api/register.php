<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/error.log');
error_reporting(E_ALL);

// Incluir la conexión a la base de datos
require_once 'database.php'; // Aquí estamos incluyendo el archivo que establece la conexión PDO

// Permitir solicitudes CORS (si es necesario)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Función para registrar un usuario
function register_user($data) {
    // Aseguramos que estamos accediendo a la variable global $db
    $db = conectarDB();  // Aquí estamos declarando que vamos a usar la variable global $db

    try {
        $nombre = htmlspecialchars($data->nombre);
        $email = htmlspecialchars($data->email);
        $password = password_hash($data->password, PASSWORD_DEFAULT);

        // Verificar si el email ya está registrado
        $check_query = "SELECT * FROM usuarios WHERE email = :email";
        $stmt = $db->prepare($check_query); // Usamos $db correctamente aquí
        $stmt->execute(['email' => $email]);

        if ($stmt->rowCount() > 0) {
            return ["status" => "error", "message" => "El correo electrónico ya está registrado"];
        }

        // Insertar el nuevo usuario en la base de datos
        $insert_query = "INSERT INTO usuarios (nombre, email, password) VALUES (:nombre, :email, :password)";
        $stmt = $db->prepare($insert_query);  // Aquí también accedemos a $db
        $stmt->execute([
            'nombre' => $nombre,
            'email' => $email,
            'password' => $password
        ]);

        return ["status" => "success", "message" => "Usuario registrado con éxito"];
    } catch (PDOException $e) {
        return ["status" => "error", "message" => "Error al registrar el usuario: " . $e->getMessage()];
    }
}

// Manejo de la solicitud
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Recuperar los datos JSON enviados en el cuerpo de la solicitud
    $data = json_decode(file_get_contents("php://input"));

    // Verificar que los datos están llegando
    error_log(print_r($data, true));  // Esto imprimirá el contenido de la variable $data en los logs

    // Verificar que los datos necesarios estén presentes
    if (isset($data->nombre) && isset($data->email) && isset($data->password)) {
        // Registrar al usuario
        $response = register_user($data);
    } else {
        $response = ["status" => "error", "message" => "Faltan datos"];
    }

    // Responder con JSON
    echo json_encode($response);
} else {
    // Si no es una solicitud POST
    echo json_encode(["status" => "error", "message" => "Método no permitido"]);
}
?>
