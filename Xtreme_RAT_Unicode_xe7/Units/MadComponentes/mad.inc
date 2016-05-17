{$ifndef ver120}{$ifndef ver130}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN SYMBOL_LIBRARY OFF}
  {$WARN UNIT_LIBRARY OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$ifndef ver140}
    {$WARN UNSAFE_TYPE OFF}
    {$WARN UNSAFE_CODE OFF}
    {$WARN UNSAFE_CAST OFF}
  {$endif}
{$endif}{$endif}
{$R-}{$Q-}{$T-}
{$ifdef debugMadExcept}
  {$D+}{$L+}
{$else}
  {$D-}{$L-}
{$endif}
{$O+}
{$MINENUMSIZE 1}
{$ALIGN ON}
