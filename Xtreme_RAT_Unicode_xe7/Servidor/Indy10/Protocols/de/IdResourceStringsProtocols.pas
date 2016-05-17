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
  Rev 1.11    1/9/2005 6:08:30 PM  JPMugaas
  New FSP Messages.

  Rev 1.10    24.08.2004 18:01:42  Andreas Hausladen
  Added AttachmentBlocked property to TIdAttachmentFile.

  Rev 1.9    7/29/2004 2:15:32 AM  JPMugaas
  New property for controlling what AUTH command is sent.  Fixed some minor
  issues with FTP properties.  Some were not set to defaults causing
  unpredictable results -- OOPS!!!

  Rev 1.8    7/28/2004 8:26:48 AM  JPMugaas
  Further work on the SMTP Server.  Not tested yet.

  Rev 1.7    7/16/2004 4:28:44 AM  JPMugaas
  CCC Support in TIdFTP to complement that capability in TIdFTPServer.

  Rev 1.6    7/13/2004 3:31:20 AM  JPMugaas
  Messages for a new FTP server feature, CCC.

  Rev 1.5    6/20/2004 8:17:20 PM  JPMugaas
  Message for FTP Deflate FXP.

  Rev 1.4    6/16/04 12:52:36 PM  RLebeau
  Changed wording of RSPOP3SvrInternalError

  Rev 1.2    3/2/2004 6:38:58 AM  JPMugaas
  Stuff for more comprehensive help in the FTP Server.

  Rev 1.1    2/3/2004 4:12:28 PM  JPMugaas
  Fixed up units so they should compile.

  Rev 1.0    2004.02.03 7:46:06 PM  czhower
  New names

  Rev 1.26    2/1/2004 4:47:50 AM  JPMugaas
  Resource strings from the MappedPort units.

  Rev 1.25    1/5/2004 11:53:32 PM  JPMugaas
  Some messages moved to resource strings.  Minor tweeks.  EIdException no
  longer raised.

  Rev 1.24    30/12/2003 23:27:22  CCostelloe
  Added RSIMAP4DisconnectedProbablyIdledOut

  Rev 1.23    11/28/2003 4:10:10 PM  JPMugaas
  RS for empty names in FTP upload.

  Rev 1.22    11/13/2003 5:44:38 PM  VVassiliev
  Add RSQueryInvalidIpV6 for DNSResolver

  Rev 1.21    10/20/2003 12:58:18 PM  JPMugaas
  Exception messages moved to RS.

    Rev 1.20    10/17/2003 1:15:26 AM  DSiders
  Added resource strings used in Message Client, HTTP, IMAP4.

  Rev 1.19    2003.10.14 1:28:00 PM  czhower
  DotNet

  Rev 1.18    10/9/2003 10:15:46 AM  JPMugaas
  FTP SSCN FXP Message.

  Rev 1.17    9/8/2003 02:24:36 AM  JPMugaas
  New message for custom FTP Proxy support.

    Rev 1.16    8/10/2003 11:05:22 AM  BGooijen
  fixed typo

  Rev 1.15    6/17/2003 03:14:38 PM  JPMugaas
  FTP Structured help message.

  Rev 1.14    6/17/2003 09:08:00 AM  JPMugaas
  Improved SITE HELP handling.

  Rev 1.13    10/6/2003 4:07:14 PM  SGrobety
  IdCoder3to4 addition for exception handling

  Rev 1.12    6/9/2003 05:14:54 AM  JPMugaas
  Fixed crical error.
  Supports HDR and OVER commands defined in
  http://www.ietf.org/internet-drafts/draft-ietf-nntpext-base-18.txt if feature
  negotiation indicates that they are supported.
  Added XHDR data parsing routine.
  Added events for when we receive a line of data with XOVER or XHDR as per
  John Jacobson's request.

  Rev 1.11    6/8/2003 02:59:26 AM  JPMugaas
  RFC 2449 and RFC 3206 support.

  Rev 1.10    5/22/2003 05:26:08 PM  JPMugaas
  RFC 2034

  Rev 1.9    5/19/2003 08:12:46 PM  JPMugaas
  Strings for IdPOP3Reply unit.

  Rev 1.8    5/8/2003 03:18:20 PM  JPMugaas
  Flattened ou the SASL authentication API, made a custom descendant of SASL
  enabled TIdMessageClient classes.

  Rev 1.7    5/8/2003 02:18:12 AM  JPMugaas
  Fixed an AV in IdPOP3 with SASL list on forms.  Made exceptions for SASL
  mechanisms missing more consistant, made IdPOP3 support feature feature
  negotiation, and consolidated some duplicate code.

  Rev 1.6    3/27/2003 05:46:44 AM  JPMugaas
  Updated framework with an event if the TLS negotiation command fails.
  Cleaned up some duplicate code in the clients.

  Rev 1.5    3/19/2003 02:42:18 AM  JPMugaas
  Added more strings for the SMTP server.

  Rev 1.4    3/17/2003 02:28:32 PM  JPMugaas
  Updated with some TLS strings.

  Rev 1.3    3/9/2003 02:11:48 PM  JPMugaas
  Removed server support for MODE B and MODE C.  It turns out that we do not
  support those modes properly.  We only implemented Stream mode.  We now
  simply return a 504 for modes we don't support instead of a 200 okay.  This
  was throwing off Opera 7.02.

  Rev 1.2    2/24/2003 07:55:16 PM  JPMugaas
  Added /bin/ls strings to make the server look mroe like Unix.

  Rev 1.1    2/16/2003 10:51:00 AM  JPMugaas
  Attempt to implement:

  http://www.ietf.org/internet-drafts/draft-ietf-ftpext-data-connection-assuranc
  e-00.txt

  Currently commented out because it does not work.

  Rev 1.0    11/13/2002 07:59:36 AM  JPMugaas
}

unit IdResourceStringsProtocols;

interface

resourcestring
  // General
  RSIOHandlerPropInvalid = 'Wert für IOHandler ist ungültig';

  //FIPS
  RSFIPSAlgorithmNotAllowed = 'Algorithmus %s im FIPS-Modus nicht zulässig';
  //FSP
  RSFSPNotFound = 'Datei nicht gefunden';
  RSFSPPacketTooSmall = 'Paket ist zu klein';

  //SASL
  RSSASLNotReady = 'Die angegebenen SASL-Behandlungsroutinen sind nicht bereit!!';
  RSSASLNotSupported = 'AUTH oder die angegebenen SASL-Behandlungsroutinen werden nicht unterstützt!!';
  RSSASLRequired = 'SASL-Mechanismus für Anmeldung erforderlich!!';

  //TIdSASLDigest
  RSSASLDigestMissingAlgorithm = 'fehlender Algorithmus in Challenge.';
  RSSASLDigestInvalidAlgorithm = 'ungültiger Algorithmus in Challenge.';
  RSSASLDigestAuthConfNotSupported = 'auth-conf wird noch nicht unterstützt.';

  //  TIdEMailAddress
  RSEMailSymbolOutsideAddress = '@ Öffentliche Adresse';

  //ZLIB Intercept
  RSZLCompressorInitializeFailure = 'Komprimierung kann nicht initialisiert werden';
  RSZLDecompressorInitializeFailure = 'Dekomprimierung kann nicht initialisiert werden';
  RSZLCompressionError = 'Komprimierungsfehler';
  RSZLDecompressionError = 'Dekomprimierungsfehler';

  //MIME Types
  RSMIMEExtensionEmpty = 'Erweiterung ist leer';
  RSMIMEMIMETypeEmpty = 'Mimetype ist leer';
  RSMIMEMIMEExtAlreadyExists = 'Erweiterung existiert bereits';

  // IdRegister
  RSRegSASL = 'Indy SASL';

  // Status Strings
  // TIdTCPClient
  // Message Strings
  RSIdMessageCannotLoad = 'Meldung aus Datei %s kann nicht geladen werden';

  // MessageClient Strings
  RSMsgClientEncodingText = 'Text wird codiert';
  RSMsgClientEncodingAttachment = 'Anlage wird codiert';
  RSMsgClientInvalidEncoding = 'Ungültige Codierung. UU lässt nur Body und Attachments zu.';
  RSMsgClientInvalidForTransferEncoding = 'Botschaftsteile können in einer Botschaft nicht verwendet, die einen ContentTransferEncoding-Wert hat.';

  // NNTP Exceptions
  RSNNTPConnectionRefused = 'Die Verbindung wurde explizit vom NNTP-Server abgelehnt.';
  RSNNTPStringListNotInitialized = 'Die String-Liste ist nicht initialisiert!';
  RSNNTPNoOnNewsgroupList = 'Es wurde kein Ereignis OnNewsgroupList definiert.';
  RSNNTPNoOnNewGroupsList = 'Es wurde kein Ereignis OnNewGroupsList definiert.';
  RSNNTPNoOnNewNewsList = 'Es wurde kein Ereignis OnNewNewsList definiert.';
  RSNNTPNoOnXHDREntry = 'Es wurde kein Ereignis OnXHDREntry definiert.';
  RSNNTPNoOnXOVER = 'Es wurde kein Ereignis OnXOVER definiert.';

  // HTTP Status
  RSHTTPChunkStarted = 'Chunk gestartet';
  RSHTTPContinue = 'Fortsetzen';
  RSHTTPSwitchingProtocols = 'Protokollumschaltung';
  RSHTTPOK = 'OK';
  RSHTTPCreated = 'Erstellt';
  RSHTTPAccepted = 'Akzeptiert';
  RSHTTPNonAuthoritativeInformation = 'Keine verlässliche Information';
  RSHTTPNoContent = 'Kein Inhalt';
  RSHTTPResetContent = 'Inhalt zurücksetzen';
  RSHTTPPartialContent = 'Teilinhalt';
  RSHTTPMovedPermanently = 'Permanent verschoben';
  RSHTTPMovedTemporarily = 'Temporär verschoben';
  RSHTTPSeeOther = 'Siehe Weitere';
  RSHTTPNotModified = 'Nicht geändert';
  RSHTTPUseProxy = 'Proxy verwenden';
  RSHTTPBadRequest = 'Falsche Anforderung';
  RSHTTPUnauthorized = 'Nicht autorisiert';
  RSHTTPForbidden = 'Verboten';
  RSHTTPNotFound = 'Nicht gefunden';
  RSHTTPMethodNotAllowed = 'Methode nicht erlaubt';
  RSHTTPNotAcceptable = 'Nicht akzeptabel';
  RSHTTPProxyAuthenticationRequired = 'Proxy-Authentifizierung erforderlich';
  RSHTTPRequestTimeout = 'Zeitüberschreitung für Anforderung';
  RSHTTPConflict = 'Konflikt';
  RSHTTPGone = 'Fort';
  RSHTTPLengthRequired = 'Länge erforderlich';
  RSHTTPPreconditionFailed = 'Vorbedingung fehlgeschlagen';
  RSHTTPPreconditionRequired = 'Vorbedingung erforderlich';
  RSHTTPTooManyRequests = 'Zu viele Anforderungen';
  RSHTTPRequestHeaderFieldsTooLarge = 'Felder des Anforderungs-Headers zu groß';
  RSHTTPNetworkAuthenticationRequired = 'Netzwerkauthentifizierung erforderlich';
  RSHTTPRequestEntityTooLong = 'Anforderungs-Entität zu lang';
  RSHTTPRequestURITooLong = 'Anforderungs-URI zu lang. Max. 256 Zeichen';
  RSHTTPUnsupportedMediaType = 'Nicht unterstützter Medientyp';
  RSHTTPExpectationFailed = 'Erwartung fehlgeschlagen';
  RSHTTPInternalServerError = 'Interner Server-Fehler';
  RSHTTPNotImplemented = 'Nicht implementiert';
  RSHTTPBadGateway = 'Falsches Gateway';
  RSHTTPServiceUnavailable = 'Service nicht verfügbar';
  RSHTTPGatewayTimeout = 'Zeitüberschreitung bei Gateway';
  RSHTTPHTTPVersionNotSupported = 'HTTP-Version nicht unterstützt';
  RSHTTPUnknownResponseCode = 'Unbekannter Antwort-Code';

  // HTTP Other
  RSHTTPUnknownProtocol = 'Unbekanntes Protokoll';
  RSHTTPMethodRequiresVersion = 'Anforderungsmethode erfordert HTTP Version 1.1';
  RSHTTPHeaderAlreadyWritten = 'Der Header wurde bereits geschrieben.';
  RSHTTPErrorParsingCommand = 'Fehler bei der Analyse einer Anweisung.';
  RSHTTPUnsupportedAuthorisationScheme = 'Nicht unterstütztes Autorisierungs-Schema.';
  RSHTTPCannotSwitchSessionStateWhenActive = 'Sitzungsstatus kann nicht geändert werden, während der Server aktiv ist.';
  RSHTTPCannotSwitchSessionListWhenActive = 'Sitzungsliste kann nicht geändert werden, während der Server aktiv ist.';

  //HTTP Authentication
  RSHTTPAuthAlreadyRegistered = 'Diese Authentifizierungsmethode ist bereits mit Klassennamen %s registriert.';

  //HTTP Authentication Digeest
  RSHTTPAuthInvalidHash = 'Nicht unterstützter Hash-Algorithmus. Die Implementierung unterstützt nur MD5-Codierung.';

  // HTTP Cookies
  RSHTTPUnknownCookieVersion = 'Nicht unterstützte Cookie-Version: %d';

  //Block Cipher Intercept
  RSBlockIncorrectLength = 'Falsche Länge in empfangenem Block (%d)';

  // FTP
  RSFTPInvalidNumberArgs = 'Ungültige Argumentanzahl %s';
  RSFTPHostNotFound = 'Host nicht gefunden.';
  RSFTPUnknownHost = 'Unbekannt';
  RSFTPStatusReady = 'Verbindung hergestellt';
  RSFTPStatusStartTransfer = 'FTP-Transfer wird gestartet';
  RSFTPStatusDoneTransfer  = 'Transfer abgeschlossen';
  RSFTPStatusAbortTransfer = 'Transfer abgebrochen';
  RSFTPProtocolMismatch = 'Netzwerkprotokoll stimmt nicht überein, verwenden Sie'; { may not include '(' or ')' }
  RSFTPParamError = 'Fehler in Parametern für %s';
  RSFTPParamNotImp = 'Parameter %s nicht implementiert';
  RSFTPInvalidPort = 'Ungültige Portnummer';
  RSFTPInvalidIP = 'Ungültige IP-Adresse';
  RSFTPOnCustomFTPProxyReq = 'OnCustomFTPProxy erforderlich, aber nicht zugewiesen';
  RSFTPDataConnAssuranceFailure = 'Sicherheitsüberprüfung der Datenverbindung fehlgeschlagen. Server meldet IP: %s  Port:'#13#10' %d'#13#10'Unsere Socket-IP: %s  Port: %d';
  RSFTPProtocolNotSupported = 'Protokoll wird nicht unterstützt, verwenden Sie'; { may not include '(' or ')' }
  RSFTPMustUseExtWithIPv6 = 'UseExtensionDataPort muss für IPv6-Verbindungen true sein.';
  RSFTPMustUseExtWithNATFastTrack = 'UseExtensionDataPort muss für NAT-Fasttracking true sein.';
  RSFTPFTPPassiveMustBeTrueWithNATFT = 'Aktive Transfers können nicht mit NAT-Fasttracking verwendet werden.';
  RSFTPServerSentInvalidPort = 'Server hat ungültige Portnummer (%s) gesendet';
  RSInvalidFTPListingFormat = 'Unbekanntes FTP-Auflistungsformat';
  RSFTPNoSToSWithNATFastTrack = 'Mit einer FTP NAT-Fasttracked-Verbindung sind keine Site-to-Site-Transfers zulässig.';
  RSFTPSToSNoDataProtection = 'Datenschutz kann bei Site-to-Site-Transfer nicht verwendet werden.';
  RSFTPSToSProtosMustBeSame = 'Transportprotokolle müssen gleich sein.';
  RSFTPSToSSSCNNotSupported = 'SSCN wird auf beiden Servern nicht unterstützt.';
  RSFTPNoDataPortProtectionAfterCCC = 'DataPortProtection kann nach CCC nicht gesetzt werden.';
  RSFTPNoDataPortProtectionWOEncryption = 'DataPortProtection kann für nicht verschlüsselte Verbindungen nicht gesetzt werden.';
  RSFTPNoCCCWOEncryption = 'CCC kann ohne Verschlüsselung nicht gesetzt werden.';
  RSFTPNoAUTHWOSSL = 'AUTH kann ohne SSL nicht gesetzt werden.';
  RSFTPNoAUTHCon = 'AUTH kann während Verbindung nicht gesetzt werden.';
  RSFTPSToSTransferModesMusbtSame = 'Transfermodi müssen gleich sein.';
  RSFTPNoListParseUnitsRegistered = 'Es wurden keine FTP-Listen-Parser registriert.';
  RSFTPMissingCompressor = 'Kein Kompressor zugewiesen.';
  RSFTPCompressorNotReady = 'Kompressor ist nicht bereit.';
  RSFTPUnsupportedTransferMode = 'Nicht unterstützter Transfermodus.';
  RSFTPUnsupportedTransferType = 'Nicht unterstützter Transfertyp.';

  // Property editor exceptions
  // Stack Error Messages

  RSCMDNotRecognized = 'Anweisung nicht erkannt';

  RSGopherNotGopherPlus = '%s ist kein Gopher+-Server';

  RSCodeNoError     = 'RCode NO Fehler';
  RSCodeQueryServer = 'Der DNS-Server meldet einen Fehler beim Abfrage-Server';
  RSCodeQueryFormat = 'Der DNS-Server meldet einen Fehler im Abfrageformat';
  RSCodeQueryName   = 'Der DNS-Server meldet einen Fehler im Abfragenamen';
  RSCodeQueryNotImplemented = 'Der DNS-Server meldet den Fehler, dass die Abfrage nicht implementiert ist';
  RSCodeQueryQueryRefused = 'Der DNS-Server meldet den Fehler, dass die Abfrage zurückgewiesen wurde';
  RSCodeQueryUnknownError = 'Server gab einen unbekannten Fehler zurück';

  RSDNSTimeout = 'TimedOut';
  RSDNSMFIsObsolete = 'MF ist ein veralteter Befehl. VERWENDEN SIE MX.';
  RSDNSMDISObsolete = 'MD ist ein veralteter Befehl. VERWENDEN SIE MX.';
  RSDNSMailAObsolete = 'MailA ist ein veralteter Befehl. VERWENDEN SIE MX.';
  RSDNSMailBNotImplemented = '-Err 501 MailB ist nicht implementiert';

  RSQueryInvalidQueryCount = 'Ungültige Abfrageanzahl %d';
  RSQueryInvalidPacketSize = 'Ungültige Paketgröße %d';
  RSQueryLessThanFour = 'Empfangenes Paket ist zu klein. Weniger als 4 Byte. %d';
  RSQueryInvalidHeaderID = 'Ungültige Header-Id %d';
  RSQueryLessThanTwelve = 'Empfangenes Paket ist zu klein. Weniger als 12 Byte. %d';
  RSQueryPackReceivedTooSmall = 'Empfangenes Paket ist zu klein. %d';
  RSQueryUnknownError = 'Unbekannter Fehler %d, Id %d';
  RSQueryInvalidIpV6 = 'Ungültige IP V6-Adresse. %s';
  RSQueryMustProvideSOARecord = 'Sie müssen ein TIdRR_SOA-Objekt mit Seriennummer und Name für IXFR angeben. %d';
 
  { LPD Client Logging event strings }
  RSLPDDataFileSaved = 'Datendatei gespeichert in %s';
  RSLPDControlFileSaved = 'Steuerungsdatei speichern in %s';
  RSLPDDirectoryDoesNotExist = 'Verzeichnis %s ist nicht vorhanden';
  RSLPDServerStartTitle = 'Winshoes LPD-Server %s ';
  RSLPDServerActive = 'Server-Status: aktiv';
  RSLPDQueueStatus  = 'Warteschlange %s Status: %s';
  RSLPDClosingConnection = 'Verbindung wird geschlossen';
  RSLPDUnknownQueue = 'Unbekannte Warteschlange %s';
  RSLPDConnectTo = 'Verbunden mit %s';
  RSLPDAbortJob = 'Job abbrechen';
  RSLPDReceiveControlFile = 'Empfang von Steuerungsdatei';
  RSLPDReceiveDataFile = 'Empfang von Datendatei';

  { LPD Exception Messages }
  RSLPDNoQueuesDefined = 'Fehler: Keine Warteschlange definiert';

  { Trivial FTP Exception Messages }
  RSTimeOut = 'Zeitüberschreitung';
  RSTFTPUnexpectedOp = 'Unerwartete Operation von %s:%d';
  RSTFTPUnsupportedTrxMode = 'Nicht unterstützter Transfermodus: "%s"';
  RSTFTPDiskFull = 'Die Schreibanforderung konnte nicht abgeschlossen werden; wurde bei %d Byte angehalten';
  RSTFTPFileNotFound = '%s kann nicht geöffnet werden';
  RSTFTPAccessDenied = 'Zugriff auf %s verweigert';
  RSTFTPUnsupportedOption = 'Nicht unterstützte Option: "%s"';
  RSTFTPUnsupportedOptionValue = 'Nicht unterstützter Wert "%s" für Option: "%s"';

  { MESSAGE Exception messages }
  RSTIdTextInvalidCount = 'Ungültige Anzahl für Text. Muss mehr als 1 TIdText-Objekt haben.';
  RSTIdMessagePartCreate = 'TIdMessagePart kann nicht erzeugt werden. Verwenden Sie abgeleitete Klassen. ';
  RSTIdMessageErrorSavingAttachment = 'Fehler beim Speichern der Anlage.';
  RSTIdMessageErrorAttachmentBlocked = 'Anlage %s ist blockiert.';

  { POP Exception Messages }
  RSPOP3FieldNotSpecified = ' nicht angegeben';
  RSPOP3UnrecognizedPOP3ResponseHeader = 'Nicht erkannter POP3-Antwort-Header: "%s"'#10; //APR: user will see Server response    {Do not Localize}
  RSPOP3ServerDoNotSupportAPOP = 'Server unterstützt APOP nicht (kein Zeitstempel)';//APR    {Do not Localize}

  { IdIMAP4 Exception Messages }
  RSIMAP4ConnectionStateError = 'Befehl kann nicht ausgeführt werden, falscher Verbindungsstatus; Aktueller Verbindungsstatus: %s.';
  RSUnrecognizedIMAP4ResponseHeader = 'Nicht erkannter IMAP4-Antwort-Header.';
  RSIMAP4NumberInvalid = 'Zahlenparameter (relative Meldungsnummer oder UID) ist ungültig; Muss 1 oder größer sein.';
  RSIMAP4NumberInvalidString = 'Zahlenparameter (relative Meldungsnummer oder UID) ist ungültig; Darf keinen leeren String enthalten.';
  RSIMAP4NumberInvalidDigits = 'Zahlenparameter (relative Meldungsnummer oder UID) ist ungültig; Darf nur Ziffern enthalten.';
  RSIMAP4DisconnectedProbablyIdledOut = 'Der Server hat die Verbindung ordnungsgemäß geschlossen, möglicherweise weil die Verbindung zu lange inaktiv war.';

  { IdIMAP4 UTF encoding error strings}
  RSIMAP4UTFIllegalChar = 'Ungültiges Zeichen #%d in UTF7-Sequenz.';

  RSIMAP4UTFIllegalBitShifting = 'Ungültige Bit-Verschiebung in MUTF7-String';
  RSIMAP4UTFUSASCIIInUTF = 'US-ASCII-Zeichen #%d in UTF7-Sequenz.';
  { IdIMAP4 Connection State strings }
  RSIMAP4ConnectionStateAny = 'Alle';
  RSIMAP4ConnectionStateNonAuthenticated = 'Nicht authentifiziert';
  RSIMAP4ConnectionStateAuthenticated = 'Authentifiziert';
  RSIMAP4ConnectionStateSelected = 'Ausgewählt';
  RSIMAP4ConnectionStateUnexpectedlyDisconnected = 'Verbindung unerwartet getrennt';

  { Telnet Server }
  RSTELNETSRVUsernamePrompt = 'Benutzername: ';
  RSTELNETSRVPasswordPrompt = 'Passwort: ';
  RSTELNETSRVInvalidLogin = 'Ungültige Anmeldung.';
  RSTELNETSRVMaxloginAttempt = 'Die Anzahl erlaubter Anmeldeversuche wurde überschritten, auf Wiedersehen.';
  RSTELNETSRVNoAuthHandler = 'Es wurde keine Authentifizierungsbehandlung angegeben.';
  RSTELNETSRVWelcomeString = 'Indy Telnet-Server';
  RSTELNETSRVOnDataAvailableIsNil = 'Ereignis OnDataAvailable ist nil.';

  { Telnet Client }
  RSTELNETCLIConnectError = 'Server antwortet nicht.';
  RSTELNETCLIReadError = 'Server hat nicht geantwortet.';

  { Network Calculator }
  RSNETCALInvalidIPString     = 'Zeichenkette %s ergibt keine gültige IP.';
  RSNETCALCInvalidNetworkMask = 'Ungültige Netzwerkmaske.';
  RSNETCALCInvalidValueLength = 'Ungültige Länge des Wertes: Sollte 32 sein.';
  RSNETCALConfirmLongIPList = 'Im angegebenen Bereich (%d) gibt es mehr IP-Adressen als zur Entwurfszeit angezeigt werden können.';
  { IdentClient}
  RSIdentReplyTimeout = 'Zeit überschritten bei Antwort:  Der Server gab keine Antwort zurück, und die Abfrage wurde abgebrochen';
  RSIdentInvalidPort = 'Ungültiger Port:  Der fremde oder lokale Port sind nicht korrekt angegeben oder ungültig';
  RSIdentNoUser = 'Kein Benutzer:  Port-Paar wird nicht oder nicht von identifizierbarem Benutzer verwendet';
  RSIdentHiddenUser = 'Verborgener Benutzer:  Information wurde nicht bei Benutzeranforderung zurückgegeben';
  RSIdentUnknownError = 'Unbekannter oder anderer Fehler: Der Besitzer oder anderer Fehler kann nicht festgestellt werden, oder der Fehler wurde nicht offen gelegt werden.';

  {Standard dialog stock strings}
  {}

  { Tunnel messages }
  RSTunnelGetByteRange = 'Aufruf von %s.GetByte [Eigenschaft Bytes] mit Index <> [0..%d]';
  RSTunnelTransformErrorBS = 'Fehler bei der Transformation vor dem Senden';
  RSTunnelTransformError = 'Transformation fehlgeschlagen';
  RSTunnelCRCFailed = 'CRC fehlgeschlagen';
  RSTunnelConnectMsg = 'Herstellen der Verbindung';
  RSTunnelDisconnectMsg = 'Verbindung trennen';
  RSTunnelConnectToMasterFailed = 'Zum Haupt-Server kann keine Verbindung hergestellt werden';
  RSTunnelDontAllowConnections = 'Verbindungen jetzt nicht zulassen';
  RSTunnelMessageTypeError = 'Fehler beim Erkennen des Botschaftstyps';
  RSTunnelMessageHandlingError = 'Botschaftsbehandlung fehlgeschlagen';
  RSTunnelMessageInterpretError = 'Die Interpretation der Botschaft ist nicht gelungen';
  RSTunnelMessageCustomInterpretError = 'Individuelle Botschaftsinterpretation ist fehlgeschlagen';

  { Socks messages }

  { FTP }
  RSDestinationFileAlreadyExists = 'Die Zieldatei existiert bereits.';

  { SSL messages }
  RSSSLAcceptError = 'Fehler beim Annehmen der Verbindung mit SSL.';
  RSSSLConnectError = 'Fehler beim Verbinden mit SSL.';
  RSSSLSettingCipherError = 'SetCipher fehlgeschlagen.';
  RSSSLCreatingSessionError = 'Fehler beim Anlegen einer SSL-Sitzung.';
  RSSSLCreatingContextError = 'Fehler beim Anlegen eines SSL-Kontexts.';
  RSSSLLoadingRootCertError = 'Stammzertifikat konnte nicht geladen werden.';
  RSSSLLoadingCertError = 'Zertifikat konnte nicht geladen werden.';
  RSSSLLoadingKeyError = 'Der Schlüssel konnte nicht geladen werden; überprüfen Sie das Passwort.';
  RSSSLLoadingDHParamsError = 'DH-Parameter konnten nicht geladen werden.';
  RSSSLGetMethodError = 'Fehler beim Abrufen einer SSL-Methode.';
  RSSSLFDSetError = 'Fehler beim Setzen des Dateideskriptors für SSL';
  RSSSLDataBindingError = 'Fehler beim Binden der Daten an den SSL-Socket.';
  RSSSLEOFViolation = 'EOF festgestellt, das gegen das Protokoll verstößt';

  {IdMessage Component Editor}
  RSMsgCmpEdtrNew = '&Neuer Botschaftsteil...';
  RSMsgCmpEdtrExtraHead = 'Texteditor für Extra-Header';
  RSMsgCmpEdtrBodyText = 'Editor für Textkörper';

  {IdNNTPServer}
  RSNNTPServerNotRecognized = 'Befehl nicht erkannt';
  RSNNTPServerGoodBye = 'Auf Wiedersehen';
  RSNNTPSvrImplicitTLSRequiresSSL = 'Implizites NNTP erfordert, dass der IOHandler auf ein TIdSSLIOHandlerSocketBase gesetzt wird.';
  RSNNTPRetreivedArticleFollows = ' Artikel abgerufen - Header und Rumpf folgen';
  RSNNTPRetreivedBodyFollows = ' Artikel abgerufen - Rumpf folgt';
  RSNNTPRetreivedHeaderFollows =  ' Artikel abgerufen - Header folgt';
  RSNNTPRetreivedAStaticstsOnly = ' Artikel abgerufen - nur Statistik';
  RSNTTPNewsToMeSendArticle = 'Nachrichten für mich!  <CRLF.CRLF> zum Beenden.';
  RSNTTPArticleRetrievedRequestTextSeparately = ' Artikel abgerufen - Text separat anfordern';
  RSNTTPNotInNewsgroup = 'Aktuell nicht in der Newsgroup';
  RSNNTPExtSupported = 'Erweiterungen unterstützt:';
  
  //IdNNTPServer reply messages
  RSNTTPReplyHelpTextFollows = 'Hilfetext folgt';
  RSNTTPReplyDebugOutput =  'Debug-Ausgabe';
   
  RSNNTPReplySvrReadyPostingAllowed =  'Server bereit - Veröffentlichen zulässig';
  RSNNTPReplySvrReadyNoPostingAllowed =  'Server bereit - kein Veröffentlichen zulässig';
  RSNNTPReplySlaveStatus =  'Slave-Status zur Kenntnis genommen';
  RSNNTPReplyClosingGoodby = 'Verbindung wird geschlossen - auf Wiedersehen!';
  RSNNTPReplyNewsgroupsFollow = 'Liste der Newsgroups folgt';
  RSNNTPReplyHeadersFollow =  'Header folgen';
  RSNNTPReplyOverViewInfoFollows =  'Übersichtsinformationen folgen';
  RSNNTPReplyNewNewsgroupsFollow =  'Liste der neuen Newsgroups folgt';
  RSNNTPReplyArticleTransferedOk =  'Artikel übertragen ok';
  RSNNTPReplyArticlePostedOk =  'Artikel gesendet ok';
  RSNNTPReplyAuthAccepted = 'Authentifizierung akzeptiert';

  RSNNTPReplySendArtTransfer = 'zu übertragenden Artikel senden. Beenden mit <CR-LF>.<CR-LF>';
  RSNNTPReplySendArtPost =  'zu veröffentlichenden Artikel senden. Beenden mit <CR-LF>.<CR-LF>';
  RSNNTPReplyMoreAuthRequired = 'Weitere Authentifizierungsinformationen erforderlich';
  RSNNTPReplyContinueTLSNegot = 'TLS-Aushandlung fortsetzen';

  RSNNTPReplyServiceDiscont =  'Dienst abgebrochen';
  RSNNTPReplyTLSTempUnavail =  'TLS temporär nicht verfügbar';
  RSNNTPReplyNoSuchNewsgroup =  'diese Newsgroup ist nicht vorhanden';
  RSNNTPReplyNoNewsgroupSel =  'keine Newsgroup ausgewählt';
  RSNNTPReplyNoArticleSel =  'kein aktueller Artikel ausgewählt';
  RSNNTPReplyNoNextArt =  'kein weiterer Artikel in dieser Gruppe';
  RSNNTPReplyNoPrevArt =  'kein vorheriger Artikel in dieser Gruppe';
  RSNNTPReplyNoArtNumber =  'Artikelnummer in dieser Gruppe nicht vorhanden';
  RSNNTPReplyNoArtFound =  'keinen Artikel gefunden';
  RSNNTPReplyArtNotWanted =  'Artikel nicht gewünscht - nicht senden';
  RSNNTPReplyTransferFailed =  'Übertragung fehlgeschlagen - versuchen Sie es später erneut';
  RSNNTPReplyArtRejected =  'Artikel abgelehnt - nicht erneut versuchen.';
  RSNNTPReplyNoPosting =  'Veröffentlichen nicht zulässig';
  RSNNTPReplyPostingFailed =  'Veröffentlichen fehlgeschlagen';
  RSNNTPReplyAuthorizationRequired =  'Autorisierung ist für diesen Befehl erforderlich';
  RSNNTPReplyAuthorizationRejected = 'Autorisierung abgelehnt';
  RSNNTPReplyAuthRejected =  'Authentifizierung erforderlich';
  RSNNTPReplyStrongEncryptionRequired =  'Starke Verschlüsselungsebene ist erforderlich';

  RSNNTPReplyCommandNotRec =  'Befehl nicht erkannt';
  RSNNTPReplyCommandSyntax =  'Fehler in der Befehlssyntax';
  RSNNTPReplyPermDenied =  'Zugriffsbeschränkung oder Zugriff verweigert';
  RSNNTPReplyProgramFault = 'Programmfehler - Befehl nicht ausgeführt';
  RSNNTPReplySecAlreadyActive =  'Sicherheitsebene bereits aktiv';

  {IdGopherServer}
  RSGopherServerNoProgramCode = 'Fehler: Kein Programmcode, um die Anforderung zurückzugeben!';

  {IdSyslog}
  RSInvalidSyslogPRI = 'Ungültige Syslog-Botschaft: Inkorrekter PRI-Abschnitt';
  RSInvalidSyslogPRINumber = 'Ungültige Syslog-Botschaft: Inkorrekte PRI-Nummer "%s"';
  RSInvalidSyslogTimeStamp = 'Ungültige Syslog-Botschaft: Ungültiger Zeitstempel "%s"';
  RSInvalidSyslogPacketSize = 'Ungültige Syslog-Botschaft: Paket zu groß (%d Byte)';
  RSInvalidHostName = 'Ungültiger Host-Name. Ein SYSLOG-Host-Name darf keine Leerzeichen enthalten ("%s")+';

  {IdWinsockStack}
  RSWSockStack = 'Winsock-Stack';

  {IdSMTPServer}
  RSSMTPSvrCmdNotRecognized = 'Command Not Recognised';
  RSSMTPSvrQuit = 'Signing Off';
  RSSMTPSvrOk   = 'Ok';
  RSSMTPSvrStartData = 'Start mail input; end with <CRLF>.<CRLF>';
  RSSMTPSvrAddressOk = '%s Address Okay';
  RSSMTPSvrAddressError = '%s Address Error';
  RSSMTPSvrNotPermitted = '%s Sender Not Permitted';
    // !!!YES!!! - do not relay for third parties - otherwise you have a server
    //waiting to be abused by some spammer.
  RSSMTPSvrNoRelay = 'We do not relay %s';
  RSSMTPSvrWelcome = 'Welcome to the INDY SMTP Server';
  RSSMTPSvrHello = 'Hello %s';
  RSSMTPSvrNoHello = 'Polite people say HELO';
  RSSMTPSvrCmdGeneralError = 'Syntax Error - Command not understood: %s';
  RSSMTPSvrXServer = 'Indy SMTP Server';
  RSSMTPSvrReceivedHeader = 'by DNSName [127.0.0.1] running Indy SMTP';
  RSSMTPSvrAuthFailed = 'Authentication Failed';
  RSSMTPSvrAddressWillForward = '%s User not local, Will forward';
  RSSMTPSvrReqSTARTTLS = 'Must issue a STARTTLS command first';
  RSSMTPSvrParmErrMailFrom = 'Parameter error! Example: mail from:<user@domain.com>';
  RSSMTPSvrParmErrRcptTo = 'Command parameter error! Example: rcpt to:<a@b.c>';
  RSSMTPSvrParmErr = 'Syntax error in parameters or arguments';
  RSSMTPSvrParmErrNoneAllowed = 'Syntax error (no parameters allowed)';
  RSSMTPSvrReadyForTLS = 'Ready to start TLS';
  RSSMTPSvrCmdErrSecurity = 'Command refused due to lack of security'; // errorcode 554
  RSSMTPSvrImplicitTLSRequiresSSL = 'Implicit SMTP TLS requires that IOHandler be set to a TIdServerIOHandlerSSL.';
  RSSMTPSvrBadSequence = 'Bad sequence of commands';
  RSSMTPNotLoggedIn = 'Not logged in';
  RSSMTPMailboxUnavailable = 'Requested action not taken: mailbox unavailable';
  RSSMTPUserNotLocal = 'User %s not local; please try <%s>';
  RSSMTPUserNotLocalNoAddr = 'User %s not local; no forwarding address';
  RSSMTPUserNotLocalFwdAddr = 'User %s not local; will forward to <%s>';
  RSSMTPTooManyRecipients = 'Too Many recipients.';
  RSSMTPAccountDisabled = '%s Account Disabled';
  RSSMTPLocalProcessingError = 'Local Processing Error';
  RSSMTPNoOnRcptTo = 'No OnRcptTo event';
  //data command error replies
  RSSMTPSvrExceededStorageAlloc = 'Requested mail action aborted: exceeded storage allocation';
  RSSMTPSvrMailBoxNameNotAllowed = 'Requested action not taken: mailbox name not allowed';
  RSSMTPSvrTransactionFailed = ' Transaction failed';
  RSSMTPSvrLocalError = 'Requested action aborted: local error in processing';
  RSSMTPSvrInsufficientSysStorage = 'Requested action not taken: insufficient system storage ';
  RSSMTPMsgLenLimit = 'Message length exceeds administrative limit';
  // SPF replies
  RSSMTPSvrSPFCheckFailed = 'SPF %s check failed';
  RSSMTPSvrSPFCheckError = 'SPF %s check error';

  { IdPOP3Server }
  RSPOP3SvrImplicitTLSRequiresSSL = 'Implizites POP3 erfordert, dass der IOHandler auf ein TIdServerIOHandlerSSL gesetzt wird.';
  RSPOP3SvrMustUseSTLS = 'Muss STLS verwenden';
  RSPOP3SvrNotHandled = 'Befehl nicht behandelt: %s';
  RSPOP3SvrNotPermittedWithTLS = 'Befehl nicht zulässig, wenn TLS aktiv ist';
  RSPOP3SvrNotInThisState = 'Befehl in diesem Status nicht zulässig';
  RSPOP3SvrBeginTLSNegotiation = 'TLS-Aushandlung beginnen';
  RSPOP3SvrLoginFirst = 'Bitte melden Sie sich zuerst an';
  RSPOP3SvrInvalidSyntax = 'Ungültige Syntax';
  RSPOP3SvrClosingConnection = 'Verbindungskanal wird geschlossen';
  RSPOP3SvrPasswordRequired = 'Passwort erforderlich';
  RSPOP3SvrLoginFailed = 'Anmeldung fehlgeschlagen';
  RSPOP3SvrLoginOk = 'Anmeldung OK';
  RSPOP3SvrWrongState = 'Falscher Status';
  RSPOP3SvrInvalidMsgNo = 'Ungültige Botschaftsnummer';
  RSPOP3SvrNoOp = 'NOOP';
  RSPOP3SvrReset = 'Zurücksetzen';
  RSPOP3SvrCapaList = 'Funktionalitätsliste folgt';
  RSPOP3SvrWelcome = 'Willkommen beim Indy POP3-Server';
  RSPOP3SvrUnknownCmd = 'Unbekannter Befehl';
  RSPOP3SvrUnknownCmdFmt = 'Unbekannter Befehl: %s';
  RSPOP3SvrInternalError = 'Unbekannter interner Fehler';
  RSPOP3SvrHelpFollows = 'Hilfe folgt';
  RSPOP3SvrTooManyCons = 'Zu viele Verbindungen. Versuchen Sie es später erneut.';
  RSPOP3SvrWelcomeAPOP = 'Willkommen ';

  // TIdCoder3to4
  RSUnevenSizeInDecodeStream = 'Ungerade Größe in DecodeToStream.';
  RSUnevenSizeInEncodeStream = 'Ungerade Größe in Encode.';
  RSIllegalCharInInputString = 'Ungültiges Zeichen im Eingabe-String.';

  // TIdMessageCoder
  RSMessageDecoderNotFound = 'Botschafts-Decoder nicht gefunden';
  RSMessageEncoderNotFound = 'Botschafts-Encoder nicht gefunden';

  // TIdMessageCoderMIME
  RSMessageCoderMIMEUnrecognizedContentTrasnferEncoding = 'Nicht erkannte Inhaltstransfer-Codierung.';

  // TIdMessageCoderUUE
  RSUnrecognizedUUEEncodingScheme = 'Nicht erkanntes UUE-Codierungsschema.';

  { IdFTPServer }
  RSFTPDefaultGreeting = 'Indy FTP-Server bereit.';
  RSFTPOpenDataConn = 'Datenverbindung besteht bereits; Transfer wird gestartet.';
  RSFTPDataConnToOpen = 'Dateistatus OK; Datenverbindung wird geöffnet.';
  RSFTPDataConnList = 'Datenverbindung im ASCII-Modus für /bin/ls wird geöffnet.';
  RSFTPDataConnNList = 'Datenverbindung im ASCII-Modus für Dateiliste wird geöffnet.';
  RSFTPDataConnMLst = 'ASCII-Datenverbindung für Verzeichnisauflistung wird geöffnet';
  RSFTPCmdSuccessful = '%s Befehl erfolgreich.';
  RSFTPServiceOpen = 'Dienst bereit für neuen Benutzer.';
  RSFTPServerClosed = 'Dienst schließt die Steuerverbindung.';
  RSFTPDataConn = 'Datenverbindung besteht bereits; kein Transfer läuft.';
  RSFTPDataConnClosed = 'Datenverbindung wird geschlossen.';
  RSFTPDataConnEPLFClosed = 'Erfolg.';
  RSFTPDataConnClosedAbnormally = 'Datenverbindung wurde anormal geschlossen.';
  RSFTPPassiveMode = 'Passiv-Modus (%s) wird aktiviert.';
  RSFTPUserLogged = 'Benutzer angemeldet, weiter.';
  RSFTPAnonymousUserLogged = 'Anonymer Benutzer angemeldet, weiter.';
  RSFTPFileActionCompleted = 'Angeforderte Dateiaktion OK, abgeschlossen.';
  RSFTPDirFileCreated = '"%s" erzeugt.';
  RSFTPUserOkay = 'Benutzername OK, Passwort wird benötigt.';
  RSFTPAnonymousUserOkay = 'Anonyme Anmeldung OK, E-Mail als Passwort senden.';
  RSFTPNeedLoginWithUser = 'Zuerst mit USER anmelden.';
  RSFTPNotAfterAuthentication = 'Nicht im Autorisierungsstatus, bereits angemeldet.';
  RSFTPFileActionPending = 'Angeforderte Dateiaktion steht aus wegen Informationsbedarf.';
  RSFTPServiceNotAvailable = 'Dienst nicht verfügbar, Steuerverbindung wird geschlossen.';
  RSFTPCantOpenDataConn = 'Datenverbindung kann nicht geöffnet werden.';
  RSFTPFileActionNotTaken = 'Angeforderte Dateiaktion nicht durchgeführt.';
  RSFTPFileActionAborted = 'Angeforderte Aktion abgebrochen: Lokaler Fehler bei Bearbeitung.';
  RSFTPEnteringEPSV = 'Erweiterter Passiv-Modus (%s) wird aktiviert';
  RSFTPClosingConnection = 'Dienst nicht verfügbar, Steuerverbindung wird geschlossen.';
  RSFTPPORTDisabled = 'PORT/EPRT-Befehl deaktiviert.';
  RSFTPPORTRange    = 'PORT/EPRT-Befehl deaktiviert für reservierten Port-Bereich (1-1024).';
  RSFTPSameIPAddress = 'Daten-Port kann nur von derselben IP-Adresse verwendet werden, die die Steuerverbindung benutzt.';
  RSFTPCantOpenData = 'Datenverbindung kann nicht geöffnet werden.';
  RSFTPEPSVAllEntered = ' EPSV ALL gesendet, jetzt werden nur EPSV-Verbindungen akzeptiert';
  RSFTPNetProtNotSup = 'Netzwerkprotokoll nicht unterstützt, verwenden Sie %s';
  RSFTPFileOpSuccess = 'Dateioperation erfolgreich';
  RSFTPIsAFile = '%s: Ist eine Datei.';
  RSFTPInvalidOps = 'Ungültige %s-Optionen';
  RSFTPOptNotRecog = 'Option nicht erkannt.';
  RSFTPPropNotNeg = 'Eigenschaft darf keine negative Zahl sein.';
  RSFTPClntNoted = 'Zur Kenntnis genommen.';
  RSFTPQuitGoodby = 'Auf Wiedersehen.';
  RSFTPPASVBoundPortMaxMustBeGreater = 'PASVBoundPortMax muss größer als PASVBoundPortMax sein.';
  RSFTPPASVBoundPortMinMustBeLess = 'PASVBoundPortMin muss kleiner als PASVBoundPortMax sein.';
  RSFTPRequestedActionNotTaken = 'Angeforderte Aktion nicht durchgeführt.';
  RSFTPCmdNotRecognized = #39'%s'#39': Befehl wurde nicht verstanden.';
  RSFTPCmdNotImplemented = '"%s" Befehl nicht implementiert.';
  RSFTPCmdHelpNotKnown = 'Unbekannter Befehl %s.';
  RSFTPUserNotLoggedIn = 'Nicht angemeldet.';
  RSFTPActionNotTaken = 'Angeforderte Aktion nicht durchgeführt.';
  RSFTPActionAborted = 'Angeforderte Aktion abgebrochen: Seitenzahl unbekannt.';
  RSFTPRequestedFileActionAborted = 'Angeforderte Dateiaktion abgebrochen.';
  RSFTPRequestedFileActionNotTaken = 'Angeforderte Aktion nicht durchgeführt.';
  RSFTPMaxConnections = 'Max. Anzahl an Verbindungen überschritten. Versuchen Sie es später.';
  RSFTPDataConnToOpenStou = 'Datenverbindung für %s wird gleich geöffnet';
  RSFTPNeedAccountForLogin = 'Konto für Anmeldung wird benötigt.';
  RSFTPAuthSSL = 'AUTH-Befehl OK. SSL wird initialisiert';
  RSFTPDataProtBuffer0 = 'PBSZ-Befehl OK. Größe des Schutzpuffers ist auf 0 gesetzt.';

  RSFTPInvalidProtTypeForMechanism = 'Angeforderte PROT-Ebene wird vom Mechanismus nicht unterstützt.';
  RSFTPProtTypeClear   = 'PROT-Befehl OK. Klartextdatenverbindung wird verwendet';
  RSFTPProtTypePrivate = 'PROT-Befehl OK. Private Datenverbindung wird verwendet';
  RSFTPClearCommandConnection = 'Befehlskanal zu Klartext gewechselt.';
  RSFTPClearCommandNotPermitted = 'Klartext-Befehlskanal ist nicht zulässig.';
  RSFTPPBSZAuthDataRequired = 'AUTH-Daten erforderlich.';
  RSFTPPBSZNotAfterCCC = 'Nach CCC nicht zulässig';
  RSFTPPROTProtBufRequired = 'Größe des PBSZ-Datenpuffers erforderlich.';
  RSFTPInvalidForParam = 'Befehl für diesen Parameter nicht implementiert.';
  RSFTPNotAllowedAfterEPSVAll = '%s nach EPSV ALL nicht zulässig';

  RSFTPOTPMethod = 'Unbekannte OTP-Methode';
  RSFTPIOHandlerWrong = 'IOHandler hat den falschen Typ.';
  RSFTPFileNameCanNotBeEmpty = 'Der Zieldateiname darf nicht leer sein';

  //Note to translators, it may be best to leave the stuff in quotes as the very first
  //part of any phrase otherwise, a FTP client might get confused.
  RSFTPCurrentDirectoryIs = '"%s" ist das Arbeitsverzeichnis.';
  RSFTPTYPEChanged = 'Typ auf %s gesetzt.';
  RSFTPMODEChanged = 'Modus ist auf %s gesetzt.';
  RSFTPMODENotSupported = 'Nicht implementierter Modus.';
  RSFTPSTRUChanged = 'Struktur auf %s gesetzt.';
  RSFTPSITECmdsSupported = 'Folgende SITE-Befehle werden unterstützt:';
  RSFTPDirectorySTRU = '%s-Verzeichnisstruktur.';
  RSFTPCmdStartOfStat = 'Systemstatus';
  RSFTPCmdEndOfStat = 'Ende des Status';
  RSFTPCmdExtsSupportedStart = 'Erweiterungen unterstützt:';
  RSFTPCmdExtsSupportedEnd = 'Ende der Erweiterungen.';
  RSFTPNoOnDirEvent = 'Es wurde kein Ereignis OnListDirectory gefunden!';
  RSFTPImplicitTLSRequiresSSL = 'Implizites FTP erfordert, dass der IOHandler auf ein TIdServerIOHandlerSSL gesetzt wird.';

  //%s number of attributes changes
  RSFTPSiteATTRIBMsg = 'site attrib';
  RSFTPSiteATTRIBInvalid = ' fehlgeschlagen, ungültiges Attribut.';
  RSFTPSiteATTRIBDone = ' fertig, insgesamt %s Attribute geändert.';
  //%s is the umask number
  RSFTPUMaskIs = 'Aktuelles UMASK ist %.3d';
  //first %d is the new value, second one is the old value
  RSFTPUMaskSet = 'UMASK auf %.3d (war %.3d) gesetzt';
  RSFTPPermissionDenied = 'Zugriff verweigert.';
  RSFTPCHMODSuccessful = 'CHMOD-Befehl erfolgreich.';
  RSFTPHelpBegining = 'Die folgenden Befehle werden erkannt (* => nicht implementiert, + => Erweiterung).';
  //toggles for DIRSTYLE SITE command in IIS
  RSFTPOn = 'ein';
  RSFTPOff = 'aus';
  RSFTPDirStyle = 'Verzeichnisausgabe im MSDOS-Stil ist %s';

  {SYSLog Message}
  // facility
  STR_SYSLOG_FACILITY_KERNEL     = 'Kernel-Botschaften';
  STR_SYSLOG_FACILITY_USER       = 'Botschaften auf Benutzerebene';
  STR_SYSLOG_FACILITY_MAIL       = 'Mail-System';
  STR_SYSLOG_FACILITY_SYS_DAEMON = 'System-Daemone';
  STR_SYSLOG_FACILITY_SECURITY1  = 'Sicherheits-/Autorisierungsbotschaften (1)';
  STR_SYSLOG_FACILITY_INTERNAL   = 'Botschaften, die intern von syslogd generiert werden';
  STR_SYSLOG_FACILITY_LPR        = 'Zeilendrucker-Untersystem';
  STR_SYSLOG_FACILITY_NNTP       = 'Netzwerknachrichtensystem';
  STR_SYSLOG_FACILITY_UUCP       = 'UUCP-Subsystem';
  STR_SYSLOG_FACILITY_CLOCK1     = 'Uhrzeit-Daemon (1)';
  STR_SYSLOG_FACILITY_SECURITY2  = 'Sicherheits-/Autorisierungsbotschaften (2)';
  STR_SYSLOG_FACILITY_FTP        = 'FTP-Daemon';
  STR_SYSLOG_FACILITY_NTP        = 'NTP-Subsystem';
  STR_SYSLOG_FACILITY_AUDIT      = 'Protokollüberprüfung';
  STR_SYSLOG_FACILITY_ALERT      = 'Protokollalarm';
  STR_SYSLOG_FACILITY_CLOCK2     = 'Uhrzeit-Daemon (2)';
  STR_SYSLOG_FACILITY_LOCAL0     = 'Lokale Verwendung 0  (local0)';
  STR_SYSLOG_FACILITY_LOCAL1     = 'Lokale Verwendung 1  (local1)';
  STR_SYSLOG_FACILITY_LOCAL2     = 'Lokale Verwendung 2  (local2)';
  STR_SYSLOG_FACILITY_LOCAL3     = 'Lokale Verwendung 3  (local3)';
  STR_SYSLOG_FACILITY_LOCAL4     = 'Lokale Verwendung 4  (local4)';
  STR_SYSLOG_FACILITY_LOCAL5     = 'Lokale Verwendung 5  (local5)';
  STR_SYSLOG_FACILITY_LOCAL6     = 'Lokale Verwendung 6  (local6)';
  STR_SYSLOG_FACILITY_LOCAL7     = 'Lokale Verwendung 7  (local7)';
  STR_SYSLOG_FACILITY_UNKNOWN    = 'Unbekannter oder ungültiger Facility-Code';

  // Severity
  STR_SYSLOG_SEVERITY_EMERGENCY     = 'Notfall: System ist unbrauchbar';
  STR_SYSLOG_SEVERITY_ALERT         = 'Alarm: Es muss sofort etwas getan werden';
  STR_SYSLOG_SEVERITY_CRITICAL      = 'Kritisch: Kritischer Zustand';
  STR_SYSLOG_SEVERITY_ERROR         = 'Fehler: Fehlerzustand';
  STR_SYSLOG_SEVERITY_WARNING       = 'Warnung: Warnungszustand';
  STR_SYSLOG_SEVERITY_NOTICE        = 'Hinweis: Normaler, aber signifikanter Zustand';
  STR_SYSLOG_SEVERITY_INFORMATIONAL = 'Information: Informationsbotschaften';
  STR_SYSLOG_SEVERITY_DEBUG         = 'Debug: Botschaften auf Debug-Ebene';
  STR_SYSLOG_SEVERITY_UNKNOWN       = 'Unbekannter oder ungültiger Sicherheits-Code';

  {LPR Messages}
  RSLPRError = 'Antwort %d auf Job-ID %s';
  RSLPRUnknown = 'Unbekannt';
  RSCannotBindRange = 'An LPR-Port aus Bereich %d bis %d kann nicht gebunden werden (Kein freier Port)';

  {IRC Messages}
  RSIRCCanNotConnect = 'IRC-Verbindung fehlgeschlagen';
  // RSIRCNotConnected = 'Not connected to server.';
  // RSIRCClientVersion =  'TIdIRC 1.061 by Steve Williams';
  // RSIRCClientInfo = '%s Non-visual component for 32-bit Delphi.';
  // RSIRCNick = 'Nick';
  // RSIRCAltNick = 'OtherNick';
  // RSIRCUserName = 'ircuser';
  // RSIRCRealName = 'Real name';
  // RSIRCTimeIsNow = 'Local time is %s'; // difficult to strip for clients

  {HL7 Lower Layer Protocol Messages}
  RSHL7StatusStopped           = 'Angehalten';
  RSHL7StatusNotConnected      = 'Nicht verbunden';
  RSHL7StatusFailedToStart     = 'Start fehlgeschlagen: %s';
  RSHL7StatusFailedToStop      = 'Anhalten fehlgeschlagen: %s';
  RSHL7StatusConnected         = 'Verbunden';
  RSHL7StatusConnecting        = 'Herstellen der Verbindung';
  RSHL7StatusReConnect         = 'Wieder verbinden bei %s: %s';
  RSHL7NotWhileWorking         = 'Sie können %s nicht setzen, während die HL7-Komponente arbeitet';
  RSHL7NotWorking              = 'Versuch zu %s, während die HL7-Komponente nicht arbeitet';
  RSHL7NotFailedToStop         = 'Interface ist unbrauchbar, da es nicht angehalten werden kann';
  RSHL7AlreadyStarted          = 'Interface wurde bereits gestartet';
  RSHL7AlreadyStopped          = 'Interface wurde bereits angehalten';
  RSHL7ModeNotSet              = 'Modus ist nicht initialisiert';
  RSHL7NoAsynEvent             = 'Komponente ist in asynchronen Modus, aber OnMessageArrive wurde nicht verwendet';
  RSHL7NoSynEvent              = 'Komponente ist in synchronen Modus, aber OnMessageReceive wurde nicht verwendet';
  RSHL7InvalidPort             = 'Zugewiesener Wert für Port %d ist ungültig';
  RSHL7ImpossibleMessage       = 'Es wurde eine Botschaft empfangen, aber der Kommunikationsmodus ist unbekannt';
  RSHL7UnexpectedMessage       = 'Eine unerwartete Botschaft kam bei einem Interface an, das nicht empfangsbereit ist.';
  RSHL7UnknownMode             = 'Unbekannter Modus';
  RSHL7ClientThreadNotStopped  = 'Client-Thread kann nicht angehalten werden';
  RSHL7SendMessage             = 'Eine Botschaft senden';
  RSHL7NoConnectionFound       = 'Serververbindung wird beim Senden der Botschaft nicht gefunden';
  RSHL7WaitForAnswer           = 'Sie können keine Botschaft schicken, während Sie auf eine Antwort warten.';
  //TIdHL7 error messages
  RSHL7ErrInternalsrNone       =  'Interner Fehler in IdHL7.pas: SynchronousSend hat srNone zurückgegeben';
  RSHL7ErrNotConn              =   'Nicht verbunden';
  RSHL7ErrInternalsrSent       =  'Interner Fehler in IdHL7.pas: SynchronousSend hat srSent zurückgegeben';
  RSHL7ErrNoResponse           =  'Keine Antwort vom Remote-System';
  RSHL7ErrInternalUnknownVal   =  'Interner Fehler in IdHL7.pas: SynchronousSend hat einen unbekannten Wert zurückgegeben ';
  RSHL7Broken                  = 'IdHL7 arbeitet in Indy 10 gegenwärtig nicht';

  { TIdMultipartFormDataStream exceptions }
  RSMFDInvalidObjectType        = 'Nicht unterstützter Objekttyp. Sie können nur einen der folgenden Typen oder deren Nachkommen zuweisen: TStrings, TStream.';
  RSMFDInvalidTransfer          = 'Nicht unterstützter Transfertyp. Es kann nur ein leerer String oder einer der folgenden Werte zugewiesen werden: 7bit, 8bit, binary, quoted-printable, base64.';
  RSMFDInvalidEncoding          = 'Nicht unterstützte Codierung. Es kann nur einer der folgenden Werte zugewiesen werden: Q, B, 8.';

  { TIdURI exceptions }
  RSURINoProto                 = 'Protokollfeld ist leer';
  RSURINoHost                  = 'Host-Feld ist leer';

  { TIdIOHandlerThrottle}
  RSIHTChainedNotAssigned      = 'Sie müssen diese Komponenten vor ihrer Verwendung an einen anderen I/O-Handler binden';

  { TIdSNPP}
  RSSNPPNoMultiLine            = 'TIdSNPP-Befehl Mess unterstützt nur einzeilige Botschaften.';

  {TIdThread}
  RSUnassignedUserPassProv     = 'Nicht zugewiesener UserPassProvider!';

  {TIdDirectSMTP}
  RSDirSMTPInvalidEMailAddress = 'Ungültige E-Mail-Adresse %s';
  RSDirSMTPNoMXRecordsForDomain = 'Keine MX-Datensätze für die Domäne %s';
  RSDirSMTPCantConnectToSMTPSvr = 'Für Adresse %s kann nicht zu MX-Servern verbunden werden';
  RSDirSMTPCantAssignHost       = 'Host-Eigenschaft kann nicht zugewiesen werden, sie wird von IdDirectSMTP aufgelöst.';

  {TIdMessageCoderYenc}
  RSYencFileCorrupted           = 'Datei beschädigt.';
  RSYencInvalidSize             = 'Ungültige Größe';
  RSYencInvalidCRC              = 'Ungültiges CRC';

  {TIdSocksServer}
  RSSocksSvrNotSupported        = 'Nicht unterstützt';
  RSSocksSvrInvalidLogin        = 'Ungültige Anmeldung';
  RSSocksSvrWrongATYP           = 'Falscher SOCKS5-ATYP';
  RSSocksSvrWrongSocksVersion   = 'Falsche SOCKS-Version';
  RSSocksSvrWrongSocksCommand   = 'Falscher SOCKS-Befehl';
  RSSocksSvrAccessDenied        = 'Zugriff verweigert';
  RSSocksSvrUnexpectedClose     = 'Unerwartetes Ende';
  RSSocksSvrPeerMismatch        = 'Peer IP stimmt nicht überein';

  {TLS Framework}
  RSTLSSSLIOHandlerRequired = 'SSL IOHandler ist für diese Einstellung erforderlich';
  RSTLSSSLCanNotSetWhileActive = 'Dieser Wert kann nicht gesetzt werden, während der Server aktiv ist.';
  RSTLSSLCanNotSetWhileConnected = 'Dieser Wert kann nicht gesetzt werden, während der Client verbunden ist.';
  RSTLSSLSSLNotAvailable = 'SSL ist auf diesem Server nicht verfügbar.';
  RSTLSSLSSLCmdFailed = 'Befehl zum Starten der SSL-Aushandlung fehlgeschlagen.';

  ///IdPOP3Reply
  //user's provided reply will follow this string
  RSPOP3ReplyInvalidEnhancedCode = 'Ungültiger erweiterter Code: ';

  //IdSMTPReply
  RSSMTPReplyInvalidReplyStr = 'Invalid Reply String.';
  RSSMTPReplyInvalidClass = 'Invalid Reply Class.';

  RSUnsupportedOperation = 'Nicht unterstützte Operation.';

  //Mapped port components
  RSEmptyHost = 'Host ist leer';    {Do not Localize}
  RSPop3ProxyGreeting = 'POP3-Proxy bereit';    {Do not Localize}
  RSPop3UnknownCommand = 'Befehl muss entweder USER oder QUIT sein';    {Do not Localize}
  RSPop3QuitMsg = 'POP3-Proxy wird beendet';    {Do not Localize}

  //IMAP4 Server
  RSIMAP4SvrBeginTLSNegotiation = 'TLS-Aushandlung jetzt beginnen';
  RSIMAP4SvrNotPermittedWithTLS = 'Befehl nicht zulässig, wenn TLS aktiv ist';
  RSIMAP4SvrImplicitTLSRequiresSSL = 'Implizites IMAP4 erfordert, dass der IOHandler auf ein TIdServerIOHandlerSSLBase gesetzt wird.';

  // OTP Calculator
  RSFTPFSysErrMsg = 'Zugriff verweigert';
  RSOTPUnknownMethod = 'Unbekannte OTP-Methode';

  // Message Header Encoding
  RSHeaderEncodeError = 'Header-Daten konnten nicht mit Zeichensatz "%s" codiert werden';
  RSHeaderDecodeError = 'Header-Daten konnten nicht mit Zeichensatz "%s" decodiert werden';

  // message builder strings
  rsHtmlViewerNeeded = 'Zum Anzeigen der Meldung ist ein HTML-Viewer erforderlich';
  rsRtfViewerNeeded = 'Zum Anzeigen der Meldung ist ein RTF-Viewer erforderlich';

  // HTTP Web Broker Bridge strings
  RSWBBInvalidIdxGetDateVariable = 'Ungültiger Index %s in TIdHTTPAppResponse.GetDateVariable';
  RSWBBInvalidIdxSetDateVariable = 'Ungültiger Index %s in TIdHTTPAppResponse.SetDateVariable';
  RSWBBInvalidIdxGetIntVariable = 'Ungültiger Index %s in TIdHTTPAppResponse.GetIntegerVariable';
  RSWBBInvalidIdxSetIntVariable = 'Ungültiger Index %s in TIdHTTPAppResponse.SetIntegerVariable';
  RSWBBInvalidIdxGetStrVariable = 'Ungültiger Index %s in TIdHTTPAppResponse.GetStringVariable';
  RSWBBInvalidStringVar = 'TIdHTTPAppResponse.SetStringVariable: Version kann nicht gesetzt werden';
  RSWBBInvalidIdxSetStringVar = 'Ungültiger Index %s in TIdHTTPAppResponse.SetStringVariable';

implementation

end.
