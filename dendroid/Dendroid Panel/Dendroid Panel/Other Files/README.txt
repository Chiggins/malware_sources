 ______   _______  _        ______   _______  _______ _________ ______  
(  __  \ (  ____ \( (    /|(  __  \ (  ____ )(  ___  )\__   __/(  __  \ 
| (  \  )| (    \/|  \  ( || (  \  )| (    )|| (   ) |   ) (   | (  \  )
| |   ) || (__    |   \ | || |   ) || (____)|| |   | |   | |   | |   ) |
| |   | ||  __)   | (\ \) || |   | ||     __)| |   | |   | |   | |   | |
| |   ) || (      | | \   || |   ) || (\ (   | |   | |   | |   | |   ) |
| (__/  )| (____/\| )  \  || (__/  )| ) \ \__| (___) |___) (___| (__/  )
(______/ (_______/|/    )_)(______/ |/   \__/(_______)\_______/(______/ 

Thank you for purchasing Dendroid. This file will outline the webserver requirements and how to install the Dendroid HTTP Panel.

I. REQUIREMENTS
	1. Your webserver must have PHP 5.2 or above. PHP 5.3 is highly recommended.
	2. PHP must have full read and write access to the panel's files and folders.
		2-1. Shared hosting users should have no problem. If you do, talk to your host's support system. They can help with file and folder permissions.
		2-2. VPS and Dedicated Server users should know how to chmod and chown if on Linux.
	3. Your webserver must have the ionCube loaders installed.
		3-1. For more information, visit http://www.ioncube.com/loaders.php
	4. It is recommended to have at least 1GB of disk space.
		4-1. Disk space usage will vary depending on how heavily you use certain features of Dendroid.
	5. A MySQL database.
	
If you meet the above requirements, Dendroid's installation should be a breeze.

II. INSTALLATION
	1. UnZIP the Panel.
	2. Upload all files to your webserver. Pay attention to the subdirectory (if any) that you uploaded it to.
	3. Use phpMyAdmin, or however you manage your MySQL database to upload the "SQL.sql" file.
	3. When all files are uploaded, visit http://yourdomain.com/setup/
	4. Follow the setup instructions. If you need any help, contact us. We will be glad to help.
	5. Visit http://yourdomain.com/ to use your panel.