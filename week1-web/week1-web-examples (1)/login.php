<?php

require_once("mydb.php");

$db = mydb_connect();

if (isset($_POST['login']) && isset($_POST['password'])){
  $login = $_POST['login'];
  $password = $_POST['password'];
  $query = "SELECT username FROM Users 
             WHERE login='$login' 
               AND password='$password'";
  $result = mysqli_query($db, $query); 
  if ($result && $row = mysqli_fetch_row($result)){ 
    echo "Logged in. Welcome " .$row[0] . "<br>"; 
  } else { 
    echo "No go"; 
  } 
}

?>