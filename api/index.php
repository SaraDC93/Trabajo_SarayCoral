<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/error.log');
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$request_method = $_SERVER['REQUEST_METHOD'];
$request_uri = explode('?', $_SERVER['REQUEST_URI'], 2)[0];

switch ($request_uri) {
    case '/usuarios.php':
        include 'api/usuarios.php';
        break;

    case '/peliculas.php':
        include 'api/peliculas.php';
        break;

    case '/alquileres.php':
        include 'api/alquileres.php';
        break;

    case '/resenas.php':
        include 'api/resenas.php';
        break;

    case '/auth.php':
        include 'api/auth.php';
        break;

    default:
        echo json_encode(["error" => "Ruta no encontrada"]);
        break;
}
?>
