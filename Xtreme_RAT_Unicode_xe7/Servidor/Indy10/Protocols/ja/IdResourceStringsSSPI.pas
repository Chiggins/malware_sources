unit IdResourceStringsSSPI;

interface

resourcestring
  //SSPI Authentication
  {
  Note: CompleteToken is an API function Name:
  }
  RSHTTPSSPISuccess = 'API 呼び出し成功';
  RSHTTPSSPINotEnoughMem = 'この要求を完了するのに使用できるメモリが十分にありません';
  RSHTTPSSPIInvalidHandle = '指定されたハンドルが不正です';
  RSHTTPSSPIFuncNotSupported = '要求された関数はサポートされていません';
  RSHTTPSSPIUnknownTarget = '指定されたターゲットが不明か，アクセスできません';
  RSHTTPSSPIInternalError = 'ローカルセキュリティ機関と連絡が取れません';
  RSHTTPSSPISecPackageNotFound = '要求されたセキュリティパッケージがありません';
  RSHTTPSSPINotOwner = '呼び出し元は希望の証明書の所有者ではありません';
  RSHTTPSSPIPackageCannotBeInstalled = 'セキュリティパッケージは初期化できないため，インストールできません';
  RSHTTPSSPIInvalidToken = '関数に提供されたトークンは正しくありません';
  RSHTTPSSPICannotPack = 'セキュリティパッケージがログオンバッファをマーシャリングできないため，ログオンができませんでした';
  RSHTTPSSPIQOPNotSupported = 'メッセージごとの保護品質は，セキュリティパッケージによってサポートされていません';
  RSHTTPSSPINoImpersonation = 'セキュリティコンテキストによってクライアントのインパーソネーションが許可されていません';
  RSHTTPSSPILoginDenied = 'ログオンができません';
  RSHTTPSSPIUnknownCredentials = 'パッケージに提供された証明書は認識できません';
  RSHTTPSSPINoCredentials = '証明書がセキュリティパッケージで使用できません';
  RSHTTPSSPIMessageAltered = '確認用に提供されたメッセージやシグネチャが変更されています';
  RSHTTPSSPIOutOfSequence = '確認用に提供されたメッセージがシーケンス外です';
  RSHTTPSSPINoAuthAuthority = '認証について届出がありません。';
  RSHTTPSSPIContinueNeeded = '関数は無事終了しましたが，もう一度呼び出してコンテキストを完了する必要があります';
  RSHTTPSSPICompleteNeeded = '関数は無事終了しましたが，CompleteToken を呼び出す必要があります';
  RSHTTPSSPICompleteContinueNeeded =  '関数は無事終了しましたが，CompleteToken およびこの関数を呼び出してコンテキストを完了する必要があります';
  RSHTTPSSPILocalLogin = 'ログオンは終了しましたが，ネットワーク許可がありません。ログオンはローカルで得られる情報を使って行われました';
  RSHTTPSSPIBadPackageID = '要求されたセキュリティパッケージがありません';
  RSHTTPSSPIContextExpired = 'コンテキストが期限切れのため，使用できません。';
  RSHTTPSSPIIncompleteMessage = '提供されたメッセージが不完全です。シグネチャが確認できませんでした。';
  RSHTTPSSPIIncompleteCredentialNotInit =  '提供された証明書は完全ではないため，確認できません。コンテキストが初期化できません。';
  RSHTTPSSPIBufferTooSmall = '関数に提供されたバッファは小さすぎます。';
  RSHTTPSSPIIncompleteCredentialsInit = '提供された証明書は完全ではないため，確認できません。コンテキストより追加情報が返されます。';
  RSHTTPSSPIRengotiate = 'コンテキストデータはピアとやり取りされなければなりません。';
  RSHTTPSSPIWrongPrincipal = 'ターゲット一次名が正しくありません。';
  RSHTTPSSPINoLSACode = 'このコンテキストと関連する LSA モードコンテキストがありません。';
  RSHTTPSSPITimeScew = 'クライアントとサーバーマシンのクロックがずれています。';
  RSHTTPSSPIUntrustedRoot = '証明書チェインは，信用されない機関によって発行されています。';
  RSHTTPSSPIIllegalMessage = '受信されたメッセージは不要か，形式が正しくありません。';
  RSHTTPSSPICertUnknown = '証明書の処理中に不明なエラーが発生しました。';
  RSHTTPSSPICertExpired = '受信した証明書は期限切れです。';
  RSHTTPSSPIEncryptionFailure = '指定されたデータが暗号化できません。';
  RSHTTPSSPIDecryptionFailure = '指定されたデータが暗号解読できません。';
  RSHTTPSSPIAlgorithmMismatch = '共通のアルゴリズムがないので，クライアントとサーバーが通信できません。';
  RSHTTPSSPISecurityQOSFailure = '要求されたサービス品質におけるエラーのため，セキュリティコンテキストが確立できませんでした(たとえば相互認証やデリゲーション）。';
  RSHTTPSSPISecCtxWasDelBeforeUpdated = 'セキュリティ コンテキストが完了前に削除されました。これはログオンの失敗であると考えられます。';
  RSHTTPSSPIClientNoTGTReply = 'クライアントはコンテキストをネゴシエートしようとしており、サーバーはユーザー対ユーザー認証を要求していますが、TGT 応答を送信しませんでした。';
  RSHTTPSSPILocalNoIPAddr = 'ローカル マシンに IP アドレスがないため、要求されたタスクを遂行できません。';
  RSHTTPSSPIWrongCredHandle = '与えられた資格情報ハンドルは、セキュリティ コンテキストに関連付けられている資格情報と一致しません。';
  RSHTTPSSPICryptoSysInvalid = '必要な関数が使用不能なため、暗号システムまたはチェックサム機能が無効です。';
  RSHTTPSSPIMaxTicketRef = 'チケット参照の最大回数を超えました。';
  RSHTTPSSPIMustBeKDC = 'ローカル マシンは Kerberos KDC (ドメイン コントローラ) でなければなりませんが、そうなっていません。';
  RSHTTPSSPIStrongCryptoNotSupported = 'セキュリティ ネゴシエーションの相手側では強力な暗号が必要ですが、それはローカル マシンではサポートされていません。';
  RSHTTPSSPIKDCReplyTooManyPrincipals = 'KDC の応答に複数のプリンシパル名が含まれていました。';
  RSHTTPSSPINoPAData = '使用する暗号化タイプ (etype) のヒントとなる PA データが見つかるはずですが、見つかりませんでした。';
  RSHTTPSSPIPKInitNameMismatch = 'クライアント証明書に有効な UPN が含まれていないか、クライアント証明書がログオン要求のクライアント名と一致しません。管理者に連絡してください。';
  RSHTTPSSPISmartcardLogonReq = 'スマートカード ログオンが必要ですが、使用されませんでした。';
  RSHTTPSSPISysShutdownInProg = 'システムを停止中です。';
  RSHTTPSSPIKDCInvalidRequest = '無効な要求が KDC に送信されました。';
  RSHTTPSSPIKDCUnableToRefer = '要求されたサービスの参照を KDC が生成できませんでした。';
  RSHTTPSSPIKDCETypeUnknown = '要求された暗号化タイプは KDC ではサポートされていません。';
  RSHTTPSSPIUnsupPreauth = 'サポートされていない認証前メカニズムが Kerberos パッケージに提供されました。';
  RSHTTPSSPIDeligationReq = '要求された操作を完了できません。コンピュータは委任に対して信頼されている必要があり、現在のユーザー アカウントは委任可能なように構成されている必要があります。';
  RSHTTPSSPIBadBindings = 'クライアントに提供された SSPI チャネル バインディングが正しくありませんでした。';
  RSHTTPSSPIMultipleAccounts = '受信した証明書は複数のアカウントにマッピングされました。';
  RSHTTPSSPINoKerbKey = 'SEC_E_NO_KERB_KEY';
  RSHTTPSSPICertWrongUsage = '証明書は要求された用途には無効です。';
  RSHTTPSSPIDowngradeDetected = 'セキュリティを脅かすおそれのある試みをシステムが検出しました。認証を行ったサーバーに必ず接続できるようにしてください。';
  RSHTTPSSPISmartcardCertRevoked = '認証に使用されたスマートカード証明書が取り消されました。システム管理者に連絡してください。イベント ログに追加情報が記載されている可能性があります。';
  RSHTTPSSPIIssuingCAUntrusted = '認証に使用されたスマートカード証明書の処理中に、信頼できない認証局が検出されました。システム管理者に連絡してください。';
  RSHTTPSSPIRevocationOffline = '認証に使用されたスマートカード証明書の取り消し状態を判定できませんでした。システム管理者に連絡してください。';
  RSHTTPSSPIPKInitClientFailure = '認証に使用されたスマートカード証明書は信頼できませんでした。システム管理者に連絡してください。';
  RSHTTPSSPISmartcardExpired = '認証に使用されたスマートカード証明書の有効期限が切れました。システム管理者に連絡してください。';
  RSHTTPSSPINoS4UProtSupport = 'Kerberos サブシステムでエラーが発生しました。ユーザー向けのサービスをサポートしていないドメイン コントローラーに対して、ユーザー プロトコルのサービスが要求されました。';
  RSHTTPSSPICrossRealmDeligationFailure = 'このサーバーは、サーバー領域外のターゲットについての Kerberos 制約付き委任要求を行おうとしました。これはサポートされておらず、このサーバーの Allowed-to-Delegate-to リストに構成ミスがあることを示しています。管理者に連絡してください。';
  RSHTTPSSPIRevocationOfflineKDC = 'スマートカード認証に使用されたドメイン コントローラ証明書の取り消し状態を判定できませんでした。システム イベント ログに追加情報が記載されています。システム管理者に連絡してください。';
  RSHTTPSSPICAUntrustedKDC = '認証に使用されたドメイン コントローラ証明書の処理中に、信頼できない認証局が検出されました。システム イベント ログに追加情報が記載されています。システム管理者に連絡してください。';
  RSHTTPSSPIKDCCertExpired = 'スマートカード ログオンに使用されたドメイン コントローラ証明書の有効期限が切れました。システム管理者に連絡し、システム イベント ログの内容を知らせてください。';
  RSHTTPSSPIKDCCertRevoked = 'スマートカード ログオンに使用されたドメイン コントローラ証明書が取り消されました。システム管理者に連絡し、システム イベント ログの内容を知らせてください。';
  RSHTTPSSPISignatureNeeded = 'ユーザーが認証を行うには、まず、署名操作を行う必要があります。';
  RSHTTPSSPIInvalidParameter = '関数に渡されたパラメータのうち 1 つ以上が無効でした。';
  RSHTTPSSPIDeligationPolicy = 'クライアント ポリシーにより、ターゲット サーバーに対する資格情報の委譲は許されていません。';
  RSHTTPSSPIPolicyNTLMOnly = 'クライアント ポリシーにより、NLTM 認証のみを使用したターゲット サーバーに対する資格情報の委譲は許されていません。';
  RSHTTPSSPINoRenegotiation = '受信側が再ネゴシエーション要求を拒否しました。';
  RSHTTPSSPINoContext = '必要なセキュリティ コンテキストが存在しません。';
  RSHTTPSSPIPKU2UCertFailure = '関連する証明書を利用しようとしたときに、PKU2U プロトコルでエラーが発生しました。';
  RSHTTPSSPIMutualAuthFailed = 'サーバー コンピュータの ID を確認できませんでした。';
  RSHTTPSSPIUnknwonError = '原因不明のエラー';
  {
  Note to translators - the parameters for the next message are below:

  Failed Function Name
  Error Number
  Error Number
  Error Message by Number
  }

  RSHTTPSSPIErrorMsg = 'SSPI %s がエラー #%d(0x%x) を返します: %s';

  RSHTTPSSPIInterfaceInitFailed = 'SSPI インターフェイスが正しく初期化できません';
  RSHTTPSSPINoPkgInfoSpecified = 'PSecPkgInfo が指定されていません';
  RSHTTPSSPINoCredentialHandle = '証明書ハンドルが取得されていません';
  RSHTTPSSPICanNotChangeCredentials = 'ハンドル取得後は証明書ファイルを変更できません。Release を先に使用してください';
  RSHTTPSSPIUnknwonCredentialUse = '不明な証明書の使用';
  RSHTTPSSPIDoAuquireCredentialHandle = 'AcquireCredentialsHandle を最初に実行';
  RSHTTPSSPICompleteTokenNotSupported = 'CompleteAuthToken はサポートされていません';

implementation

end.
