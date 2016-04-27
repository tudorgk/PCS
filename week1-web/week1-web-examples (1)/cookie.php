<?php

setcookie("Mmm", "", time() - 3600);
setcookie("Rule", "Dont play Secret Paladin", time()+3600);  /* expire in 1 hour */

echo "Hello"
?>
