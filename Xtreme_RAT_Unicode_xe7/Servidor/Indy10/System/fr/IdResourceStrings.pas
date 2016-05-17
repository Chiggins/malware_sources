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
  RSInvalidSourceArray = 'Tableau source invalide';
  RSInvalidDestinationArray = 'Tableau destination invalide';
  RSCharIndexOutOfBounds = 'Index caractère hors limites (%d)';
  RSInvalidCharCount = 'Nombre invalide (%d)';
  RSInvalidDestinationIndex = 'Index destination invalide (%d)';

  RSInvalidCodePage = 'Page de code non valide (%d)';
  RSInvalidCharSet = 'Jeu de caractères non valide (%s)';
  RSInvalidCharSetConv = 'Conversion du jeu de caractères invalide (%s <-> %s)';
  RSInvalidCharSetConvWithFlags = 'Conversion du jeu de caractères invalide (%s <-> %s, %s)';

  //IdSys
  RSFailedTimeZoneInfo = 'Echec lors de la tentative de récupération des informations de fuseau horaire.';
  // Winsock
  RSWinsockCallError = 'Erreur d'#39'appel de la fonction %s de la bibliothèque Winsock2';
  RSWinsockLoadError = 'Erreur de chargement de la bibliothèque (%s) Winsock2';
  {CH RSWinsockInitializationError = 'Winsock Initialization Error.'; }
  // Status
  RSStatusResolving = 'Résolution du nom d'#39'hôte %s.';
  RSStatusConnecting = 'Connexion à %s.';
  RSStatusConnected = 'Connecté.';
  RSStatusDisconnecting = 'Déconnexion.';
  RSStatusDisconnected = 'Déconnecté.';
  RSStatusText = '%s';
  // Stack
  RSStackError = 'Erreur de socket n° %d'#13#10'%s';
  RSStackEINTR = 'Appel système interrompu.';
  RSStackEBADF = 'Nombre de fichiers incorrect.';
  RSStackEACCES = 'Accès refusé.';
  RSStackEFAULT = 'Erreur de tampon.';
  RSStackEINVAL = 'Argument non valide.';
  RSStackEMFILE = 'Trop de fichiers ouverts.';
  RSStackEWOULDBLOCK = 'L'#39'opération risquerait de bloquer.';
  RSStackEINPROGRESS = 'Opération maintenant en cours.';
  RSStackEALREADY = 'Opération déjà en cours.';
  RSStackENOTSOCK = 'Opération socket sur cible non-socket.';
  RSStackEDESTADDRREQ = 'Adresse de destination demandée.';
  RSStackEMSGSIZE = 'Message trop long.';
  RSStackEPROTOTYPE = 'Type de protocole inapproprié pour le socket.';
  RSStackENOPROTOOPT = 'Option de protocole incorrecte.';
  RSStackEPROTONOSUPPORT = 'Protocole non supporté.';
  RSStackESOCKTNOSUPPORT = 'Type de socket non supporté.';
  RSStackEOPNOTSUPP = 'Opération non supportée sur un socket.';
  RSStackEPFNOSUPPORT = 'Famille de protocole non supportée.';
  RSStackEAFNOSUPPORT = 'Famille d'#39'adresse non supportée par la famille de protocole.';
  RSStackEADDRINUSE = 'Adresse déjà utilisée.';
  RSStackEADDRNOTAVAIL = 'Impossible d'#39'assigner l'#39'adresse demandée.';
  RSStackENETDOWN = 'Le réseau est arrêté.';
  RSStackENETUNREACH = 'Le réseau est inaccessible.';
  RSStackENETRESET = 'Connexion interrompue ou réinitialisée par le réseau.';
  RSStackECONNABORTED = 'Le logiciel a provoqué l'#39'interruption de la connexion.';
  RSStackECONNRESET = 'Connexion réinitialisée par l'#39'homologue (peer).';
  RSStackENOBUFS = 'Aucun espace tampon disponible.';
  RSStackEISCONN = 'Le socket est déjà connecté.';
  RSStackENOTCONN = 'Le socket n'#39'est pas connecté.';
  RSStackESHUTDOWN = 'Envoi ou réception impossible après la fermeture du socket.';
  RSStackETOOMANYREFS = 'Références trop nombreuses, attribution impossible.';
  RSStackETIMEDOUT = 'Délai de connexion dépassé.';
  RSStackECONNREFUSED = 'Connexion refusée.';
  RSStackELOOP = 'Trop de niveaux de liens symboliques.';
  RSStackENAMETOOLONG = 'Nom de fichier trop long.';
  RSStackEHOSTDOWN = 'Hôte arrêté.';
  RSStackEHOSTUNREACH = 'Pas de route vers l'#39'hôte.';
  RSStackENOTEMPTY = 'Répertoire non vide';
  RSStackHOST_NOT_FOUND = 'Hôte non trouvé.';
  RSStackClassUndefined = 'La classe Stack n'#39'est pas définie.';
  RSStackAlreadyCreated = 'Pile déjà créée.';
  // Other
  RSAntiFreezeOnlyOne = 'Un seul TIdAntiFreeze peut exister par application.';
  RSCannotSetIPVersionWhenConnected = 'Impossible de changer IPVersion en cours de connexion';
  RSCannotBindRange = 'Liaison impossible dans l'#39'étendue du port (%d - %d)';
  RSConnectionClosedGracefully = 'La connexion s'#39'est fermée proprement.';
  RSCorruptServicesFile = '%s est altéré.';
  RSCouldNotBindSocket = 'Impossible de lier le socket. L'#39'adresse et le port sont déjà en cours d'#39'utilisation.';
  RSInvalidPortRange = 'Etendue du port non valide (%d - %d)';
  RSInvalidServiceName = '%s n'#39'est pas un service valide.';
  RSIPv6Unavailable = 'IPv6 indisponible';
  RSInvalidIPv6Address = '%s n'#39'est pas une adresse IPv6 valide.';
  RSIPVersionUnsupported = 'La famille IPVersion / Adresse demandée n'#39'est pas supportée.';
  RSNotAllBytesSent = 'Tous les octets n'#39'ont pas été envoyés.';
  RSPackageSizeTooBig = 'Taille de package trop élevée.';
  RSSetSizeExceeded = 'Taille d'#39'ensemble dépassée.';
  RSNoEncodingSpecified = 'Aucun codage spécifié.';
  {CH RSStreamNotEnoughBytes = 'Not enough bytes read from stream.'; }
  RSEndOfStream = 'Fin du flux : Classe %s à %d';

  //DNS Resolution error messages
  RSMaliciousPtrRecord = 'Enregistrement PTR malveillant';

implementation

end.
