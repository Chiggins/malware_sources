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
  RSIOHandlerPropInvalid = 'Valeur IOHandler non valide';

  //FIPS
  RSFIPSAlgorithmNotAllowed = 'L'#39'algorithme %s n'#39'est pas autorisé en mode FIPS';
  //FSP
  RSFSPNotFound = 'Fichier introuvable';
  RSFSPPacketTooSmall = 'Paquet trop petit';

  //SASL
  RSSASLNotReady = 'Les gestionnaires SASL spécifiés ne sont pas prêts !!';
  RSSASLNotSupported = 'Ne supporte pas AUTH ou les gestionnaires SASL spécifiés !!';
  RSSASLRequired = 'Mécanismes SASL nécessaires pour la connexion !!';

  //TIdSASLDigest
  RSSASLDigestMissingAlgorithm = 'algorithme manquant.';
  RSSASLDigestInvalidAlgorithm = 'algorithme non valide.';
  RSSASLDigestAuthConfNotSupported = 'auth-conf pas encore supporté.';

  //  TIdEMailAddress
  RSEMailSymbolOutsideAddress = '@ Adresse extérieure';

  //ZLIB Intercept
  RSZLCompressorInitializeFailure = 'Impossible d'#39'initialiser le compresseur';
  RSZLDecompressorInitializeFailure = 'Impossible d'#39'initialiser le décompresseur';
  RSZLCompressionError = 'Erreur de compression';
  RSZLDecompressionError = 'Erreur de décompression';

  //MIME Types
  RSMIMEExtensionEmpty = 'Extension vide';
  RSMIMEMIMETypeEmpty = 'Mimetype vide';
  RSMIMEMIMEExtAlreadyExists = 'Extension déjà existante';

  // IdRegister
  RSRegSASL = 'Indy SASL';

  // Status Strings
  // TIdTCPClient
  // Message Strings
  RSIdMessageCannotLoad = 'Impossible de charger le message depuis le fichier %s';

  // MessageClient Strings
  RSMsgClientEncodingText = 'Encodage du texte';
  RSMsgClientEncodingAttachment = 'Encodage de la pièce jointe';
  RSMsgClientInvalidEncoding = 'Encodage non valide. UU autorise seulement le corps et les pièces jointes.';
  RSMsgClientInvalidForTransferEncoding = 'Les parties de message ne peuvent pas être utilisées dans un message ayant une valeur ContentTransferEncoding.';

  // NNTP Exceptions
  RSNNTPConnectionRefused = 'La connexion a été explicitement refusée par le serveur NNTP.';
  RSNNTPStringListNotInitialized = 'Stringlist non initialisée !';
  RSNNTPNoOnNewsgroupList = 'Aucun événement OnNewsgroupList n'#39'a été défini.';
  RSNNTPNoOnNewGroupsList = 'Aucun événement OnNewGroupsList n'#39'a été défini.';
  RSNNTPNoOnNewNewsList = 'Aucun événement OnNewNewsList n'#39'a été défini.';
  RSNNTPNoOnXHDREntry = 'Aucun événement OnXHDREntry n'#39'a été défini.';
  RSNNTPNoOnXOVER = 'Aucun événement OnXOVER n'#39'a été défini.';

  // HTTP Status
  RSHTTPChunkStarted = 'Opération Chunk démarrée';
  RSHTTPContinue = 'Continuer';
  RSHTTPSwitchingProtocols = 'Permutation des protocoles';
  RSHTTPOK = 'OK';
  RSHTTPCreated = 'Créé';
  RSHTTPAccepted = 'Accepté';
  RSHTTPNonAuthoritativeInformation = 'Informations ne faisant pas autorité';
  RSHTTPNoContent = 'Pas de contenu';
  RSHTTPResetContent = 'Réinitialiser le contenu';
  RSHTTPPartialContent = 'Contenu partiel';
  RSHTTPMovedPermanently = 'Déplacé de façon permanente';
  RSHTTPMovedTemporarily = 'Déplacé de façon temporaire';
  RSHTTPSeeOther = 'Voir autre';
  RSHTTPNotModified = 'Non modifié';
  RSHTTPUseProxy = 'Utiliser le proxy';
  RSHTTPBadRequest = 'Requête incorrecte';
  RSHTTPUnauthorized = 'Non autorisé';
  RSHTTPForbidden = 'Interdit';
  RSHTTPNotFound = 'Introuvable';
  RSHTTPMethodNotAllowed = 'Méthode non autorisée';
  RSHTTPNotAcceptable = 'Inacceptable';
  RSHTTPProxyAuthenticationRequired = 'Authentification du proxy requise';
  RSHTTPRequestTimeout = 'Délai de requête';
  RSHTTPConflict = 'Conflit';
  RSHTTPGone = 'Parti';
  RSHTTPLengthRequired = 'Longueur requise';
  RSHTTPPreconditionFailed = 'Echec de la précondition';
  RSHTTPPreconditionRequired = 'Précondition requise';
  RSHTTPTooManyRequests = 'Trop de requêtes';
  RSHTTPRequestHeaderFieldsTooLarge = 'Champs d'#39'en-tête de la requête trop grands';
  RSHTTPNetworkAuthenticationRequired = 'Authentification du réseau requise';
  RSHTTPRequestEntityTooLong = 'Entité de requête trop longue';
  RSHTTPRequestURITooLong = 'URI de requête trop longue. 256 caractères max';
  RSHTTPUnsupportedMediaType = 'Type de support non supporté';
  RSHTTPExpectationFailed = 'Echec de l'#39'attente';
  RSHTTPInternalServerError = 'Erreur serveur interne';
  RSHTTPNotImplemented = 'Non implémenté';
  RSHTTPBadGateway = 'Passerelle incorrecte';
  RSHTTPServiceUnavailable = 'Service indisponible';
  RSHTTPGatewayTimeout = 'Délai de passerelle';
  RSHTTPHTTPVersionNotSupported = 'Version HTTP non supportée';
  RSHTTPUnknownResponseCode = 'Code de réponse inconnu';

  // HTTP Other
  RSHTTPUnknownProtocol = 'Protocole inconnu';
  RSHTTPMethodRequiresVersion = 'La méthode de requête nécessite HTTP version 1.1';
  RSHTTPHeaderAlreadyWritten = 'L'#39'en-tête a déjà été écrit.';
  RSHTTPErrorParsingCommand = 'Erreur lors de l'#39'analyse de la commande.';
  RSHTTPUnsupportedAuthorisationScheme = 'Schéma d'#39'autorisation non supporté.';
  RSHTTPCannotSwitchSessionStateWhenActive = 'Impossible de changer l'#39'état de session tant que le serveur est actif.';
  RSHTTPCannotSwitchSessionListWhenActive = 'Impossible de changer la liste de sessions quand le serveur est actif.';

  //HTTP Authentication
  RSHTTPAuthAlreadyRegistered = 'Cette méthode d'#39'authentification est déjà recensée avec le nom de classe %s.';

  //HTTP Authentication Digeest
  RSHTTPAuthInvalidHash = 'Algorithme de hachage non supporté. Cette implémentation supporte seulement l'#39'encodage MD5.';

  // HTTP Cookies
  RSHTTPUnknownCookieVersion = 'Version de cookie non supportée : %d';

  //Block Cipher Intercept
  RSBlockIncorrectLength = 'Longueur incorrecte dans le bloc reçu (%d)';

  // FTP
  RSFTPInvalidNumberArgs = 'Nombre d'#39'arguments %s non valide';
  RSFTPHostNotFound = 'Hôte non trouvé.';
  RSFTPUnknownHost = 'Inconnu';
  RSFTPStatusReady = 'Connexion établie';
  RSFTPStatusStartTransfer = 'Démarrage du transfert FTP';
  RSFTPStatusDoneTransfer  = 'Transfert terminé';
  RSFTPStatusAbortTransfer = 'Transfert abandonné';
  RSFTPProtocolMismatch = 'Non concordance du protocole réseau, utilisez'; { may not include '(' or ')' }
  RSFTPParamError = 'Erreur dans les paramètres (%s)';
  RSFTPParamNotImp = 'Paramètre %s non implémenté';
  RSFTPInvalidPort = 'Numéro de port non valide';
  RSFTPInvalidIP = 'Adresse IP non valide';
  RSFTPOnCustomFTPProxyReq = 'OnCustomFTPProxy requis mais non assigné';
  RSFTPDataConnAssuranceFailure = 'Echec du contrôle de la connexion de données.'#13#10'IP serveur signalée : %s  Port : %d'#13#10'Notre IP socket : %s  Port : %d';
  RSFTPProtocolNotSupported = 'Protocole non supporté, utilisez'; { may not include '(' or ')' }
  RSFTPMustUseExtWithIPv6 = 'UseExtensionDataPort doit être à true pour les connexions IPv6.';
  RSFTPMustUseExtWithNATFastTrack = 'UseExtensionDataPort doit être à true pour le fastracking NAT.';
  RSFTPFTPPassiveMustBeTrueWithNATFT = 'Impossible d'#39'utiliser les transferts actifs avec le fastracking NAT.';
  RSFTPServerSentInvalidPort = 'Le serveur a envoyé un numéro de port non valide (%s)';
  RSInvalidFTPListingFormat = 'Format d'#39'écoute FTP inconnu';
  RSFTPNoSToSWithNATFastTrack = 'Aucun transfert site à site n'#39'est autorisé avec une connexion FTP de type fastracking NAT.';
  RSFTPSToSNoDataProtection = 'Impossible d'#39'utiliser la protection des données sur un transfert site à site.';
  RSFTPSToSProtosMustBeSame = 'Les protocoles de transport doivent être les mêmes.';
  RSFTPSToSSSCNNotSupported = 'SSCN n'#39'est pas supporté sur les deux serveurs.';
  RSFTPNoDataPortProtectionAfterCCC = 'Impossible de définir DataPortProtection après l'#39'émission de CCC.';
  RSFTPNoDataPortProtectionWOEncryption = 'Impossible de définir DataPortProtection avec des connexions non cryptées.';
  RSFTPNoCCCWOEncryption = 'Impossible de définir CCC sans cryptage.';
  RSFTPNoAUTHWOSSL = 'Impossible de définir AUTH sans SSL.';
  RSFTPNoAUTHCon = 'Impossible de définir AUTH lors d'#39'une connexion.';
  RSFTPSToSTransferModesMusbtSame = 'Les modes de transfert doivent être les mêmes.';
  RSFTPNoListParseUnitsRegistered = 'Aucun analyseur de liste FTP n'#39'a été enregistré.';
  RSFTPMissingCompressor = 'Aucun compresseur n'#39'est assigné.';
  RSFTPCompressorNotReady = 'Le compresseur n'#39'est pas prêt.';
  RSFTPUnsupportedTransferMode = 'Mode de transfert non supporté.';
  RSFTPUnsupportedTransferType = 'Type de transfert non supporté.';

  // Property editor exceptions
  // Stack Error Messages

  RSCMDNotRecognized = 'commande non reconnue';

  RSGopherNotGopherPlus = '%s n'#39'est pas un serveur Gopher+';

  RSCodeNoError     = 'Erreur RCode NO';
  RSCodeQueryServer = 'Le serveur DNS signale une erreur de serveur de requête';
  RSCodeQueryFormat = 'Le serveur DNS signale une erreur de format de requête';
  RSCodeQueryName   = 'Le serveur DNS signale une erreur de nom de requête';
  RSCodeQueryNotImplemented = 'Le serveur DNS signale une erreur de requête non implémentée';
  RSCodeQueryQueryRefused = 'Le serveur DNS signale une erreur de requête refusée';
  RSCodeQueryUnknownError = 'Le serveur a renvoyé une erreur inconnue';

  RSDNSTimeout = 'TimedOut';
  RSDNSMFIsObsolete = 'MF est une commande obsolète. Utilisez MX.';
  RSDNSMDISObsolete = 'MD est une commande obsolète. Utilisez MX.';
  RSDNSMailAObsolete = 'MailA est une commande obsolète. Utilisez MX.';
  RSDNSMailBNotImplemented = '-Err 501 MailB n'#39'est pas implémenté';

  RSQueryInvalidQueryCount = 'Nombre de requêtes (%d) non valide';
  RSQueryInvalidPacketSize = 'Taille de paquet (%d) non valide';
  RSQueryLessThanFour = 'Le paquet reçu est trop petit. Inférieur à 4 octets. %d';
  RSQueryInvalidHeaderID = 'ID d'#39'en-tête %d non valide';
  RSQueryLessThanTwelve = 'Le paquet reçu est trop petit. Inférieur à 12 octets. %d';
  RSQueryPackReceivedTooSmall = 'Le paquet reçu est trop petit. %d';
  RSQueryUnknownError = 'Erreur inconnue %d, Id %d';
  RSQueryInvalidIpV6 = 'Adresse IP V6 non valide. %s';
  RSQueryMustProvideSOARecord = 'Vous devez fournir un objet TIdRR_SOA avec un nom et un numéro de série pour IXFR. %d';
 
  { LPD Client Logging event strings }
  RSLPDDataFileSaved = 'Fichier de données enregistré sous %s';
  RSLPDControlFileSaved = 'Fichier de contrôle enregistré sous %s';
  RSLPDDirectoryDoesNotExist = 'Le répertoire %s n'#39'existe pas';
  RSLPDServerStartTitle = 'Serveur LPD Winshoes %s ';
  RSLPDServerActive = 'Statut du serveur : actif';
  RSLPDQueueStatus  = 'Statut de la file d'#39'attente %s : %s';
  RSLPDClosingConnection = 'fermeture de la connexion';
  RSLPDUnknownQueue = 'File d'#39'attente %s inconnue';
  RSLPDConnectTo = 'connecté à %s';
  RSLPDAbortJob = 'abandon de la tâche';
  RSLPDReceiveControlFile = 'Réception du fichier de contrôle';
  RSLPDReceiveDataFile = 'Réception du fichier de données';

  { LPD Exception Messages }
  RSLPDNoQueuesDefined = 'Erreur :  aucune file d'#39'attente définie';

  { Trivial FTP Exception Messages }
  RSTimeOut = 'Délai dépassé';
  RSTFTPUnexpectedOp = 'Opération inattendue de %s:%d';
  RSTFTPUnsupportedTrxMode = 'Mode de transfert non supporté : "%s"';
  RSTFTPDiskFull = 'Impossibilité de terminer la requête d'#39'écriture, l'#39'opération s'#39'est arrêtée à %d octets';
  RSTFTPFileNotFound = 'Impossible d'#39'ouvrir %s';
  RSTFTPAccessDenied = 'L'#39'accès à %s a été refusé';
  RSTFTPUnsupportedOption = 'Option non supportée : "%s"';
  RSTFTPUnsupportedOptionValue = 'Valeur "%s" non supportée pour l'#39'option : "%s"';

  { MESSAGE Exception messages }
  RSTIdTextInvalidCount = 'Nombre renvoyé par Text non valide. Doit avoir plus d'#39'un objet TIdText.';
  RSTIdMessagePartCreate = 'Impossible de créer TIdMessagePart.  Utilisez les classes descendantes. ';
  RSTIdMessageErrorSavingAttachment = 'Erreur lors de l'#39'enregistrement de la pièce jointe.';
  RSTIdMessageErrorAttachmentBlocked = 'La pièce jointe %s est bloquée.';

  { POP Exception Messages }
  RSPOP3FieldNotSpecified = ' non spécifié';
  RSPOP3UnrecognizedPOP3ResponseHeader = 'En-tête de réponse POP3 non reconnu :'#10'"%s"'; //APR: user will see Server response    {Do not Localize}
  RSPOP3ServerDoNotSupportAPOP = 'Le serveur ne supporte pas APOP (pas d'#39'horodatage)';//APR    {Do not Localize}

  { IdIMAP4 Exception Messages }
  RSIMAP4ConnectionStateError = 'Impossible d'#39'exécuter la commande, état de connexion incorrect ;Etat de connexion en cours : %s.';
  RSUnrecognizedIMAP4ResponseHeader = 'En-tête de réponse IMAP4 non reconnu.';
  RSIMAP4NumberInvalid = 'Le paramètre numérique (numéro de message relatif ou UID) n'#39'est pas valide ; Doit être supérieur ou égal à 1.';
  RSIMAP4NumberInvalidString = 'Le paramètre numérique (numéro de message relatif ou UID) n'#39'est pas valide ; Ne doit pas contenir une chaîne vide.';
  RSIMAP4NumberInvalidDigits = 'Le paramètre numérique (numéro de message relatif ou UID) n'#39'est pas valide ; Ne doit pas contenir des caractères autres que des chiffres.';
  RSIMAP4DisconnectedProbablyIdledOut = 'Le serveur vous a déconnecté, la connexion est probablement restée inactive trop longtemps.';

  { IdIMAP4 UTF encoding error strings}
  RSIMAP4UTFIllegalChar = 'Caractère #%d illégal dans la séquence UTF7.';

  RSIMAP4UTFIllegalBitShifting = 'Décalage de bits illégal dans la chaîne MUTF7';
  RSIMAP4UTFUSASCIIInUTF = 'Caractère US-ASCII #%d dans la séquence UTF7.';
  { IdIMAP4 Connection State strings }
  RSIMAP4ConnectionStateAny = 'Tout';
  RSIMAP4ConnectionStateNonAuthenticated = 'Non authentifié';
  RSIMAP4ConnectionStateAuthenticated = 'Authentifié';
  RSIMAP4ConnectionStateSelected = 'Sélectionné';
  RSIMAP4ConnectionStateUnexpectedlyDisconnected = 'Déconnexion inattendue';

  { Telnet Server }
  RSTELNETSRVUsernamePrompt = 'Nom d'#39'utilisateur :  ';
  RSTELNETSRVPasswordPrompt = 'Mot de passe : ';
  RSTELNETSRVInvalidLogin = 'Connexion non valide.';
  RSTELNETSRVMaxloginAttempt = 'Le nombre de tentatives de connexions autorisées a été dépassé, au revoir.';
  RSTELNETSRVNoAuthHandler = 'Aucun gestionnaire d'#39'authentification n'#39'a été spécifié.';
  RSTELNETSRVWelcomeString = 'Serveur Indy Telnet';
  RSTELNETSRVOnDataAvailableIsNil = 'L'#39'événement OnDataAvailable vaut nil.';

  { Telnet Client }
  RSTELNETCLIConnectError = 'pas de réponse du serveur';
  RSTELNETCLIReadError = 'Le serveur n'#39'a pas répondu.';

  { Network Calculator }
  RSNETCALInvalidIPString     = 'La chaîne %s n'#39'est pas traduite en adresse IP valide.';
  RSNETCALCInvalidNetworkMask = 'Masque réseau non valide.';
  RSNETCALCInvalidValueLength = 'Longueur de la valeur non valide : Doit être 32.';
  RSNETCALConfirmLongIPList = 'L'#39'étendue spécifiée (%d) comporte un trop grand nombre d'#39'adresses IP pour pouvoir les afficher lors de la conception.';
  { IdentClient}
  RSIdentReplyTimeout = 'Délai de réponse dépassé :  Le serveur n'#39'a pas renvoyé de réponse et la requête a été abandonnée';
  RSIdentInvalidPort = 'Port non valide :  Le port étranger ou local n'#39'est pas spécifié correctement ou n'#39'est pas valide';
  RSIdentNoUser = 'Pas d'#39'utilisateur :  Paire de ports non utilisée ou utilisée par un utilisateur non identifiable';
  RSIdentHiddenUser = 'Utilisateur caché :  L'#39'information n'#39'a pas été renvoyée suite à une requête de l'#39'utilisateur';
  RSIdentUnknownError = 'Erreur inconnue ou autre erreur : Impossible de déterminer le propriétaire, autre erreur ou erreur ne pouvant pas être révélée.';

  {Standard dialog stock strings}
  {}

  { Tunnel messages }
  RSTunnelGetByteRange = 'Appel à %s.GetByte [property Bytes] with index <> [0..%d]';
  RSTunnelTransformErrorBS = 'Erreur de transformation avant l'#39'envoi';
  RSTunnelTransformError = 'Echec de transformation';
  RSTunnelCRCFailed = 'Echec CRC';
  RSTunnelConnectMsg = 'Connexion';
  RSTunnelDisconnectMsg = 'Déconnecter';
  RSTunnelConnectToMasterFailed = 'Impossible de se connecter au serveur maître';
  RSTunnelDontAllowConnections = 'Ne pas autoriser les connexions maintenant';
  RSTunnelMessageTypeError = 'Erreur de reconnaissance du type de message';
  RSTunnelMessageHandlingError = 'Echec de la gestion de message';
  RSTunnelMessageInterpretError = 'Echec de l'#39'interprétation du message';
  RSTunnelMessageCustomInterpretError = 'Echec de l'#39'interprétation du message personnalisé';

  { Socks messages }

  { FTP }
  RSDestinationFileAlreadyExists = 'Le fichier de destination existe déjà.';

  { SSL messages }
  RSSSLAcceptError = 'Erreur lors de l'#39'acceptation de la connexion avec SSL.';
  RSSSLConnectError = 'Erreur lors de la connexion avec SSL.';
  RSSSLSettingCipherError = 'Echec de SetCipher.';
  RSSSLCreatingSessionError = 'Erreur de création de la session SSL.';
  RSSSLCreatingContextError = 'Erreur de création du contexte SSL.';
  RSSSLLoadingRootCertError = 'Impossible de charger le certificat racine.';
  RSSSLLoadingCertError = 'Impossible de charger le certificat.';
  RSSSLLoadingKeyError = 'Impossible de charger la clé, vérifiez le mot de passe.';
  RSSSLLoadingDHParamsError = 'Impossible de charger les paramètres DH.';
  RSSSLGetMethodError = 'Erreur lors de l'#39'obtention de la méthode SSL.';
  RSSSLFDSetError = 'Erreur de définition du descripteur de fichier pour SSL';
  RSSSLDataBindingError = 'Erreur lors de la liaison des données au socket SSL.';
  RSSSLEOFViolation = 'EOF : violation du protocole';

  {IdMessage Component Editor}
  RSMsgCmpEdtrNew = '&Partie Nouveau message...';
  RSMsgCmpEdtrExtraHead = 'Editeur du texte des en-têtes supplémentaires';
  RSMsgCmpEdtrBodyText = 'Editeur du texte du corps';

  {IdNNTPServer}
  RSNNTPServerNotRecognized = 'Commande non reconnue';
  RSNNTPServerGoodBye = 'Au revoir';
  RSNNTPSvrImplicitTLSRequiresSSL = 'Le NNTP implicite nécessite que IOHandler soit défini sur un TIdSSLIOHandlerSocketBase.';
  RSNNTPRetreivedArticleFollows = ' article récupéré - l'#39'en-tête et le corps suivent';
  RSNNTPRetreivedBodyFollows = ' article récupéré - le corps suit';
  RSNNTPRetreivedHeaderFollows =  ' article récupéré - l'#39'en-tête suit';
  RSNNTPRetreivedAStaticstsOnly = ' article récupéré - statistiques seulement';
  RSNTTPNewsToMeSendArticle = 'Mes actualités !  <CRLF.CRLF> pour terminer.';
  RSNTTPArticleRetrievedRequestTextSeparately = ' article récupéré - demander le texte séparément';
  RSNTTPNotInNewsgroup = 'Pas actuellement dans le groupe de discussion';
  RSNNTPExtSupported = 'Extensions supportées :';
  
  //IdNNTPServer reply messages
  RSNTTPReplyHelpTextFollows = 'le texte d'#39'aide suit';
  RSNTTPReplyDebugOutput =  'sortie de débogage';
   
  RSNNTPReplySvrReadyPostingAllowed =  'serveur prêt - publication autorisée';
  RSNNTPReplySvrReadyNoPostingAllowed =  'serveur prêt - aucune publication autorisée';
  RSNNTPReplySlaveStatus =  'statut esclave signalé';
  RSNNTPReplyClosingGoodby = 'fermeture de la connexion - au revoir !';
  RSNNTPReplyNewsgroupsFollow = 'la liste des groupes de discussion suit';
  RSNNTPReplyHeadersFollow =  'Les en-têtes suivent';
  RSNNTPReplyOverViewInfoFollows =  'Les informations globales suivent';
  RSNNTPReplyNewNewsgroupsFollow =  'la liste des nouveaux groupes de discussion suit';
  RSNNTPReplyArticleTransferedOk =  'article transféré ok';
  RSNNTPReplyArticlePostedOk =  'article posté ok';
  RSNNTPReplyAuthAccepted = 'Authentification acceptée';

  RSNNTPReplySendArtTransfer = 'envoyer l'#39'article à transférer. Terminer par <CR-LF>.<CR-LF>';
  RSNNTPReplySendArtPost =  'envoyer l'#39'article à poster. Terminer par <CR-LF>.<CR-LF>';
  RSNNTPReplyMoreAuthRequired = 'Autres informations d'#39'authentification requises';
  RSNNTPReplyContinueTLSNegot = 'Continuer avec la négociation TLS';

  RSNNTPReplyServiceDiscont =  'service interrompu';
  RSNNTPReplyTLSTempUnavail =  'TLS temporairement indisponible';
  RSNNTPReplyNoSuchNewsgroup =  'un tel groupe de discussion n'#39'a pas été trouvé';
  RSNNTPReplyNoNewsgroupSel =  'aucun groupe de discussion n'#39'a été sélectionné';
  RSNNTPReplyNoArticleSel =  'aucun article en cours n'#39'a été sélectionné';
  RSNNTPReplyNoNextArt =  'pas d'#39'article suivant dans ce groupe';
  RSNNTPReplyNoPrevArt =  'pas d'#39'article précédent dans ce groupe';
  RSNNTPReplyNoArtNumber =  'un tel numéro d'#39'article n'#39'a pas été trouvé dans ce groupe';
  RSNNTPReplyNoArtFound =  'un tel article n'#39'a pas été trouvé';
  RSNNTPReplyArtNotWanted =  'article non voulu - ne pas l'#39'envoyer';
  RSNNTPReplyTransferFailed =  'échec du transfert - essayez à nouveau ultérieurement';
  RSNNTPReplyArtRejected =  'article rejeté - ne pas retenter.';
  RSNNTPReplyNoPosting =  'publication non autorisée';
  RSNNTPReplyPostingFailed =  'échec de la publication';
  RSNNTPReplyAuthorizationRequired =  'Autorisation requise pour cette commande';
  RSNNTPReplyAuthorizationRejected = 'Autorisation rejetée';
  RSNNTPReplyAuthRejected =  'Authentification requise';
  RSNNTPReplyStrongEncryptionRequired =  'Une couche de cryptage fort est requise';

  RSNNTPReplyCommandNotRec =  'commande non reconnue';
  RSNNTPReplyCommandSyntax =  'erreur de syntaxe de la commande';
  RSNNTPReplyPermDenied =  'restriction d'#39'accès ou permission refusée';
  RSNNTPReplyProgramFault = 'erreur de programme - commande non exécutée';
  RSNNTPReplySecAlreadyActive =  'Couche de sécurité déjà active';

  {IdGopherServer}
  RSGopherServerNoProgramCode = 'Erreur :  Pas de code programme pour renvoyer la requête !';

  {IdSyslog}
  RSInvalidSyslogPRI = 'Message syslog non valide : section PRI incorrecte';
  RSInvalidSyslogPRINumber = 'Message syslog non valide : numéro de PRI "%s" incorrect';
  RSInvalidSyslogTimeStamp = 'Message syslog non valide : horodatage "%s" incorrect';
  RSInvalidSyslogPacketSize = 'Message syslog non valide : paquet trop volumineux (%d octets)';
  RSInvalidHostName = 'Nom d'#39'hôte non valide. Un nom d'#39'hôte SYSLOG ne peut pas contenir d'#39'espaces ("%s")+';

  {IdWinsockStack}
  RSWSockStack = 'Pile Winsock';

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
  RSPOP3SvrImplicitTLSRequiresSSL = 'Le POP3 implicite nécessite que IOHandler soit défini sur un TIdServerIOHandlerSSL.';
  RSPOP3SvrMustUseSTLS = 'Doit utiliser STLS';
  RSPOP3SvrNotHandled = 'Commande non gérée : %s';
  RSPOP3SvrNotPermittedWithTLS = 'Commande non autorisée quand TLS est actif';
  RSPOP3SvrNotInThisState = 'Commande non autorisée dans cet état';
  RSPOP3SvrBeginTLSNegotiation = 'Commencer la négociation TLS';
  RSPOP3SvrLoginFirst = 'Etablissez d'#39'abord la connexion';
  RSPOP3SvrInvalidSyntax = 'Syntaxe non valide';
  RSPOP3SvrClosingConnection = 'Fermeture du canal de connexion.';
  RSPOP3SvrPasswordRequired = 'Mot de passe requis';
  RSPOP3SvrLoginFailed = 'La connexion a échoué';
  RSPOP3SvrLoginOk = 'Connexion OK';
  RSPOP3SvrWrongState = 'Etat incorrect';
  RSPOP3SvrInvalidMsgNo = 'Numéro de message non valide';
  RSPOP3SvrNoOp = 'NOOP';
  RSPOP3SvrReset = 'Réinitialiser';
  RSPOP3SvrCapaList = 'La liste des capacités suit';
  RSPOP3SvrWelcome = 'Bienvenue dans le serveur Indy POP3';
  RSPOP3SvrUnknownCmd = 'Désolé, Commande inconnue';
  RSPOP3SvrUnknownCmdFmt = 'Désolé, Commande inconnue : %s';
  RSPOP3SvrInternalError = 'Erreur interne inconnue';
  RSPOP3SvrHelpFollows = 'L'#39'aide suit';
  RSPOP3SvrTooManyCons = 'Trop de connexions. Essayez à nouveau ultérieurement.';
  RSPOP3SvrWelcomeAPOP = 'Accueil';

  // TIdCoder3to4
  RSUnevenSizeInDecodeStream = 'Taille irrégulière dans DecodeToStream.';
  RSUnevenSizeInEncodeStream = 'Taille irrégulière dans Encode.';
  RSIllegalCharInInputString = 'Caractère illégal dans la chaîne d'#39'entrée.';

  // TIdMessageCoder
  RSMessageDecoderNotFound = 'Décodeur de message introuvable';
  RSMessageEncoderNotFound = 'Encodeur de message introuvable';

  // TIdMessageCoderMIME
  RSMessageCoderMIMEUnrecognizedContentTrasnferEncoding = 'Encodage de transfert de contenu non reconnu.';

  // TIdMessageCoderUUE
  RSUnrecognizedUUEEncodingScheme = 'Schéma d'#39'encodage UUE non reconnu.';

  { IdFTPServer }
  RSFTPDefaultGreeting = 'Serveur FTP Indy prêt.';
  RSFTPOpenDataConn = 'Connexion de données déjà ouverte ; démarrage du transfert.';
  RSFTPDataConnToOpen = 'Statut du fichier OK ; sur le point d'#39'ouvrir la connexion de données.';
  RSFTPDataConnList = 'Ouverture de la connexion de données en mode ASCII pour /bin/ls.';
  RSFTPDataConnNList = 'Ouverture de la connexion de données en mode ASCII pour la liste de fichiers.';
  RSFTPDataConnMLst = 'Ouverture de la connexion de données en mode ASCII pour la liste de répertoires.';
  RSFTPCmdSuccessful = 'Commande %s réussie.';
  RSFTPServiceOpen = 'Service prêt pour un nouvel utilisateur.';
  RSFTPServerClosed = 'Le service ferme la connexion de contrôle.';
  RSFTPDataConn = 'Connexion de données ouverte ; aucun transfert en cours.';
  RSFTPDataConnClosed = 'Fermeture de la connexion de données.';
  RSFTPDataConnEPLFClosed = 'Succès.';
  RSFTPDataConnClosedAbnormally = 'La connexion de données a été fermée de façon anormale.';
  RSFTPPassiveMode = 'Entrer en mode passif (%s).';
  RSFTPUserLogged = 'Utilisateur connecté, continuer.';
  RSFTPAnonymousUserLogged = 'Utilisateur anonyme connecté, continuer.';
  RSFTPFileActionCompleted = 'Action requise sur le fichier OK, opération terminée.';
  RSFTPDirFileCreated = '"%s" créé.';
  RSFTPUserOkay = 'Nom d'#39'utilisateur ok, mot de passe nécessaire.';
  RSFTPAnonymousUserOkay = 'Connexion anonyme OK, envoyez un e-mail comme mot de passe.';
  RSFTPNeedLoginWithUser = 'Connexion avec USER d'#39'abord.';
  RSFTPNotAfterAuthentication = 'Pas dans l'#39'état autorisation, déjà connecté.';
  RSFTPFileActionPending = 'Action requise sur le fichier en attente d'#39'informations supplémentaires.';
  RSFTPServiceNotAvailable = 'Service non disponible, fermeture de la connexion de contrôle.';
  RSFTPCantOpenDataConn = 'Impossible d'#39'ouvrir la connexion de données.';
  RSFTPFileActionNotTaken = 'Action requise sur le fichier non prise.';
  RSFTPFileActionAborted = 'Action requise abandonnée : erreur locale en cours.';
  RSFTPEnteringEPSV = 'Entrer en mode passif étendu (%s)';
  RSFTPClosingConnection = 'Service non disponible, fermeture de la connexion de contrôle.';
  RSFTPPORTDisabled = 'Commande PORT/EPRT désactivée.';
  RSFTPPORTRange    = 'Commande PORT/EPRT désactivée pour l'#39'intervalle des ports réservés (1-1024).';
  RSFTPSameIPAddress = 'Le port des données peut seulement être utilisé par l'#39'adresse IP utilisée par la connexion de contrôle.';
  RSFTPCantOpenData = 'Impossible d'#39'ouvrir la connexion de données.';
  RSFTPEPSVAllEntered = ' EPSV ALL envoyé, maintenant seules les connexions EPSV sont acceptées';
  RSFTPNetProtNotSup = 'Protocole réseau non supporté, utilisez %s';
  RSFTPFileOpSuccess = 'Opération sur le fichier réussie';
  RSFTPIsAFile = '%s : Est un fichier.';
  RSFTPInvalidOps = 'Options %s non valides';
  RSFTPOptNotRecog = 'Option non reconnue.';
  RSFTPPropNotNeg = 'La propriété ne peut pas être un nombre négatif.';
  RSFTPClntNoted = 'Noté.';
  RSFTPQuitGoodby = 'Au revoir.';
  RSFTPPASVBoundPortMaxMustBeGreater = 'PASVBoundPortMax doit être supérieur à PASVBoundPortMax.';
  RSFTPPASVBoundPortMinMustBeLess = 'PASVBoundPortMin doit être inférieur à PASVBoundPortMax.';
  RSFTPRequestedActionNotTaken = 'Action demandée non prise.';
  RSFTPCmdNotRecognized = #39'%s'#39' : commande non comprise.';
  RSFTPCmdNotImplemented = 'Commande "%s" non implémentée.';
  RSFTPCmdHelpNotKnown = 'Commande %s inconnue.';
  RSFTPUserNotLoggedIn = 'Non connecté.';
  RSFTPActionNotTaken = 'Action demandée non prise.';
  RSFTPActionAborted = 'Action requise abandonnée : type de page inconnu.';
  RSFTPRequestedFileActionAborted = 'L'#39'action requise sur le fichier a été annulée.';
  RSFTPRequestedFileActionNotTaken = 'Action demandée non prise.';
  RSFTPMaxConnections = 'La limite maximale des connexions est dépassée. Essayez à nouveau ultérieurement.';
  RSFTPDataConnToOpenStou = 'Sur le point d'#39'ouvrir la connexion de données pour %s';
  RSFTPNeedAccountForLogin = 'Compte nécessaire pour la connexion.';
  RSFTPAuthSSL = 'Commande AUTH OK. Initialisation SSL';
  RSFTPDataProtBuffer0 = 'Commande PBSZ OK. Taille du tampon de protection définie sur 0.';

  RSFTPInvalidProtTypeForMechanism = 'Le niveau PROT requis n'#39'est pas supporté par le mécanisme.';
  RSFTPProtTypeClear   = 'Commande PROT OK. Utilisation de la connexion de données en mode non crypté.';
  RSFTPProtTypePrivate = 'Commande PROT OK. Utilisation de la connexion de données privée.';
  RSFTPClearCommandConnection = 'Canal de commande passé en mode non crypté.';
  RSFTPClearCommandNotPermitted = 'Le canal de commande en mode non crypté n'#39'est pas autorisé.';
  RSFTPPBSZAuthDataRequired = 'Données AUTH requises.';
  RSFTPPBSZNotAfterCCC = 'Pas autorisé après CCC';
  RSFTPPROTProtBufRequired = 'Taille du tampon de données PBSZ requis.';
  RSFTPInvalidForParam = 'Commande non implémentée pour ce paramètre.';
  RSFTPNotAllowedAfterEPSVAll = '%s non autorisé après EPSV ALL';

  RSFTPOTPMethod = 'Méthode OTP inconnue';
  RSFTPIOHandlerWrong = 'IOHandler a un type incorrect.';
  RSFTPFileNameCanNotBeEmpty = 'Le nom de fichier de la destination ne peut pas être vide.';

  //Note to translators, it may be best to leave the stuff in quotes as the very first
  //part of any phrase otherwise, a FTP client might get confused.
  RSFTPCurrentDirectoryIs = '"%s" est le répertoire de travail.';
  RSFTPTYPEChanged = 'Type défini sur %s.';
  RSFTPMODEChanged = 'Mode défini sur %s.';
  RSFTPMODENotSupported = 'Mode non implémenté.';
  RSFTPSTRUChanged = 'Structure définie sur %s.';
  RSFTPSITECmdsSupported = 'Les commandes SITE suivantes sont supportées :';
  RSFTPDirectorySTRU = 'Structure de répertoires %s.';
  RSFTPCmdStartOfStat = 'Statut du système';
  RSFTPCmdEndOfStat = 'Fin du statut';
  RSFTPCmdExtsSupportedStart = 'Extensions supportées :';
  RSFTPCmdExtsSupportedEnd = 'Fin des extensions.';
  RSFTPNoOnDirEvent = 'Aucun événement OnListDirectory n'#39'a été trouvé !';
  RSFTPImplicitTLSRequiresSSL = 'Le FTP implicite nécessite que IOHandler soit défini sur un TIdServerIOHandlerSSL.';

  //%s number of attributes changes
  RSFTPSiteATTRIBMsg = 'site attrib';
  RSFTPSiteATTRIBInvalid = ' en échec, attribut non valide.';
  RSFTPSiteATTRIBDone = ' terminé, attributs %s changés.';
  //%s is the umask number
  RSFTPUMaskIs = 'UMASK en cours : %.3d';
  //first %d is the new value, second one is the old value
  RSFTPUMaskSet = 'UMASK défini sur %.3d (%.3d auparavant)';
  RSFTPPermissionDenied = 'Permission refusée.';
  RSFTPCHMODSuccessful = 'Commande CHMOD réussie.';
  RSFTPHelpBegining = 'Les commandes suivantes sont reconnues (* => non implémenté, + => extension).';
  //toggles for DIRSTYLE SITE command in IIS
  RSFTPOn = 'on';
  RSFTPOff = 'off';
  RSFTPDirStyle = 'La sortie répertoire de type MSDOS est %s';

  {SYSLog Message}
  // facility
  STR_SYSLOG_FACILITY_KERNEL     = 'messages du noyau';
  STR_SYSLOG_FACILITY_USER       = 'messages de niveau utilisateur';
  STR_SYSLOG_FACILITY_MAIL       = 'système de messagerie';
  STR_SYSLOG_FACILITY_SYS_DAEMON = 'démons système';
  STR_SYSLOG_FACILITY_SECURITY1  = 'messages sécurité/autorisation (1)';
  STR_SYSLOG_FACILITY_INTERNAL   = 'messages générés de façon interne par syslogd';
  STR_SYSLOG_FACILITY_LPR        = 'sous-système d'#39'impression en ligne';
  STR_SYSLOG_FACILITY_NNTP       = 'sous-système d'#39'informations réseau';
  STR_SYSLOG_FACILITY_UUCP       = 'Sous-système UUCP';
  STR_SYSLOG_FACILITY_CLOCK1     = 'clock daemon (1)';
  STR_SYSLOG_FACILITY_SECURITY2  = 'messages sécurité/autorisation (2)';
  STR_SYSLOG_FACILITY_FTP        = 'Démon FTP';
  STR_SYSLOG_FACILITY_NTP        = 'sous-système NTP';
  STR_SYSLOG_FACILITY_AUDIT      = 'log audit';
  STR_SYSLOG_FACILITY_ALERT      = 'log alert';
  STR_SYSLOG_FACILITY_CLOCK2     = 'clock daemon (2)';
  STR_SYSLOG_FACILITY_LOCAL0     = 'local use 0  (local0)';
  STR_SYSLOG_FACILITY_LOCAL1     = 'local use 1  (local1)';
  STR_SYSLOG_FACILITY_LOCAL2     = 'local use 2  (local2)';
  STR_SYSLOG_FACILITY_LOCAL3     = 'local use 3  (local3)';
  STR_SYSLOG_FACILITY_LOCAL4     = 'local use 4  (local4)';
  STR_SYSLOG_FACILITY_LOCAL5     = 'local use 5  (local5)';
  STR_SYSLOG_FACILITY_LOCAL6     = 'local use 6  (local6)';
  STR_SYSLOG_FACILITY_LOCAL7     = 'local use 7  (local7)';
  STR_SYSLOG_FACILITY_UNKNOWN    = 'Code de dispositif inconnu ou illégal';

  // Severity
  STR_SYSLOG_SEVERITY_EMERGENCY     = 'Urgence : le système est inutilisable';
  STR_SYSLOG_SEVERITY_ALERT         = 'Alerte : une action doit être prise immédiatement';
  STR_SYSLOG_SEVERITY_CRITICAL      = 'Critique : conditions critiques';
  STR_SYSLOG_SEVERITY_ERROR         = 'Erreur : conditions d'#39'erreur';
  STR_SYSLOG_SEVERITY_WARNING       = 'Avertissement : conditions d'#39'avertissement';
  STR_SYSLOG_SEVERITY_NOTICE        = 'Notification : condition normale mais significative';
  STR_SYSLOG_SEVERITY_INFORMATIONAL = 'Information : messages informatifs';
  STR_SYSLOG_SEVERITY_DEBUG         = 'Débogage : messages de niveau débogage';
  STR_SYSLOG_SEVERITY_UNKNOWN       = 'Code de sécurité inconnu ou illégal';

  {LPR Messages}
  RSLPRError = 'Réponse %d sur ID de tâche %s';
  RSLPRUnknown = 'Inconnu';
  RSCannotBindRange = 'Impossible d'#39'effectuer la liaison à un port LPR dans l'#39'étendue %d à %d (pas de port libre)';

  {IRC Messages}
  RSIRCCanNotConnect = 'Echec de la connexion IRC';
  // RSIRCNotConnected = 'Not connected to server.';
  // RSIRCClientVersion =  'TIdIRC 1.061 by Steve Williams';
  // RSIRCClientInfo = '%s Non-visual component for 32-bit Delphi.';
  // RSIRCNick = 'Nick';
  // RSIRCAltNick = 'OtherNick';
  // RSIRCUserName = 'ircuser';
  // RSIRCRealName = 'Real name';
  // RSIRCTimeIsNow = 'Local time is %s'; // difficult to strip for clients

  {HL7 Lower Layer Protocol Messages}
  RSHL7StatusStopped           = 'Arrêté';
  RSHL7StatusNotConnected      = 'Non connecté';
  RSHL7StatusFailedToStart     = 'Démarrage en échec : %s';
  RSHL7StatusFailedToStop      = 'Arrêt en échec : %s';
  RSHL7StatusConnected         = 'Connecté';
  RSHL7StatusConnecting        = 'Connexion';
  RSHL7StatusReConnect         = 'Reconnecter à %s : %s';
  RSHL7NotWhileWorking         = 'Impossible de définir %s tant que le composant HL7 fonctionne';
  RSHL7NotWorking              = 'Tentative %s lorsque le composant HL7 ne fonctionne pas';
  RSHL7NotFailedToStop         = 'L'#39'interface est inutilisable suite à une impossibilité de s'#39'arrêter';
  RSHL7AlreadyStarted          = 'L'#39'interface était déjà lancée';
  RSHL7AlreadyStopped          = 'L'#39'interface était déjà arrêtée';
  RSHL7ModeNotSet              = 'Le mode n'#39'est pas initialisé';
  RSHL7NoAsynEvent             = 'Le composant est en mode asynchrone, mais pas de hook sur OnMessageArrive';
  RSHL7NoSynEvent              = 'Le composant est en mode synchrone, mais pas de hook sur OnMessageReceive';
  RSHL7InvalidPort             = 'La valeur %d du port assigné n'#39'est pas valide';
  RSHL7ImpossibleMessage       = 'Un message a été reçu, mais le mode de communication est inconnu';
  RSHL7UnexpectedMessage       = 'Un message inattendu est arrivé sur une interface qui n'#39'est pas en mode écoute';
  RSHL7UnknownMode             = 'Mode inconnu';
  RSHL7ClientThreadNotStopped  = 'Impossible d'#39'arrêter le thread client';
  RSHL7SendMessage             = 'Envoyer un message';
  RSHL7NoConnectionFound       = 'Connexion serveur non localisable lors de l'#39'envoi du message';
  RSHL7WaitForAnswer           = 'Impossible d'#39'envoyer un message tant que vous attendez une réponse';
  //TIdHL7 error messages
  RSHL7ErrInternalsrNone       =  'Erreur interne dans IdHL7.pas : SynchronousSend a renvoyé srNone';
  RSHL7ErrNotConn              =   'Non connecté';
  RSHL7ErrInternalsrSent       =  'Erreur interne dans IdHL7.pas : SynchronousSend a renvoyé srSent';
  RSHL7ErrNoResponse           =  'Pas de réponse du système distant';
  RSHL7ErrInternalUnknownVal   =  'Erreur interne dans IdHL7.pas : SynchronousSend a renvoyé une valeur inconnue ';
  RSHL7Broken                  = 'IdHL7 est interrompu dans Indy 10 pour le moment';

  { TIdMultipartFormDataStream exceptions }
  RSMFDInvalidObjectType        = 'Type d'#39'objet non supporté. Vous pouvez assigner seulement l'#39'un des types suivants ou de leurs descendants : TStrings, TStream.';
  RSMFDInvalidTransfer          = 'Type de transfert non supporté. Vous pouvez assigner seulement une chaîne vide ou l'#39'une des valeurs suivantes : 7bit, 8bit, binary, quoted-printable, base64.';
  RSMFDInvalidEncoding          = 'Encodage non supporté. Vous pouvez assigner seulement l'#39'une des valeurs suivantes : Q, B, 8.';

  { TIdURI exceptions }
  RSURINoProto                 = 'Le champ protocole est vide';
  RSURINoHost                  = 'Le champ hôte est vide';

  { TIdIOHandlerThrottle}
  RSIHTChainedNotAssigned      = 'Vous devez enchaîner ce composant à un autre gestionnaire d'#39'E/S avant de l'#39'utiliser';

  { TIdSNPP}
  RSSNPPNoMultiLine            = 'La commande TIdSNPP Mess supporte uniquement les messages sur une seule ligne.';

  {TIdThread}
  RSUnassignedUserPassProv     = 'UserPassProvider non assigné !';

  {TIdDirectSMTP}
  RSDirSMTPInvalidEMailAddress = 'Adresse e-mail %s non valide';
  RSDirSMTPNoMXRecordsForDomain = 'Aucun enregistrement MX pour le domaine %s';
  RSDirSMTPCantConnectToSMTPSvr = 'Impossible d'#39'établir la connexion aux serveurs MX pour l'#39'adresse %s';
  RSDirSMTPCantAssignHost       = 'Impossible d'#39'assigner la propriété Host, elle est résolue par IdDirectSMTP à la volée.';

  {TIdMessageCoderYenc}
  RSYencFileCorrupted           = 'Fichier endommagé.';
  RSYencInvalidSize             = 'Taille non valide';
  RSYencInvalidCRC              = 'CRC non valide';

  {TIdSocksServer}
  RSSocksSvrNotSupported        = 'Non supporté';
  RSSocksSvrInvalidLogin        = 'Connexion non valide';
  RSSocksSvrWrongATYP           = 'SOCKS5-ATYP incorrect';
  RSSocksSvrWrongSocksVersion   = 'Version SOCKS incorrecte';
  RSSocksSvrWrongSocksCommand   = 'Commande SOCKS incorrecte';
  RSSocksSvrAccessDenied        = 'Accès refusé';
  RSSocksSvrUnexpectedClose     = 'Fermeture inattendue';
  RSSocksSvrPeerMismatch        = 'Non concordance de l'#39'adresse IP de l'#39'homologue';

  {TLS Framework}
  RSTLSSSLIOHandlerRequired = 'SSL IOHandler est nécessaire pour ce paramétrage';
  RSTLSSSLCanNotSetWhileActive = 'Cette valeur ne peut pas être définie quand le serveur est actif.';
  RSTLSSLCanNotSetWhileConnected = 'Cette valeur ne peut pas être définie quand le client est connecté.';
  RSTLSSLSSLNotAvailable = 'SSL n'#39'est pas disponible sur ce serveur.';
  RSTLSSLSSLCmdFailed = 'La commande de démarrage de la négociation SSL a échoué.';

  ///IdPOP3Reply
  //user's provided reply will follow this string
  RSPOP3ReplyInvalidEnhancedCode = 'Code amélioré non valide : ';

  //IdSMTPReply
  RSSMTPReplyInvalidReplyStr = 'Invalid Reply String.';
  RSSMTPReplyInvalidClass = 'Invalid Reply Class.';

  RSUnsupportedOperation = 'Opération non supportée.';

  //Mapped port components
  RSEmptyHost = 'Hôte vide';    {Do not Localize}
  RSPop3ProxyGreeting = 'Proxy POP3 prêt';    {Do not Localize}
  RSPop3UnknownCommand = 'la commande doit être USER ou QUIT';    {Do not Localize}
  RSPop3QuitMsg = 'Terminaison en cours du proxy POP3';    {Do not Localize}

  //IMAP4 Server
  RSIMAP4SvrBeginTLSNegotiation = 'Commencer maintenant la négociation TLS';
  RSIMAP4SvrNotPermittedWithTLS = 'Commande non autorisée quand TLS est actif';
  RSIMAP4SvrImplicitTLSRequiresSSL = 'Le IMAP4 implicite nécessite que IOHandler soit défini sur un TIdServerIOHandlerSSLBase.';

  // OTP Calculator
  RSFTPFSysErrMsg = 'Permission refusée';
  RSOTPUnknownMethod = 'Méthode OTP inconnue';

  // Message Header Encoding
  RSHeaderEncodeError = 'Impossible d'#39'encoder les données d'#39'en-tête avec le jeu de caractères "%s"';
  RSHeaderDecodeError = 'Impossible de décoder les données d'#39'en-tête avec le jeu de caractères "%s"';

  // message builder strings
  rsHtmlViewerNeeded = 'Un afficheur HTML est requis pour voir ce message';
  rsRtfViewerNeeded = 'Un afficheur RTF est requis pour voir ce message';

  // HTTP Web Broker Bridge strings
  RSWBBInvalidIdxGetDateVariable = 'Index %s invalide dans TIdHTTPAppResponse.GetDateVariable';
  RSWBBInvalidIdxSetDateVariable = 'Index %s invalide dans TIdHTTPAppResponse.SetDateVariable';
  RSWBBInvalidIdxGetIntVariable = 'Index %s invalide dans TIdHTTPAppResponse.GetIntegerVariable';
  RSWBBInvalidIdxSetIntVariable = 'Index %s invalide dans TIdHTTPAppResponse.SetIntegerVariable';
  RSWBBInvalidIdxGetStrVariable = 'Index %s invalide dans TIdHTTPAppResponse.GetStringVariable';
  RSWBBInvalidStringVar = 'TIdHTTPAppResponse.SetStringVariable : Impossible de définir la version';
  RSWBBInvalidIdxSetStringVar = 'Index %s invalide dans TIdHTTPAppResponse.SetStringVariable';

implementation

end.
