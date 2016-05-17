unit IdResourceStringsUriUtils;

interface

resourcestring
  // TIdURI
  RSUTF16IndexOutOfRange = '文字インデックス %d は範囲外です (長さ = %d)';
  RSUTF16InvalidHighSurrogate = 'インデックス %d の文字は UTF-16 の上位サロゲートとして無効です';
  RSUTF16InvalidLowSurrogate = 'インデックス %d の文字は UTF-16 の下位サロゲートとして無効です';
  RSUTF16MissingLowSurrogate = 'UTF-16 シーケンスに下位サロゲートが見つかりません';

implementation

end.
