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
  RSNoBindingsSpecified = 'バインディングが指定されていません。';
  RSCannotAllocateSocket = 'ソケットを割り当てられません。';
  RSSocksUDPNotSupported = 'UDP はこの SOCKS バージョンではサポートされていません。';
  RSSocksRequestFailed = '要求は拒否または失敗しました。';
  RSSocksRequestServerFailed = '要求は拒否されました。SOCKS サーバーが接続できないためです。';
  RSSocksRequestIdentFailed = '要求は拒否されました。クライアント プログラムと identd のユーザー ID が異なるためです。';
  RSSocksUnknownError = '不明な SOCKS エラーです。';
  RSSocksServerRespondError = 'SOCKS サーバーが応答しませんでした。';
  RSSocksAuthMethodError = '不正な socks 認証方式です。';
  RSSocksAuthError = 'Socks サーバーに対する認証エラー。';
  RSSocksServerGeneralError = '一般 SOCKS サーバー エラーです。';
  RSSocksServerPermissionError = 'ルールセットによりこれ以上接続できません。';
  RSSocksServerNetUnreachableError = 'ネットワークに到達できません。';
  RSSocksServerHostUnreachableError = 'ホストに到達できません。';
  RSSocksServerConnectionRefusedError = '接続が拒否されました。';
  RSSocksServerTTLExpiredError = 'TTL を超えています。';
  RSSocksServerCommandError = 'コマンドはサポートされていません:';
  RSSocksServerAddressError = 'アドレス タイプがサポートされていません。';
  RSInvalidIPAddress = 'IP アドレスが無効です';
  RSInterceptCircularLink = '%s: 循環リンクは使用できません';

  RSNotEnoughDataInBuffer = 'バッファに十分なデータがありません。(%d/%d)';
  RSTooMuchDataInBuffer = 'バッファに十分なデータがありません。';
  RSCapacityTooSmall = 'Capacity は Size 以上でなければなりません。';
  RSBufferIsEmpty = 'バッファにデータがありません。';
  RSBufferRangeError = 'インデックスが範囲外です。';

  RSFileNotFound = 'ファイル "%s" が見つかりません';
  RSNotConnected = '接続されていません';
  RSObjectTypeNotSupported = 'オブジェクト型がサポートされていません。';
  RSIdNoDataToRead = '読み取るデータがありません。';
  RSReadTimeout = '読み取りがタイム アウトしました。';
  RSReadLnWaitMaxAttemptsExceeded = '読み取り最大試行行数を超えています。';
  RSAcceptTimeout = 'accept がタイムアウトしました。';
  RSReadLnMaxLineLengthExceeded = '行の最大サイズを超えています。';
  RSRequiresLargeStream = '2 GB より大きいストリームを送信するには、LargeStream を True に設定します';
  RSDataTooLarge = 'データがストリームには大きすぎます';
  RSConnectTimeout = '接続がタイムアウトしました。';
  RSICMPNotEnoughtBytes = '受信したバイト数が不十分です';
  RSICMPNonEchoResponse = 'エコー タイプ以外の応答を受信しました';
  RSThreadTerminateAndWaitFor  = 'TerminateAndWaitFor を FreeAndTerminate スレッドで呼び出しできません';
  RSAlreadyConnected = 'すでに接続されています。';
  RSTerminateThreadTimeout = 'スレッド終了のタイムアウト';
  RSNoExecuteSpecified = '実行ハンドラが見つかりません。';
  RSNoCommandHandlerFound = 'コマンド ハンドラが見つかりません。';
  RSCannotPerformTaskWhileServerIsActive = 'サーバーの稼働中にタスクを実行できません。';
  RSThreadClassNotSpecified = 'スレッド クラスが指定されていません。';
  RSMaximumNumberOfCaptureLineExceeded = '最大許容行数を超えています'; // S.G. 6/4/2004: IdIOHandler.DoCapture
  RSNoCreateListeningThread = 'リスン スレッドを作成できません。';
  RSInterceptIsDifferent = 'IOHandler には別のインターセプトがすでに割り当てられています';

  //scheduler
  RSchedMaxThreadEx = 'このスケジューラの最大スレッド数を超えています。';
  //transparent proxy
  RSTransparentProxyCannotBind = '透過プロキシをバインドできません。';
  RSTransparentProxyCanNotSupportUDP = 'UDP はこのプロキシでサポートされていません。';
  //Fibers
  RSFibersNotSupported = 'このシステムではファイバーはサポートされていません。';
  // TIdICMPCast
  RSIPMCastInvalidMulticastAddress = '指定された IP アドレスは有効なマルチキャスト アドレス (224.0.0.0 から 239.255.255.255 まで) ではありません。';
  RSIPMCastNotSupportedOnWin32 = 'この関数は Win32 ではサポートされていません。';
  RSIPMCastReceiveError0 = 'IP ブロードキャスト受信エラー = 0。';

  // Log strings
  RSLogConnected = '接続しました。';
  RSLogDisconnected = '接続解除されました。';
  RSLogEOL = '<EOL>';  // End of Line
  RSLogCR  = '<CR>';   // Carriage Return
  RSLogLF  = '<LF>';   // Line feed
  RSLogRecv = '受信 '; // Receive
  RSLogSent = '送信済み '; // Send
  RSLogStat = 'Stat '; // Status

  RSLogFileAlreadyOpen = 'ログ ファイルが開かれている間はファイル名を設定できません。';

  RSBufferMissingTerminator = 'バッファの終了文字を指定する必要があります。';
  RSBufferInvalidStartPos   = 'バッファの開始位置が無効です。';

  RSIOHandlerCannotChange = '接続した IOHandler を変更できません。';
  RSIOHandlerTypeNotInstalled = 'タイプ %s の IOHandler がインストールされていません。';

  RSReplyInvalidCode = 'リプライ コードが不正です: %s';
  RSReplyCodeAlreadyExists = 'リプライ コードはすでに存在します: %s';

  RSThreadSchedulerThreadRequired = 'スレッドをこのスケジューラに指定する必要があります。';
  RSNoOnExecute = 'OnExecute イベントが必要です。';
  RSThreadComponentLoopAlreadyRunning = 'スレッドが既に実行中の場合は Loop プロパティを設定できません。';
  RSThreadComponentThreadNameAlreadyRunning = 'スレッドが既に実行中の場合は ThreadName  を設定できません。';

  RSStreamProxyNoStack = 'データ型変換用のスタックが作成されていません。';

  RSTransparentProxyCyclic = '透過プロキシの循環エラーです。';

  RSTCPServerSchedulerAlreadyActive = 'サーバーがアクティブであるときにスケジューラを変更できません。';
  RSUDPMustUseProxyOpen = 'proxyOpen を使用する必要があります。';

//ICMP stuff
  RSICMPTimeout = 'タイムアウト';
//Destination Address -3
  RSICMPNetUnreachable  = 'ネットワークに到達できません。';
  RSICMPHostUnreachable = 'ホストに到達できません。';
  RSICMPProtUnreachable = 'プロトコルに到達できません。';
  RSICMPPortUnreachable = 'ポートに到達できません';
  RSICMPFragmentNeeded = 'フラグメント化が必要ですが、"Don'#39't Fragment" フラグが設定されています';
  RSICMPSourceRouteFailed = '送信元ルートで障害が発生しました';
  RSICMPDestNetUnknown = '宛先ネットワークが不明です';
  RSICMPDestHostUnknown = '宛先ホストが不明です';
  RSICMPSourceIsolated = '送信元ホストへのルートがありません';
  RSICMPDestNetProhibitted = '宛先ネットワークとの通信が管理上禁止されています';
  RSICMPDestHostProhibitted = '宛先ホストとの通信が管理上禁止されています';
  RSICMPTOSNetUnreach =  'サービスのタイプに対応する宛先ネットワークに到達できません';
  RSICMPTOSHostUnreach = 'サービスのタイプに対応する宛先ホストに到達できません';
  RSICMPAdminProhibitted = '通信が管理上禁止されています';
  RSICMPHostPrecViolation = 'ホスト優先度の侵害';
  RSICMPPrecedenceCutoffInEffect =  '優先度による遮断が有効です';
  //for IPv6
  RSICMPNoRouteToDest = '宛先へのルートが存在しません';
  RSICMPAAdminDestProhibitted =  '宛先との通信は管理上禁止されています';
  RSICMPSourceFilterFailed = '送信元アドレスが侵入/侵出ポリシーに違反しています';
  RSICMPRejectRoutToDest = '宛先へのルートを破棄します';
  // Destination Address - 11
  RSICMPTTLExceeded     = '転送中に存続時間 (TTL) を超過しました';
  RSICMPHopLimitExceeded = '転送中にホップ限度を超えました';
  RSICMPFragAsmExceeded = 'フラグメントの再構成時間を超過しました。';
//Parameter Problem - 12
  RSICMPParamError      = 'パラメータの問題 (オフセット %d)';
  //IPv6
  RSICMPParamHeader = '誤りのあるヘッダー フィールドを検出しました (オフセット %d)';
  RSICMPParamNextHeader = '認識できない "次のヘッダー" タイプを検出しました (オフセット %d)';
  RSICMPUnrecognizedOpt = '認識できない IPv6 オプションを検出しました (オフセット %d)';
//Source Quench Message -4
  RSICMPSourceQuenchMsg = '送信元抑制メッセージ';
//Redirect Message
  RSICMPRedirNet =        'ネットワークのデータグラムをリダイレクトします。';
  RSICMPRedirHost =       'ホストのデータグラムをリダイレクトします。';
  RSICMPRedirTOSNet =     'サービスおよびネットワークのタイプに対応するデータグラムをリダイレクトします。';
  RSICMPRedirTOSHost =    'サービスおよびホストのタイプに対応するデータグラムをリダイレクトします。';
//echo
  RSICMPEcho = 'Echo';
//timestamp
  RSICMPTimeStamp = 'タイムスタンプ';
//information request
  RSICMPInfoRequest = '情報要求';
//mask request
  RSICMPMaskRequest = 'アドレス マスク要求';
// Traceroute
  RSICMPTracePacketForwarded = '発信パケットが正常に転送されました';
  RSICMPTraceNoRoute = '発信パケットのルートがありません。パケットは破棄されました';
//conversion errors
  RSICMPConvUnknownUnspecError = '不明または明示されていないエラーです';
  RSICMPConvDontConvOptPresent = '"Don'#39't Convert" オプションがあります';
  RSICMPConvUnknownMandOptPresent =  '不明な必須オプションがあります';
  RSICMPConvKnownUnsupportedOptionPresent = 'サポートされていない既知のオプションがあります';
  RSICMPConvUnsupportedTransportProtocol = 'サポートされていないトランスポート プロトコルです';
  RSICMPConvOverallLengthExceeded = '全長を超えています';
  RSICMPConvIPHeaderLengthExceeded = 'IP ヘッダー長を超えています';
  RSICMPConvTransportProtocol_255 = 'トランスポート プロトコル &gt; 255';
  RSICMPConvPortConversionOutOfRange = 'ポート変換が範囲外です';
  RSICMPConvTransportHeaderLengthExceeded = 'トランスポート ヘッダー長を超えています';
  RSICMPConv32BitRolloverMissingAndACKSet = '"32 Bit Rollover" オプションがなく、ACK フラグが設定されています';
  RSICMPConvUnknownMandatoryTransportOptionPresent =      'トランスポートに関する不明な必須オプションがあります';
//mobile host redirect
  RSICMPMobileHostRedirect = 'モバイル ホスト リダイレクト';
//IPv6 - Where are you
  RSICMPIPv6WhereAreYou    = 'IPv6 Where-Are-You';
//IPv6 - I am here
  RSICMPIPv6IAmHere        = 'IPv6 I-Am-Here';
// Mobile Regestration request
  RSICMPMobReg             = 'モバイル登録要求';
//Skip
  RSICMPSKIP               = 'SKIP';
//Security
  RSICMPSecBadSPI          = 'SPI が無効です';
  RSICMPSecAuthenticationFailed = '認証に失敗しました';
  RSICMPSecDecompressionFailed = '解凍に失敗しました';
  RSICMPSecDecryptionFailed = '暗号解読に失敗しました';
  RSICMPSecNeedAuthentication = '認証が必要です';
  RSICMPSecNeedAuthorization = '権限が必要です';
//IPv6 Packet Too Big
  RSICMPPacketTooBig = 'パケットが大きすぎます (MTU = %d)';
{ TIdCustomIcmpClient }

  // TIdSimpleServer
  RSCannotUseNonSocketIOHandler = 'ソケット以外の IOHandler を使用できません';

implementation

end.
