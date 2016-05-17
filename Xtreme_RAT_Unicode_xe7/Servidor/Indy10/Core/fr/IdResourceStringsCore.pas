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
  RSNoBindingsSpecified = 'Aucune liaison n'#39'a été spécifiée.';
  RSCannotAllocateSocket = 'Impossible d'#39'allouer le socket.';
  RSSocksUDPNotSupported = 'UDP n'#39'est pas supporté dans cette version SOCKS.';
  RSSocksRequestFailed = 'Rejet ou échec de la requête.';
  RSSocksRequestServerFailed = 'Requête rejetée car le serveur SOCKS ne peut pas établir de connexion.';
  RSSocksRequestIdentFailed = 'Requête rejetée car le programme client et l'#39'identd indiquent des ID utilisateur différents.';
  RSSocksUnknownError = 'Erreur socks inconnue.';
  RSSocksServerRespondError = 'Le serveur Socks n'#39'a pas répondu.';
  RSSocksAuthMethodError = 'Méthode d'#39'authentification socks incorrecte.';
  RSSocksAuthError = 'Erreur d'#39'authentification sur le serveur socks.';
  RSSocksServerGeneralError = 'Panne du serveur SOCKS générale.';
  RSSocksServerPermissionError = 'Connexion non autorisée par l'#39'ensemble de règles.';
  RSSocksServerNetUnreachableError = 'Réseau inaccessible.';
  RSSocksServerHostUnreachableError = 'Hôte inaccessible.';
  RSSocksServerConnectionRefusedError = 'Connexion refusée.';
  RSSocksServerTTLExpiredError = 'Expiration du TTL.';
  RSSocksServerCommandError = 'Commande non supportée.';
  RSSocksServerAddressError = 'Type d'#39'adresse non supporté.';
  RSInvalidIPAddress = 'Adresse IP non valide';
  RSInterceptCircularLink = '%s : Les liens circulaires ne sont pas autorisés';

  RSNotEnoughDataInBuffer = 'Pas assez de données dans le tampon. (%d/%d)';
  RSTooMuchDataInBuffer = 'Trop de données dans le tampon.';
  RSCapacityTooSmall = 'La capacité ne peut pas être plus petite que la taille.';
  RSBufferIsEmpty = 'Pas d'#39'octets dans le tampon.';
  RSBufferRangeError = 'Index hors limites.';

  RSFileNotFound = 'Fichier "%s" introuvable';
  RSNotConnected = 'Non connecté';
  RSObjectTypeNotSupported = 'Type d'#39'objet non supporté.';
  RSIdNoDataToRead = 'Pas de données pour la lecture.';
  RSReadTimeout = 'Délai de lecture.';
  RSReadLnWaitMaxAttemptsExceeded = 'Le nombre maximal de tentatives de lecture de lignes a été dépassé.';
  RSAcceptTimeout = 'Délai d'#39'acceptation dépassé.';
  RSReadLnMaxLineLengthExceeded = 'Longueur de ligne maximale dépassée.';
  RSRequiresLargeStream = 'Définissez LargeStream sur True pour envoyer des flux supérieurs à 2 Go';
  RSDataTooLarge = 'Les données sont trop grandes pour le flux';
  RSConnectTimeout = 'Délai de connexion.';
  RSICMPNotEnoughtBytes = 'Pas suffisamment d'#39'octets reçus';
  RSICMPNonEchoResponse = 'Réponse de type non-écho reçue';
  RSThreadTerminateAndWaitFor  = 'Impossible d'#39'appeler TerminateAndWaitFor sur les threads FreeAndTerminate';
  RSAlreadyConnected = 'Déjà connecté.';
  RSTerminateThreadTimeout = 'Délai du thread de terminaison dépassé';
  RSNoExecuteSpecified = 'Aucun gestionnaire d'#39'exécution n'#39'a été trouvé.';
  RSNoCommandHandlerFound = 'Aucun gestionnaire de commande n'#39'a été trouvé.';
  RSCannotPerformTaskWhileServerIsActive = 'Impossible d'#39'effectuer la tâche tant que le serveur est actif.';
  RSThreadClassNotSpecified = 'Classe Thread non spécifiée.';
  RSMaximumNumberOfCaptureLineExceeded = 'Le nombre de lignes maximal autorisé a été dépassé'; // S.G. 6/4/2004: IdIOHandler.DoCapture
  RSNoCreateListeningThread = 'Impossible de créer un thread d'#39'écoute.';
  RSInterceptIsDifferent = 'Une autre interception est déjà affectée au IOHandler';

  //scheduler
  RSchedMaxThreadEx = 'Le nombre maximal de threads pour ce planificateur a été dépassé.';
  //transparent proxy
  RSTransparentProxyCannotBind = 'Impossible de lier le proxy transparent.';
  RSTransparentProxyCanNotSupportUDP = 'UDP non supporté par ce proxy.';
  //Fibers
  RSFibersNotSupported = 'Les fibres ne sont pas supportées sur ce système';
  // TIdICMPCast
  RSIPMCastInvalidMulticastAddress = 'L'#39'adresse IP fournie n'#39'est pas une adresse de multidiffusion valide [224.0.0.0 à 239.255.255.255].';
  RSIPMCastNotSupportedOnWin32 = 'Cette fonction n'#39'est pas supportée sur Win32.';
  RSIPMCastReceiveError0 = 'Erreur de réception (diffusion IP) = 0.';

  // Log strings
  RSLogConnected = 'Connecté.';
  RSLogDisconnected = 'Déconnecté.';
  RSLogEOL = '<EOL>';  // End of Line
  RSLogCR  = '<CR>';   // Carriage Return
  RSLogLF  = '<LF>';   // Line feed
  RSLogRecv = 'Reçu '; // Receive
  RSLogSent = 'Envoyé '; // Send
  RSLogStat = 'Stat '; // Status

  RSLogFileAlreadyOpen = 'Impossible de définir le nom de fichier quand le fichier journal est ouvert.';

  RSBufferMissingTerminator = 'Le terminateur du tampon doit être spécifié.';
  RSBufferInvalidStartPos   = 'La position de début du tampon est incorrecte.';

  RSIOHandlerCannotChange = 'Impossible de changer un IOHandler connecté.';
  RSIOHandlerTypeNotInstalled = 'Aucun IOHandler de type %s n'#39'est installé.';

  RSReplyInvalidCode = 'Le code de réponse n'#39'est pas valide : %s';
  RSReplyCodeAlreadyExists = 'Le code de réponse existe déjà : %s';

  RSThreadSchedulerThreadRequired = 'Le thread doit être spécifié pour le planificateur.';
  RSNoOnExecute = 'Vous devez avoir un événement OnExecute.';
  RSThreadComponentLoopAlreadyRunning = 'Impossible de définir la propriété Loop quand le thread est déjà en cours d'#39'exécution.';
  RSThreadComponentThreadNameAlreadyRunning = 'Impossible de définir le nom du thread quand le thread est déjà en cours d'#39'exécution.';

  RSStreamProxyNoStack = 'Une pile n'#39'a pas été créée pour la conversion du type de données.';

  RSTransparentProxyCyclic = 'Erreur cyclique de proxy transparent.';

  RSTCPServerSchedulerAlreadyActive = 'Impossible de changer le planificateur tant que le serveur est actif.';
  RSUDPMustUseProxyOpen = 'Vous devez utiliser proxyOpen';

//ICMP stuff
  RSICMPTimeout = 'Délai dépassé';
//Destination Address -3
  RSICMPNetUnreachable  = 'net inaccessible;';
  RSICMPHostUnreachable = 'hôte inaccessible;';
  RSICMPProtUnreachable = 'protocole inaccessible;';
  RSICMPPortUnreachable = 'Port inaccessible';
  RSICMPFragmentNeeded = 'Fragmentation nécessaire et Ne pas fragmenter a été défini';
  RSICMPSourceRouteFailed = 'Echec de l'#39'itinéraire source';
  RSICMPDestNetUnknown = 'Réseau de destination inconnu';
  RSICMPDestHostUnknown = 'Hôte de destination inconnu';
  RSICMPSourceIsolated = 'Hôte source isolé';
  RSICMPDestNetProhibitted = 'La communication avec le réseau de destination est administrativement interdite';
  RSICMPDestHostProhibitted = 'La communication avec l'#39'hôte de destination est administrativement interdite';
  RSICMPTOSNetUnreach =  'Réseau de destination inaccessible pour le type de service';
  RSICMPTOSHostUnreach = 'Hôte de destination inaccessible pour le type de service';
  RSICMPAdminProhibitted = 'Communication administrativement interdite';
  RSICMPHostPrecViolation = 'Violation de la précédence de l'#39'hôte';
  RSICMPPrecedenceCutoffInEffect =  'Coupure de précédence en vigueur';
  //for IPv6
  RSICMPNoRouteToDest = 'pas d'#39'itinéraire vers la destination';
  RSICMPAAdminDestProhibitted =  'communication avec destination administrativement interdite';
  RSICMPSourceFilterFailed = 'échec de la stratégie d'#39'entrée/sortie (ingress/egress) de l'#39'adresse source';
  RSICMPRejectRoutToDest = 'rejeter l'#39'itinéraire vers la destination';
  // Destination Address - 11
  RSICMPTTLExceeded     = 'durée de vie dépassée dans le transit';
  RSICMPHopLimitExceeded = 'limite de saut dépassée dans le transit';
  RSICMPFragAsmExceeded = 'temps de réassemblage du fragment dépassé.';
//Parameter Problem - 12
  RSICMPParamError      = 'Problème de paramètre (offset %d)';
  //IPv6
  RSICMPParamHeader = 'champ en-tête erroné (offset %d)';
  RSICMPParamNextHeader = 'type en-tête suivant non reconnu (offset %d)';
  RSICMPUnrecognizedOpt = 'option IPv6 non reconnue (offset %d)';
//Source Quench Message -4
  RSICMPSourceQuenchMsg = 'Message Extinction de source';
//Redirect Message
  RSICMPRedirNet =        'Rediriger les datagrammes pour le réseau.';
  RSICMPRedirHost =       'Rediriger les datagrammes pour l'#39'hôte.';
  RSICMPRedirTOSNet =     'Rediriger les datagrammes pour le type de service et le réseau.';
  RSICMPRedirTOSHost =    'Rediriger les datagrammes pour le type de service et l'#39'hôte.';
//echo
  RSICMPEcho = 'Echo';
//timestamp
  RSICMPTimeStamp = 'Horodatage';
//information request
  RSICMPInfoRequest = 'Requête d'#39'information';
//mask request
  RSICMPMaskRequest = 'Requête de masque d'#39'adresse';
// Traceroute
  RSICMPTracePacketForwarded = 'Le paquet sortant a été transféré avec succès';
  RSICMPTraceNoRoute = 'Pas d'#39'itinéraire pour le paquet sortant ; paquet ignoré';
//conversion errors
  RSICMPConvUnknownUnspecError = 'Erreur inconnue/non spécifiée';
  RSICMPConvDontConvOptPresent = 'Présence d'#39'une option Ne pas convertir';
  RSICMPConvUnknownMandOptPresent =  'Présence d'#39'une option obligatoire inconnue';
  RSICMPConvKnownUnsupportedOptionPresent = 'Présence d'#39'une option non supportée connue';
  RSICMPConvUnsupportedTransportProtocol = 'Protocole de transport non supporté';
  RSICMPConvOverallLengthExceeded = 'Longueur globale dépassée';
  RSICMPConvIPHeaderLengthExceeded = 'Longueur de l'#39'en-tête IP dépassée';
  RSICMPConvTransportProtocol_255 = 'Protocole de transport &gt; 255';
  RSICMPConvPortConversionOutOfRange = 'Conversion de port hors limites';
  RSICMPConvTransportHeaderLengthExceeded = 'Longueur de l'#39'en-tête de transport dépassée';
  RSICMPConv32BitRolloverMissingAndACKSet = 'Rollover 32 bits manquant et ACK défini';
  RSICMPConvUnknownMandatoryTransportOptionPresent =      'Présence d'#39'une option de transport obligatoire inconnue';
//mobile host redirect
  RSICMPMobileHostRedirect = 'Redirection d'#39'hôte mobile';
//IPv6 - Where are you
  RSICMPIPv6WhereAreYou    = 'IPv6 Where-Are-You';
//IPv6 - I am here
  RSICMPIPv6IAmHere        = 'IPv6 I-Am-Here';
// Mobile Regestration request
  RSICMPMobReg             = 'Requête d'#39'enregistrement mobile';
//Skip
  RSICMPSKIP               = 'SKIP';
//Security
  RSICMPSecBadSPI          = 'SPI incorrect';
  RSICMPSecAuthenticationFailed = 'Echec d'#39'authentification';
  RSICMPSecDecompressionFailed = 'Echec de la décompression';
  RSICMPSecDecryptionFailed = 'Echec du décryptage';
  RSICMPSecNeedAuthentication = 'Authentification nécessaire';
  RSICMPSecNeedAuthorization = 'Autorisation nécessaire';
//IPv6 Packet Too Big
  RSICMPPacketTooBig = 'Paquet trop gros (MTU = %d)';
{ TIdCustomIcmpClient }

  // TIdSimpleServer
  RSCannotUseNonSocketIOHandler = 'Impossible d'#39'utiliser un IOHandler non-socket';

implementation

end.
