unit InformacoesServidor;

interface

type
  TServerINFO = record
    ImagemBandeira: integer;
    ImagemDesktop: integer;
    GroupName: array [0..100] of WideChar;
    NomeDoServidor: array [0..100] of WideChar;
    Pais: array [0..100] of WideChar;
    IPWAN: array [0..15] of WideChar;
    IPLAN: array [0..15] of WideChar;
    Account: array [0..20] of WideChar;
    NomeDoComputador: array [0..100] of WideChar;
    NomeDoUsuario: array [0..100] of WideChar;
    PASSID: array [0..100] of WideChar;
    CAM: array [0..10] of WideChar;
    ImagemCam: integer;
    SistemaOperacional: array [0..100] of WideChar;
    CPU: array [0..100] of WideChar;
    RAM: array [0..30] of WideChar;
    AV: array [0..100] of WideChar;
    FW: array [0..100] of WideChar;
    Versao: array [0..20] of WideChar;
    Porta: integer;
    Ping: integer;
    ImagemPing: integer;
    Idle: integer;
    PrimeiraExecucao: array [0..100] of WideChar;
    JanelaAtiva: array [0..1000] of WideChar;
  end;

implementation

end.