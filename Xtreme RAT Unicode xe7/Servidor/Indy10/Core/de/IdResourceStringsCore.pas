{
  $Project$
  $Workfile$
  $Revision$
  $DateUTC$
  $Id$

  This file is part of the Indy (Internet Direct) project, and is offered
  under the dual-licensing agreement described on the Indy website.
  (http://www.indyproject.org/)

  Copyright:
   (c) 1993-2005, Chad Z. Hower and the Indy Pit Crew. All rights reserved.
}
{
  $Log$
}
{
  Rev 1.5    12/2/2004 9:26:44 PM  JPMugaas
  Bug fix.

  Rev 1.4    11/11/2004 10:25:24 PM  JPMugaas
  Added OpenProxy and CloseProxy so you can do RecvFrom and SendTo functions
  from the UDP client with SOCKS.  You must call OpenProxy  before using
  RecvFrom or SendTo.  When you are finished, you must use CloseProxy to close
  any connection to the Proxy.  Connect and disconnect also call OpenProxy and
  CloseProxy.

  Rev 1.3    11/11/2004 3:42:52 AM  JPMugaas
  Moved strings into RS.  Socks will now raise an exception if you attempt to
  use SOCKS4 and SOCKS4A with UDP.  Those protocol versions do not support UDP
  at all.

  Rev 1.2    2004.05.20 11:39:12 AM  czhower
  IdStreamVCL

  Rev 1.1    6/4/2004 5:13:26 PM  SGrobety
  EIdMaxCaptureLineExceeded message string

  Rev 1.0    2004.02.03 4:19:50 PM  czhower
  Rename

  Rev 1.15    10/24/2003 4:21:56 PM  DSiders
  Addes resource string for stream read exception.

  Rev 1.14    2003.10.16 11:25:22 AM  czhower
  Added missing ;

  Rev 1.13    10/15/2003 11:11:06 PM  DSiders
  Added resource srting for exception raised in TIdTCPServer.SetScheduler.

  Rev 1.12    10/15/2003 11:03:00 PM  DSiders
  Added resource string for circular links from transparent proxy.
  Corrected spelling errors.

  Rev 1.11    10/15/2003 10:41:34 PM  DSiders
  Added resource strings for TIdStream and TIdStreamProxy exceptions.

  Rev 1.10    10/15/2003 8:48:56 PM  DSiders
  Added resource strings for exceptions raised when setting thread component
  properties.

  Rev 1.9    10/15/2003 8:35:28 PM  DSiders
  Added resource string for exception raised in TIdSchedulerOfThread.NewYarn.

  Rev 1.8    10/15/2003 8:04:26 PM  DSiders
  Added resource strings for exceptions raised in TIdLogFile, TIdReply, and
  TIdIOHandler.

  Rev 1.7    10/15/2003 1:03:42 PM  DSiders
  Created resource strings for TIdBuffer.Find exceptions.

  Rev 1.6    2003.10.14 1:26:44 PM  czhower
  Uupdates + Intercept support

  Rev 1.5    10/1/2003 10:49:02 PM  GGrieve
  Rework buffer for Octane Compability

  Rev 1.4    7/1/2003 8:32:32 PM  BGooijen
  Added RSFibersNotSupported

  Rev 1.3    7/1/2003 02:31:34 PM  JPMugaas
  Message for invalid IP address.

  Rev 1.2    5/14/2003 6:40:22 PM  BGooijen
  RS for transparent proxy

  Rev 1.1    1/17/2003 05:06:04 PM  JPMugaas
  Exceptions for scheduler string.

  Rev 1.0    11/13/2002 08:42:02 AM  JPMugaas
}

unit IdResourceStringsCore;

interface

{$i IdCompilerDefines.inc}

resourcestring
  RSNoBindingsSpecified = 'Keine Bindungen angegeben.';
  RSCannotAllocateSocket = 'Socket kann nicht zugewiesen werden.';
  RSSocksUDPNotSupported = 'UDP wird in dieser SOCKS-Version nicht unterstützt.';
  RSSocksRequestFailed = 'Anforderung zurückgewiesen oder fehlgeschlagen.';
  RSSocksRequestServerFailed = 'Anforderung zurückgewiesen, weil der SOCKS-Server keine Verbindung herstellen kann.';
  RSSocksRequestIdentFailed = 'Anforderung zurückgewiesen, weil das Client-Programm und der Identd verschiedene Benutzer-IDs melden.';
  RSSocksUnknownError = 'Unbekannter Socks-Fehler.';
  RSSocksServerRespondError = 'Socks-Server hat nicht geantwortet.';
  RSSocksAuthMethodError = 'Ungültige Authentifizierungsmethode für Socks.';
  RSSocksAuthError = 'Authentifizierungsfehler beim Socks-Server.';
  RSSocksServerGeneralError = 'Allgemeiner SOCKS-Server-Fehler.';
  RSSocksServerPermissionError = 'Verbindung von Regelmenge nicht zugelassen.';
  RSSocksServerNetUnreachableError = 'Netzwerk nicht erreichbar.';
  RSSocksServerHostUnreachableError = 'Host nicht erreichbar.';
  RSSocksServerConnectionRefusedError = 'Verbindung abgelehnt.';
  RSSocksServerTTLExpiredError = 'TTL abgelaufen.';
  RSSocksServerCommandError = 'Anweisung nicht unterstützt.';
  RSSocksServerAddressError = 'Adresstyp nicht unterstützt.';
  RSInvalidIPAddress = 'Ungültige IP-Adresse';
  RSInterceptCircularLink = '%s: Zirkuläre Verknüpfungen sind nicht zulässig';

  RSNotEnoughDataInBuffer = 'Nicht genügend Daten im Puffer. (%d/%d)';
  RSTooMuchDataInBuffer = 'Zu viele Daten im Puffer.';
  RSCapacityTooSmall = 'Die Kapazität darf nicht kleiner als die Größe sein.';
  RSBufferIsEmpty = 'Keine Bytes im Puffer.';
  RSBufferRangeError = 'Index außerhalb des Bereichs.';

  RSFileNotFound = 'Datei "%s" nicht gefunden';
  RSNotConnected = 'Nicht verbunden';
  RSObjectTypeNotSupported = 'Objekttyp nicht unterstützt.';
  RSIdNoDataToRead = 'Keine Daten für den Lesezugriff.';
  RSReadTimeout = 'Zeitüberschreitung beim Lesen.';
  RSReadLnWaitMaxAttemptsExceeded = 'Max. Zeilenleseversuche überschritten.';
  RSAcceptTimeout = 'Zeitüberschreitung bei der Annahme.';
  RSReadLnMaxLineLengthExceeded = 'Max. Zeilenlänge überschritten.';
  RSRequiresLargeStream = 'Setzen Sie LargeStream auf True, um Streams, die größer als 2 GB sind, zu senden';
  RSDataTooLarge = 'Daten sind für den Stream zu groß';
  RSConnectTimeout = 'Zeitüberschreitung der Verbindung.';
  RSICMPNotEnoughtBytes = 'Nicht genug Bytes erhalten';
  RSICMPNonEchoResponse = 'Antwort vom Typ Non-Echo erhalten';
  RSThreadTerminateAndWaitFor  = 'Aufruf von TerminateAndWaitFor für FreeAndTerminate-Threads nicht möglich';
  RSAlreadyConnected = 'Verbindung besteht bereits.';
  RSTerminateThreadTimeout = 'Zeitüberschreitung bei Thread-Beendigung';
  RSNoExecuteSpecified = 'Keine Ausführungsbehandlungsroutine gefunden.';
  RSNoCommandHandlerFound = 'Keine Befehlsbehandlungsroutine gefunden.';
  RSCannotPerformTaskWhileServerIsActive = 'Task kann nicht ausgeführt werden, solange der Server aktiv ist.';
  RSThreadClassNotSpecified = 'Thread-Klasse nicht angegeben.';
  RSMaximumNumberOfCaptureLineExceeded = 'Maximal zulässige Zeilenanzahl überschritten'; // S.G. 6/4/2004: IdIOHandler.DoCapture
  RSNoCreateListeningThread = 'Empfangs-Thread kann nicht erstellt werden.';
  RSInterceptIsDifferent = 'Dem IOHandler wurde bereits ein anderes Intercept zugewiesen';

  //scheduler
  RSchedMaxThreadEx = 'Die maximale Thread-Anzahl für diesen Scheduler ist überschritten.';
  //transparent proxy
  RSTransparentProxyCannotBind = 'Transparenter Proxy kann nicht binden.';
  RSTransparentProxyCanNotSupportUDP = 'UDP wird von diesem Proxy nicht unterstützt.';
  //Fibers
  RSFibersNotSupported = 'Fasern werden auf diesem System nicht unterstützt.';
  // TIdICMPCast
  RSIPMCastInvalidMulticastAddress = 'Die übermittelte IP-Adresse ist keine gültige Multicast-Adresse [224.0.0.0 bis 239.255.255.255].';
  RSIPMCastNotSupportedOnWin32 = 'Diese Funktion wird unter Win32 nicht unterstützt.';
  RSIPMCastReceiveError0 = 'IP-Broadcast-Empfangsfehler = 0.';

  // Log strings
  RSLogConnected = 'Verbunden.';
  RSLogDisconnected = 'Verbindung getrennt.';
  RSLogEOL = '<EOL>';  // End of Line
  RSLogCR  = '<CR>';   // Carriage Return
  RSLogLF  = '<LF>';   // Line feed
  RSLogRecv = 'Erh '; // Receive
  RSLogSent = 'Ges '; // Send
  RSLogStat = 'Stat '; // Status

  RSLogFileAlreadyOpen = 'Dateiname kann bei geöffneter Protokolldatei nicht festgelegt werden.';

  RSBufferMissingTerminator = 'Pufferbegrenzer muss angegeben werden.';
  RSBufferInvalidStartPos   = 'Pufferstartposition ist ungültig.';

  RSIOHandlerCannotChange = 'Verbundener IOHandler kann nicht geändert werden.';
  RSIOHandlerTypeNotInstalled = 'Kein IOHandler des Typs %s installiert.';

  RSReplyInvalidCode = 'Antwortcode ist ungültig: %s';
  RSReplyCodeAlreadyExists = 'Antwortcode bereits vorhanden: %s';

  RSThreadSchedulerThreadRequired = 'Thread muss für den Scheduler angegeben werden.';
  RSNoOnExecute = 'OnExecute-Ereignis muss vorhanden sein.';
  RSThreadComponentLoopAlreadyRunning = 'Loop-Eigenschaft kann bei ausgeführtem Thread nicht gesetzt werden.';
  RSThreadComponentThreadNameAlreadyRunning = 'ThreadName kann bei ausgeführtem Thread nicht gesetzt werden.';

  RSStreamProxyNoStack = 'Für die Konvertierung des Datentyps wurde ein Stack erstellt.';

  RSTransparentProxyCyclic = 'Zyklischer Fehler bei transparentem Proxy.';

  RSTCPServerSchedulerAlreadyActive = 'Scheduler kann nicht geändert werden, solange der Server aktiv ist.';
  RSUDPMustUseProxyOpen = 'proxyOpen muss verwendet werden';

//ICMP stuff
  RSICMPTimeout = 'Zeitüberschreitung';
//Destination Address -3
  RSICMPNetUnreachable  = 'Netz nicht erreichbar;';
  RSICMPHostUnreachable = 'Host nicht erreichbar;';
  RSICMPProtUnreachable = 'Protokoll nicht erreichbar;';
  RSICMPPortUnreachable = 'Port nicht erreichbar';
  RSICMPFragmentNeeded = 'Fragmentierung erforderlich und "Nicht fragmentieren" wurde festgelegt';
  RSICMPSourceRouteFailed = 'Quellroute fehlgeschlagen';
  RSICMPDestNetUnknown = 'Ziel-Netzwerk unbekannt';
  RSICMPDestHostUnknown = 'Ziel-Host unbekannt';
  RSICMPSourceIsolated = 'Quell-Host isoliert';
  RSICMPDestNetProhibitted = 'Kommunikation mit Ziel-Netzwerk wurde vom Administrator gesperrt';
  RSICMPDestHostProhibitted = 'Kommunikation mit Ziel-Host wurde vom Administrator gesperrt';
  RSICMPTOSNetUnreach =  'Ziel-Netzwerk für Type-of-Service nicht erreichbar';
  RSICMPTOSHostUnreach = 'Ziel-Host für Type-of-Service nicht erreichbar';
  RSICMPAdminProhibitted = 'Kommunikation vom Administrator gesperrt';
  RSICMPHostPrecViolation = 'Verletzung der Host-Rangfolge';
  RSICMPPrecedenceCutoffInEffect =  'Rangfolgenobergrenze aktiv';
  //for IPv6
  RSICMPNoRouteToDest = 'Keine Route zum Ziel';
  RSICMPAAdminDestProhibitted =  'Kommunikation mit Ziel vom Administrator gesperrt';
  RSICMPSourceFilterFailed = 'Quelladresse entspricht nicht der Eintritts-/Austrittsrichtlinie';
  RSICMPRejectRoutToDest = 'Route zum Ziel ablehnen';
  // Destination Address - 11
  RSICMPTTLExceeded     = 'Time-to-Live überschritten';
  RSICMPHopLimitExceeded = 'Hop-Obergrenze überschritten';
  RSICMPFragAsmExceeded = 'Zeit für die erneute Fragment-Zusammensetzung überschritten.';
//Parameter Problem - 12
  RSICMPParamError      = 'Parameterproblem (Offset %d)';
  //IPv6
  RSICMPParamHeader = 'fehlerhaftes Header-Feld vorhanden (Offset %d)';
  RSICMPParamNextHeader = 'nicht erkannter nächster Header-Typ vorhanden (Offset %d)';
  RSICMPUnrecognizedOpt = 'nicht erkannte IPv6-Option vorhanden (Offset %d)';
//Source Quench Message -4
  RSICMPSourceQuenchMsg = 'Meldung "Überlastung durch den Sender"';
//Redirect Message
  RSICMPRedirNet =        'Datagramme für das Netzwerk umleiten.';
  RSICMPRedirHost =       'Datagramme für den Host umleiten.';
  RSICMPRedirTOSNet =     'Datagramme für Type-of-Service und Netzwerk umleiten.';
  RSICMPRedirTOSHost =    'Datagramme für Type-of-Service und Host umleiten.';
//echo
  RSICMPEcho = 'Echo';
//timestamp
  RSICMPTimeStamp = 'Zeitstempel';
//information request
  RSICMPInfoRequest = 'Informationsanforderung';
//mask request
  RSICMPMaskRequest = 'Adressmaskenanforderung';
// Traceroute
  RSICMPTracePacketForwarded = 'Ausgehendes Paket erfolgreich weitergeleitet';
  RSICMPTraceNoRoute = 'Keine Route für ausgehendes Paket; Paket verworfen';
//conversion errors
  RSICMPConvUnknownUnspecError = 'Unbekannter/unspezifischer Fehler';
  RSICMPConvDontConvOptPresent = 'Option "Nicht konvertieren" ist vorhanden';
  RSICMPConvUnknownMandOptPresent =  'Unbekannte Option vorhanden';
  RSICMPConvKnownUnsupportedOptionPresent = 'Bekannte nicht unterstützte Option vorhanden';
  RSICMPConvUnsupportedTransportProtocol = 'Nicht unterstütztes Transportprotokoll';
  RSICMPConvOverallLengthExceeded = 'Gesamtlänge überschritten';
  RSICMPConvIPHeaderLengthExceeded = 'IP-Header-Länge überschritten';
  RSICMPConvTransportProtocol_255 = 'Transportprotokoll &gt; 255';
  RSICMPConvPortConversionOutOfRange = 'Port-Konvertierung außerhalb des Bereichs';
  RSICMPConvTransportHeaderLengthExceeded = 'Transport-Header-Länge überschritten';
  RSICMPConv32BitRolloverMissingAndACKSet = '32 Bit Rollover fehlt und ACK gesetzt';
  RSICMPConvUnknownMandatoryTransportOptionPresent =      'Unbekannte Transportoption vorhanden';
//mobile host redirect
  RSICMPMobileHostRedirect = 'Mobile Host-Umleitung';
//IPv6 - Where are you
  RSICMPIPv6WhereAreYou    = 'IPv6 Where-Are-You';
//IPv6 - I am here
  RSICMPIPv6IAmHere        = 'IPv6 I-Am-Here';
// Mobile Regestration request
  RSICMPMobReg             = 'Mobile Registrierungsanforderung';
//Skip
  RSICMPSKIP               = 'SKIP';
//Security
  RSICMPSecBadSPI          = 'Schlechte SPI';
  RSICMPSecAuthenticationFailed = 'Authentifizierung fehlgeschlagen';
  RSICMPSecDecompressionFailed = 'Dekomprimierung fehlgeschlagen';
  RSICMPSecDecryptionFailed = 'Entschlüsselung fehlgeschlagen';
  RSICMPSecNeedAuthentication = 'Authentifizierung erforderlich';
  RSICMPSecNeedAuthorization = 'Autorisierung erforderlich';
//IPv6 Packet Too Big
  RSICMPPacketTooBig = 'Paket zu groß (MTU = %d)';
{ TIdCustomIcmpClient }

  // TIdSimpleServer
  RSCannotUseNonSocketIOHandler = 'Ein Nicht-Socket-IOHandler kann nicht verwendet werden';

implementation

end.
