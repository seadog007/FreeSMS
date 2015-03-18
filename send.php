<?php

if (get_all_get() == ''){
  r403();
}else{
  $password = $_GET['password'];
  $func = $_GET['function'];
  $phone = $_GET['phone'];
  $msg = $_GET['msg'];
  $proxyaddr = $_GET['proxyaddr'];
  $proxyport = $_GET['proxyport'];



if ($password == '~~~'){
  if ($func == 'help'){
    echo 'Please use POST method';
  }elseif($func == "send"){
    if ($phone==''){
      die('Please Enter The Phone Number.');
    }
    if ($msg==''){
      die('Please Enter The Message.');
    }
    $re = '/9\\d{8}/';
    preg_match($re, $phone, $phone_matches);
    if ($phone_matches[0] == ''){
      die('Plesase Enter Correct Phone Number.');
    }else{
      if (mb_strlen($msg) <= 160 && mb_strlen($msg) >= 10){
        if ($proxyaddr=='' || $proxyport=''){
          $command = './freesms.sh ' . $phone . ' \'' . $msg . '\' 0';
        }else{
          $command = './freesms.sh ' . $phone . ' \'' . $msg . '\' 1' . $proxyaddr . ' ' . $proxyport;
        }
      }else{
        die('Please Enter Correct Message<br>char >= 10<br>and<br>char <=160');
      }
    }
    echo exec(escapeshellcmd($command));
  }else{
    r403();
  }
}else{
  r403();
}
}

function get_all_get(){
  $output = "";
  $firstRun = true;
  foreach($_GET as $key=>$val) {
    if($key != $parameter) {
      if(!$firstRun) {
        $output .= "&";
      } else {
        $firstRun = false;
      }
      $output .= $key."=".$val;
    }
  }
  return $output;
}

function r403(){
  header('HTTP/1.0 403 Forbidden');
  die("
    <html><head>
    <title>403 Forbidden</title>
    <style type=\"text/css\"></style></head><body>
    <h1>Forbidden</h1>
    <p>You don't have permission to access " . $_SERVER['PHP_SELF'] . " on this server.<br>
    </p>
    </body></html>
    ");
}
?>
