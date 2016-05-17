unit IdResourceStringsOpenSSL;

interface

resourcestring
  {IdOpenSSL}
  RSOSSFailedToLoad = 'Fehler beim Laden von %s.';
  RSOSSLModeNotSet = 'Der Modus wurde nicht gesetzt.';
  RSOSSLCouldNotLoadSSLLibrary = 'SSL.-Bibliothek konnte nicht geladen werden.';
  RSOSSLStatusString = 'SSL-Status: "%s"';
  RSOSSLConnectionDropped = 'Die SSL-Verbindung ging verloren.';
  RSOSSLCertificateLookup = 'Fehler bei der Anforderung eines SSL-Zertifikats.';
  RSOSSLInternal = 'SSL-Bibliotheksinterner Fehler.';
  //callback where strings
  RSOSSLAlert =  '%s Meldung';
  RSOSSLReadAlert =  '%s Lesemeldung';
  RSOSSLWriteAlert =  '%s Schreibmeldung';
  RSOSSLAcceptLoop = 'Annahme-Schleife';
  RSOSSLAcceptError = 'Fehler bei der Annahme';
  RSOSSLAcceptFailed = 'Annahme fehlgeschlagen';
  RSOSSLAcceptExit =  'Annahme-Ende';
  RSOSSLConnectLoop =  'Verbindungsschleife';
  RSOSSLConnectError = 'Fehler bei der Verbindung';
  RSOSSLConnectFailed = 'Verbindung fehlgeschlagen';
  RSOSSLConnectExit =  'Verbindungsende';
  RSOSSLHandshakeStart = 'Handshake-Start';
  RSOSSLHandshakeDone =  'Handshake ausgeführt';

implementation

end.
