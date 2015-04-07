<?
  require("passwd.inc");
  $errors_dir = "../errors/";
  $id = $_GET['id'];

  header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");  
  header("Last-Modified: " . gmdate( "D, d M Y H:i:s") . " GMT"); 
  header("Cache-Control: no-cache, must-revalidate"); 
  header("Pragma: no-cache");

  echo "<hr>\r\n";
  echo "<div align='center'><h2>Errors of task #$id</h2></div>\r\n";
  echo "<hr>\r\n";

  echo "<table border=0 align='CENTER' width='100%'>";
  echo "<tr><td align='CENTER' width='50%'>";

  echo "<table border='1' align='CENTER'>";
  echo "<tr><td>Error</td><td>Count</td></tr>\r\n";

  $dir = opendir($errors_dir);
  chdir($errors_dir);

  $sigma = 0;
  
  while (($d = readdir($dir)) !== false) {
    if (is_file($d)) {
      $filename = $errors_dir."$d";
      $text = stripslashes(join('',file($filename)));
      $basename = basename($filename);
      list($tid,$err) = explode(".",$basename);
      if ($tid === $id) {
        $errors[$err] = $text;
        $sigma += $text;
      }
    }
  }
  closedir($dir);
  
  asort($errors);
  for ($i=0; $i < 1000; $i++) {
    if ($errors[$i] > 0) {
      echo "<tr>";
      if ($i == 0) echo "<td><font color='green'>good</font></td>";
      else echo "<td>$i</td>";
      echo "<td>".$errors[$i]."</td>";
      echo "</tr>\r\n";
    }
  }
  
  $valid = round(100*$errors[0]/$sigma);
  
  ?>
  
  </table></td><td align='CENTER' width='50%' valign='TOP'><table align='CENTER'><tr><td>701</td><td>Не смог выдернуть домен из мыла TO_EMAIL.</td></tr><tr><td>702</td><td>Не смог отрезолвить MX записи.</td></tr><tr><td>703</td><td>Не смог подключиться к MX серверам.</td></tr><tr><td>704</td><td>Не смог послать команду серверу.</td></tr><tr><td>705</td><td>Не получил ответ сервера после посылки команды.</td></tr><tr><td>706</td><td>Не смог выдернуть домен из мыла FROM_EMAIL.</td></tr><tr><td>707</td><td>В процессе посылки BODY сервер разорвал соединение.</td></tr><tr><td>708</td><td>-</td></tr><tr><td>709</td><td>Оборвалась связь. Не дождались баннера.</td></tr><tr><td>710</td><td>Сервер отверг бота. Баннер не 250.</td></tr><tr><td>711</td><td>Не смог послать HELO.</td></tr><tr><td>712</td><td>Разорвалась связь после посылки HELO.</td></tr><tr><td>713</td><td>HELO не принято.</td></tr><tr><td>714</td><td>Не смог послать MAIL FROM.</td></tr><tr><td>715</td><td>Разорвалась связь после посылки MAIL FROM.</td></tr><tr><td>716</td><td>MAIL FROM не принято.</td></tr><tr><td>717</td><td>Не смог послать RCPT TO.</td></tr><tr><td>718</td><td>Разорвалась связь после посылки RCPT TO.</td></tr><tr><td>719</td><td>RCPT TO не принято.</td></tr><tr><td>720</td><td>Не смог послать комманду DATA для посылки тела письма.</td></tr><tr><td>721</td><td>Разорвалась связь после посылки комманды DATA.</td></tr><tr><td>722</td><td>Комманда DATA не принята сервером - бот разрывает соединение.</td></tr><tr><td>723</td><td>Не смог послать [CRLF].[CRLF].</td></tr><tr><td>724</td><td>Разорвалась связь после посылки [CRLF].[CRLF].</td></tr>
  <tr><td>Errors Sum:</td><td><?=$sigma?></td></tr>
  <tr><td>Valid:</td><td>%<?=$valid?></td></tr>
  
  </table></td></tr></table>  
  
  