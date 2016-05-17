<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Fragus</title>
<link href="style.css" rel="stylesheet" type="text/css">
<style type="text/css">
body
{
   background-color: #282828;
   color: #000000;
}
</style>
<link rel="stylesheet" href="./ui-darkness/jquery.ui.all.css" type="text/css">
<script type="text/javascript" src="./jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="./jquery.ui.core.min.js"></script>
<script type="text/javascript" src="./jquery.ui.widget.min.js"></script>
<script type="text/javascript" src="./jquery.ui.mouse.min.js"></script>
<script type="text/javascript" src="./jquery.ui.draggable.min.js"></script>
<script type="text/javascript" src="./jquery.ui.position.min.js"></script>
<script type="text/javascript" src="./jquery.ui.resizable.min.js"></script>
<script type="text/javascript" src="./jquery.ui.dialog.min.js"></script>
<script type="text/javascript" src="./jquery.effects.core.min.js"></script>
<script type="text/javascript" src="./jquery.effects.blind.min.js"></script>
<script type="text/javascript" src="./jquery.effects.bounce.min.js"></script>
<script type="text/javascript" src="./jquery.effects.clip.min.js"></script>
<script type="text/javascript" src="./jquery.effects.drop.min.js"></script>
<script type="text/javascript" src="./jquery.effects.explode.min.js"></script>
<script type="text/javascript" src="./jquery.effects.fold.min.js"></script>
<script type="text/javascript" src="./jquery.effects.highlight.min.js"></script>
<script type="text/javascript" src="./jquery.effects.pulsate.min.js"></script>
<script type="text/javascript" src="./jquery.effects.scale.min.js"></script>
<script type="text/javascript" src="./jquery.effects.shake.min.js"></script>
<script type="text/javascript" src="./jquery.effects.slide.min.js"></script>
<script type="text/javascript" src="./jquery.ui.button.min.js"></script>
<style type="text/css">
.ui-dialog
{
   padding: 4px 4px 4px 4px;
}
.ui-dialog .ui-dialog-title
{
   font-family: Arial;
   font-size: 13px;
   font-weight: normal;
   font-style: normal;
   color: #EEEEEE;
}
.ui-dialog .ui-dialog-titlebar
{
   padding: 10px 10px 10px 30px;
}
.ui-dialog .ui-dialog-titlebar-close
{
   right: 10px;
}
</style>
<style type="text/css">
#jQueryButton1
{
   font-family: Arial;
   font-size: 13px;
   font-weight: normal;
   font-style: normal;
}
#jQueryButton1 .ui-button
{
   position: absolute;
}
</style>
<style type="text/css">
#jQueryButton2
{
   font-family: Arial;
   font-size: 13px;
   font-weight: normal;
   font-style: normal;
}
#jQueryButton2 .ui-button
{
   position: absolute;
}
</style>
<style type="text/css">
#jQueryButton3
{
   font-family: Arial;
   font-size: 13px;
   font-weight: normal;
   font-style: normal;
}
#jQueryButton3 .ui-button
{
   position: absolute;
}
</style>
<style type="text/css">
#jQueryButton4
{
   font-family: Arial;
   font-size: 13px;
   font-weight: normal;
   font-style: normal;
}
#jQueryButton4 .ui-button
{
   position: absolute;
}
</style>
<style type="text/css">
#jQueryButton5
{
   font-family: Arial;
   font-size: 13px;
   font-weight: normal;
   font-style: normal;
}
#jQueryButton5 .ui-button
{
   position: absolute;
}
</style>
<style type="text/css">
#jQueryButton6
{
   font-family: Arial;
   font-size: 13px;
   font-weight: normal;
   font-style: italic;
}
#jQueryButton6 .ui-button
{
   position: absolute;
}
</style>
<style type="text/css">
#jQueryButton7
{
   font-family: Arial;
   font-size: 13px;
   font-weight: normal;
   font-style: italic;
}
#jQueryButton7 .ui-button
{
   position: absolute;
}
</style>
<script type="text/javascript">
$(document).ready(function()
{
   var jQueryDialog1Opts =
   {
      width: 396,
      height: 148,
      position: [1046,656],
      resizable: true,
      draggable: true,
      closeOnEscape: true,
      show: 'pulsate',
      autoOpen: true
   };
   $("#jQueryDialog1").dialog(jQueryDialog1Opts);
   $("#jQueryButton1").button();
   $("#jQueryButton2").button();
   $("#jQueryButton3").button();
   var jQueryDialog2Opts =
   {
      width: 396,
      height: 143,
      position: [1040,133],
      resizable: true,
      draggable: true,
      closeOnEscape: true,
      show: 'pulsate',
      autoOpen: true
   };
   $("#jQueryDialog2").dialog(jQueryDialog2Opts);
   $("#jQueryButton4").button();
   $("#jQueryButton5").button();
   $("#jQueryButton6").button();
   $("#jQueryButton7").button();
   $("#jQueryButton8").button(); 
});
</script>
<link rel="stylesheet" href="./ui-darkness/jquery.ui.all.css" type="text/css">
<style type="text/css">
a:active
{
   color: #0000FF;
}
</style>
<script type="text/javascript" src="./jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="./jquery.ui.core.min.js"></script>
<script type="text/javascript" src="./jquery.ui.widget.min.js"></script>
<script type="text/javascript" src="./jquery.ui.datepicker.min.js"></script>
<style type="text/css">
.ui-datepicker
{
   font-family: Arial;
   font-size: 13px;
   z-index: 1003 !important;
   display: none;
}
</style>
<script type="text/javascript">
$(document).ready(function()
{
   var jQueryDatePicker1Opts =
   {
      dateFormat: 'mm/dd/yy',
      changeMonth: false,
      changeYear: false,
      showButtonPanel: false,
      showAnim: 'slideDown'
   };
   $("#jQueryDatePicker1").datepicker(jQueryDatePicker1Opts);
});
</script>
</head>
<body>
<div class="background">
<div class="transbox">


<div id="wb_Text2" style="margin:0;padding:0;position:absolute;left:1468px;top:1029px;width:21px;height:16px;text-align:left;z-index:0;">
<font style="FONT-SIZE: 13px" face="Arial" color="#000000">.</font></div>
<div id="wb_Text19" style="margin:0;padding:0;position:absolute;left:155px;top:53px;width:133px;height:53px;text-align:left;z-index:1;">
<font style="FONT-SIZE: 43px" face="Impact" color="#ffffff">Fragus</font></div>



<hr id="Line1" style="color:#3C3C3C;background-color:#3C3C3C;border:0px;margin:0;padding:0;position:absolute;left:157px;top:111px;width:151px;height:26px;z-index:6">
<div id="wb_Image4" style="margin:0;padding:0;position:absolute;left:169px;top:116px;width:17px;height:16px;text-align:left;z-index:7;">
<a href="../"><img src="images/MSIE_01.gif" id="Image4" alt="" border="0" style="width:17px;height:16px;"></div>
<div id="wb_Image5" style="margin:0;padding:0;position:absolute;left:192px;top:117px;width:16px;height:16px;text-align:left;z-index:8;">
<img src="images/FIREFOX_01.gif" id="Image5" alt="" border="0" style="width:16px;height:16px;"></div>
<div id="wb_Image6" style="margin:0;padding:0;position:absolute;left:217px;top:118px;width:14px;height:16px;text-align:left;z-index:9;">
<img src="images/OPERA_01.gif" id="Image6" alt="" border="0" style="width:14px;height:16px;"></div>
<div id="wb_Image7" style="margin:0;padding:0;position:absolute;left:258px;top:117px;width:16px;height:16px;text-align:left;z-index:10;">
<img src="images/CHROME_01.gif" id="Image7" alt="" border="0" style="width:16px;height:16px;"></div>
<div id="wb_Image8" style="margin:0;padding:0;position:absolute;left:237px;top:118px;width:16px;height:16px;text-align:left;z-index:11;">
<img src="images/SAFARI_01.gif" id="Image8" alt="" border="0" style="width:16px;height:16px;"></div>
<div id="wb_Image9" style="margin:0;padding:0;position:absolute;left:279px;top:117px;width:16px;height:16px;text-align:left;z-index:12;">
<img src="images/OTHER_01.gif" id="Image9" alt="" border="0" style="width:16px;height:16px;"></div></a>
<input type="submit" id="Button2" name="" value="Descargar" style="position:absolute;left:157px;top:161px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:13">
<input type="text" id="jQueryDatePicker1" style="position:absolute;left:1005px;top:91px;width:156px;height:18px;border:0px #C0C0C0 solid;background-color:#666666;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:14" name="jQueryDatePicker1" value="Calendario (Click)">
<input type="submit" id="Button4" name="" value="Descargar" style="position:absolute;left:157px;top:161px;width:364px;height:23px;font-family:Arial;font-size:13px;z-index:11">
<input type="text" id="Editbox1" style="position:absolute;left:1005px;top:91px;width:156px;height:18px;border:1px #C0C0C0 solid;font-family:'Courier New';font-size:13px;z-index:12" name="jQueryDatePicker1" value="Calendario (Click)">
<a href="Exploits/9-ActiveX Control.txt"><input type="submit" id="Button5" name="" value="ActiveX Control Remote Buffer Overflow" style="position:absolute;left:158px;top:197px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href="Exploits/10-Apple QuickTime.txt"><input type="submit" id="Button6" name="" value="Apple QuickTime" style="position:absolute;left:158px;top:231px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href="Exploits/11-Integer Adobe Flash Player.txt"><input type="submit" id="Button7" name="" value="Integer overflow in Adobe Flash Player" style="position:absolute;left:158px;top:267px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<a href="Exploits/12-Java GIF file parsing.txt"><input type="submit" id="Button8" name="" value="Java GIF file parsing" style="position:absolute;left:158px;top:303px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href="Exploits/13-Vector Markup  (IE).txt"><input type="submit" id="Button9" name="" value="Vector Markup Language Vulnerability (IE)" style="position:absolute;left:158px;top:339px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button10" name="" value="Descargar" style="position:absolute;left:158px;top:373px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button11" name="" value="Descargar" style="position:absolute;left:158px;top:409px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button12" name="" value="Descargar" style="position:absolute;left:158px;top:442px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button13" name="" value="Descargar" style="position:absolute;left:158px;top:478px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button14" name="" value="Descargar" style="position:absolute;left:158px;top:512px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button15" name="" value="Descargar" style="position:absolute;left:158px;top:548px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button16" name="" value="Descargar" style="position:absolute;left:158px;top:584px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button17" name="" value="Descargar" style="position:absolute;left:158px;top:620px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button18" name="" value="Descargar" style="position:absolute;left:158px;top:654px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button19" name="" value="Descargar" style="position:absolute;left:158px;top:690px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button52" name="" value="Siguiente" style="position:absolute;left:1240px;top:733px;width:96px;height:25px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>

<a href=""><input type="submit" id="Button20" name="" value="Descargar" style="position:absolute;left:561px;top:161px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button21" name="" value="Descargar" style="position:absolute;left:562px;top:197px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button22" name="" value="Descargar" style="position:absolute;left:562px;top:231px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button23" name="" value="Descargar" style="position:absolute;left:562px;top:267px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button24" name="" value="Descargar" style="position:absolute;left:562px;top:303px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button25" name="" value="Descargar" style="position:absolute;left:562px;top:339px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button26" name="" value="Descargar" style="position:absolute;left:562px;top:373px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<a href=""><input type="submit" id="Button27" name="" value="Descargar" style="position:absolute;left:562px;top:409px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15"></a>
<input type="submit" id="Button28" name="" value="Descargar" style="position:absolute;left:562px;top:442px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button29" name="" value="Descargar" style="position:absolute;left:562px;top:478px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button30" name="" value="Descargar" style="position:absolute;left:562px;top:512px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button31" name="" value="Descargar" style="position:absolute;left:562px;top:548px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button32" name="" value="Descargar" style="position:absolute;left:562px;top:584px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button33" name="" value="Descargar" style="position:absolute;left:562px;top:620px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button34" name="" value="Descargar" style="position:absolute;left:562px;top:654px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button35" name="" value="Descargar" style="position:absolute;left:562px;top:690px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button36" name="" value="Descargar" style="position:absolute;left:972px;top:161px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button37" name="" value="Descargar" style="position:absolute;left:973px;top:197px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button38" name="" value="Descargar" style="position:absolute;left:973px;top:231px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button39" name="" value="Descargar" style="position:absolute;left:973px;top:267px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button40" name="" value="Descargar" style="position:absolute;left:973px;top:303px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button41" name="" value="Descargar" style="position:absolute;left:973px;top:339px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button42" name="" value="Descargar" style="position:absolute;left:973px;top:373px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button43" name="" value="Descargar" style="position:absolute;left:973px;top:409px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button44" name="" value="Descargar" style="position:absolute;left:973px;top:442px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button45" name="" value="Descargar" style="position:absolute;left:973px;top:478px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button46" name="" value="Descargar" style="position:absolute;left:973px;top:512px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button47" name="" value="Descargar" style="position:absolute;left:973px;top:548px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button48" name="" value="Descargar" style="position:absolute;left:973px;top:584px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button49" name="" value="Descargar" style="position:absolute;left:973px;top:620px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button50" name="" value="Descargar" style="position:absolute;left:973px;top:654px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
<input type="submit" id="Button51" name="" value="Descargar" style="position:absolute;left:973px;top:690px;width:364px;height:23px;border:0px #000000 solid;background-color:#4B4B4B;color:#FFFFFF;font-family:Arial;font-size:13px;z-index:15">
</body>
</html>