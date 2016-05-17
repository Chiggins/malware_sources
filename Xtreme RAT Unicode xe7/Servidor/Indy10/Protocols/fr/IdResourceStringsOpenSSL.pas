unit IdResourceStringsOpenSSL;

interface

resourcestring
  {IdOpenSSL}
  RSOSSFailedToLoad = 'Le chargement de %s a échoué.';
  RSOSSLModeNotSet = 'Le mode n'#39'a pas été défini.';
  RSOSSLCouldNotLoadSSLLibrary = 'Impossible de charger la bibliothèque SSL.';
  RSOSSLStatusString = 'Etat SSL : "%s"';
  RSOSSLConnectionDropped = 'La connexion SSL s'#39'est interrompue.';
  RSOSSLCertificateLookup = 'Erreur de requête de certificat SSL.';
  RSOSSLInternal = 'Erreur interne de la bibliothèque SSL.';
  //callback where strings
  RSOSSLAlert =  'Alerte %s';
  RSOSSLReadAlert =  'Alerte Lecture %s';
  RSOSSLWriteAlert =  'Alerte Ecriture %s';
  RSOSSLAcceptLoop = 'Boucle d'#39'acceptation';
  RSOSSLAcceptError = 'Erreur d'#39'acceptation';
  RSOSSLAcceptFailed = 'Echec de l'#39'acceptation';
  RSOSSLAcceptExit =  'Sortie d'#39'acceptation';
  RSOSSLConnectLoop =  'Boucle de connexion';
  RSOSSLConnectError = 'Erreur de connexion';
  RSOSSLConnectFailed = 'Echec de la connexion';
  RSOSSLConnectExit =  'Sortie de la connexion';
  RSOSSLHandshakeStart = 'Négociation démarrée';
  RSOSSLHandshakeDone =  'Négociation effectuée';

implementation

end.
