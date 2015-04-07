 ______   _______  _        ______   _______  _______ _________ ______  
(  __  \ (  ____ \( (    /|(  __  \ (  ____ )(  ___  )\__   __/(  __  \ 
| (  \  )| (    \/|  \  ( || (  \  )| (    )|| (   ) |   ) (   | (  \  )
| |   ) || (__    |   \ | || |   ) || (____)|| |   | |   | |   | |   ) |
| |   | ||  __)   | (\ \) || |   | ||     __)| |   | |   | |   | |   | |
| |   ) || (      | | \   || |   ) || (\ (   | |   | |   | |   | |   ) |
| (__/  )| (____/\| )  \  || (__/  )| ) \ \__| (___) |___) (___| (__/  )
(______/ (_______/|/    )_)(______/ |/   \__/(_______)\_______/(______/ 
                                                                        

This file contains instructions on how to 1. Setup URL locking, 2. ionCube the panel, and 3. Pack it up for delivery.

Something to consider:
	1. Don't mention reg.php to the customers, the more they know about the URL locking system, the easier it is for them to crack our protection and share the panel freely.
	If they don't know what reg.php is, we are probably better off.

I. URL LOCKING
	1. Open Panel/reg.php in Notepad++ (Recommended) or similar text editing application.
	2. Change "www.pizzachip.com" and "pizzachip.com" on line 1 to the domain the customer has specified.
		2-1. For example: $allowedDomains = array("www.androidcapture.com", "androidcapture.com");
	3. Save reg.php
	
II. ionCube
	1. Visit http://ioncube.com
	2. Login to your ionCube account.
	3. Click "Encode" or visit https://www.ioncube.com/main.php?c=encode
	4. ZIP the files inside of the Panel folder.
	5. "Choose File" on ionCube.com and select the ZIP.
	6. Make sure only "Allow short open tags (<? ?>)" is checked.
	7. Set "Encoder Selection" to "8.0"
	8. Set "Source Language" to "PHP 5.3"
	9. Click "Upload"
	10. When the "Download" button appears, click it.

III. Final Packing
	1. Create a "Dendroid" folder, and create a folder inside of that folder named "HTTP Panel"
	1. Extract the ZIP file you downloaded in Section II, Step 10 to the "HTTP Panel" folder.
	2. Ensure there is a "dlfiles" folder, along with "assets" and "setup"
		2-1. If there is no "dlfiles" folder, create one.
	3. Copy the "README" and "SQL" files from the "Other Files" folder you have into the "Dendroid" folder.
	4. Ensure your finished folder structure for the clients looks like this:
	
"Dendroid" =>
	"README.txt"
	"SQL.sql"
	"HTTP Panel" =>
		"assets"
		"setup" =>
			"createconfig.php"
			"index.php"
			"laststep.php"
			"step1.php"
		"dlfiles"
		"addcommand.php"
		"applysettings.php"
		"blockbot.php"
		"clearawaiting.php"
		"clearmessages.php"
		"control.php"
		"deletebot.php"
		"deletefile.php"
		"deletepics.php"
		"filetable.php"
		"functions.php"
		"get-functions.php"
		"get.php"
		"getimages.php"
		"getmessages.php"
		"getawaitingcommands.php"
		"index.php"
		"login.php"
		"logout.php"
		"message.php"
		"new-upload.php"
		"reg.php"
		"settings.php"
		"showpictures.php"
		"table.php"
		"upload-pictures.php"
		
	5. ZIP the "Dendroid" folder.
	6. Send to client.