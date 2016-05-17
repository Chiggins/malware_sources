Unit UnitDebug;

interface

uses
  windows,
  UnitDiversos,
  unitcomandos,
  UnitSettings;

const
  erro1 = '1';
  erro2 = '2';
  erro3 = '3';
  erro4 = '4';
  erro5 = '5';
  erro6 = '6';
  erro7 = '7';
  erro8 = '8';
  erro9 = '9';
  erro10 = '10';
  erro11 = '11'; // erro ---> SocketUnit (eram problema... mudei a forma do "receivestring" e corrigiu até mesmo a desconexão qdo a webcam e desktop estão ligados)
  erro12 = '12';
  erro13 = '13'; // erro ---> SocketUnit (o erro de cima causava esse) 
  erro14 = '14';
  erro15 = '15';
  erro16 = '16';
  erro17 = '17';
  erro18 = '18';
  erro19 = '19';
  erro20 = '20';
  erro21 = '21';
  erro22 = '22';
  //erro23 = '23';
  //erro24 = '24';
  //erro25 = '25';
  //erro26 = '26';
  //erro27 = '27';
  //erro28 = '28';
  //erro29 = '29';
  //erro30 = '30';
  //erro31 = '31';
  //erro32 = '32';
  //erro33 = '33';
  //erro34 = '34';
  //erro35 = '35';
  //erro36 = '36';
  //erro37 = '37';
  //erro38 = '38';
  //erro39 = '39';
  //erro40 = '40';
  //erro41 = '41';
  //erro42 = '42';
  //erro43 = '43';
  //erro44 = '44';
  //erro45 = '45';
  //erro46 = '46';
  //erro47 = '47';
  //erro48 = '48';
  //erro49 = '49';
  //erro50 = '50';
  //erro51 = '51';
  //erro52 = '52';
  //erro53 = '53';
  //erro54 = '54';
  //erro55 = '55';
  //erro56 = '56';
  //erro57 = '57';
  //erro58 = '58';
  //erro59 = '59';
  //erro60 = '60';
  //erro61 = '61';
  //erro62 = '62';
  //erro63 = '63';
  //erro64 = '64';
  //erro65 = '65';
  //erro66 = '66';
  //erro67 = '67';
  //erro68 = '68';
  //erro69 = '69';
  //erro70 = '70';
  //erro71 = '71';
  //erro72 = '72';
  //erro73 = '73';
  //erro74 = '74';
  //erro75 = '75';
  //erro76 = '76';
  //erro77 = '77';
  //erro78 = '78';
  //erro79 = '79';
  //erro80 = '80';
  //erro81 = '81';
  //erro82 = '82';
  //erro83 = '83';
  //erro84 = '84';
  //erro85 = '85';
  //erro86 = '86';
  //erro87 = '87';
  //erro88 = '88';
  //erro89 = '89';
  //erro90 = '90';
  //erro91 = '91';
  //erro92 = '92';
  //erro93 = '93';
  //erro94 = '94';
  //erro95 = '95';
  //erro96 = '96';
  //erro97 = '97';
  //erro98 = '98';
  //erro99 = '99';
  //erro100 = '100';
  //erro101 = '101';
  //erro102 = '102';
  //erro103 = '103';
  //erro104 = '104';
  //erro105 = '105';
  //erro106 = '106';
  //erro107 = '107';
  //erro108 = '108';
  //erro109 = '109';
  //erro110 = '110';

var
  BufferTest: string;  

Procedure AddDebug(LOG: string);

implementation

Procedure AddDebug(LOG: string);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
  NomeDoarquivo: string;
begin
  if DebugAtivoServer = false then exit;

  NomeDoarquivo := GetShellFolder('Desktop') + '\' + 'Spy-Net ' + VersaoPrograma + '.txt';

  if fileexists(NomeDoarquivo) = false then
  begin
    hFile := CreateFile(PChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);
    CloseHandle(hFile);
  end;

  LOG := GetDay + '/' + GetMonth + '/' + GetYear + ' --- ' + GetHour + ':' + GetMinute + ':' + GetSecond + #13#10 + 'Código: ' + LOG + #13#10 + #13#10;

  hFile := CreateFile(PChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    SetFilePointer(hFile, 0, nil, FILE_END);
    WriteFile(hFile, LOG[1], length(LOG), lpNumberOfBytesWritten, nil);
    CloseHandle(hFile);
  end;
end;

end.
