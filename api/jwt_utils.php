<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/error.log');
error_reporting(E_ALL);

require_once '../vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class JWTUtils {
    private static $key;

    public static function init() {
        // Inicializamos la clave secreta de JWT
        self::$key = $_ENV['JWT_SECRET'];
    }

    public static function encode($payload) {
        // Codificar el JWT con el payload y la clave secreta
        return JWT::encode($payload, self::$key);
    }

    public static function decode($jwt) {
        try {
            // Decodificar el JWT usando la clave secreta
            return JWT::decode($jwt, new Key(self::$key, 'HS256'));
        } catch (Exception $e) {
            // Si ocurre un error, devolver null
            return null;
        }
    }

    public static function validateToken($jwt) {
        // Validar el token JWT
        $decoded = self::decode($jwt);
        if ($decoded && isset($decoded->exp) && $decoded->exp > time()) {
            return $decoded;
        }
        return null;
    }
}
