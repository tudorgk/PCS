<?php

function initialise_tables(&$db) {
    if (! $db->query(
        'CREATE TABLE IF NOT EXISTS Users (
            ID  INT PRIMARY KEY AUTO_INCREMENT,
            password  TEXT NOT NULL,
            login     TEXT NOT NULL,
            username  TEXT NOT NULL)') ) {
        die ("Table creation failed: (" . $db->errno . ") " . $db->error);
    }

    if ( ($db->query("SELECT * FROM Users")->num_rows) < 1) {
        $sql = "INSERT INTO Users (login, password, username) VALUES ".
            "('kflarsen', 'what', 'Ken Friis Larsen'), " .
            "('br0ns', 'the', 'Morten')";
        $db->query($sql);
    }
}

// function for establishing connection to the database
function mydb_connect() {
    $dbhost = "localhost";
    $user = "barman";
    $passwd = "secret";
    $database = "barbarbar";
    
    $db = mysqli_connect($dbhost, $user, $passwd, $database);
    if ($db->connect_errno) {
        die ("Failed to connect to MySQL: (" . $db->connect_errno . ") " . $db->connect_error);
    }
    initialise_tables($db);
    return $db;
}
?>
