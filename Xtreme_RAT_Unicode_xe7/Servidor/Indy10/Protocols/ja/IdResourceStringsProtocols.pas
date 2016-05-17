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
  RSIOHandlerPropInvalid = 'IOHandler 値が無効です';

  //FIPS
  RSFIPSAlgorithmNotAllowed = 'アルゴリズム %s は FIPS モードでは使用できません';
  //FSP
  RSFSPNotFound = 'ファイルが見つかりません';
  RSFSPPacketTooSmall = 'パケットが小さすぎます';

  //SASL
  RSSASLNotReady = '指定された SASL ハンドラが用意されていません!!';
  RSSASLNotSupported = 'AUTH または指定された SASL ハンドラをサポートしていません!!';
  RSSASLRequired = 'ログインするための SASL メカニズムが必要です!!';

  //TIdSASLDigest
  RSSASLDigestMissingAlgorithm = 'アルゴリズムが見つかりません';
  RSSASLDigestInvalidAlgorithm = 'アルゴリズムが無効です';
  RSSASLDigestAuthConfNotSupported = 'auth-conf  はまだサポートされていません。';

  //  TIdEMailAddress
  RSEMailSymbolOutsideAddress = '@ 外部アドレス';

  //ZLIB Intercept
  RSZLCompressorInitializeFailure = '圧縮モジュールを初期化できません';
  RSZLDecompressorInitializeFailure = '解凍モジュールを初期化できません';
  RSZLCompressionError = '圧縮エラーが発生しました';
  RSZLDecompressionError = '解凍時にエラーが発生しました';

  //MIME Types
  RSMIMEExtensionEmpty = '拡張がありません';
  RSMIMEMIMETypeEmpty = 'MIME 型がありません';
  RSMIMEMIMEExtAlreadyExists = '拡張がすでに存在';

  // IdRegister
  RSRegSASL = 'Indy SASL';

  // Status Strings
  // TIdTCPClient
  // Message Strings
  RSIdMessageCannotLoad = 'ファイル %s からメッセージを読み込めません';

  // MessageClient Strings
  RSMsgClientEncodingText = 'テキストをエンコードしています';
  RSMsgClientEncodingAttachment = '添付ファイルをエンコードしています';
  RSMsgClientInvalidEncoding = 'エンコーディングが無効です。UU では本文と添付ファイルのみ使用できます。';
  RSMsgClientInvalidForTransferEncoding = 'ContentTransferEncoding 値のあるメッセージではメッセージ パートを使用できません。';

  // NNTP Exceptions
  RSNNTPConnectionRefused = '接続が NNTP サーバーから明示的に拒否されました。';
  RSNNTPStringListNotInitialized = '文字列リストが初期化されていません!';
  RSNNTPNoOnNewsgroupList = 'OnNewsgroupList イベントが定義されていません。';
  RSNNTPNoOnNewGroupsList = 'OnNewGroupsList イベントが定義されていません。';
  RSNNTPNoOnNewNewsList = 'OnNewNewsList イベントが定義されていません。';
  RSNNTPNoOnXHDREntry = 'OnXHDREntry イベントが定義されていません。';
  RSNNTPNoOnXOVER = 'OnXOVER イベントが定義されていません。';

  // HTTP Status
  RSHTTPChunkStarted = 'チャンク開始';
  RSHTTPContinue = 'Continue (続行)';
  RSHTTPSwitchingProtocols = 'プロトコルを切り替えます';
  RSHTTPOK = 'OK';
  RSHTTPCreated = 'Created (作成)';
  RSHTTPAccepted = 'Accepted (受理)';
  RSHTTPNonAuthoritativeInformation = 'Non-authoritative Information (未承認の情報)';
  RSHTTPNoContent = 'No Content (内容なし)';
  RSHTTPResetContent = 'Reset Content (内容のリセット)';
  RSHTTPPartialContent = 'Partial Content (一部の内容)';
  RSHTTPMovedPermanently = 'Moved Permanently (恒久的に移動)';
  RSHTTPMovedTemporarily = 'Moved Temporarily (一時的に移動)';
  RSHTTPSeeOther = 'See Other (他を参照)';
  RSHTTPNotModified = 'Not Modified (未更新)';
  RSHTTPUseProxy = 'Use Proxy (プロキシが必要)';
  RSHTTPBadRequest = 'Bad Request (不正な要求)';
  RSHTTPUnauthorized = 'Unauthorized (認証が必要)';
  RSHTTPForbidden = 'Forbidden (アクセス禁止)';
  RSHTTPNotFound = 'Not Found (未検出)';
  RSHTTPMethodNotAllowed = 'Method not allowed (許可されていないメソッド)';
  RSHTTPNotAcceptable = 'Not Acceptable (受理不可)';
  RSHTTPProxyAuthenticationRequired = 'Proxy Authentication Required (プロキシ認証が必要)';
  RSHTTPRequestTimeout = 'Request Timeout (要求タイムアウト)';
  RSHTTPConflict = '競合';
  RSHTTPGone = 'Gone (消滅)';
  RSHTTPLengthRequired = 'Length Required (Length ヘッダが必要)';
  RSHTTPPreconditionFailed = 'Precondition Failed (前提条件エラー)';
  RSHTTPPreconditionRequired = '前提条件が必要です';
  RSHTTPTooManyRequests = '要求が多すぎます';
  RSHTTPRequestHeaderFieldsTooLarge = '要求ヘッダー フィールドが大きすぎます';
  RSHTTPNetworkAuthenticationRequired = 'ネットワーク認証が必要です';
  RSHTTPRequestEntityTooLong = '要求エンティティが長すぎる';
  RSHTTPRequestURITooLong = 'Request-URI Too Long (要求 URI が長すぎる)。最大 256 文字です。';
  RSHTTPUnsupportedMediaType = 'Unsupported Media Type (未サポートのメディア タイプ)';
  RSHTTPExpectationFailed = 'Expectation Failed (ヘッダーが不正)';
  RSHTTPInternalServerError = 'Internal Server Error (サーバー内部エラー)';
  RSHTTPNotImplemented = 'Not Implemented (未実装)';
  RSHTTPBadGateway = 'Bad Gateway (不正なゲートウェイ)';
  RSHTTPServiceUnavailable = 'Service Unavailable (サービス利用不可)';
  RSHTTPGatewayTimeout = 'Gateway timeout (ゲートウェイ タイムアウト)';
  RSHTTPHTTPVersionNotSupported = 'HTTP version not supported (未サポートの HTTP バージョン)';
  RSHTTPUnknownResponseCode = 'Unknown Response Code (不明な応答コード)';

  // HTTP Other
  RSHTTPUnknownProtocol = 'プロトコルが不明です';
  RSHTTPMethodRequiresVersion = '要求メソッドには HTTP バージョン 1.1 が必要です';
  RSHTTPHeaderAlreadyWritten = 'ヘッダーは書き込み済みです。';
  RSHTTPErrorParsingCommand = 'コマンドの解析時にエラーが発生しました。';
  RSHTTPUnsupportedAuthorisationScheme = '承認スキームがサポートされていません。';
  RSHTTPCannotSwitchSessionStateWhenActive = 'サーバーがアクティブであるときにセッション状態を変更できません。';
  RSHTTPCannotSwitchSessionListWhenActive = 'サーバーがアクティブであるときにセッション リストを変更できません。';

  //HTTP Authentication
  RSHTTPAuthAlreadyRegistered = 'この認証方式はすでにクラス名 %s で登録されています。';

  //HTTP Authentication Digeest
  RSHTTPAuthInvalidHash = 'サポートされていないハッシュ アルゴリズムです。この実装では MD5 エンコーディングのみサポートしています。';

  // HTTP Cookies
  RSHTTPUnknownCookieVersion = 'サポートされていないクッキー バージョンです: %d';

  //Block Cipher Intercept
  RSBlockIncorrectLength = '受信したブロックの長さ (%d) が正しくありません';

  // FTP
  RSFTPInvalidNumberArgs = '引数の数 %s は無効です';
  RSFTPHostNotFound = 'ホストが見つかりません。';
  RSFTPUnknownHost = '不明';
  RSFTPStatusReady = '接続が確立されました';
  RSFTPStatusStartTransfer = 'FTP 転送を開始します';
  RSFTPStatusDoneTransfer  = '転送が完了しました';
  RSFTPStatusAbortTransfer = '転送が中止されました';
  RSFTPProtocolMismatch = 'ネットワーク プロトコルが一致しません。次のものを使用してください:'; { may not include '(' or ')' }
  RSFTPParamError = '%s へのパラメータでエラーが発生しました';
  RSFTPParamNotImp = 'パラメータ %s は実装されていません';
  RSFTPInvalidPort = 'ポート番号が無効です';
  RSFTPInvalidIP = 'IP アドレスが無効です';
  RSFTPOnCustomFTPProxyReq = 'OnCustomFTPProxy が必要ですが、割り当てられていません';
  RSFTPDataConnAssuranceFailure = 'データ接続の保証確認に失敗しました。'#13#10'サーバーが通知した IP: %s  ポート: %d'#13#10'使用中のソケット IP: %s  ポート: %d';
  RSFTPProtocolNotSupported = 'プロトコルはサポートされていません。次のものを使用してください: '; { may not include '(' or ')' }
  RSFTPMustUseExtWithIPv6 = 'IPv6 接続の場合は、UseExtensionDataPort を true にする必要があります。';
  RSFTPMustUseExtWithNATFastTrack = 'NAT ファストトラッキングの場合は、UseExtensionDataPort を true にする必要があります。';
  RSFTPFTPPassiveMustBeTrueWithNATFT = 'NAT ファストトラッキングではアクティブ転送を使用できません。';
  RSFTPServerSentInvalidPort = 'サーバーが無効なポート番号 (%s) を送信しました';
  RSInvalidFTPListingFormat = 'FTP リスト形式が不明です';
  RSFTPNoSToSWithNATFastTrack = 'FTP NAT ファストトラック接続ではサイト間転送は許可されていません。';
  RSFTPSToSNoDataProtection = 'サイト間転送ではデータ保護を使用できません。';
  RSFTPSToSProtosMustBeSame = '転送プロトコルが同じでなければなりません。';
  RSFTPSToSSSCNNotSupported = 'SSCN は、どちらのサーバーでもサポートされていません。';
  RSFTPNoDataPortProtectionAfterCCC = 'CCC の発行後は DataPortProtection を設定できません。';
  RSFTPNoDataPortProtectionWOEncryption = '暗号化されていない接続では DataPortProtection を設定できません。';
  RSFTPNoCCCWOEncryption = '暗号化を使用しない場合は CCC を設定できません。';
  RSFTPNoAUTHWOSSL = 'SSL を使用しない場合は AUTH を設定できません。';
  RSFTPNoAUTHCon = '接続中は AUTH を設定できません。';
  RSFTPSToSTransferModesMusbtSame = '転送モードが同じでなければなりません。';
  RSFTPNoListParseUnitsRegistered = 'FTP リスト パーサーが登録されていません。';
  RSFTPMissingCompressor = '圧縮モジュールが割り当てられていません。';
  RSFTPCompressorNotReady = '圧縮モジュールの用意ができていません。';
  RSFTPUnsupportedTransferMode = 'サポートされていない転送モードです。';
  RSFTPUnsupportedTransferType = 'サポートされていない転送タイプです。';

  // Property editor exceptions
  // Stack Error Messages

  RSCMDNotRecognized = 'コマンドが認識されませんでした';

  RSGopherNotGopherPlus = '%s は Gopher+ サーバーではありません';

  RSCodeNoError     = 'RCode: エラーなし';
  RSCodeQueryServer = 'DNS サーバーはクエリ サーバー エラーを通知します';
  RSCodeQueryFormat = 'DNS サーバーはクエリ形式エラーを通知します';
  RSCodeQueryName   = 'DNS サーバーはクエリ名エラーを通知します';
  RSCodeQueryNotImplemented = 'DNS サーバーはクエリ未実装エラーを通知します';
  RSCodeQueryQueryRefused = 'DNS サーバーはクエリ拒否エラーを通知します';
  RSCodeQueryUnknownError = 'サーバーが不明なエラーを返しました';

  RSDNSTimeout = 'TimedOut';
  RSDNSMFIsObsolete = 'MF は使用されなくなったコマンドです。MX を使用してください。';
  RSDNSMDISObsolete = 'MD は使用されなくなったコマンドです。MX を使用してください。';
  RSDNSMailAObsolete = 'MailA は使用されなくなったコマンドです。MX を使用してください。';
  RSDNSMailBNotImplemented = '-Err 501 MailB が実装されていません';

  RSQueryInvalidQueryCount = 'クエリ カウント (%d) は無効です';
  RSQueryInvalidPacketSize = 'パケット サイズ (%d) は無効です ';
  RSQueryLessThanFour = '受信したパケットが小さすぎます。4 バイト未満です: %d';
  RSQueryInvalidHeaderID = 'ヘッダー ID (%d) は無効です';
  RSQueryLessThanTwelve = '受信したパケットが小さすぎます。12 バイト未満です: %d';
  RSQueryPackReceivedTooSmall = '受信したパケットが小さすぎます: %d';
  RSQueryUnknownError = '不明なエラーです %d、ID %d';
  RSQueryInvalidIpV6 = '無効な IPv6 アドレスです: %s';
  RSQueryMustProvideSOARecord = 'IXFR に移行するには、TIdRR_SOA オブジェクトに Serial Number と名前を付ける必要があります。%d';
 
  { LPD Client Logging event strings }
  RSLPDDataFileSaved = 'データ ファイルを %s に保存しました';
  RSLPDControlFileSaved = '制御ファイルを %s に保存しました';
  RSLPDDirectoryDoesNotExist = 'ディレクトリ %s が存在しません';
  RSLPDServerStartTitle = 'Winshoes LPD サーバー %s ';
  RSLPDServerActive = 'サーバーのステータス: 稼働中';
  RSLPDQueueStatus  = 'キュー %s のステータス: %s';
  RSLPDClosingConnection = '接続を閉じています';
  RSLPDUnknownQueue = '%s は不明なキューです';
  RSLPDConnectTo = '%s に接続しました';
  RSLPDAbortJob = 'ジョブを中止します';
  RSLPDReceiveControlFile = '制御ファイルを受信します';
  RSLPDReceiveDataFile = 'データ ファイルを受信します';

  { LPD Exception Messages }
  RSLPDNoQueuesDefined = 'エラー: キューが定義されていません';

  { Trivial FTP Exception Messages }
  RSTimeOut = 'タイムアウト';
  RSTFTPUnexpectedOp = '%s:%d からの予期しない操作です';
  RSTFTPUnsupportedTrxMode = 'サポートしていない転送モードです: "%s"';
  RSTFTPDiskFull = '書き込み要求を完了できません。処理の進行は %d バイトで停止しました';
  RSTFTPFileNotFound = '%s を開けません';
  RSTFTPAccessDenied = '%s へのアクセスが拒否されました';
  RSTFTPUnsupportedOption = 'サポートされていないオプション: "%s"';
  RSTFTPUnsupportedOptionValue = '"%s" はオプション "%s" の値としてサポートされていません';

  { MESSAGE Exception messages }
  RSTIdTextInvalidCount = 'テキスト カウントが無効です。複数の TIdText オブジェクトが必要です。';
  RSTIdMessagePartCreate = 'TIdMessagePart を作成できません。下位クラスを使用してください。 ';
  RSTIdMessageErrorSavingAttachment = '添付ファイルの保存時にエラーが発生しました。';
  RSTIdMessageErrorAttachmentBlocked = '添付ファイル %s はブロックされています。';

  { POP Exception Messages }
  RSPOP3FieldNotSpecified = ' 未指定';
  RSPOP3UnrecognizedPOP3ResponseHeader = '認識できない POP3 応答ヘッダーです: '#10'"%s"'; //APR: user will see Server response    {Do not Localize}
  RSPOP3ServerDoNotSupportAPOP = 'サーバーは APOP (タイムスタンプなし) をサポートしていません';//APR    {Do not Localize}

  { IdIMAP4 Exception Messages }
  RSIMAP4ConnectionStateError = 'コマンドを実行できません。接続状態が不適切です。現在の接続状態: %s。';
  RSUnrecognizedIMAP4ResponseHeader = '認識できない IMAP4 応答ヘッダーです。';
  RSIMAP4NumberInvalid = '数値パラメータ (メッセージの相対番号や UID) が無効です。1 以上でなければなりません。';
  RSIMAP4NumberInvalidString = '数値パラメータ (メッセージの相対番号や UID) が無効です。空文字列を含むことはできません。';
  RSIMAP4NumberInvalidDigits = '数値パラメータ (メッセージの相対番号や UID) が無効です。数字以外の文字を含むことはできません。';
  RSIMAP4DisconnectedProbablyIdledOut = 'サーバーが接続を正常に解除しました。おそらく接続が長時間使用されていなかったためです。';

  { IdIMAP4 UTF encoding error strings}
  RSIMAP4UTFIllegalChar = 'UTF7 シーケンスに無効な文字 #%d が含まれています。';

  RSIMAP4UTFIllegalBitShifting = 'MUTF7 文字列で無効なビット シフトが行われました';
  RSIMAP4UTFUSASCIIInUTF = 'UTF7 シーケンスに US-ASCII 文字 #%d が含まれています。';
  { IdIMAP4 Connection State strings }
  RSIMAP4ConnectionStateAny = '任意';
  RSIMAP4ConnectionStateNonAuthenticated = '未認証';
  RSIMAP4ConnectionStateAuthenticated = '認証済み';
  RSIMAP4ConnectionStateSelected = '選択済み';
  RSIMAP4ConnectionStateUnexpectedlyDisconnected = '接続が予期せず解除されました';

  { Telnet Server }
  RSTELNETSRVUsernamePrompt = 'ユーザー名: ';
  RSTELNETSRVPasswordPrompt = 'パスワード: ';
  RSTELNETSRVInvalidLogin = 'ログインが無効です。';
  RSTELNETSRVMaxloginAttempt = 'ログイン試行回数の上限を超えました。終了します。';
  RSTELNETSRVNoAuthHandler = '認証ハンドラが指定されていません。';
  RSTELNETSRVWelcomeString = 'Indy Telnet サーバー';
  RSTELNETSRVOnDataAvailableIsNil = 'OnDataAvailable イベントが nil です。';

  { Telnet Client }
  RSTELNETCLIConnectError = 'サーバーが応答していません';
  RSTELNETCLIReadError = 'サーバーが応答しませんでした。';

  { Network Calculator }
  RSNETCALInvalidIPString     = '文字列 %s は有効な IP に変換されません。';
  RSNETCALCInvalidNetworkMask = 'ネットワーク マスクが無効です。';
  RSNETCALCInvalidValueLength = '値の長さが無効です: 32 でなければなりません。';
  RSNETCALConfirmLongIPList = '設計時に表示される指定範囲 (%d) 内の IP アドレスが多すぎます。';
  { IdentClient}
  RSIdentReplyTimeout = '応答がタイムアウト:  サーバーが応答を返さず、クエリは破棄されました';
  RSIdentInvalidPort = 'ポートが無効:  外部ポートまたはローカル ポートが正しく指定されていないか無効です';
  RSIdentNoUser = 'ユーザーなし:  ポート ペアが使用されていないか、識別可能なユーザーによって使用されていません';
  RSIdentHiddenUser = 'ユーザーが非表示:  ユーザーの要請により情報が返されませんでした';
  RSIdentUnknownError = '不明なエラーまたはその他のエラー:  所有者を決定できない、またはエラーを明らかにすることができません。';

  {Standard dialog stock strings}
  {}

  { Tunnel messages }
  RSTunnelGetByteRange = 'インデックス <> [0..%d] での %s.GetByte [プロパティ Bytes] への呼び出し';
  RSTunnelTransformErrorBS = '送信前の変換でエラーが発生しました';
  RSTunnelTransformError = '変換に失敗しました';
  RSTunnelCRCFailed = 'CRC が失敗しました';
  RSTunnelConnectMsg = '接続中';
  RSTunnelDisconnectMsg = '接続解除';
  RSTunnelConnectToMasterFailed = 'マスタ サーバーに接続できません';
  RSTunnelDontAllowConnections = '今は接続できません';
  RSTunnelMessageTypeError = 'メッセージ タイプの認識エラーです';
  RSTunnelMessageHandlingError = 'メッセージ処理に失敗しました';
  RSTunnelMessageInterpretError = 'メッセージの解釈に失敗しました';
  RSTunnelMessageCustomInterpretError = 'カスタム メッセージ解釈が失敗しました';

  { Socks messages }

  { FTP }
  RSDestinationFileAlreadyExists = 'ターゲット ファイルは既に存在します。';

  { SSL messages }
  RSSSLAcceptError = 'SSL 接続を受け入れる際にエラーが発生しました。';
  RSSSLConnectError = 'SSL で接続する際にエラーが発生しました。';
  RSSSLSettingCipherError = 'SetCipher が失敗しました。';
  RSSSLCreatingSessionError = 'SSL セッションの作成時にエラーが発生しました。';
  RSSSLCreatingContextError = 'SSL コンテキストの作成時にエラーが発生しました。';
  RSSSLLoadingRootCertError = 'ルート証明書を読み込めませんでした。';
  RSSSLLoadingCertError = '証明書を読み込めませんでした。';
  RSSSLLoadingKeyError = 'キーを読み込めませんでした。パスワードを確認してください。';
  RSSSLLoadingDHParamsError = 'DH パラメータを読み込めません。';
  RSSSLGetMethodError = 'SSL メソッドの取得でエラーが発生しました。';
  RSSSLFDSetError = 'SSL のファイル記述子を設定する際にエラーが発生しました';
  RSSSLDataBindingError = 'データを SSL ソケットにバインドする際にエラーが発生しました。';
  RSSSLEOFViolation = 'プロトコルに違反する EOF が検出されました';

  {IdMessage Component Editor}
  RSMsgCmpEdtrNew = 'メッセージ パートの新規作成(&N)...';
  RSMsgCmpEdtrExtraHead = 'エキストラ ヘッダー テキスト エディタ';
  RSMsgCmpEdtrBodyText = '本文テキスト エディタ';

  {IdNNTPServer}
  RSNNTPServerNotRecognized = 'コマンドが認識されませんでした';
  RSNNTPServerGoodBye = '終了';
  RSNNTPSvrImplicitTLSRequiresSSL = '暗黙の NNTP では、IOHandler を TIdSSLIOHandlerSocketBase に設定する必要があります。';
  RSNNTPRetreivedArticleFollows = ' 記事を取得しました - この後にヘッダと本文が表示されます';
  RSNNTPRetreivedBodyFollows = ' 記事を取得しました - この後に本文を表示します';
  RSNNTPRetreivedHeaderFollows =  ' 記事を取得しました - この後にヘッダを表示します';
  RSNNTPRetreivedAStaticstsOnly = ' 記事を取得しました - 統計情報のみ表示します';
  RSNTTPNewsToMeSendArticle = '記事を投稿してください!  末尾に <CRLF>.<CRLF> を付けてください。';
  RSNTTPArticleRetrievedRequestTextSeparately = ' 記事を取得しました - テキストを個別に要求してください';
  RSNTTPNotInNewsgroup = '現在ニュースグループに入っていません';
  RSNNTPExtSupported = 'サポートされている拡張機能:';
  
  //IdNNTPServer reply messages
  RSNTTPReplyHelpTextFollows = 'この後にヘルプ テキストが表示されます';
  RSNTTPReplyDebugOutput =  'デバッグ出力';
   
  RSNNTPReplySvrReadyPostingAllowed =  'サーバー準備完了 - 投稿できます';
  RSNNTPReplySvrReadyNoPostingAllowed =  'サーバー準備完了 - 投稿できません';
  RSNNTPReplySlaveStatus =  'スレーブのステータスを記録しました';
  RSNNTPReplyClosingGoodby = '接続を閉じています - 終了!';
  RSNNTPReplyNewsgroupsFollow = 'ニュースグループのリストがこの後に表示されます';
  RSNNTPReplyHeadersFollow =  'この後にヘッダーが表示されます';
  RSNNTPReplyOverViewInfoFollows =  'この後に概要情報が表示されます';
  RSNNTPReplyNewNewsgroupsFollow =  '新規ニュースグループのリストがこの後に表示されます';
  RSNNTPReplyArticleTransferedOk =  '記事が正常に転送されました';
  RSNNTPReplyArticlePostedOk =  '記事が正常に投稿されました';
  RSNNTPReplyAuthAccepted = '認証が受理されました';

  RSNNTPReplySendArtTransfer = '転送する記事を送信してください。末尾には <CR-LF>.<CR-LF> を付けてください ';
  RSNNTPReplySendArtPost =  '投稿する記事を送信してください。末尾には <CR-LF>.<CR-LF> を付けてください ';
  RSNNTPReplyMoreAuthRequired = 'さらに認証情報が必要です';
  RSNNTPReplyContinueTLSNegot = 'TLS ネゴシエーションを続行します';

  RSNNTPReplyServiceDiscont =  'サービスは停止されました';
  RSNNTPReplyTLSTempUnavail =  'TLS が一時的に利用できません';
  RSNNTPReplyNoSuchNewsgroup =  'そのようなニュースグループはありません';
  RSNNTPReplyNoNewsgroupSel =  'ニュースグループは選択されていません';
  RSNNTPReplyNoArticleSel =  '現在選択されている記事はありません';
  RSNNTPReplyNoNextArt =  'このグループに次の記事はありません';
  RSNNTPReplyNoPrevArt =  'このグループに前の記事はありません';
  RSNNTPReplyNoArtNumber =  'このグループにそのような記事番号はありません';
  RSNNTPReplyNoArtFound =  'そのような記事は見つかりません';
  RSNNTPReplyArtNotWanted =  '記事は不要です - 送信しないでください';
  RSNNTPReplyTransferFailed =  '転送に失敗しました - 後でやり直してください';
  RSNNTPReplyArtRejected =  '記事が却下されました - 再度試みないでください';
  RSNNTPReplyNoPosting =  '投稿はできません';
  RSNNTPReplyPostingFailed =  '投稿に失敗しました';
  RSNNTPReplyAuthorizationRequired =  'このコマンドには権限が必要です';
  RSNNTPReplyAuthorizationRejected = '権限付与が拒否されました';
  RSNNTPReplyAuthRejected =  '認証が必要です';
  RSNNTPReplyStrongEncryptionRequired =  '強度の高い暗号化レイヤが必要です';

  RSNNTPReplyCommandNotRec =  'コマンドが認識されませんでした';
  RSNNTPReplyCommandSyntax =  'コマンド構文エラー';
  RSNNTPReplyPermDenied =  'アクセスが制限または拒否されました';
  RSNNTPReplyProgramFault = 'プログラムの障害 - コマンドが実行されません';
  RSNNTPReplySecAlreadyActive =  'セキュリティ レイヤは既に稼働しています';

  {IdGopherServer}
  RSGopherServerNoProgramCode = 'エラー: 要求を返すプログラム コードがありません!';

  {IdSyslog}
  RSInvalidSyslogPRI = 'syslog メッセージが無効です: PRI セクションが間違っています';
  RSInvalidSyslogPRINumber = 'syslog メッセージが無効です: PRI 番号 "%s" が間違っています';
  RSInvalidSyslogTimeStamp = 'syslog メッセージが無効です: タイムスタンプ "%s" が間違っています';
  RSInvalidSyslogPacketSize = 'syslog メッセージが無効です: パケットが大きすぎます (%d バイト)';
  RSInvalidHostName = 'ホスト名が無効です。SYSLOG ホスト名にはスペース ("%s")+ を含めることはできません';

  {IdWinsockStack}
  RSWSockStack = 'Winsock スタック';

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
  RSPOP3SvrImplicitTLSRequiresSSL = '暗黙の POP3 では、IOHandler を TIdServerIOHandlerSSL に設定する必要があります。';
  RSPOP3SvrMustUseSTLS = 'STLS を使用する必要があります';
  RSPOP3SvrNotHandled = 'コマンドが処理されません: %s';
  RSPOP3SvrNotPermittedWithTLS = 'TLS が有効なとき、コマンドは使用できません';
  RSPOP3SvrNotInThisState = 'この状態ではコマンドは使用できません';
  RSPOP3SvrBeginTLSNegotiation = 'TLS ネゴシエーションを開始します';
  RSPOP3SvrLoginFirst = 'まず、ログインしてください';
  RSPOP3SvrInvalidSyntax = '構文が無効です';
  RSPOP3SvrClosingConnection = '接続チャネルを閉じています。';
  RSPOP3SvrPasswordRequired = 'パスワードが必要です';
  RSPOP3SvrLoginFailed = 'ログインに失敗しました';
  RSPOP3SvrLoginOk = 'ログイン OK';
  RSPOP3SvrWrongState = '状態が不適切です';
  RSPOP3SvrInvalidMsgNo = 'メッセージ番号が無効です';
  RSPOP3SvrNoOp = 'NOOP';
  RSPOP3SvrReset = 'リセット';
  RSPOP3SvrCapaList = 'この後に機能一覧が表示されます';
  RSPOP3SvrWelcome = 'Indy POP3 サーバーへようこそ';
  RSPOP3SvrUnknownCmd = '申し訳ありません。不明なコマンドです';
  RSPOP3SvrUnknownCmdFmt = '申し訳ありません。不明なコマンドです: %s';
  RSPOP3SvrInternalError = '不明な内部エラーです';
  RSPOP3SvrHelpFollows = 'この後にヘルプが表示されます';
  RSPOP3SvrTooManyCons = '接続が多すぎます。後でやり直してください。';
  RSPOP3SvrWelcomeAPOP = 'ようこそ ';

  // TIdCoder3to4
  RSUnevenSizeInDecodeStream = 'DecodeToStream 内の不均一なサイズ。';
  RSUnevenSizeInEncodeStream = 'Encode 内の不均一なサイズ。';
  RSIllegalCharInInputString = '入力文字列に無効な文字が含まれています。';

  // TIdMessageCoder
  RSMessageDecoderNotFound = 'メッセージ デコーダが見つかりません';
  RSMessageEncoderNotFound = 'メッセージ エンコーダが見つかりません';

  // TIdMessageCoderMIME
  RSMessageCoderMIMEUnrecognizedContentTrasnferEncoding = 'コンテンツの転送エンコーディングが認識できません。';

  // TIdMessageCoderUUE
  RSUnrecognizedUUEEncodingScheme = '認識できない UUE エンコーディング スキームです。';

  { IdFTPServer }
  RSFTPDefaultGreeting = 'Indy FTP サーバーの準備が完了しました。';
  RSFTPOpenDataConn = 'データ接続が既に開いています。転送を開始します。';
  RSFTPDataConnToOpen = 'ファイル ステータス OK、データ接続を開こうとしています。';
  RSFTPDataConnList = '/bin/ls 用に ASCII モード データ接続を開いています。';
  RSFTPDataConnNList = 'ファイル一覧用に ASCII モード データ接続を開いています。';
  RSFTPDataConnMLst = 'ディレクトリ一覧用に ASCII データ接続を開いています。';
  RSFTPCmdSuccessful = '%s コマンドが正常終了しました。';
  RSFTPServiceOpen = 'サービスは新規ユーザーに対応する準備ができました。';
  RSFTPServerClosed = 'サービスは制御接続を閉じます。';
  RSFTPDataConn = 'データ接続が開いています。転送は行われていません。';
  RSFTPDataConnClosed = 'データ接続を閉じています。';
  RSFTPDataConnEPLFClosed = '成功。';
  RSFTPDataConnClosedAbnormally = 'データ接続が異常終了しました。';
  RSFTPPassiveMode = 'パッシブ モードに入ります (%s)。';
  RSFTPUserLogged = 'ユーザーがログインしました。続行します。';
  RSFTPAnonymousUserLogged = '匿名ユーザーがログインしました。続行してください。';
  RSFTPFileActionCompleted = '要求されたファイル アクションは正常に完了しました。';
  RSFTPDirFileCreated = '"%s" が作成されました。';
  RSFTPUserOkay = 'ユーザー名は問題なし。パスワードが必要です。';
  RSFTPAnonymousUserOkay = '匿名ログイン OK。電子メール アドレスをパスワードとして送信してください。';
  RSFTPNeedLoginWithUser = 'まず USER でログインしてください。';
  RSFTPNotAfterAuthentication = '既にログインしていますが、まだ権限が付与されていません。';
  RSFTPFileActionPending = '要求されたファイル アクションにはさらに情報が必要です。';
  RSFTPServiceNotAvailable = 'サービスは利用できません。制御接続を閉じます。';
  RSFTPCantOpenDataConn = 'データ接続を開けません。';
  RSFTPFileActionNotTaken = '要求されたファイル アクションは実行されませんでした。';
  RSFTPFileActionAborted = '要求されたアクションは中止されました: 処理中にローカル エラーが発生しました。';
  RSFTPEnteringEPSV = '拡張パッシブ モードに入ります (%s)';
  RSFTPClosingConnection = 'サービスは利用できません。制御接続を閉じます。';
  RSFTPPORTDisabled = 'PORT/EPRT コマンドは無効です。';
  RSFTPPORTRange    = '予約ポート範囲 (1-1024) では PORT/EPRT コマンドは無効です。';
  RSFTPSameIPAddress = 'データ ポートは制御接続で使用されるのと同じ IP アドレスでのみ使用できます。';
  RSFTPCantOpenData = 'データ接続を開けません。';
  RSFTPEPSVAllEntered = ' EPSV ALL を送信しました。これで EPSV 接続のみ受け入れます。';
  RSFTPNetProtNotSup = 'ネットワーク プロトコルがサポートされていません。%s を使用してください';
  RSFTPFileOpSuccess = 'ファイル操作は正常終了しました';
  RSFTPIsAFile = '%s: ファイルです。';
  RSFTPInvalidOps = '%s オプションが無効です';
  RSFTPOptNotRecog = 'オプションが認識されませんでした。';
  RSFTPPropNotNeg = 'プロパティは負の数値以外でなければなりません。';
  RSFTPClntNoted = '了解。';
  RSFTPQuitGoodby = '終了。';
  RSFTPPASVBoundPortMaxMustBeGreater = 'PASVBoundPortMax は PASVBoundPortMax よりも大きくなければなりません。';
  RSFTPPASVBoundPortMinMustBeLess = 'PASVBoundPortMin は PASVBoundPortMax よりも小さくなければなりません。';
  RSFTPRequestedActionNotTaken = '要求されたアクションは実行されませんでした。';
  RSFTPCmdNotRecognized = #39'%s'#39': 不明なコマンドです。';
  RSFTPCmdNotImplemented = '"%s" コマンドは実装されていません。';
  RSFTPCmdHelpNotKnown = '%s は不明なコマンドです。';
  RSFTPUserNotLoggedIn = 'ログインしていません。';
  RSFTPActionNotTaken = '要求されたアクションは実行されませんでした。';
  RSFTPActionAborted = '要求されたアクションは中止されました: ページ タイプが不明です。';
  RSFTPRequestedFileActionAborted = '要求されたファイル アクションは中止されました。';
  RSFTPRequestedFileActionNotTaken = '要求されたアクションは実行されませんでした。';
  RSFTPMaxConnections = '接続の最大限度を超えました。後でやり直してください。';
  RSFTPDataConnToOpenStou = '%s 用のデータ接続を開こうとしています';
  RSFTPNeedAccountForLogin = 'ログインするにはアカウントが必要です。';
  RSFTPAuthSSL = 'AUTH コマンド OK。SSL を初期化しています';
  RSFTPDataProtBuffer0 = 'PBSZ コマンド OK。保護バッファ サイズが 0 に設定されました。';

  RSFTPInvalidProtTypeForMechanism = '要求された PROT レベルはメカニズムではサポートされていません。';
  RSFTPProtTypeClear   = 'PROT コマンド OK。クリア データ接続を使用します';
  RSFTPProtTypePrivate = 'PROT コマンド OK。プライベート データ接続を使用します';
  RSFTPClearCommandConnection = 'コマンド チャネルがクリアテキストに切り替わりました。';
  RSFTPClearCommandNotPermitted = 'クリア コマンド チャネルは許可されていません。';
  RSFTPPBSZAuthDataRequired = 'AUTH データが必要です。';
  RSFTPPBSZNotAfterCCC = 'CCC の実行後は使用できません';
  RSFTPPROTProtBufRequired = 'PBSZ データ バッファ サイズが必要です。';
  RSFTPInvalidForParam = 'コマンドはそのパラメータについては実装されていません。';
  RSFTPNotAllowedAfterEPSVAll = 'EPSV ALL の実行後は %s を使用できません';

  RSFTPOTPMethod = '不明な OTP メソッドです';
  RSFTPIOHandlerWrong = 'IOHandler の型が間違っています。';
  RSFTPFileNameCanNotBeEmpty = 'ターゲット ファイル名は必須です';

  //Note to translators, it may be best to leave the stuff in quotes as the very first
  //part of any phrase otherwise, a FTP client might get confused.
  RSFTPCurrentDirectoryIs = '"%s" が作業ディレクトリです。';
  RSFTPTYPEChanged = 'タイプが %s に設定されました。';
  RSFTPMODEChanged = 'モードが %s に設定されました。';
  RSFTPMODENotSupported = '未実装モード。';
  RSFTPSTRUChanged = '構造が %s に設定されました。';
  RSFTPSITECmdsSupported = 'サポートされている文は次のとおりです。';
  RSFTPDirectorySTRU = '%s のディレクトリ構造。';
  RSFTPCmdStartOfStat = 'システム ステータス';
  RSFTPCmdEndOfStat = 'ステータスの終わり';
  RSFTPCmdExtsSupportedStart = 'サポートされている拡張機能:';
  RSFTPCmdExtsSupportedEnd = '拡張機能の終わり。';
  RSFTPNoOnDirEvent = 'OnListDirectory イベントが見つかりません!';
  RSFTPImplicitTLSRequiresSSL = '暗黙の FTP では、IOHandler を TIdServerIOHandlerSSL に設定する必要があります。';

  //%s number of attributes changes
  RSFTPSiteATTRIBMsg = 'site attrib';
  RSFTPSiteATTRIBInvalid = ' 失敗。属性が無効です。';
  RSFTPSiteATTRIBDone = ' 完了。すべての %s 属性が変更されました。';
  //%s is the umask number
  RSFTPUMaskIs = '現在の UMASK は %.3d です';
  //first %d is the new value, second one is the old value
  RSFTPUMaskSet = 'UMASK が %.3d に設定されました (前の値は %.3d)';
  RSFTPPermissionDenied = 'アクセスが拒否されました。';
  RSFTPCHMODSuccessful = 'CHMOD コマンドが正常終了しました。';
  RSFTPHelpBegining = '以下のコマンドが認識されます (* => 未実装、+ => 拡張機能)。';
  //toggles for DIRSTYLE SITE command in IIS
  RSFTPOn = 'オン';
  RSFTPOff = 'オフ';
  RSFTPDirStyle = 'MSDOS 的なディレクトリ出力は %s です';

  {SYSLog Message}
  // facility
  STR_SYSLOG_FACILITY_KERNEL     = 'カーネル メッセージ';
  STR_SYSLOG_FACILITY_USER       = 'ユーザーレベル メッセージ';
  STR_SYSLOG_FACILITY_MAIL       = 'メール システム';
  STR_SYSLOG_FACILITY_SYS_DAEMON = 'システム デーモン';
  STR_SYSLOG_FACILITY_SECURITY1  = 'セキュリティ/権限付与メッセージ (1)';
  STR_SYSLOG_FACILITY_INTERNAL   = 'syslogd によって内部で生成されたメッセージ';
  STR_SYSLOG_FACILITY_LPR        = 'ライン プリンタ サブシステム';
  STR_SYSLOG_FACILITY_NNTP       = 'ネットワーク ニュース サブシステム';
  STR_SYSLOG_FACILITY_UUCP       = 'UUCP サブシステム';
  STR_SYSLOG_FACILITY_CLOCK1     = 'クロック デーモン (1)';
  STR_SYSLOG_FACILITY_SECURITY2  = 'セキュリティ/権限付与メッセージ (2)';
  STR_SYSLOG_FACILITY_FTP        = 'FTP デーモン';
  STR_SYSLOG_FACILITY_NTP        = 'NTP サブシステム';
  STR_SYSLOG_FACILITY_AUDIT      = '監査ログ';
  STR_SYSLOG_FACILITY_ALERT      = '警告ログ';
  STR_SYSLOG_FACILITY_CLOCK2     = 'クロック デーモン (2)';
  STR_SYSLOG_FACILITY_LOCAL0     = 'ローカル使用 0  (local0)';
  STR_SYSLOG_FACILITY_LOCAL1     = 'ローカル使用 1  (local1)';
  STR_SYSLOG_FACILITY_LOCAL2     = 'ローカル使用 2  (local2)';
  STR_SYSLOG_FACILITY_LOCAL3     = 'ローカル使用 3  (local3)';
  STR_SYSLOG_FACILITY_LOCAL4     = 'ローカル使用 4  (local4)';
  STR_SYSLOG_FACILITY_LOCAL5     = 'ローカル使用 5  (local5)';
  STR_SYSLOG_FACILITY_LOCAL6     = 'ローカル使用 6  (local6)';
  STR_SYSLOG_FACILITY_LOCAL7     = 'ローカル使用 7  (local7)';
  STR_SYSLOG_FACILITY_UNKNOWN    = '不明または無効な機能コード';

  // Severity
  STR_SYSLOG_SEVERITY_EMERGENCY     = '緊急: システムが使用できない';
  STR_SYSLOG_SEVERITY_ALERT         = '警告: 直ちに対策を講じる必要があります';
  STR_SYSLOG_SEVERITY_CRITICAL      = '重大: 重大な状況';
  STR_SYSLOG_SEVERITY_ERROR         = 'エラー: エラー状況';
  STR_SYSLOG_SEVERITY_WARNING       = '警告: 警告に当たる状況';
  STR_SYSLOG_SEVERITY_NOTICE        = '注意: 通常の範囲内ではあるが重要な状況';
  STR_SYSLOG_SEVERITY_INFORMATIONAL = '情報: 情報提供メッセージ';
  STR_SYSLOG_SEVERITY_DEBUG         = 'デバッグ: デバッグレベル メッセージ';
  STR_SYSLOG_SEVERITY_UNKNOWN       = '不明または無効なセキュリティ コード';

  {LPR Messages}
  RSLPRError = 'ジョブ ID %s に関する応答 %d';
  RSLPRUnknown = '不明';
  RSCannotBindRange = '%d から %d の範囲を LPR ポートにバインドできません (未使用ポートがありません)';

  {IRC Messages}
  RSIRCCanNotConnect = 'IRC 接続に失敗しました';
  // RSIRCNotConnected = 'Not connected to server.';
  // RSIRCClientVersion =  'TIdIRC 1.061 by Steve Williams';
  // RSIRCClientInfo = '%s Non-visual component for 32-bit Delphi.';
  // RSIRCNick = 'Nick';
  // RSIRCAltNick = 'OtherNick';
  // RSIRCUserName = 'ircuser';
  // RSIRCRealName = 'Real name';
  // RSIRCTimeIsNow = 'Local time is %s'; // difficult to strip for clients

  {HL7 Lower Layer Protocol Messages}
  RSHL7StatusStopped           = '停止';
  RSHL7StatusNotConnected      = '未接続';
  RSHL7StatusFailedToStart     = '開始できませんでした: %s';
  RSHL7StatusFailedToStop      = '停止できませんでした: %s';
  RSHL7StatusConnected         = '接続済み';
  RSHL7StatusConnecting        = '接続中';
  RSHL7StatusReConnect         = '%s で再接続: %s';
  RSHL7NotWhileWorking         = 'HL7 コンポーネントが動作している間は %s を設定できません';
  RSHL7NotWorking              = 'HL7 コンポーネントが動作していないときに %s を試みてください';
  RSHL7NotFailedToStop         = '停止できないため、インターフェイスを使用できません';
  RSHL7AlreadyStarted          = 'インターフェイスは既に開始されました';
  RSHL7AlreadyStopped          = 'インターフェイスは既に停止されました';
  RSHL7ModeNotSet              = 'モードが初期化されていません';
  RSHL7NoAsynEvent             = 'コンポーネントは非同期モードになっていますが、OnMessageArrive がフックされていません';
  RSHL7NoSynEvent              = 'コンポーネントは同期モードになっていますが、OnMessageReceive がフックされていません';
  RSHL7InvalidPort             = '割り当てられたポート値 %d は無効です';
  RSHL7ImpossibleMessage       = 'メッセージを受信しましたが、通信モードが不明です';
  RSHL7UnexpectedMessage       = 'リスンしていないインターフェイスに予期しないメッセージが着信しました';
  RSHL7UnknownMode             = 'モードが不明';
  RSHL7ClientThreadNotStopped  = 'クライアント スレッドを停止できません';
  RSHL7SendMessage             = 'メッセージの送信';
  RSHL7NoConnectionFound       = 'メッセージ送信時にサーバー接続が見つかりません';
  RSHL7WaitForAnswer           = 'まだ応答を待っている間はメッセージを送信できません';
  //TIdHL7 error messages
  RSHL7ErrInternalsrNone       =  'IdHL7.pas で内部エラーが発生: SynchronousSend が srNone を返しました';
  RSHL7ErrNotConn              =   '接続していません';
  RSHL7ErrInternalsrSent       =  'IdHL7.pas で内部エラーが発生: SynchronousSend が srSent を返しました';
  RSHL7ErrNoResponse           =  'リモート システムから応答がありません';
  RSHL7ErrInternalUnknownVal   =  'IdHL7.pas で内部エラーが発生: SynchronousSend が不明な値を返しました   ';
  RSHL7Broken                  = '今のところ Indy 10 では IdHL7 は機能しません';

  { TIdMultipartFormDataStream exceptions }
  RSMFDInvalidObjectType        = 'サポートされていないオブジェクト型です。TStrings と TStream のどちらか一方またはその下位クラスのみ割り当てることができます。';
  RSMFDInvalidTransfer          = 'サポートされていない転送タイプです。設定できるのは空文字列か、7bit、8bit、binary、quoted-printable、base64 のいずれかの値のみです。';
  RSMFDInvalidEncoding          = 'サポートされていないエンコードです。設定できるのは Q、B、8 のいずれかの値のみです。';

  { TIdURI exceptions }
  RSURINoProto                 = 'プロトコル フィールドが空です';
  RSURINoHost                  = 'ホスト フィールドが空です';

  { TIdIOHandlerThrottle}
  RSIHTChainedNotAssigned      = 'このコンポーネントを別の I/O ハンドラにつないでから使用する必要があります';

  { TIdSNPP}
  RSSNPPNoMultiLine            = 'TIdSNPP Mess コマンドは 1 行だけのメッセージのみサポートしています。';

  {TIdThread}
  RSUnassignedUserPassProv     = 'UserPassProvider が割り当てられていません!';

  {TIdDirectSMTP}
  RSDirSMTPInvalidEMailAddress = '電子メール アドレス %s は無効です';
  RSDirSMTPNoMXRecordsForDomain = 'ドメイン %s の MX レコードがありません';
  RSDirSMTPCantConnectToSMTPSvr = 'アドレス %s の MX サーバーに接続できません';
  RSDirSMTPCantAssignHost       = 'Host プロパティを割り当てることができません。IdDirectSMTP によりその場で解決されます。';

  {TIdMessageCoderYenc}
  RSYencFileCorrupted           = 'ファイルが破損しています。';
  RSYencInvalidSize             = 'サイズが無効です';
  RSYencInvalidCRC              = 'CRC が無効です';

  {TIdSocksServer}
  RSSocksSvrNotSupported        = 'サポートされていません';
  RSSocksSvrInvalidLogin        = 'ログインが無効です';
  RSSocksSvrWrongATYP           = 'SOCKS5-ATYP が間違っています';
  RSSocksSvrWrongSocksVersion   = 'SOCKS-version が間違っています';
  RSSocksSvrWrongSocksCommand   = 'SOCKS-Command が間違っています';
  RSSocksSvrAccessDenied        = 'アクセスが拒否されました';
  RSSocksSvrUnexpectedClose     = '予期しない終了';
  RSSocksSvrPeerMismatch        = 'ピア IP が一致しません';

  {TLS Framework}
  RSTLSSSLIOHandlerRequired = 'この設定には SSL IOHandler が必要です';
  RSTLSSSLCanNotSetWhileActive = 'サーバーが稼働している間は、この値を設定できません。';
  RSTLSSLCanNotSetWhileConnected = 'クライアントが接続している間は、この値を設定できません。';
  RSTLSSLSSLNotAvailable = 'このサーバーでは SSL は利用できません。';
  RSTLSSLSSLCmdFailed = 'SSL ネゴシエーション開始コマンドが失敗しました。';

  ///IdPOP3Reply
  //user's provided reply will follow this string
  RSPOP3ReplyInvalidEnhancedCode = '拡張コードが無効です: ';

  //IdSMTPReply
  RSSMTPReplyInvalidReplyStr = 'Invalid Reply String.';
  RSSMTPReplyInvalidClass = 'Invalid Reply Class.';

  RSUnsupportedOperation = 'サポートしていない操作です。';

  //Mapped port components
  RSEmptyHost = 'ホストが空です';    {Do not Localize}
  RSPop3ProxyGreeting = 'POP3 プロキシの準備が完了しました';    {Do not Localize}
  RSPop3UnknownCommand = 'コマンドは USER か QUIT のどちらかでなければなりません';    {Do not Localize}
  RSPop3QuitMsg = 'POP3 プロキシが終了しました';    {Do not Localize}

  //IMAP4 Server
  RSIMAP4SvrBeginTLSNegotiation = 'TLS ネゴシエーションをすぐに開始します';
  RSIMAP4SvrNotPermittedWithTLS = 'TLS が有効なとき、コマンドは使用できません';
  RSIMAP4SvrImplicitTLSRequiresSSL = '暗黙の IMAP4 では、IOHandler を TIdServerIOHandlerSSLBase に設定する必要があります。';

  // OTP Calculator
  RSFTPFSysErrMsg = 'アクセスが拒否されました';
  RSOTPUnknownMethod = '不明な OTP メソッドです';

  // Message Header Encoding
  RSHeaderEncodeError = '文字セット "%s" を使ってヘッダー データをエンコードできませんでした';
  RSHeaderDecodeError = '文字セット "%s" を使ってヘッダー データをデコードできませんでした';

  // message builder strings
  rsHtmlViewerNeeded = 'このメッセージを表示するには HTML ビューアが必要です';
  rsRtfViewerNeeded = 'このメッセージを表示するには RTF ビューアが必要です';

  // HTTP Web Broker Bridge strings
  RSWBBInvalidIdxGetDateVariable = 'TIdHTTPAppResponse.GetDateVariable に渡されたインデックス %s は無効です';
  RSWBBInvalidIdxSetDateVariable = 'TIdHTTPAppResponse.SetDateVariable に渡されたインデックス %s は無効です';
  RSWBBInvalidIdxGetIntVariable = 'TIdHTTPAppResponse.GetIntegerVariable に渡されたインデックス %s は無効です';
  RSWBBInvalidIdxSetIntVariable = 'TIdHTTPAppResponse.SetIntegerVariable に渡されたインデックス %s は無効です';
  RSWBBInvalidIdxGetStrVariable = 'TIdHTTPAppResponse.GetStringVariable に渡されたインデックス %s は無効です';
  RSWBBInvalidStringVar = 'TIdHTTPAppResponse.SetStringVariable: バージョンを設定できません';
  RSWBBInvalidIdxSetStringVar = 'TIdHTTPAppResponse.SetStringVariable に渡されたインデックス %s は無効です';

implementation

end.
