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
  RSInvalidSourceArray = 'ソース配列が無効です';
  RSInvalidDestinationArray = 'ターゲット配列が無効です';
  RSCharIndexOutOfBounds = '文字インデックスが範囲外です (%d)';
  RSInvalidCharCount = 'カウントが無効です (%d)';
  RSInvalidDestinationIndex = 'ターゲット インデックスが無効です (%d)';

  RSInvalidCodePage = 'コードページが無効です (%d)';
  RSInvalidCharSet = '文字セット (%s) が無効です';
  RSInvalidCharSetConv = '文字セット変換が無効です (%s <-> %s)';
  RSInvalidCharSetConvWithFlags = '文字セット変換が無効です (%s <-> %s、%s)';

  //IdSys
  RSFailedTimeZoneInfo = 'タイム ゾーン情報を取得できませんでした。';
  // Winsock
  RSWinsockCallError = 'Winsock2 ライブラリ関数 %s への呼び出しでエラーが発生しました';
  RSWinsockLoadError = 'Winsock2 ライブラリ (%s) の読み込み中にエラーが発生しました';
  {CH RSWinsockInitializationError = 'Winsock Initialization Error.'; }
  // Status
  RSStatusResolving = 'ホスト名 %s を解決しています。';
  RSStatusConnecting = '%s に接続しています。';
  RSStatusConnected = '接続しました。';
  RSStatusDisconnecting = '接続解除しています。';
  RSStatusDisconnected = '接続解除されました。';
  RSStatusText = '%s';
  // Stack
  RSStackError = 'Socket エラー # %d'#13#10'%s';
  RSStackEINTR = 'システム コールが割り込まれました。';
  RSStackEBADF = 'ファイル番号が不正です。';
  RSStackEACCES = 'アクセスが拒否されました。';
  RSStackEFAULT = 'バッファ フォルトが発生しました。';
  RSStackEINVAL = '引数が無効です。';
  RSStackEMFILE = '開いているファイルが多すぎます。';
  RSStackEWOULDBLOCK = '操作はブロックされます。';
  RSStackEINPROGRESS = '操作を現在実行中です。';
  RSStackEALREADY = '操作は既に実行中です。';
  RSStackENOTSOCK = 'ソケット以外のものに対するソケット操作です。';
  RSStackEDESTADDRREQ = '送信先アドレスが必要です。';
  RSStackEMSGSIZE = 'メッセージが長すぎます。';
  RSStackEPROTOTYPE = 'ソケットのプロトコルの種類が正しくありません。';
  RSStackENOPROTOOPT = 'プロトコル オプションが不正です。';
  RSStackEPROTONOSUPPORT = 'プロトコルがサポートされていません。';
  RSStackESOCKTNOSUPPORT = 'ソケット タイプがサポートされていません。';
  RSStackEOPNOTSUPP = 'ソケットで操作がサポートされていません。';
  RSStackEPFNOSUPPORT = 'プロトコル ファミリがサポートされていません。';
  RSStackEAFNOSUPPORT = 'アドレス ファミリがプロトコル ファミリでサポートされていません。';
  RSStackEADDRINUSE = 'アドレスは既に使われています。';
  RSStackEADDRNOTAVAIL = '要求されたアドレスを割り当てることができません。';
  RSStackENETDOWN = 'ネットワークが停止しています。';
  RSStackENETUNREACH = 'ネットワークに到達できません。';
  RSStackENETRESET = 'ネットワークが接続を切断またはリセットしました。';
  RSStackECONNABORTED = 'ソフトウェアが原因で接続が途中で中止されました。';
  RSStackECONNRESET = 'ピアにより接続がリセットされました。';
  RSStackENOBUFS = '使用できるバッファ領域がありません。';
  RSStackEISCONN = 'ソケットは既に接続されています。';
  RSStackENOTCONN = 'ソケットが接続されていません。';
  RSStackESHUTDOWN = 'ソケットが閉じた後に送信や受信をすることはできません。';
  RSStackETOOMANYREFS = '参照が多すぎます。継ぎ合わせることができません。';
  RSStackETIMEDOUT = '接続がタイムアウトしました。';
  RSStackECONNREFUSED = '接続が拒否されました。';
  RSStackELOOP = 'シンボリック リンクのレベルが多すぎます。';
  RSStackENAMETOOLONG = 'ファイル名が長すぎます。';
  RSStackEHOSTDOWN = 'ホストが停止しています。';
  RSStackEHOSTUNREACH = 'ホストへのルートが存在しません。';
  RSStackENOTEMPTY = 'ディレクトリが空ではありません';
  RSStackHOST_NOT_FOUND = 'ホストが見つかりません。';
  RSStackClassUndefined = 'スタック クラスは未定義です。';
  RSStackAlreadyCreated = 'スタックが既に作成されています。';
  // Other
  RSAntiFreezeOnlyOne = 'アプリケーションあたり 1 つの TIdAntiFreeze のみ存在できます。';
  RSCannotSetIPVersionWhenConnected = '接続時に IPVersion を変更できません';
  RSCannotBindRange = 'ポート範囲 (%d - %d) にバインドできません';
  RSConnectionClosedGracefully = '接続が正常に閉じられました。';
  RSCorruptServicesFile = '%s が壊れています。';
  RSCouldNotBindSocket = 'ソケットをバインドできませんでした。アドレスとポートは既に使われています。';
  RSInvalidPortRange = 'ポート範囲 (%d - %d) が無効です';
  RSInvalidServiceName = '%s は有効なサービスではありません。';
  RSIPv6Unavailable = 'IPv6 は利用できません';
  RSInvalidIPv6Address = '%s は有効な IPv6 アドレスではありません';
  RSIPVersionUnsupported = '要求した IP バージョン/アドレス ファミリはサポートされていません。';
  RSNotAllBytesSent = '送信できなかったバイトがあります。';
  RSPackageSizeTooBig = 'パッケージ サイズが大きすぎます。';
  RSSetSizeExceeded = 'セットのサイズを超えています。';
  RSNoEncodingSpecified = 'エンコーディングが指定されていません。';
  {CH RSStreamNotEnoughBytes = 'Not enough bytes read from stream.'; }
  RSEndOfStream = 'ストリームの終わり: クラス %s (位置 %d)';

  //DNS Resolution error messages
  RSMaliciousPtrRecord = '悪意のある PTR レコードです';

implementation

end.
