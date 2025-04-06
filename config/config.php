<?php
// Konfiguracja połączenia z bazą danych
define('DB_HOST', 'localhost');
define('DB_NAME', 'xxx');
define('DB_USER', 'xxx');
define('DB_PASS', 'xxx');

$db = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

if ($db->connect_error) {
    die("Błąd połączenia z bazą danych: " . $db->connect_error);
}
?>
