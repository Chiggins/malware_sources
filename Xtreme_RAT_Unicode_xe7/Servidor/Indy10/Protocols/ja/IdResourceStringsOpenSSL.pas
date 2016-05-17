unit IdResourceStringsOpenSSL;

interface

resourcestring
  {IdOpenSSL}
  RSOSSFailedToLoad = '%s を読み込めませんでした。';
  RSOSSLModeNotSet = 'モードはまだ設定されていません。';
  RSOSSLCouldNotLoadSSLLibrary = 'SSL ライブラリが読み込めませんでした。';
  RSOSSLStatusString = 'SSL ステータス: "%s"';
  RSOSSLConnectionDropped = 'SSL 接続が解除されました。';
  RSOSSLCertificateLookup = 'SSL 証明書要求エラー。';
  RSOSSLInternal = 'SSL ライブラリ内部エラー。';
  //callback where strings
  RSOSSLAlert =  '%s 警告';
  RSOSSLReadAlert =  '%s 読み取り警告';
  RSOSSLWriteAlert =  '%s 書き込み警告';
  RSOSSLAcceptLoop = 'アクセプト ループ';
  RSOSSLAcceptError = 'アクセプト エラー';
  RSOSSLAcceptFailed = 'アクセプト失敗';
  RSOSSLAcceptExit =  'アクセプト終了';
  RSOSSLConnectLoop =  '接続ループ';
  RSOSSLConnectError = '接続エラー';
  RSOSSLConnectFailed = '接続失敗';
  RSOSSLConnectExit =  '接続終了';
  RSOSSLHandshakeStart = 'ハンドシェイク開始';
  RSOSSLHandshakeDone =  'ハンドシェイク完了';

implementation

end.
