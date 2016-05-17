unit IdResourceStringsSSPI;

interface

resourcestring
  //SSPI Authentication
  {
  Note: CompleteToken is an API function Name:
  }
  RSHTTPSSPISuccess = 'Appel API réussi';
  RSHTTPSSPINotEnoughMem = 'Mémoire insuffisante pour terminer cette requête';
  RSHTTPSSPIInvalidHandle = 'Handle incorrect';
  RSHTTPSSPIFuncNotSupported = 'La fonction requise n'#39'est pas supportée';
  RSHTTPSSPIUnknownTarget = 'La cible spécifiée est inconnue ou non accessible';
  RSHTTPSSPIInternalError = 'L'#39'autorité de sécurité locale ne peut pas être contactée';
  RSHTTPSSPISecPackageNotFound = 'Le paquet de sécurité demandé n'#39'existe pas';
  RSHTTPSSPINotOwner = 'L'#39'appelant n'#39'est pas le propriétaire du justificatif voulu';
  RSHTTPSSPIPackageCannotBeInstalled = 'L'#39'initialisation du paquet de sécurité a échoué et il ne peut donc pas être installé';
  RSHTTPSSPIInvalidToken = 'Le token fourni à la fonction est incorrect';
  RSHTTPSSPICannotPack = 'Le paquet de sécurité n'#39'est pas capable d'#39'effectuer le marshalling du tampon de connexion. En conséquence, la tentative de connexion a échoué.';
  RSHTTPSSPIQOPNotSupported = 'La qualité de protection par message n'#39'est pas supportée par le paquet de sécurité';
  RSHTTPSSPINoImpersonation = 'Le contexte de sécurité ne permet aucune usurpation d'#39'identité du client';
  RSHTTPSSPILoginDenied = 'La tentative de connexion a échoué';
  RSHTTPSSPIUnknownCredentials = 'Les justificatifs fournis au paquet n'#39'ont pas été reconnus';
  RSHTTPSSPINoCredentials = 'Aucun justificatif n'#39'est disponible dans le paquet de sécurité';
  RSHTTPSSPIMessageAltered = 'La signature ou le message fourni pour vérification a été modifié';
  RSHTTPSSPIOutOfSequence = 'Le message fourni pour vérification n'#39'est pas dans l'#39'ordre';
  RSHTTPSSPINoAuthAuthority = 'Aucune autorité n'#39'a pu être contactée pour authentification.';
  RSHTTPSSPIContinueNeeded = 'La fonction s'#39'est terminée correctement, mais doit être à nouveau appelée pour terminer le contexte.';
  RSHTTPSSPICompleteNeeded = 'La fonction s'#39'est terminée avec succès, mais CompleteToken doit être appelé';
  RSHTTPSSPICompleteContinueNeeded =  'La fonction s'#39'est terminée avec succès, mais CompleteToken et cette fonction doivent être appelés pour terminer le contexte';
  RSHTTPSSPILocalLogin = 'La connexion s'#39'est effectuée, mais aucune autorité réseau n'#39'était disponible. La connexion s'#39'est effectuée en utilisant des informations de connexion connues localement';
  RSHTTPSSPIBadPackageID = 'Le paquet de sécurité demandé n'#39'existe pas';
  RSHTTPSSPIContextExpired = 'Le contexte a expiré et ne peut plus être utilisé.';
  RSHTTPSSPIIncompleteMessage = 'Le message fourni est incomplet. La signature n'#39'a pas été vérifiée.';
  RSHTTPSSPIIncompleteCredentialNotInit =  'Les justitificatifs fournis étaient incomplets et n'#39'ont pas pu être vérifiés. Le contexte n'#39'a pas pu être initialisé.';
  RSHTTPSSPIBufferTooSmall = 'Le tampon fourni à une fonction était trop petit.';
  RSHTTPSSPIIncompleteCredentialsInit = 'Les justificatifs fournis étaient incomplets et n'#39'ont pas pu être vérifiés. Des informations supplémentaires peuvent être renvoyées par le contexte.';
  RSHTTPSSPIRengotiate = 'Les données contextuelles doivent être renégociées par le peer.';
  RSHTTPSSPIWrongPrincipal = 'Le nom principal de la cible est incorrect.';
  RSHTTPSSPINoLSACode = 'Aucun contexte de mode LSA n'#39'est associé à ce contexte.';
  RSHTTPSSPITimeScew = 'Les horloges des machines client et serveur ne sont pas concordantes.';
  RSHTTPSSPIUntrustedRoot = 'La chaînes de certificats a été émise par une autorité non fiable.';
  RSHTTPSSPIIllegalMessage = 'Le message reçu était inattendu ou incorrectement formaté.';
  RSHTTPSSPICertUnknown = 'Une erreur inconnue s'#39'est produite lors du traitement du certificat.';
  RSHTTPSSPICertExpired = 'Le certificat reçu a expiré.';
  RSHTTPSSPIEncryptionFailure = 'Les données spécifiées n'#39'ont pas pu être encryptées.';
  RSHTTPSSPIDecryptionFailure = 'Les données spécifiées n'#39'ont pas pu être décryptées.';
  RSHTTPSSPIAlgorithmMismatch = 'Le client et le serveur ne peuvent pas communiquer car ils ne possèdent pas d'#39'algorithme commun.';
  RSHTTPSSPISecurityQOSFailure = 'Le contexte de sécurité n'#39'a pas été établi suite à une panne dans le service de qualité requis (ex : authentification mutuelle ou délégation).';
  RSHTTPSSPISecCtxWasDelBeforeUpdated = 'Un contexte de sécurité a été supprimé avant la fin du contexte. Ceci est considéré comme un échec de connexion.';
  RSHTTPSSPIClientNoTGTReply = 'Le client tente de négocier un contexte et le serveur nécessite une authentification d'#39'utilisateur à utilisateur mais n'#39'a pas envoyé de réponse TGT.';
  RSHTTPSSPILocalNoIPAddr = 'Impossible d'#39'accomplir la tâche requise car la machine locale n'#39'a aucune adresse IP.';
  RSHTTPSSPIWrongCredHandle = 'Le handle d'#39'informations d'#39'identification fourni ne correspond pas aux informations d'#39'identification associées au contexte de sécurité.';
  RSHTTPSSPICryptoSysInvalid = 'Le système de cryptage ou la fonction de somme de contrôle n'#39'est pas valide car une fonction requise est indisponible.';
  RSHTTPSSPIMaxTicketRef = 'Le nombre maximal de tickets de référence a été dépassé.';
  RSHTTPSSPIMustBeKDC = 'La machine locale doit être un contrôleur de domaine Kerberos (KDC), ce qui n'#39'est pas le cas.';
  RSHTTPSSPIStrongCryptoNotSupported = 'L'#39'autre côté de la négociation de sécurité nécessite un cryptage renforcé mais cela n'#39'est pas supporté sur la machine locale.';
  RSHTTPSSPIKDCReplyTooManyPrincipals = 'La réponse du contrôleur de domaine Kerberos contenait plus d'#39'un nom principal.';
  RSHTTPSSPINoPAData = 'Des données d'#39'activité personnelle étaient attendues pour savoir quel etype utiliser, mais elles n'#39'ont pas été trouvées.';
  RSHTTPSSPIPKInitNameMismatch = 'Le certificat du client ne contient pas un UPN valide, ou ne correspond pas au nom du client dans la requête de connexion. Contactez votre administrateur.';
  RSHTTPSSPISmartcardLogonReq = 'Une connexion avec la carte à puce est nécessaire et n'#39'a pas été utilisée.';
  RSHTTPSSPISysShutdownInProg = 'Un arrêt système est en cours.';
  RSHTTPSSPIKDCInvalidRequest = 'Une requête non valide a été envoyée au contrôleur de domaine Kerberos.';
  RSHTTPSSPIKDCUnableToRefer = 'Le contrôleur de domaine Kerberos n'#39'a pas pu générer une référence pour le service requis.';
  RSHTTPSSPIKDCETypeUnknown = 'Le type d'#39'encryptage requis n'#39'est pas supporté par le contrôleur de domaine Kerberos.';
  RSHTTPSSPIUnsupPreauth = 'Un mécanisme de pré-authentification non supporté a été présenté au package Kerberos.';
  RSHTTPSSPIDeligationReq = 'L'#39'opération requise ne peut pas être terminée. L'#39'ordinateur doit être approuvé pour la délégation et le compte d'#39'utilisateur actuel doit être configuré afin d'#39'autoriser la délégation.';
  RSHTTPSSPIBadBindings = 'Les liaisons de canal SSPI fournies au client étaient incorrectes.';
  RSHTTPSSPIMultipleAccounts = 'Le certificat reçu a été mappé à de multiples comptes.';
  RSHTTPSSPINoKerbKey = 'SEC_E_NO_KERB_KEY';
  RSHTTPSSPICertWrongUsage = 'Le certificat n'#39'est pas valide pour l'#39'usage requis.';
  RSHTTPSSPIDowngradeDetected = 'Le système a détecté une tentative potentielle d'#39'atteinte à la sécurité. Vérifiez que vous pouvez contacter le serveur qui vous a authentifié.';
  RSHTTPSSPISmartcardCertRevoked = 'Le certificat de la carte à puce utilisé pour l'#39'authentification a été révoqué. Contactez votre administrateur système. Il y a peut-être des informations supplémentaires dans le journal d'#39'événements.';
  RSHTTPSSPIIssuingCAUntrusted = 'Une autorité de certificat non approuvée a été détectée lors du traitement du certificat de la carte à puce utilisée pour l'#39'authentification. Contactez votre administrateur système.';
  RSHTTPSSPIRevocationOffline = 'Le statut de révocation du certificat de la carte à puce utilisé pour l'#39'authentification n'#39'a pas pu être déterminé. Contactez votre administrateur système.';
  RSHTTPSSPIPKInitClientFailure = 'Le certificat de la carte à puce utilisé pour l'#39'authentification n'#39'est pas approuvé. Contactez votre administrateur système.';
  RSHTTPSSPISmartcardExpired = 'Le certificat de la carte à puce utilisé pour l'#39'authentification a expiré. Contactez votre administrateur système.';
  RSHTTPSSPINoS4UProtSupport = 'Le sous-système Kerberos a rencontré une erreur. Un service pour la requête de protocole utilisateur a été effectué dans un contrôleur de domaine qui ne supporte pas le service pour l'#39'utilisateur.';
  RSHTTPSSPICrossRealmDeligationFailure = 'Une tentative a été réalisée par ce serveur pour effectuer une requête de délégation Kerberos contrainte pour une cible en dehors du domaine Kerberos du serveur. Ce n'#39'est pas supporté, et indique une configuration incorrecte sur ce serveur autorisé à délé'+
'guer à la liste. Contactez votre administrateur.';
  RSHTTPSSPIRevocationOfflineKDC = 'Le statut de révocation du certificat du contrôleur de domaine utilisé pour l'#39'authentification de la carte à puce n'#39'a pas pu être déterminé. Le journal des événements système contient des informations supplémentaires. Contactez votre administrateur systèm'+
'e.';
  RSHTTPSSPICAUntrustedKDC = 'Une autorité de certificat non approuvée a été détectée lors du traitement du certificat du contrôleur de domaine utilisé pour l'#39'authentification. Le journal des événements système contient des informations supplémentaires. Contactez votre administrateur '+
'système.';
  RSHTTPSSPIKDCCertExpired = 'Le certificat du contrôleur de domaine utilisé pour la connexion de la carte à puce a expiré. Contactez votre administrateur système avec le journal d'#39'événements de votre système.';
  RSHTTPSSPIKDCCertRevoked = 'Le certificat du contrôleur de domaine utilisé pour la connexion de la carte à puce a été révoqué. Contactez votre administrateur système avec le journal d'#39'événements de votre système.';
  RSHTTPSSPISignatureNeeded = 'Une opération de signature doit être effectuée avant que l'#39'utilisateur ne puisse s'#39'authentifier.';
  RSHTTPSSPIInvalidParameter = 'Au moins un des paramètres transmis à la fonction n'#39'était pas valide.';
  RSHTTPSSPIDeligationPolicy = 'La stratégie du client n'#39'autorise pas la délégation des informations d'#39'identification au serveur cible.';
  RSHTTPSSPIPolicyNTLMOnly = 'La stratégie du client n'#39'autorise pas la délégation des informations d'#39'identification au serveur cible sur la seule présentation de l'#39'authentification NLTM.';
  RSHTTPSSPINoRenegotiation = 'Le destinataire a refusé la demande de renégociation.';
  RSHTTPSSPINoContext = 'Le contexte de sécurité requis n'#39'existe pas.';
  RSHTTPSSPIPKU2UCertFailure = 'Le protocole PKU2U a rencontré une erreur lors de la tentative d'#39'utilisation des certificats associés.';
  RSHTTPSSPIMutualAuthFailed = 'L'#39'identité du serveur n'#39'a pas pu être vérifiée.';
  RSHTTPSSPIUnknwonError = 'Erreur inconnue';
  {
  Note to translators - the parameters for the next message are below:

  Failed Function Name
  Error Number
  Error Number
  Error Message by Number
  }

  RSHTTPSSPIErrorMsg = 'SSPI %s renvoie l'#39'erreur #%d(0x%x): %s';

  RSHTTPSSPIInterfaceInitFailed = 'L'#39'interface SSPI n'#39'a pas pu s'#39'initialiser correctement';
  RSHTTPSSPINoPkgInfoSpecified = 'Aucun PSecPkgInfo n'#39'a été spécifié';
  RSHTTPSSPINoCredentialHandle = 'Aucun handle de justificatif n'#39'a été acquis';
  RSHTTPSSPICanNotChangeCredentials = 'Impossible de changer les justificatifs après l'#39'acquisition du handle. Utilisez Release d'#39'abord.';
  RSHTTPSSPIUnknwonCredentialUse = 'Utilisation de justificatifs inconnus';
  RSHTTPSSPIDoAuquireCredentialHandle = 'Exécuter d'#39'abord AcquireCredentialsHandle';
  RSHTTPSSPICompleteTokenNotSupported = 'CompleteAuthToken n'#39'est pas supporté';

implementation

end.
