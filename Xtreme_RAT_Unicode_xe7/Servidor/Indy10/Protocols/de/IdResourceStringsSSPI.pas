unit IdResourceStringsSSPI;

interface

resourcestring
  //SSPI Authentication
  {
  Note: CompleteToken is an API function Name:
  }
  RSHTTPSSPISuccess = 'Erfolgreicher API-Aufruf';
  RSHTTPSSPINotEnoughMem = 'Für diese Anforderung steht nicht genügend Speicher zur Verfügung';
  RSHTTPSSPIInvalidHandle = 'Das angegebene Handle ist ungültig';
  RSHTTPSSPIFuncNotSupported = 'Die angeforderte Funktion wird nicht unterstützt';
  RSHTTPSSPIUnknownTarget = 'Das angegebene Ziel ist unbekannt oder nicht erreichbar';
  RSHTTPSSPIInternalError = 'Die lokale Sicherheitsautorität kann nicht kontaktiert werden';
  RSHTTPSSPISecPackageNotFound = 'Das angeforderte Sicherheits-Package existiert nicht';
  RSHTTPSSPINotOwner = 'Der Aufrufer ist nicht der Besitzer der gewünschten Beglaubigung';
  RSHTTPSSPIPackageCannotBeInstalled = 'Das Sicherheits-Package konnte nicht initialisiert werden und kann nicht installiert werden';
  RSHTTPSSPIInvalidToken = 'Das der Funktion übermittelte Token ist ungültig';
  RSHTTPSSPICannotPack = 'Das Sicherheits-Package kann den Anmelde-Puffer nicht einrichten, deswegen ist der Versuch der Anmeldung fehlgeschlagen';
  RSHTTPSSPIQOPNotSupported = 'Der Qualitätsschutz pro Botschaft wird vom Sicherheits-Package nicht unterstützt';
  RSHTTPSSPINoImpersonation = 'Der Sicherheitskontext erlaubt keine Darstellung des Client';
  RSHTTPSSPILoginDenied = 'Der Versuch der Anmeldung ist fehlgeschlagen';
  RSHTTPSSPIUnknownCredentials = 'Die Beglaubigungen aus dem Package wurden nicht erkannt';
  RSHTTPSSPINoCredentials = 'Im Sicherheits-Package sind keine Beglaubigungen verfügbar';
  RSHTTPSSPIMessageAltered = 'Die zur Verifizierung übermittelte Botschaft oder Signatur wurde verändert';
  RSHTTPSSPIOutOfSequence = 'Die zur Verifizierung übermittelte Botschaft ist außerhalb der Sequenz';
  RSHTTPSSPINoAuthAuthority = 'Für die Authentifizierung konnte keine geeignete Stelle kontaktiert werden.';
  RSHTTPSSPIContinueNeeded = 'Die Funktion wurde erfolgreich ausgeführt, muss aber zur Vervollständigung des Kontexts wieder aufgerufen werden';
  RSHTTPSSPICompleteNeeded = 'Die Funktion wurde erfolgreich ausgeführt, aber CompleteToken muss aufgerufen werden';
  RSHTTPSSPICompleteContinueNeeded =  'Die Funktion wurde erfolgreich ausgeführt, aber CompleteToken als auch diese Funktion müssen aufgerufen werden, um den Kontext zu vervollständigen';
  RSHTTPSSPILocalLogin = 'Die Anmeldung wurde durchgeführt, aber es war keine Netzwerk-Autorität verfügbar. Die Anmeldung wurde unter Verwendung lokal bekannter Informationen durchgeführt';
  RSHTTPSSPIBadPackageID = 'Das angeforderte Sicherheits-Package existiert nicht';
  RSHTTPSSPIContextExpired = 'Der Kontext ist abgelaufen und kann nicht mehr verwendet werden.';
  RSHTTPSSPIIncompleteMessage = 'Die übermittelte Botschaft ist unvollständig. Die Signatur wurde nicht verifiziert.';
  RSHTTPSSPIIncompleteCredentialNotInit =  'Die aufgeführten Beglaubigungen waren unvollständig und konnten nicht verifiziert werden. Der Kontext konnte nicht initialisiert werden.';
  RSHTTPSSPIBufferTooSmall = 'Die der Funktion mitgegebenen Puffer sind zu klein.';
  RSHTTPSSPIIncompleteCredentialsInit = 'Die aufgeführten Beglaubigungen waren unvollständig und konnten nicht verifiziert werden. Zusatzinformationen können aus dem Kontext zurückgegeben werden.';
  RSHTTPSSPIRengotiate = 'Die Kontextdaten müssen mit dem Peer neu ausgehandelt werden.';
  RSHTTPSSPIWrongPrincipal = 'Der Ziel-Prinzipalname ist nicht korrekt.';
  RSHTTPSSPINoLSACode = 'Mit diesem Kontext ist kein LSA-Modus-Kontext verknüpft.';
  RSHTTPSSPITimeScew = 'Die Uhrzeit auf Client und Server ist unterschiedlich.';
  RSHTTPSSPIUntrustedRoot = 'Die Zertifikatskette wurde von einer nicht vertrauenswürdigen Autorität ausgegeben.';
  RSHTTPSSPIIllegalMessage = 'Die empfangene Botschaft war nicht erwartet oder falsch formatiert.';
  RSHTTPSSPICertUnknown = 'Beim Bearbeiten des Zertifikats ist ein Fehler aufgetreten.';
  RSHTTPSSPICertExpired = 'Das empfangene Zertifikat ist abgelaufen.';
  RSHTTPSSPIEncryptionFailure = 'Die angegebenen Daten konnten nicht verschlüsselt werden.';
  RSHTTPSSPIDecryptionFailure = 'Die angegebenen Daten konnten nicht entschlüsselt werden.';
  RSHTTPSSPIAlgorithmMismatch = 'Client und Server können nicht kommunizieren, da sie keinen gemeinsamen Algorithmus besitzen.';
  RSHTTPSSPISecurityQOSFailure = 'Der Sicherheitskontext konnte nicht eingerichtet werden, da Qualität des Service fehlt (z.B. gegenseitige Authentifizierung oder Delegation).';
  RSHTTPSSPISecCtxWasDelBeforeUpdated = 'Ein Sicherheitskontext wurde vor Ausführung des Kontextes gelöscht. Dies wird als Anmeldefehler eingestuft.';
  RSHTTPSSPIClientNoTGTReply = 'Der Client versucht, einen Kontext auszuhandeln, und der Server erfordert Benutzer-zu-Benutzer, hat aber keine TGT-Antwort gesendet.';
  RSHTTPSSPILocalNoIPAddr = 'Die angeforderte Aufgabe konnte nicht ausgeführt werden, weil der lokale Computer keine IP-Adresse hat.';
  RSHTTPSSPIWrongCredHandle = 'Das bereitgestellte Anmeldeinformations-Handle stimmt nicht mit den dem Sicherheitskontext zugeordneten Anmeldeinformationen überein.';
  RSHTTPSSPICryptoSysInvalid = 'Das Kryptosystem oder die Prüfsummenfunktion ist ungültig, weil eine erforderliche Funktion nicht verfügbar ist.';
  RSHTTPSSPIMaxTicketRef = 'Die Anzahl der maximalen Ticket-Empfehlungen wurde überschritten.';
  RSHTTPSSPIMustBeKDC = 'Der lokale Computer muss ein Kerberos KDC (Domänencontroller) sein, ist er aber nicht.';
  RSHTTPSSPIStrongCryptoNotSupported = 'Das andere Ende der Sicherheitsaushandlung erfordert eine starke Verschlüsselung, was auf dem lokalen Computer aber nicht unterstützt wird.';
  RSHTTPSSPIKDCReplyTooManyPrincipals = 'Die Antwort vom KDC enthielt mehr als einen Prinzipalnamen.';
  RSHTTPSSPINoPAData = 'Es wurde erwartet, PA-Daten für einen Hinweis darauf zu finden, welcher etype verwendet werden soll; solche Daten wurden aber nicht gefunden.';
  RSHTTPSSPIPKInitNameMismatch = 'Das Client-Zertifikat enthält keinen gültigen UPN oder stimmt nicht mit dem Clientnamen in der Anmeldeanforderung überein. Bitte wenden Sie sich an Ihren Administrator.';
  RSHTTPSSPISmartcardLogonReq = 'Smartcard-Anmeldung ist erforderlich, wurde aber nicht verwendet.';
  RSHTTPSSPISysShutdownInProg = 'Das System wird gerade heruntergefahren.';
  RSHTTPSSPIKDCInvalidRequest = 'An den KDC wurde eine ungültige Anforderung gesendet.';
  RSHTTPSSPIKDCUnableToRefer = 'Der KDC konnte für den angeforderten Dienst keine Empfehlung generieren.';
  RSHTTPSSPIKDCETypeUnknown = 'Der angeforderte Verschlüsselungstyp wird vom KDC nicht unterstützt.';
  RSHTTPSSPIUnsupPreauth = 'Dem Kerberos-Package wurde ein nicht unterstützter Vor-Authentifizierungsmechanismus präsentiert.';
  RSHTTPSSPIDeligationReq = 'Die angeforderte Operation kann nicht ausgeführt werden. Der Computer muss für Delegierungen vertrauenswürdig sein, und das aktuelle Benutzerkonto muss für das Zulassen von Delegierungen konfiguriert sein.';
  RSHTTPSSPIBadBindings = 'Vom Client bereitgestellte SSPI-Kanalbindungen waren inkorrekt.';
  RSHTTPSSPIMultipleAccounts = 'Das erhaltene Zertifikat wurde mehreren Konten zugeordnet.';
  RSHTTPSSPINoKerbKey = 'SEC_E_NO_KERB_KEY';
  RSHTTPSSPICertWrongUsage = 'Das Zertifikat ist für die angeforderte Verwendung nicht gültig.';
  RSHTTPSSPIDowngradeDetected = 'Das System hat einen möglichen Versuch der Beeinträchtigung der Sicherheit festgestellt. Bitte stellen Sie sicher, dass Sie eine Verbindung zu dem Server herstellen können, der Sie authentifiziert hat.';
  RSHTTPSSPISmartcardCertRevoked = 'Das für die Authentifizierung verwendete Smartcard-Zertifikat wurde widerrufen. Bitte wenden Sie sich an Ihren Systemadministrator. Im Ereignisprotokoll finden Sie ggf. weitere Informationen.';
  RSHTTPSSPIIssuingCAUntrusted = 'Beim Verarbeiten des für die Authentifizierung verwendeten Smartcard-Zertifikats wurde eine nicht vertrauenswürdige Zertifizierungsstelle gefunden. Bitte wenden Sie sich an Ihren Systemadministrator.';
  RSHTTPSSPIRevocationOffline = 'Der für die Authentifizierung verwendete Widerrufsstatus des Smartcard-Zertifikats konnte nicht festgestellt werden. Bitte wenden Sie sich an Ihren Systemadministrator.';
  RSHTTPSSPIPKInitClientFailure = 'Das für die Authentifizierung verwendete Smartcard-Zertifikat ist nicht vertrauenswürdig. Bitte wenden Sie sich an Ihren Systemadministrator.';
  RSHTTPSSPISmartcardExpired = 'Das für die Authentifizierung verwendete Smartcard-Zertifikat ist abgelaufen. Bitte wenden Sie sich an Ihren Systemadministrator.';
  RSHTTPSSPINoS4UProtSupport = 'Das Kerberos-Subsystem hat einen Fehler festgestellt. Ein Dienst für eine Benutzerprotokollanforderung wurde für einen Domänencontroller ausgeführt, der keine Dienste für Benutzer unterstützt. ';
  RSHTTPSSPICrossRealmDeligationFailure = 'Dieser Server hat versucht, eine eingeschränkte Kerberos-Delegierung für ein Ziel außerhalb des Serverbereichs anzufordern. Dies wird nicht unterstützt und gibt eine fehlerhafte Konfiguration dieses Servers bezüglich der Zulässigkeit von Delegierungen an '+
'Listen an. Bitte wenden Sie sich an Ihren Administrator.';
  RSHTTPSSPIRevocationOfflineKDC = 'Der für die Smartcard-Authentifizierung verwendete Widerrufsstatus des Domänencontroller-Zertifikats konnte nicht festgestellt werden. Im Systemereignisprotokoll finden Sie weitere Informationen. Bitte wenden Sie sich an Ihren Systemadministrator.';
  RSHTTPSSPICAUntrustedKDC = 'Beim Verarbeiten des für die Authentifizierung verwendeten Domänencontroller-Zertifikats wurde eine nicht vertrauenswürdige Zertifizierungsstelle gefunden. Im Systemereignisprotokoll finden Sie weitere Informationen. Bitte wenden Sie sich an Ihren Systema'+
'dministrator.';
  RSHTTPSSPIKDCCertExpired = 'Das für die Smartcard-Anmeldung verwendete Domänencontroller-Zertifikat ist abgelaufen. Bitte wenden Sie sich mit dem Systemereignisprotokoll an Ihren Systemadministrator. ';
  RSHTTPSSPIKDCCertRevoked = 'Das für die Smartcard-Anmeldung verwendete Domänencontroller-Zertifikat wurde widerrufen. Bitte wenden Sie sich mit dem Systemereignisprotokoll an Ihren Systemadministrator. ';
  RSHTTPSSPISignatureNeeded = 'Eine Signaturoperation muss vor der Benutzerauthentifizierung ausgeführt werden.';
  RSHTTPSSPIInvalidParameter = 'Ein oder mehrere an die Funktion übergebene Parameter sind ungültig.';
  RSHTTPSSPIDeligationPolicy = 'Die Client-Policy erlaubt kein Delegieren von Anmeldeinformationen an den Zielserver.';
  RSHTTPSSPIPolicyNTLMOnly = 'Die Client-Policy erlaubt kein Delegieren von Anmeldeinformationen an den Zielserver mit nur NLTM-Authentifizierung.';
  RSHTTPSSPINoRenegotiation = 'Der Empfänger hat die Anforderung auf Neuaushandlung zurückgewiesen.';
  RSHTTPSSPINoContext = 'Der erforderliche Sicherheitskontext ist nicht vorhanden.';
  RSHTTPSSPIPKU2UCertFailure = 'Das PKU2U-Protokoll hat beim Versuch, die zugeordneten Zertifikate zu verwenden, einen Fehler festgestellt.';
  RSHTTPSSPIMutualAuthFailed = 'Die Identität des Server-Computers konnte nicht verifiziert werden.';
  RSHTTPSSPIUnknwonError = 'Unbekannter Fehler';
  {
  Note to translators - the parameters for the next message are below:

  Failed Function Name
  Error Number
  Error Number
  Error Message by Number
  }

  RSHTTPSSPIErrorMsg = 'SSPI %s gibt Fehler #%d(0x%x) zurück: %s';

  RSHTTPSSPIInterfaceInitFailed = 'SSPI-Interface hat sich nicht richtig initialisiert';
  RSHTTPSSPINoPkgInfoSpecified = 'Es wurde kein PSecPkgInfo angegeben';
  RSHTTPSSPINoCredentialHandle = 'Es wurde kein Beglaubigungs-Handle geholt';
  RSHTTPSSPICanNotChangeCredentials = 'Beglaubigung kann nicht nach Holen des Handle geändert werden. Zuerst Release benutzen';
  RSHTTPSSPIUnknwonCredentialUse = 'Verwendung unbekannter Beglaubigung';
  RSHTTPSSPIDoAuquireCredentialHandle = 'Erst AcquireCredentialsHandle';
  RSHTTPSSPICompleteTokenNotSupported = 'CompleteAuthToken nicht unterstützt';

implementation

end.
