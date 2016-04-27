<?php
$username = isset($_GET['username']) ? $_GET['username']
                                     : "anonymous coward";
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
  <title>PHP Greeting</title>
  <style>
    body { background: lightblue}
    .header { font-size: 140% }
  </style>
</head>
<body>
  <h1>Greeting by PHP</h1>

<?php 
echo '<div class="header"> Welcome, '.$username.'</div>';
?>


    </body>
</html>
