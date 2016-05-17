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
   Rev 1.2    2004.05.20 11:38:10 AM  czhower
 IdStreamVCL
}
{
   Rev 1.1    2004.02.03 3:15:54 PM  czhower
 Updates to move to System.
}
{
   Rev 1.0    2004.02.03 2:36:04 PM  czhower
 Move
}
unit IdResourceStrings;

interface

resourcestring
  //IIdTextEncoding
  RSInvalidSourceArray = 'Ungültiges Quell-Array';
  RSInvalidDestinationArray = 'Ungültiges Ziel-Array';
  RSCharIndexOutOfBounds = 'Zeichenindex außerhalb des gültigen Bereichs (%d)';
  RSInvalidCharCount = 'Ungültige Anzahl (%d)';
  RSInvalidDestinationIndex = 'Ungültiger Zielindex (%d)';

  RSInvalidCodePage = 'Ungültige Codeseite (%d)';
  RSInvalidCharSet = 'Ungültiger Zeichensatz (%s)';
  RSInvalidCharSetConv = 'Ungültige Zeichensatzumwandlung (%s <-> %s)';
  RSInvalidCharSetConvWithFlags = 'Ungültige Zeichensatzumwandlung (%s <-> %s, %s)';

  //IdSys
  RSFailedTimeZoneInfo = 'Das Einlesen der Informationen über die Zeitzone ist fehlgeschlagen.';
  // Winsock
  RSWinsockCallError = 'Fehler beim Aufruf der Winsock2-Bibliotheksfunktion %s';
  RSWinsockLoadError = 'Fehler beim Laden der Winsock2-Bibliothek (%s)';
  {CH RSWinsockInitializationError = 'Winsock Initialization Error.'; }
  // Status
  RSStatusResolving = 'Host-Name %s wird aufgelöst.';
  RSStatusConnecting = 'Verbinden mit %s.';
  RSStatusConnected = 'Verbunden.';
  RSStatusDisconnecting = 'Verbindung wird getrennt.';
  RSStatusDisconnected = 'Verbindung getrennt.';
  RSStatusText = '%s';
  // Stack
  RSStackError = 'Socket-Fehler # %d%s'#13#10;
  RSStackEINTR = 'Unterbrochener Systemaufruf.';
  RSStackEBADF = 'Falsche Dateinummer.';
  RSStackEACCES = 'Zugriff verweigert.';
  RSStackEFAULT = 'Pufferfehler.';
  RSStackEINVAL = 'Ungültiges Argument.';
  RSStackEMFILE = 'Zu viele geöffnete Dateien.';
  RSStackEWOULDBLOCK = 'Operation würde blockieren.';
  RSStackEINPROGRESS = 'Die Operation wird gerade durchgeführt.';
  RSStackEALREADY = 'Operation wird bereits verarbeitet.';
  RSStackENOTSOCK = 'Socket-Operation für Nicht-Socket.';
  RSStackEDESTADDRREQ = 'Zieladresse erforderlich.';
  RSStackEMSGSIZE = 'Nachricht zu lang.';
  RSStackEPROTOTYPE = 'Falscher Protokolltyp für Socket.';
  RSStackENOPROTOOPT = 'Falsche Protokolloption.';
  RSStackEPROTONOSUPPORT = 'Protokoll nicht unterstützt.';
  RSStackESOCKTNOSUPPORT = 'Socket-Typ wird nicht unterstützt.';
  RSStackEOPNOTSUPP = 'Operation für Socket nicht unterstützt.';
  RSStackEPFNOSUPPORT = 'Protokollfamilie nicht unterstützt.';
  RSStackEAFNOSUPPORT = 'Die Adressfamilie wird von der Protokollfamilie nicht unterstützt.';
  RSStackEADDRINUSE = 'Adresse wird bereits verwendet.';
  RSStackEADDRNOTAVAIL = 'Angeforderte Adresse kann nicht zugewiesen werden.';
  RSStackENETDOWN = 'Netzwerk ist heruntergefahren.';
  RSStackENETUNREACH = 'Netzwerk ist nicht erreichbar.';
  RSStackENETRESET = 'Netz hat die Verbindung verloren oder zurückgesetzt.';
  RSStackECONNABORTED = 'Software verursachte einen Verbindungsabbruch.';
  RSStackECONNRESET = 'Die Verbindung wurde von Peer zurückgesetzt.';
  RSStackENOBUFS = 'Kein Pufferplatz verfügbar.';
  RSStackEISCONN = 'Socket ist bereits verbunden.';
  RSStackENOTCONN = 'Socket ist nicht verbunden.';
  RSStackESHUTDOWN = 'Nach Schließen des Socket kann weder gesendet noch empfangen werden.';
  RSStackETOOMANYREFS = 'Zu viele Referenzen; keine Verbindungen möglich.';
  RSStackETIMEDOUT = 'Zeitüberschreitung bei Verbindung.';
  RSStackECONNREFUSED = 'Verbindung abgelehnt.';
  RSStackELOOP = 'Zu viele Ebenen symbolischer Verknüpfungen.';
  RSStackENAMETOOLONG = 'Dateiname zu lang.';
  RSStackEHOSTDOWN = 'Host ist heruntergefahren.';
  RSStackEHOSTUNREACH = 'Keine Route zum Host.';
  RSStackENOTEMPTY = 'Verzeichnis ist nicht leer';
  RSStackHOST_NOT_FOUND = 'Host nicht gefunden.';
  RSStackClassUndefined = 'Stack-Klasse ist nicht definiert.';
  RSStackAlreadyCreated = 'Stack bereits erstellt.';
  // Other
  RSAntiFreezeOnlyOne = 'Pro Anwendung darf nur ein TIdAntiFreeze vorhanden sein.';
  RSCannotSetIPVersionWhenConnected = 'Wenn verbunden, kann IPVersion nicht verändert werden';
  RSCannotBindRange = 'Port-Bereich (%d - %d) kann nicht eingebunden werden';
  RSConnectionClosedGracefully = 'Die Verbindung wurde erfolgreich geschlossen.';
  RSCorruptServicesFile = '%s ist beschädigt.';
  RSCouldNotBindSocket = 'Socket konnte nicht gebunden werden. Adresse und Port werden bereits verwendet.';
  RSInvalidPortRange = 'Ungültiger Port-Bereich (%d - %d)';
  RSInvalidServiceName = '%s ist kein gültiger Service.';
  RSIPv6Unavailable = 'IPv6 nicht verfügbar';
  RSInvalidIPv6Address = '%s ist keine gültige IPv6-Adresse';
  RSIPVersionUnsupported = 'Die angeforderte IPVersion-/Adress-Familie wird nicht unterstützt.';
  RSNotAllBytesSent = 'Es wurden nicht alle Bytes gesendet.';
  RSPackageSizeTooBig = 'Package zu groß.';
  RSSetSizeExceeded = 'Festgelegte Größe überschritten.';
  RSNoEncodingSpecified = 'Keine Codierung angegeben.';
  {CH RSStreamNotEnoughBytes = 'Not enough bytes read from stream.'; }
  RSEndOfStream = 'Ende des Streams: Klasse %s bei %d';

  //DNS Resolution error messages
  RSMaliciousPtrRecord = 'Schädlicher PTR-Record';

implementation

end.
