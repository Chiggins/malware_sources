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
  2003-11-Jul:
    Original author: Sergio Perry
    Matthew Elzer - bug fixes & modifications
}

unit IdIRC;

{
  Based on TIRCClient component by Steve Williams (stevewilliams@kromestudios.com)
  ported to Indy by Daaron Dwyer (ddwyer@ncic.com)
}

{ Based on RFC 2812 }

interface

{$i IdCompilerDefines.inc}

uses
  Classes,
  IdAssignedNumbers, IdContext, IdCmdTCPClient, IdCommandHandlers,
  IdIOHandler, IdGlobal, IdException;

type
  TIdIRC = class;

  TIdIRCUserMode = (amAway, amInvisible, amWallops, amRestricted, amOperator, amLocalOperator, amReceiveServerNotices);
  TIdIRCUserModes = set of TIdIRCUserMode;

  TIdIRCStat = (stServerConnectionsList, stCommandUsageCount, stOperatorList, stUpTime);

  { -WELCOME- }
  TIdIRCServerMsgEvent = procedure(ASender: TIdContext; const AMsg: String) of object;
  TIdIRCMyInfoEvent = procedure(ASender: TIdContext; const AServer, AVersion, AUserModes, AChanModes, AExtra: String) of object;
  TIdIRCBounceEvent = procedure(ASender: TIdContext; const AHost: String; APort: Integer; const AInfo: String) of object;
  TIdIRCISupportEvent = procedure(ASender: TIdContext; AParameters: TStrings) of object;
  { -PING- }
  TIdIRCPingPongEvent = procedure(ASender: TIdContext) of object;
  { -MESSAGE- }
  TIdIRCPrivMessageEvent = procedure(ASender: TIdContext; const ANickname, AHost, ATarget, AMessage: String) of object;
  { -NOTICE- }
  TIdIRCNoticeEvent = procedure(ASender: TIdContext; const ANickname, AHost, ATarget, ANotice: String) of object;
  { -REHASH- }
  TIdIRCRehashEvent = procedure(ASender: TIdContext; const ANickname, AHost: String) of object;
  { -SUMMON- }
  TIdIRCSummonEvent = procedure(ASender: TIdContext; const ANickname, AHost: String) of object;
  { -WALLOPS- }
  TIdIRCWallopsEvent = procedure(ASender: TIdContext; const ANickname, AHost, AMessage: String) of object;
  { -ISON- }
  TIdIRCIsOnIRCEvent = procedure(ASender: TIdContext; const ANickname, AHost: String) of object;
  { -AWAY- }
  TIdIRCAwayEvent = procedure(ASender: TIdContext; const ANickname, AHost, AAwayMessage: String; UserAway: Boolean) of object;
  { -JOIN- }
  TIdIRCJoinEvent = procedure(ASender: TIdContext; const ANickname, AHost, AChannel: String) of object;
  { -PART- }
  TIdIRCPartEvent = procedure(ASender: TIdContext; const ANickname, AHost, AChannel, APartMessage: String) of object;
  { -TOPIC- }
  TIdIRCTopicEvent = procedure(ASender: TIdContext; const ANickname, AHost, AChannel, ATopic: String) of object;
  { -KICK- }
  TIdIRCKickEvent = procedure(ASender: TIdContext; const ANickname, AHost, AChannel, ATarget, AReason: String) of object;
  { -MOTD- }
  TIdIRCMOTDEvent = procedure(ASender: TIdContext; AMOTD: TStrings) of object;
  { -TRACE- }
  TIdIRCServerTraceEvent = procedure(ASender: TIdContext; ATraceInfo: TStrings) of object;
  { -OPER- }
  TIdIRCOpEvent = procedure(ASender: TIdContext; const ANickname, AChannel, AHost: String) of object;
  { -INV- }
  TIdIRCInvitingEvent = procedure(ASender: TIdContext; const ANickname, AHost: String) of object;
  TIdIRCInviteEvent = procedure(ASender: TIdContext; const ANickname, AHost, ATarget, AChannel: String) of object;
  { -LIST- }
  TIdIRCChanBANListEvent = procedure(ASender: TIdContext; const AChannel: String; ABanList: TStrings) of object;
  TIdIRCChanEXCListEvent = procedure(ASender: TIdContext; const AChannel: String; AExceptList: TStrings) of object;
  TIdIRCChanINVListEvent = procedure(ASender: TIdContext; const AChannel: String; AInviteList: TStrings) of object;
  TIdIRCServerListEvent = procedure(ASender: TIdContext; AServerList: TStrings) of object;
  TIdIRCNickListEvent = procedure(ASender: TIdContext; const AChannel: String; ANicknameList: TStrings) of object;
  { -STATS- }
  TIdIRCServerUsersEvent = procedure(ASender: TIdContext; AUsers: TStrings) of object;
  TIdIRCServerStatsEvent = procedure(ASender: TIdContext; AStatus: TStrings) of object;
  TIdIRCKnownServerNamesEvent = procedure(ASender: TIdContext; AKnownServers: TStrings) of object;
  { -INFO- }
  TIdIRCAdminInfoRecvEvent = procedure(ASender: TIdContext; AAdminInfo: TStrings) of object;
  TIdIRCUserInfoRecvEvent = procedure(ASender: TIdContext; const AUserInfo: String) of object;
  { -WHO- }
  TIdIRCWhoEvent = procedure(ASender: TIdContext; AWhoResults: TStrings) of object;
  TIdIRCWhoIsEvent = procedure(ASender: TIdContext; AWhoIsResults: TStrings) of object;
  TIdIRCWhoWasEvent = procedure(ASender: TIdContext; AWhoWasResults: TStrings) of object;
  { Mode }
  TIdIRCChanModeEvent = procedure(ASender: TIdContext; const ANickname, AHost, AChannel, AMode, AParams: String) of object;
  TIdIRCUserModeEvent = procedure(ASender: TIdContext; const ANickname, AHost, AMode: String) of object;
  { -CTCP- }
  TIdIRCCTCPQueryEvent = procedure(ASender: TIdContext; const ANickname, AHost, ATarget, ACommand, AParams: String) of object;
  TIdIRCCTCPReplyEvent = procedure(ASender: TIdContext; const ANickname, AHost, ATarget, ACommand, AParams: String) of object;
  { -DCC- }
  TIdIRCDCCChatEvent = procedure(ASender: TIdContext; const ANickname, AHost: String; APort: Integer) of object;
  TIdIRCDCCSendEvent = procedure(ASender: TIdContext; const ANickname, AHost, AFilename: String; APort: TIdPort; AFileSize: Int64) of object;
  TIdIRCDCCResumeEvent = procedure(ASender: TIdContext; const ANickname, AHost, AFilename: String; APort: TIdPort;  AFilePos: Int64) of object;
  TIdIRCDCCAcceptEvent = procedure(ASender: TIdContext; const ANickname, AHost, AFilename: String; APort: TIdPort; AFilePos: Int64) of object;
  { -Errors- }
  TIdIRCServerErrorEvent = procedure(ASender: TIdContext; AErrorCode: Integer; const AErrorMessage: String) of object;
  TIdIRCNickErrorEvent = procedure(ASender: TIdContext; AError: Integer) of object;
  TIdIRCKillErrorEvent = procedure(ASender: TIdContext) of object;
  { Other }
  TIdIRCNicknameChangedEvent = procedure(ASender: TIdContext; const AOldNickname, AHost, ANewNickname: String) of object;
  TIdIRCKillEvent = procedure(ASender: TIdContext; const ANickname, AHost, ATargetNickname, AReason: String) of object;
  TIdIRCQuitEvent = procedure(ASender: TIdContext; const ANickname, AHost, AReason: String) of object;
  TIdIRCSvrQuitEvent = procedure(ASender: TIdContext; const ANickname, AHost, AServer, AReason: String) of object;
  TIdIRCSvrTimeEvent = procedure(ASender: TIdContext; const AHost, ATime: String) of object;
  TIdIRCServiceEvent = procedure(ASender: TIdContext) of object;
  TIdIRCSvrVersionEvent = procedure(ASender: TIdContext; const AVersion, AHost, AComments: String) of object;
  TIdIRCRawEvent = procedure(ASender: TIdContext; AIn: Boolean; const AMessage: String) of object;

  EIdIRCError = class(EIdException);

  TIdIRCReplies = class(TPersistent)
  protected
    FFinger: String;
    FVersion: String;
    FUserInfo: String;
    FClientInfo: String;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property Finger: String read FFinger write FFinger;
    property Version: String read FVersion write FVersion;
    property UserInfo: String read FUserInfo write FUserInfo;
    property ClientInfo: String read FClientInfo write FClientInfo;
  end;

  TIdIRC = class(TIdCmdTCPClient)
  protected
    FNickname: String;
    FAltNickname: String;
    FAltNickUsed: Boolean;
    //
    FUsername: String;
    FRealName: String;
    FPassword: String;
    FUserMode: TIdIRCUserModes;
    FUserAway: Boolean;
    FReplies: TIdIRCReplies;
    //
    FSenderNick: String;
    FSenderHost: String;
    //
    FBans: TStrings;
    FExcepts: TStrings;
    FInvites: TStrings;
    FLinks: TStrings;
    FMotd: TStrings;
    FNames: TStrings;
    FWho: TStrings;
    FWhoIs: TStrings;
    FWhoWas: TStrings;
    FSvrList: TStrings;
    FUsers: TStrings;
    //
    FOnSWelcome: TIdIRCServerMsgEvent;
    FOnYourHost: TIdIRCServerMsgEvent;
    FOnSCreated: TIdIRCServerMsgEvent;
    FOnMyInfo: TIdIRCMyInfoEvent;
    FOnBounce: TIdIRCBounceEvent;
    FOnISupport: TIdIRCISupportEvent;
    FOnSError: TIdIRCServerMsgEvent;
    FOnPingPong: TIdIRCPingPongEvent;
    FOnPrivMessage: TIdIRCPrivMessageEvent;
    FOnNotice: TIdIRCNoticeEvent;
    FOnRehash: TIdIRCRehashEvent;
    FOnSummon: TIdIRCSummonEvent;
    FOnWallops: TIdIRCWallopsEvent;
    FOnIsOnIRC: TIdIRCIsOnIRCEvent;
    FOnAway: TIdIRCAwayEvent;
    FOnJoin: TIdIRCJoinEvent;
    FOnPart: TIdIRCPartEvent;
    FOnTopic: TIdIRCTopicEvent;
    FOnKick: TIdIRCKickEvent;
    FOnMOTD: TIdIRCMOTDEvent;
    FOnTrace: TIdIRCServerTraceEvent;
    FOnOp: TIdIRCOpEvent;
    FOnInviting: TIdIRCInvitingEvent;
    FOnInvite: TIdIRCInviteEvent;
    FOnBANList: TIdIRCChanBANListEvent;
    FOnEXCList: TIdIRCChanEXCListEvent;
    FOnINVList: TIdIRCChanINVListEvent;
    FOnSvrList: TIdIRCServerListEvent;
    FOnNickList: TIdIRCNickListEvent;
    FOnSvrUsers: TIdIRCServerUsersEvent;
    FOnSvrStats: TIdIRCServerStatsEvent;
    FOnKnownSvrs: TIdIRCKnownServerNamesEvent;
    FOnAdminInfo: TIdIRCAdminInfoRecvEvent;
    FOnUserInfo: TIdIRCUserInfoRecvEvent;
    FOnWho: TIdIRCWhoEvent;
    FOnWhoIs: TIdIRCWhoIsEvent;
    FOnWhoWas: TIdIRCWhoWasEvent;
    FOnChanMode: TIdIRCChanModeEvent;
    FOnUserMode: TIdIRCUserModeEvent;
    FOnCTCPQry: TIdIRCCTCPQueryEvent;
    FOnCTCPRep: TIdIRCCTCPReplyEvent;
    FOnDCCChat: TIdIRCDCCChatEvent;
    FOnDCCSend: TIdIRCDCCSendEvent;
    FOnDCCResume: TIdIRCDCCResumeEvent;
    FOnDCCAccept: TIdIRCDCCAcceptEvent;
    FOnServerError: TIdIRCServerErrorEvent;
    FOnNickError: TIdIRCNickErrorEvent;
    FOnKillError: TIdIRCKillErrorEvent;
    FOnNickChange: TIdIRCNicknameChangedEvent;
    FOnKill: TIdIRCKillEvent;
    FOnQuit: TIdIRCQuitEvent;
    FOnSvrQuit: TIdIRCSvrQuitEvent;
    FOnSvrTime: TIdIRCSvrTimeEvent;
    FOnService: TIdIRCServiceEvent;
    FOnSvrVersion: TIdIRCSvrVersionEvent;
    FOnRaw: TIdIRCRawEvent;
    //
    function GetUsedNickname: String;
    procedure SetNickname(const AValue: String);
    procedure SetUsername(const AValue: String);
    procedure SetIdIRCUserMode(AValue: TIdIRCUserModes);
    procedure SetIdIRCReplies(AValue: TIdIRCReplies);
    function GetUserMode: String;
    procedure ParseDCC(AContext: TIdContext; const ADCC: String);
    //Command handlers
    procedure DoBeforeCmd(ASender: TIdCommandHandlers; var AData: string; AContext: TIdContext);
    procedure DoReplyUnknownCommand(AContext: TIdContext; ALine: string); override;
    procedure DoBounce(ASender: TIdCommand; ALegacy: Boolean);
    procedure CommandPRIVMSG(ASender: TIdCommand);
    procedure CommandNOTICE(ASender: TIdCommand);
    procedure CommandJOIN(ASender: TIdCommand);
    procedure CommandPART(ASender: TIdCommand);
    procedure CommandKICK(ASender: TIdCommand);
    procedure CommandMODE(ASender: TIdCommand);
    procedure CommandNICK(ASender: TIdCommand);
    procedure CommandQUIT(ASender: TIdCommand);
    procedure CommandSQUIT(ASender: TIdCommand);
    procedure CommandINVITE(ASender: TIdCommand);
    procedure CommandKILL(ASender: TIdCommand);
    procedure CommandPING(ASender: TIdCommand);
    procedure CommandERROR(ASender: TIdCommand);
    procedure CommandWALLOPS(ASender: TIdCommand);
    procedure CommandTOPIC(ASender: TIdCommand);
    procedure CommandWELCOME(ASender: TIdCommand);
    procedure CommandYOURHOST(ASender: TIdCommand);
    procedure CommandCREATED(ASender: TIdCommand);
    procedure CommandMYINFO(ASender: TIdCommand);
    procedure CommandISUPPORT(ASender: TIdCommand);
    procedure CommandBOUNCE(ASender: TIdCommand);
    procedure CommandUSERHOST(ASender: TIdCommand);
    procedure CommandISON(ASender: TIdCommand);
    procedure CommandWHOIS(ASender: TIdCommand);
    procedure CommandENDOFWHOIS(ASender: TIdCommand);
    procedure CommandWHOWAS(ASender: TIdCommand);
    procedure CommandENDOFWHOWAS(ASender: TIdCommand);
    procedure CommandLISTSTART(ASender: TIdCommand);
    procedure CommandLIST(ASender: TIdCommand);
    procedure CommandLISTEND(ASender: TIdCommand);
    procedure CommandAWAY(ASender: TIdCommand);
    procedure CommandINVITING(ASender: TIdCommand);
    procedure CommandSUMMONING(ASender: TIdCommand);
    procedure CommandINVITELIST(ASender: TIdCommand);
    procedure CommandENDOFINVITELIST(ASender: TIdCommand);
    procedure CommandEXCEPTLIST(ASender: TIdCommand);
    procedure CommandENDOFEXCEPTLIST(ASender: TIdCommand);
    procedure CommandWHOREPLY(ASender: TIdCommand);
    procedure CommandENDOFWHO(ASender: TIdCommand);
    procedure CommandNAMEREPLY(ASender: TIdCommand);
    procedure CommandENDOFNAMES(ASender: TIdCommand);
    procedure CommandLINKS(ASender: TIdCommand);
    procedure CommandENDOFLINKS(ASender: TIdCommand);
    procedure CommandBANLIST(ASender: TIdCommand);
    procedure CommandENDOFBANLIST(ASender: TIdCommand);
    procedure CommandINFO(ASender: TIdCommand);
    procedure CommandENDOFINFO(ASender: TIdCommand);
    procedure CommandMOTD(ASender: TIdCommand);
    procedure CommandENDOFMOTD(ASender: TIdCommand);
    procedure CommandREHASHING(ASender: TIdCommand);
    procedure CommandUSERSSTART(ASender: TIdCommand);
    procedure CommandUSERS(ASender: TIdCommand);
    procedure CommandENDOFUSERS(ASender: TIdCommand);
    procedure CommandENDOFSTATS(ASender: TIdCommand);
    procedure CommandSERVLIST(ASender: TIdCommand);
    procedure CommandSERVLISTEND(ASender: TIdCommand);
    procedure CommandTIME(ASender: TIdCommand);
    procedure CommandSERVICE(ASender: TIdCommand);
    procedure CommandVERSION(ASender: TIdCommand);
    procedure CommandCHANMODE(ASender: TIdCommand);
    procedure CommandOPER(ASender: TIdCommand);
    procedure CommandNICKINUSE(ASender: TIdCommand);
    //
    procedure AssignIRCClientCommands;
    function GetCmdHandlerClass: TIdCommandHandlerClass; override;
    procedure SetIOHandler(AValue: TIdIOHandler); override;
    procedure InitComponent; override;
  public
    destructor Destroy; override;
    //
    procedure Connect; override;
    procedure Disconnect(const AReason: String = ''); reintroduce;
    //
    function IsChannel(const AChannel: String): Boolean;
    function IsOp(const ANickname: String): Boolean;
    function IsVoice(const ANickname: String): Boolean;
    procedure Raw(const ALine: String);
    procedure Say(const ATarget, AMsg: String);
    procedure Notice(const ATarget, AMsg: String);
    procedure Action(const ATarget, AMsg: String);
    procedure CTCPQuery(const ATarget, ACommand, AParameters: String);
    procedure CTCPReply(const ATarget, ACTCP, AReply: String);
    procedure Join(const AChannel: String; const AKey: String ='');
    procedure Part(const AChannel: String; const AReason: String = '');
    procedure Kick(const AChannel, ANickname: String; const AReason: String = '');
    procedure SetChannelMode(const AChannel, AMode: String; const AParams: String = '');
    procedure SetUserMode(const ANickname, AMode: String);
    procedure GetChannelTopic(const AChannel: String);
    procedure SetChannelTopic(const AChannel, ATopic: String);
    procedure SetAway(const AMsg: String);
    procedure Op(const AChannel, ANickname: String);
    procedure Deop(const AChannel, ANickname: String);
    procedure Voice(const AChannel, ANickname: String);
    procedure Devoice(const AChannel, ANickname: String);
    procedure Ban(const AChannel, AHostmask: String);
    procedure Unban(const AChannel, AHostmask: String);
    procedure RegisterService(const ANickname, ADistribution, AInfo: String; AType: Integer);
    procedure ListChannelNicknames(const AChannel: String; const ATarget: String = '');
    procedure ListChannel(const AChannel: String; const ATarget: String = '');
    procedure Invite(const ANickname, AChannel: String);
    procedure GetMessageOfTheDay(const ATarget: String = '');
    procedure GetNetworkStatus(const AHostMask: String = ''; const ATarget: String = '');
    procedure GetServerVersion(const ATarget: String = '');
    procedure GetServerStatus(AQuery: TIdIRCStat; const ATarget: String = '');
    procedure ListKnownServerNames(const ARemoteHost: String = ''; const AHostMask: String = '');
    procedure QueryServerTime(const ATarget: String = '');
    procedure RequestServerConnect(const ATargetHost: String; APort: Integer; const ARemoteHost: String = '');
    procedure TraceServer(const ATarget: String = '');
    procedure GetAdminInfo(const ATarget: String = '');
    procedure GetServerInfo(const ATarget: String = '');
    procedure ListNetworkServices(const AHostMask: String = ''; const AType: String = '');
    procedure QueryService(const AServiceName, AMessage: String);
    procedure Who(const AMask: String; AOnlyAdmins: Boolean);
    procedure WhoIs(const AMask: String; const ATarget: String = '');
    procedure WhoWas(const ANickname: String; ACount: Integer = -1; const ATarget: String = '');
    procedure Kill(const ANickname, AComment: String);
    procedure Ping(const AServer1: String; const AServer2: String = '');
    procedure Pong(const AServer1: String; const AServer2: String = '');
    procedure Error(const AMessage: String);
    procedure ReHash;
    procedure Die;
    procedure Restart;
    procedure Summon(const ANickname: String; const ATarget: String = ''; const AChannel: String = '');
    procedure ListServerUsers(const ATarget: String = '');
    procedure SayWALLOPS(const AMessage: String);
    procedure GetUserInfo(const ANickname: String);
    procedure GetUsersInfo(const ANicknames: array of String);
    procedure IsOnIRC(const ANickname: String); overload;
    procedure IsOnIRC(const ANicknames: array of String); overload;
    procedure BecomeOp(const ANickname, APassword: String);
    procedure SQuit(const AHost, AComment: String);
    procedure SetChannelLimit(const AChannel: String; ALimit: Integer);
    procedure SetChannelKey(const AChannel, AKey: String);
    //
    property Away: Boolean read FUserAway;
  published
    property Nickname: String read FNickname write SetNickname;
    property AltNickname: String read FAltNickname write FAltNickname;
    property UsedNickname: String read GetUsedNickname; // returns Nickname or AltNickname
    property Username: String read FUsername write SetUsername;
    property RealName: String read FRealName write FRealName;
    property Password: String read FPassword write FPassword;
    property Port default IdPORT_IRC;
    property Replies: TIdIRCReplies read FReplies write SetIdIRCReplies;
    property UserMode: TIdIRCUserModes read FUserMode write SetIdIRCUserMode;
    { Events }
    property OnServerWelcome: TIdIRCServerMsgEvent read FOnSWelcome write FOnSWelcome;
    property OnYourHost: TIdIRCServerMsgEvent read FOnYourHost write FOnYourHost;
    property OnServerCreated: TIdIRCServerMsgEvent read FOnSCreated write FOnSCreated;
    property OnMyInfo: TIdIRCMyInfoEvent read FOnMyInfo write FOnMyInfo;
    property OnBounce: TIdIRCBounceEvent read FOnBounce write FOnBounce;
    property OnISupport: TIdIRCISupportEvent read FOnISupport write FOnISupport;
    property OnPingPong: TIdIRCPingPongEvent read FOnPingPong write FOnPingPong;
    property OnPrivateMessage: TIdIRCPrivMessageEvent read FOnPrivMessage write FOnPrivMessage;
    property OnNotice: TIdIRCNoticeEvent read FOnNotice write FOnNotice;
    property OnRehash: TIdIRCRehashEvent read FOnRehash write FOnRehash;
    property OnSummon: TIdIRCSummonEvent read FOnSummon write FOnSummon;
    property OnWallops: TIdIRCWallopsEvent read FOnWallops write FOnWallops;
    property OnIsOnIRC: TIdIRCIsOnIRCEvent read FOnIsOnIRC write FOnIsOnIRC;
    property OnAway: TIdIRCAwayEvent read FOnAway write FOnAway;
    property OnJoin: TIdIRCJoinEvent read FOnJoin write FOnJoin;
    property OnPart: TIdIRCPartEvent read FOnPart write FOnPart;
    property OnTopic: TIdIRCTopicEvent read FOnTopic write FOnTopic;
    property OnKick: TIdIRCKickEvent read FOnKick write FOnKick;
    property OnMOTD: TIdIRCMOTDEvent read FOnMOTD write FOnMOTD;
    property OnTrace: TIdIRCServerTraceEvent read FOnTrace write FOnTrace;
    property OnOp: TIdIRCOpEvent read FOnOp write FOnOp;
    property OnInviting: TIdIRCInvitingEvent read FOnInviting write FOnInviting;
    property OnInvite: TIdIRCInviteEvent read FOnInvite write FOnInvite;
    property OnBanListReceived: TIdIRCChanBANListEvent read FOnBANList write FOnBANList;
    property OnExceptionListReceived: TIdIRCChanEXCListEvent read FOnEXCList write FOnEXCList;
    property OnInvitationListReceived: TIdIRCChanINVListEvent read FOnINVList write FOnINVList;
    property OnServerListReceived: TIdIRCServerListEvent read FOnSvrList write FOnSvrList;
    property OnNicknamesListReceived: TIdIRCNickListEvent read FOnNickList write FOnNickList;
    property OnServerUsersListReceived: TIdIRCServerUsersEvent read FOnSvrUsers write FOnSvrUsers;
    property OnServerStatsReceived: TIdIRCServerStatsEvent read FOnSvrStats write FOnSvrStats;
    property OnKnownServersListReceived: TIdIRCKnownServerNamesEvent read FOnKnownSvrs write FOnKnownSvrs;
    property OnAdminInfoReceived: TIdIRCAdminInfoRecvEvent read FOnAdminInfo write FOnAdminInfo;
    property OnUserInfoReceived: TIdIRCUserInfoRecvEvent read FOnUserInfo write FOnUserInfo;
    property OnWho: TIdIRCWhoEvent read FOnWho write FOnWho;
    property OnWhoIs: TIdIRCWhoIsEvent read FOnWhoIs write FOnWhoIs;
    property OnWhoWas: TIdIRCWhoWasEvent read FOnWhoWas write FOnWhoWas;
    property OnChannelMode: TIdIRCChanModeEvent read FOnChanMode write FOnChanMode;
    property OnUserMode: TIdIRCUserModeEvent read FOnUserMode write FOnUserMode;
    property OnCTCPQuery: TIdIRCCTCPQueryEvent read FOnCTCPQry write FOnCTCPQry;
    property OnCTCPReply: TIdIRCCTCPReplyEvent read FOnCTCPRep write FOnCTCPRep;
    property OnDCCChat: TIdIRCDCCChatEvent read FOnDCCChat write FOnDCCChat;
    property OnDCCSend: TIdIRCDCCSendEvent read FOnDCCSend write FOnDCCSend;
    property OnDCCResume: TIdIRCDCCResumeEvent read FOnDCCResume write FOnDCCResume;
    property OnDCCAccept: TIdIRCDCCAcceptEvent read FOnDCCAccept write FOnDCCAccept;
    property OnServerError: TIdIRCServerErrorEvent read FOnServerError write FOnServerError;
    property OnNicknameError: TIdIRCNickErrorEvent read FOnNickError write FOnNickError;
    property OnKillError: TIdIRCKillErrorEvent read FOnKillError write FOnKillError;
    property OnNicknameChange: TIdIRCNicknameChangedEvent read FOnNickChange write FOnNickChange;
    property OnKill: TIdIRCKillEvent read FOnKill write FOnKill;
    property OnQuit: TIdIRCQuitEvent read FOnQuit write FOnQuit;
    property OnServerQuit: TIdIRCSvrQuitEvent read FOnSvrQuit write FOnSvrQuit;
    property OnServerTime: TIdIRCSvrTimeEvent read FOnSvrTime write FOnSvrTime;
    property OnService: TIdIRCServiceEvent read FOnService write FOnService;
    property OnServerVersion: TIdIRCSvrVersionEvent read FOnSvrVersion write FOnSvrVersion;
    property OnRaw: TIdIRCRawEvent read FOnRaw write FOnRaw;
  end;

implementation

uses
  IdGlobalProtocols, IdResourceStringsProtocols, IdSSL,
  IdStack, IdBaseComponent, SysUtils;

const
  IdIRCCTCP: array[0..11] of String = ('ACTION', 'SOUND', 'PING', 'FINGER', {do not localize}
    'USERINFO', 'VERSION', 'CLIENTINFO', 'TIME', 'ERROR', 'DCC', 'SED', 'ERRMSG');  {do not localize}

  MQuote = #16;
  XDelim = #1;
  XQuote = #92;

{ TIdIRCReplies }

constructor TIdIRCReplies.Create;
begin
  inherited Create;
  //
end;

procedure TIdIRCReplies.Assign(Source: TPersistent);
var
  LSource: TIdIRCReplies;
begin
  if Source is TIdIRCReplies then
  begin
    LSource := TIdIRCReplies(Source);
    FFinger := LSource.Finger;
    FFinger := LSource.Finger;
    FVersion := LSource.Version;
    FUserInfo := LSource.UserInfo;
    FClientInfo := LSource.ClientInfo;
  end else begin
    inherited Assign(Source);
  end;
end;

{ TIdIRC }

// RLebeau 1/7/2010: SysUtils.TrimLeft() removes all characters < #32, but
// CTC requires character #1, so don't remove that character when parsing
// IRC parameters in FetchIRCParam()...
//
function IRCTrimLeft(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') and (S[I] <> XDelim) do begin
    Inc(I);
  end;
  Result := Copy(S, I, Maxint);
end;

function FetchIRCParam(var S: String): String;
var
  LTmp: String;
begin
  LTmp := IRCTrimLeft(S);
  if TextStartsWith(LTmp, ':') then
  begin
    Result := Copy(LTmp, 2, MaxInt);
    S := '';
  end else
  begin
    Result := Fetch(LTmp, ' ');
    S := IRCTrimLeft(LTmp);
  end;
end;

function IRCQuote(const S: String): String;
begin
  // IMPORTANT! MQuote needs to be the first character in the replacement
  // list, otherwise it will end up being double-escaped if the other
  // character get replaced, which will produce the wrong output!!
  Result := StringsReplace(S, [MQuote, #0, LF, CR], [MQuote+MQuote, MQuote+'0', MQuote+'n', MQuote+'r']);
end;

{$IFDEF STRING_IS_IMMUTABLE}
function FindCharInSB(const ASB: TIdStringBuilder; AChar: Char; AStart: Integer): Integer;
begin
  for Result := AStart to ASB.Length-1 do begin
    if ASB[Result] = AChar then begin
      Exit;
    end;
  end;
  Result := -1;
end;
{$ENDIF}

function IRCUnquote(const S: String): String;
var
  I, L: Integer;
  {$IFDEF STRING_IS_IMMUTABLE}
  LSB: TIdStringBuilder;
  {$ENDIF}

begin
  {$IFDEF STRING_IS_IMMUTABLE}
  LSB := TIdStringBuilder.Create(S);
  L := LSB.Length;
  I := 0;
  while I < L do begin
    I := FindCharInSB(LSB, MQuote, I);
    if I = -1 then begin
      Break;
    end;
    LSB.Remove(I, 1);
    Dec(L);
    if I >= L then begin
      Break;
    end;
    case LSB[I] of
      '0': LSB[I] := #0;
      'n': LSB[I] := LF;
      'r': LSB[I] := CR;
    end;
    Inc(I);
  end;
  Result := LSB.ToString;
  {$ELSE}
  Result := S;
  L := Length(Result);
  I := 1;
  while I <= L do begin
    I := PosIdx(MQuote, Result, I);
    if I = 0 then begin
      Break;
    end;
    IdDelete(Result, I, 1);
    Dec(L);
    if I > L then begin
      Break;
    end;
    case Result[I] of
      '0': Result[I] := #0;
      'n': Result[I] := LF;
      'r': Result[I] := CR;
    end;
    Inc(I);
  end;
  {$ENDIF}
end;

function CTCPQuote(const S: String): String;
begin
  Result := StringsReplace(S, [XDelim, XQuote], [XQuote+'a', XQuote+XQuote]);
end;

function CTCPUnquote(const S: String): String;
var
  I, L: Integer;
  {$IFDEF STRING_IS_IMMUTABLE}
  LSB: TIdStringBuilder;
  {$ENDIF}
begin
  {$IFDEF STRING_IS_IMMUTABLE}
  LSB := TIdStringBuilder.Create(S);
  L := LSB.Length;
  I := 0;
  while I < L do begin
    I := FindCharInSB(LSB, XQuote, I);
    if I = -1 then begin
      Break;
    end;
    LSB.Remove(I, 1);
    Dec(L);
    if I >= L then begin
      Break;
    end;
    if LSB[I] = 'a' then begin
      LSB[I] := XDelim;
    end;
    Inc(I);
  end;
  Result := LSB.ToString;
  {$ELSE}
  Result := S;
  L := Length(Result);
  I := 1;
  while I <= L do begin
    I := PosIdx(XQuote, Result, I);
    if I = 0 then begin
      Break;
    end;
    IdDelete(Result, I, 1);
    Dec(L);
    if I > L then begin
      Break;
    end;
    if Result[I] = 'a' then begin
      Result[I] := XDelim;
    end;
    Inc(I);
  end;
  {$ENDIF}
end;

procedure ExtractCTCPs(var AText: String; CTCPs: TStrings);
var
  LTmp: String;
  I, J, K: Integer;
begin
  I := 1;
  repeat
    J := PosIdx(XDelim, AText, I);
    if J = 0 then begin
      Break;
    end;
    K := PosIdx(XDelim, AText, J+1);
    if K = 0 then begin
      Break;
    end;
    LTmp := Copy(AText, J+1, K-J-1);
    LTmp := CTCPUnquote(LTmp);
    CTCPs.Add(LTmp);
    IdDelete(AText, J, (K-J)+1);
    I := J;
  until False;
end;

type
  TIdIRCCommandHandler = class(TIdCommandHandler)
  public
    procedure DoParseParams(AUnparsedParams: string; AParams: TStrings); override;
  end;

procedure TIdIRCCommandHandler.DoParseParams(AUnparsedParams: string; AParams: TStrings);
begin
  AParams.Clear;
  while AUnparsedParams <> '' do begin
    AParams.Add(FetchIRCParam(AUnparsedParams));
  end;
end;

function TIdIRC.GetCmdHandlerClass: TIdCommandHandlerClass;
begin
  Result := TIdIRCCommandHandler;
end;

procedure TIdIRC.InitComponent;
begin
  inherited InitComponent;
  //
  FReplies := TIdIRCReplies.Create;
  Port := IdPORT_IRC;
  FUserMode := [];

  // RLebeau 2/21/08: for the IRC protocol, RFC 2812 section 2.4 says that
  // clients are not allowed to issue numeric replies for server-issued
  // commands.  Added the PerformReplies property so TIdIRC can specify
  // that behavior.
  CommandHandlers.PerformReplies := False;

  // RLebeau 3/11/08: most of the command handlers should parse parameters by default
  CommandHandlers.ParseParamsDefault := True;

  if not IsDesignTime then begin
    AssignIRCClientCommands;
  end;
end;

destructor TIdIRC.Destroy;
begin
  FreeAndNil(FReplies);
  FreeAndNil(FBans);
  FreeAndNil(FExcepts);
  FreeAndNil(FInvites);
  FreeAndNil(FLinks);
  FreeAndNil(FMotd);
  FreeAndNil(FNames);
  FreeAndNil(FWho);
  FreeAndNil(FWhoIs);
  FreeAndNil(FWhoWas);
  FreeAndNil(FSvrList);
  FreeAndNil(FUsers);
  inherited Destroy;
end;

function TIdIRC.GetUserMode: String;
const
  IdIRCUserModeChars: array[TIdIRCUserMode] of Char = ('a', 'i', 'w', 'r', 'o', 'O', 's'); {do not localize}
var
  i: TIdIRCUserMode;
begin
  if FUserMode <> [] then
  begin
    Result := '+';
    for i := amAway to amReceiveServerNotices do begin
      if i in FUserMode then begin
        Result := Result + IdIRCUserModeChars[i];
      end;
    end;
  end else begin
    Result := '0';
  end;
end;

procedure TIdIRC.Connect;
begin
  // I doubt that there is explicit SSL support in the IRC protocol
  if (IOHandler is TIdSSLIOHandlerSocketBase) then begin
    (IOHandler as TIdSSLIOHandlerSocketBase).PassThrough := False;
  end;
  inherited Connect;
  //
  try
    FAltNickUsed := False;
    if FPassword <> '' then begin
      Raw(IndyFormat('PASS %s', [FPassword]));  {do not localize}
    end;
    SetNickname(FNickname);
    SetUsername(FUsername);
  except
    on E: EIdSocketError do begin
      inherited Disconnect;
      raise EIdIRCError.Create(RSIRCCannotConnect);
    end;
  end;
end;

procedure TIdIRC.Disconnect(const AReason: String = '');
begin
  Raw(IndyFormat('QUIT :%s', [AReason])); {do not localize}
  inherited Disconnect;
end;

procedure TIdIRC.Raw(const ALine: String);
begin
  if Connected then begin
    if Assigned(FOnRaw) then begin
      FOnRaw(nil, False, ALine);
    end;
    IOHandler.WriteLn(IRCQuote(ALine));
  end;
end;

procedure TIdIRC.AssignIRCClientCommands;
var
  LCommandHandler: TIdCommandHandler;
begin
  { Text commands }
  //PRIVMSG Nickname/#channel :message
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'PRIVMSG'; {do not localize}
  LCommandHandler.OnCommand := CommandPRIVMSG;
  LCommandHandler.ParseParams := False;

  //NOTICE Nickname/#channel :message
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'NOTICE';  {do not localize}
  LCommandHandler.OnCommand := CommandNOTICE;
  LCommandHandler.ParseParams := False;

  //JOIN #channel
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'JOIN';  {do not localize}
  LCommandHandler.OnCommand := CommandJOIN;

  //PART #channel
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'PART';  {do not localize}
  LCommandHandler.OnCommand := CommandPART;

  //KICK #channel target :reason
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'KICK';  {do not localize}
  LCommandHandler.OnCommand := CommandKICK;

  //MODE Nickname/#channel +/-modes parameters...
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'MODE';  {do not localize}
  LCommandHandler.OnCommand := CommandMODE;
  LCommandHandler.ParseParams := False;

  //NICK newNickname
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'NICK';  {do not localize}
  LCommandHandler.OnCommand := CommandNICK;

  //QUIT :reason
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'QUIT';  {do not localize}
  LCommandHandler.OnCommand := CommandQUIT;

  //SQUIT server :reason
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'SQUIT';  {do not localize}
  LCommandHandler.OnCommand := CommandSQUIT;

  //INVITE Nickname :#channel
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'INVITE';  {do not localize}
  LCommandHandler.OnCommand := CommandINVITE;

  //KILL Nickname :reason
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'KILL';  {do not localize}
  LCommandHandler.OnCommand := CommandKILL;

  //PING server
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'PING';  {do not localize}
  LCommandHandler.OnCommand := CommandPING;

  //WALLOPS :message
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'WALLOPS'; {do not localize}
  LCommandHandler.OnCommand := CommandWALLOPS;
  LCommandHandler.ParseParams := False;

  //TOPIC
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'TOPIC'; {do not localize}
  LCommandHandler.OnCommand := CommandTOPIC;

  //ERROR message
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := 'ERROR'; {do not localize}
  LCommandHandler.OnCommand := CommandERROR;
  LCommandHandler.ParseParams := False;

  { Numeric commands, refer to http://www.alien.net.au/irc/irc2numerics.html }
  //RPL_WELCOME
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '001'; {do not localize}
  LCommandHandler.OnCommand := CommandWELCOME;
  LCommandHandler.ParseParams := False;

  //RPL_YOURHOST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '002'; {do not localize}
  LCommandHandler.OnCommand := CommandYOURHOST;

  //RPL_CREATED
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '003'; {do not localize}
  LCommandHandler.OnCommand := CommandCREATED;

  //RPL_MYINFO
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '004'; {do not localize}
  LCommandHandler.OnCommand := CommandMYINFO;
  LCommandHandler.ParseParams := False;

  //RPL_BOUNCE (deprecated), RPL_ISUPPORT (new)
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '005'; {do not localize}
  //LCommandHandler.OnCommand := CommandBOUNCE; // deprecated
  LCommandHandler.OnCommand := CommandISUPPORT;

         
                                                   
                           
                              
                         
                                                                                                                    
                                
                                   
                                                                                                                                                                                     
                                                                   
                                                                  
                                                                              
                                                               
                                                           
                                                                                                                                 
                                                                                      
                                                                    
                                                              
                                  
                                                                        
                                                                                                                                              
                                                                                                            
                                                                                          
                                                                                                                                          
                                                                                          
                                                                                              
                              
                           
                     
   
  // RPL_BOUNCE (new)
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '010'; {do not localize}
  LCommandHandler.OnCommand := CommandBOUNCE;

  //RPL_ENDOFSTATS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '219'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFSTATS;

        
                                                                                                                                                                                                         
   
  //RPL_SERVLIST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '234'; {do not localize}
  LCommandHandler.OnCommand := CommandSERVLIST;

  //RPL_SERVLISTEND
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '235'; {do not localize}
  LCommandHandler.OnCommand := CommandSERVLISTEND;

        
                                                    
                                           
                             
                                                                                                
                                                                                                             
                                                                                                                                                                                                                                
                                                                                     
                                              
                                      
                                                                                                                                                                         
                                                                                                    
                                                                                                                     
                                                                                                     
                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                               
                                                                                                
                                                                                                          
                                                                   
                                                                                                                                                                                                                     
                                                                                       
                                                                                         
                               
                         
                             
                      
                         
                              
                        
                          
                    
                    
                      
                                
                              
                                                                                                                                            
   
  //RPL_AWAY
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '301'; {do not localize}
  LCommandHandler.OnCommand := CommandAWAY;

  //RPL_USERHOST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '302'; {do not localize}
  LCommandHandler.OnCommand := CommandUSERHOST;
  LCommandHandler.ParseParams := False;

  //RPL_ISON
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '303'; {do not localize}
  LCommandHandler.OnCommand := CommandISON;

  //RPL_UNAWAY
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '305'; {do not localize}
  LCommandHandler.OnCommand := CommandAWAY;

  //RPL_NOWAWAY
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '306'; {do not localize}
  LCommandHandler.OnCommand := CommandAWAY;

  //RPL_WHOISUSER
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '311'; {do not localize}
  LCommandHandler.OnCommand := CommandWHOIS;

  //RPL_WHOISSERVER
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '312'; {do not localize}
  LCommandHandler.OnCommand := CommandWHOIS;

  //RPL_WHOISOPERATOR
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '313'; {do not localize}
  LCommandHandler.OnCommand := CommandWHOIS;

  //RPL_WHOWASUSER
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '314';
  LCommandHandler.OnCommand := CommandWHOWAS;

  //RPL_ENDOFWHO
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '315'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFWHO;

  //RPL_WHOISIDLE
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '317'; {do not localize}
  LCommandHandler.OnCommand := CommandWHOIS;

  //RPL_ENDOFWHOIS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '318'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFWHOIS;

  //RPL_WHOISCHANNELS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '319'; {do not localize}
  LCommandHandler.OnCommand := CommandWHOIS;

        
                             
                                   
                               
   
  //RPL_LISTSTART
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '321'; {do not localize}
  LCommandHandler.OnCommand := CommandLISTSTART;

  //RPL_LIST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '322'; {do not localize}
  LCommandHandler.OnCommand := CommandLIST;

  //RPL_LISTEND
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '323'; {do not localize}
  LCommandHandler.OnCommand := CommandLISTEND;

  //RPL_CHANMODEIS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '324'; {do not localize}
  LCommandHandler.OnCommand := CommandCHANMODE;

  //RPL_UNIQOPIS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '325'; {do not localize}
  //LCommandHandler.OnCommand := CommandUNIQOP;

        
                     
                        
                                        
                                
   
  //RPL_NOTOPIC
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '331'; {do not localize}
  LCommandHandler.OnCommand := CommandTOPIC;

  //RPL_TOPIC
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '332';
  LCommandHandler.OnCommand := CommandTOPIC;

        
                             
                      
                       
   
  //RPL_INVITING
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '341'; {do not localize}
  LCommandHandler.OnCommand := CommandINVITING;

  //RPL_SUMMONING
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '342'; {do not localize}
  LCommandHandler.OnCommand := CommandSUMMONING;

        
                                                                                                                                                                                                                      
   
  //RPL_INVITELIST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '346'; {do not localize}
  LCommandHandler.OnCommand := CommandINVITELIST;

  //RPL_ENDOFINVITELIST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '347'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFINVITELIST;

  //RPL_EXCEPTLIST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '348'; {do not localize}
  LCommandHandler.OnCommand := CommandEXCEPTLIST;

  //RPL_ENDOFEXCEPTLIST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '349'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFEXCEPTLIST;

  //RPL_VERSION
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '351'; {do not localize}
  LCommandHandler.OnCommand := CommandVERSION;

  //RPL_WHOREPLY
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '352'; {do not localize}
  LCommandHandler.OnCommand := CommandWHOREPLY;

  //RPL_NAMEREPLY
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '353'; {do not localize}
  LCommandHandler.OnCommand := CommandNAMEREPLY;

         
                                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                      
   
  //RPL_LINKS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '364'; {do not localize}
  LCommandHandler.OnCommand := CommandLINKS;

  //RPL_ENDOFLINKS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '365'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFLINKS;

  //RPL_ENDOFNAMES
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '366'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFNAMES;

  // RPL_BANLIST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '367'; {do not localize}
  LCommandHandler.OnCommand := CommandBANLIST;

  //RPL_ENDOFBANLIST
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '368'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFBANLIST;

  //RPL_ENDOFWHOWAS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '369'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFWHOWAS;

  //RPL_INFO
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '371'; {do not localize}
  LCommandHandler.OnCommand := CommandINFO;

  //RPL_MOTD
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '372'; {do not localize}
  LCommandHandler.OnCommand := CommandMOTD;

  //RPL_ENDOFINFO
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '374'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFINFO;
  LCommandHandler.ParseParams := False;

  //RPL_MOTDSTART
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '375'; {do not localize}
  LCommandHandler.OnCommand := CommandMOTD;

  //RPL_ENDOFMOTD
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '376'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFMOTD;

  //RPL_YOUREOPER
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '381'; {do not localize}
  //LCommandHandler.OnCommand := CommandYOUAREOPER;

  //RPL_REHASHING
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '382'; {do not localize}
  LCommandHandler.OnCommand := CommandREHASHING;

  //RPL_YOUARESERVICE
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '383'; {do not localize}
  LCommandHandler.OnCommand := CommandSERVICE;

        
                                                  
                        
                             
   
  //RPL_TIME
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '391'; {do not localize}
  LCommandHandler.OnCommand := CommandTIME;

  //RPL_USERSSTART
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '392'; {do not localize}
  LCommandHandler.OnCommand := CommandUSERSSTART;

  //RPL_USERS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '393'; {do not localize}
  LCommandHandler.OnCommand := CommandUSERS;

  //RPL_ENDOFUSERS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '394'; {do not localize}
  LCommandHandler.OnCommand := CommandENDOFUSERS;

  //RPL_NOUSERS
  LCommandHandler := CommandHandlers.Add;
  LCommandHandler.Command := '395'; {do not localize}
  LCommandHandler.OnCommand := CommandUSERS;

  //ERR_NICKNAMEINUSE
  LCommandHandler := CommandHandlers.Add;
  // 433  ERR_NICKNAMEINUSE  RFC1459  <nick> :<reason>
  // Returned by the NICK command when the given nickname is already in use
  LCommandHandler.Command := '433'; {do not localize}
  LCommandHandler.OnCommand := CommandNICKINUSE;

        
                                                                                                       
                                                                                                                                                                          
                                                                                                                                   
                                                                                                                    
                                                                                                                             
                                                                                                                                     
                                                                                                                                                                            
                                                                                                                                         
                                                                                                                                               
                                                                                                                                                                            
                                                                                                                                                                      
                                                                                              
                                                                                                       
                                                                                                                                                                  
                                                                                                                                                  
                                                                                                                 
                                                                                                                                                                                                                                                                    
                                                          
                                 
                                                                                                                                                              
                                                                                    
                                                                                                                                                                                                                                                                                                                
                                                                                                                                         
                             
                               
                                                                                                                                                     
                                                                                                                     
                                                                                                                                                                                                                                                                                                                                  
                                                                                                                          
                                                                                                      
                                        
                                                                                                                                                                    
                                                                                                                                                                                   
                                                                                                                                                
                                                                                                                                           
                                                                                                                
                                                                                                              
                                   
                                                                                                                                  
                                                                                                                                                                            
                           
                        
                                  
                          
                      
                         
                                                                            
                                    
                                                                                                                                                                   
                                                                                                                       
                                                                                                                                                                                    
                                                                                                                                                                   
                                                                                                                                                               
                                                                                                                          
                                                                                                                   
                                
                                                    
                              
                                  
                                    
                                                                                                                                        
                                                                                          
                                                                                                                                                
                                                                                                                         
                                                                                                                                                          
                                                                                        
                                                                                                                                                   
                              
                           
                                                                                                                                                               
                                                                                                                                                                                         
                                                                                                    
                                                                                                                                                                                                          
                             
                                                                                                                                                                              
                              
                           
                           
                          
                            
                            
                                                                                                                                                
                                                                                                                                                                                         
                                                                                                                                             
                                
                        
                             
                                                                                                    
                                                                                                                                                                                
                              
                          
                                                   
                             
                                
                                                                       
                                                                           
                                
                                
                               
                                 
                                  
                                    
                                     
                                 
                                  
                                     
                                          
                               
                            
                              
                                
                  
                                   
                          
                          
                             
                                  
                                                                                                                                                                     
                                                                                                                              
                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                               
                                                                                                                                                                                                                    
                                                                                                                         
                                                                                                                                                                                                   
                                                                                                                                                                                                                 
                                                                                                                                                                        
                                                                                                                                         
                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                       
                                                                                                                                         
                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                      
                                                                              
                                                                   
                                                                             
                                                                       
                                                                           
                                                                                               
                                                                                       
                                                                                                         
                                                                                            
                                                                                                                                  
                                                                                                                               
                                                                                                                                                   
                                                                                                 
                                                                                                                 
                                                                                                                                                                             
                                                                                                                                                                                                                                                                        
                                                                                          
                                                                               
                                                                  
                                                                                                                                                    
                                                                                                                                                     
                                                                                                                                          
                                                                                                                      
                                                                                                                                                                              
                                                              
                                                                  
                                                                                                                                                                                                                           
                                                                                                                    
                                                                                                                          
                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                             
                                                                                                                                               
                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                         
                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                     
                                 
   

  FCommandHandlers.OnBeforeCommandHandler := DoBeforeCmd;
end;

{ Command handlers }

procedure TIdIRC.DoBeforeCmd(ASender: TIdCommandHandlers; var AData: string; AContext: TIdContext);
var
  LTmp: String;
begin
  AData := IRCUnquote(AData);
  // ":nickname!user@host"
  if TextStartsWith(AData, ':') then begin
    LTmp := Fetch(AData, ' ');
    Delete(LTmp, 1, 1); // remove ':'
    FSenderNick := Fetch(LTmp, '!');
    FSenderHost := LTmp;
  end else begin
    FSenderNick := '';
    FSenderHost := '';
  end;
  if Assigned(FOnRaw) then begin
    FOnRaw(AContext, True, AData);
  end;
end;

procedure TIdIRC.DoReplyUnknownCommand(AContext: TIdContext; ALine: string);
var
  ACmdCode: Integer;
begin
  ACmdCode := IndyStrToInt(Fetch(ALine, ' '), -1);
  //
  case ACmdCode of
    6,
    7:
      begin
        //MAP
      end;
    5,
    400..424,
    437..502:
      begin
        if Assigned(FOnServerError) then begin
          OnServerError(AContext, ACmdCode, ALine);
        end;
      end;
    431..432,
    436:
      begin
        if Assigned(FOnNickError) then begin
          OnNicknameError(AContext, ACmdCode);
        end;
      end;
  end;
end;

procedure TIdIRC.CommandPRIVMSG(ASender: TIdCommand);
var
  LTmp, LTarget, LData, LCTCP: String;
  I: Integer;
  CTCPList: TStringList;
begin
  LTmp := ASender.UnparsedParams;
  LTarget := FetchIRCParam(LTmp);
  LData := FetchIRCParam(LTmp);

  CTCPList := TStringList.Create;
  try
    ExtractCTCPs(LData, CTCPList);
    if CTCPList.Count = 0 then begin
      if Assigned(FOnPrivMessage) then begin
        OnPrivateMessage(ASender.Context, FSenderNick, FSenderHost, LTarget, LData);
      end;
    end else
    begin
      if (LData <> '') and Assigned(FOnPrivMessage) then begin
        OnPrivateMessage(ASender.Context, FSenderNick, FSenderHost, LTarget, LData);
      end;
      for I := 0 to CTCPList.Count - 1 do begin
        LData := CTCPList[I];
        LCTCP := Fetch(LData, ' ');
        case PosInStrArray(LCTCP, IdIRCCTCP) of
          0: { ACTION }
            begin
              {
              if Assigned(FOnAction) then begin
                FOnAction(ASender.Context, FSenderNick, FSenderHost, LTarget, LData);
              end;
              }
              if Assigned(FOnCTCPQry) then begin
                FOnCTCPQry(ASender.Context, FSenderNick, FSenderHost, LTarget, LCTCP, LData);
              end;
              // RLebeau: CTCP ACTION does not send a reply back
              //CTCPReply(FSenderNick, 'ERRMSG', LCTCP +' ' + LData + ' unknown query'); {do not localize}
            end;
          1: { SOUND }
            begin
              {
              if Assigned(FOnSound) then begin
                FOnSound(ASender.Context, FSenderNick, FSenderHost, LTarget, LData);
              end;
              }
              if Assigned(FOnCTCPQry) then begin
                FOnCTCPQry(ASender.Context, FSenderNick, FSenderHost, LTarget, LCTCP, LData);
              end;
              CTCPReply(FSenderNick, 'ERRMSG', LCTCP +' ' + LData + ' unknown query'); {do not localize}
            end;
          2: { PING }
            begin
              {
              LTmp := '';
              if Assigned(FOnPing) then begin
                FOnPing(ASender.Context, LTmp);
              end;
              if LTmp = '' then begin
                LTmp := DateTimeToStr(Now);
              end;
              CTCPReply(FSenderNick, LCTCP, ':' + LTmp);
              }
              if Assigned(FOnCTCPQry) then begin
                FOnCTCPQry(ASender.Context, FSenderNick, FSenderHost, LTarget, LCTCP, LData);
              end;
              // AWinkelsdorf 3/10/2010 ToDo: CTCP Ping might need a CTIME result but
              // many clients do not send the required CTIME with the Ping Query...
              CTCPReply(FSenderNick, LCTCP, DateTimeToStr(Now)); {do not localize}
            end;
          3: { FINGER }
            begin
              CTCPReply(FSenderNick, LCTCP, Replies.Finger); {do not localize}
            end;
          4: { USERINFO }
            begin
              CTCPReply(FSenderNick, LCTCP, Replies.UserInfo); {do not localize}
            end;
          5: { VERSION }
            begin
              CTCPReply(FSenderNick, LCTCP, Replies.Version); {do not localize}
            end;
          6: { CLIENTINFO }
            begin
                                                                                
              CTCPReply(FSenderNick, LCTCP, Replies.ClientInfo); {do not localize}
            end;
          7: { TIME }
            begin
              CTCPReply(FSenderNick, LCTCP, DateTimeToStr(Now));
            end;
          8: { ERROR }
            begin
              CTCPReply(FSenderNick, LCTCP, LData + ' No Error'); {do not localize}
            end;
          9: { DCC }
            begin
              ParseDCC(ASender.Context, LData);
            end;
          10: { SED }
            begin
              //ParseSED(AContext, LData);
              if Assigned(FOnCTCPQry) then begin
                FOnCTCPQry(ASender.Context, FSenderNick, FSenderHost, LTarget, LCTCP, LData);
              end;
              CTCPReply(FSenderNick, LCTCP, LData + ' unknown query'); {do not localize}
            end;
          11: { ERRMSG }
            begin
              CTCPReply(FSenderNick, LCTCP, LData + ' No Error'); {do not localize}
            end;
          else
            begin
              if Assigned(FOnCTCPQry) then begin
                FOnCTCPQry(ASender.Context, FSenderNick, FSenderHost, LTarget, LCTCP, LData);
              end;
              CTCPReply(FSenderNick, LCTCP, LData + ' unknown query'); {do not localize}
            end;
        end;
      end;
    end;
  finally
    CTCPList.Free;
  end;
end;

procedure TIdIRC.CommandNOTICE(ASender: TIdCommand);
var
  LTmp, LTarget, LData, LCTCP: String;
  I: Integer;
  CTCPList: TStringList;
begin
  LTmp := ASender.UnparsedParams;
  LTarget := FetchIRCParam(LTmp);
  LData := FetchIRCParam(LTmp);

  CTCPList := TStringList.Create;
  try
    ExtractCTCPs(LData, CTCPList);
    if CTCPList.Count = 0 then begin
      if Assigned(FOnNotice) then begin
        OnNotice(ASender.Context, FSenderNick, FSenderHost, LTarget, LData);
      end;
    end else
    begin
      if (LData <> '') and Assigned(FOnNotice) then begin
        OnNotice(ASender.Context, FSenderNick, FSenderHost, LTarget, LData);
      end;
      for I := 0 to CTCPList.Count - 1 do begin
        LData := CTCPList[I];
        LCTCP := Fetch(LData, ' ');
        case PosInStrArray(LCTCP, IdIRCCTCP) of
          0: { ACTION }
            begin
              {
              if Assigned(FOnAction) then begin
                FOnAction(ASender.Context, FSenderNick, FSenderHost, LTarget, LData);
              end;
              }
              if Assigned(FOnCTCPRep) then begin
                FOnCTCPRep(ASender.Context, FSenderNick, FSenderHost, LTarget, LCTCP, LData);
              end;
            end;
          9: { DCC }
            begin
              ParseDCC(ASender.Context, LData);
            end;
          10: { SED }
            begin
              //ParseSED(AContext, LData);
              if Assigned(FOnCTCPRep) then begin
                FOnCTCPRep(ASender.Context, FSenderNick, FSenderHost, LTarget, LCTCP, LData);
              end;
            end;
        else
          if Assigned(FOnCTCPRep) then begin
            FOnCTCPRep(ASender.Context, FSenderNick, FSenderHost, LTarget, LCTCP, LData);
          end;
        end;
      end;
    end;
  finally
    CTCPList.Free;
  end;
end;

procedure TIdIRC.CommandJOIN(ASender: TIdCommand);
begin
  if Assigned(FOnJoin) then begin
    OnJoin(ASender.Context, FSenderNick, FSenderHost, ASender.Params[0]);
  end;
end;

procedure TIdIRC.CommandPART(ASender: TIdCommand);
var
  LChannel, LMsg: string;
begin
  if Assigned(FOnPart) then begin
    if ASender.Params.Count > 0 then begin
      LChannel := ASender.Params[0];
    end;
    if ASender.Params.Count > 1 then begin
      LMsg := ASender.Params[1];
    end;
    OnPart(ASender.Context, FSenderNick, FSenderHost, LChannel, LMsg);
  end;
end;

procedure TIdIRC.CommandKICK(ASender: TIdCommand);
var
  LChannel, LTarget, LReason: string;
begin
  if Assigned(FOnKick) then begin
    if ASender.Params.Count > 0 then begin
      LChannel := ASender.Params[0];
    end;
    if ASender.Params.Count > 1 then begin
      LTarget := ASender.Params[1];
    end;
    if ASender.Params.Count > 2 then begin
      LReason := ASender.Params[2];
    end;
    OnKick(ASender.Context, FSenderNick, FSenderHost, LChannel, LTarget, LReason);
  end;
end;

procedure TIdIRC.CommandMODE(ASender: TIdCommand);
var
  LTmp, LParam: String;
begin
  LTmp := ASender.UnparsedParams;
  LParam := FetchIRCParam(LTmp);
  if IsChannel(LParam) then begin
    if Assigned(FOnChanMode) then begin
      OnChannelMode(ASender.Context, FSenderNick, FSenderHost, LParam, LTmp, '');
    end;
  end
  else if Assigned(FOnUserMode) then begin
    OnUserMode(ASender.Context, FSenderNick, FSenderHost, LTmp);
  end;
end;

procedure TIdIRC.CommandNICK(ASender: TIdCommand);
begin
  if Assigned(FOnNickChange) then begin
    OnNicknameChange(ASender.Context, FSenderNick, FSenderHost, ASender.Params[0]);
  end;
end;

procedure TIdIRC.CommandQUIT(ASender: TIdCommand);
var
  LReason: string;
begin
  if Assigned(FOnQuit) then begin
    if ASender.Params.Count > 0 then begin
      LReason := ASender.Params[0];
    end;
    OnQuit(ASender.Context, FSenderNick, FSenderHost, LReason);
  end;
end;

procedure TIdIRC.CommandSQUIT(ASender: TIdCommand);
var
  LServer, LComment: string;
begin
  if Assigned(FOnSvrQuit) then begin
    if ASender.Params.Count > 0 then begin
      LServer := ASender.Params[0];
    end;
    if ASender.Params.Count > 1 then begin
      LComment := ASender.Params[1];
    end;
    OnServerQuit(ASender.Context, FSenderNick, FSenderHost, LServer, LComment);
  end;
end;

procedure TIdIRC.CommandINVITE(ASender: TIdCommand);
begin
  if Assigned(FOnInvite) then begin
    OnInvite(ASender.Context, FSenderNick, FSenderHost, ASender.Params[0], ASender.Params[1]);
  end;
end;

procedure TIdIRC.CommandKILL(ASender: TIdCommand);
var
  LTarget, LReason: string;
begin
  if Assigned(FOnKill) then begin
    if ASender.Params.Count > 0 then begin
      LTarget := ASender.Params[0];
    end;
    if ASender.Params.Count > 1 then begin
      LReason := ASender.Params[1];
    end;
    OnKill(ASender.Context, FSenderNick, FSenderHost, LTarget, LReason);
  end;
end;

procedure TIdIRC.CommandPING(ASender: TIdCommand);
var
  LServer1: String;
begin
  if ASender.Params.Count > 0 then begin
    LServer1 := ASender.Params[0];
  end;
  Pong(LServer1);
  if Assigned(FOnPingPong) then begin
    OnPingPong(ASender.Context);
  end;
end;

procedure TIdIRC.CommandWALLOPS(ASender: TIdCommand);
var
  LTmp: string;
begin
  if Assigned(FOnWallops) then begin
    LTmp := ASender.UnparsedParams;
    OnWallops(ASender.Context, FSenderNick, FSenderHost, FetchIRCParam(LTmp));
  end;
end;

procedure TIdIRC.CommandTOPIC(ASender: TIdCommand);
var
  LChannel, LTopic: String;
begin
  if Assigned(FOnTopic) then
  begin
    if ASender.Params.Count > 0 then begin
      LChannel := ASender.Params[0];
    end;
    if (ASender.CommandHandler.Command <> '331') and (ASender.Params.Count > 1) then begin {do not localize}
      LTopic := ASender.Params[1];
    end else begin
      LTopic := '';
    end;
    OnTopic(ASender.Context, FSenderNick, FSenderHost, LChannel, LTopic);
  end;
end;

procedure TIdIRC.CommandWELCOME(ASender: TIdCommand);
var
  LTmp: string;
begin
  if Assigned(FOnSWelcome) then begin
    LTmp := ASender.UnparsedParams;
    OnServerWelcome(ASender.Context, FetchIRCParam(LTmp));
  end;
end;

procedure TIdIRC.CommandERROR(ASender: TIdCommand);
var
  LTmp: String;
begin
  if Assigned(FOnServerError) then begin
    LTmp := ASender.UnparsedParams;
    OnServerError(ASender.Context, 0, FetchIRCParam(LTmp));
  end;
end;

procedure TIdIRC.CommandYOURHOST(ASender: TIdCommand);
var
  LTmp: String;
begin
  if Assigned(FOnYourHost) then begin
    LTmp := ASender.UnparsedParams;
    OnYourHost(ASender.Context, FetchIRCParam(LTmp));
  end;
end;

procedure TIdIRC.CommandCREATED(ASender: TIdCommand);
var
  LTmp: string;
begin
  if Assigned(FOnSCreated) then begin
    LTmp := ASender.UnparsedParams;
    OnServerCreated(ASender.Context, FetchIRCParam(LTmp));
  end;
end;

procedure TIdIRC.CommandMYINFO(ASender: TIdCommand);
var
  LTmp, LServer, LVersion, LUserModes, LChanModes: String;
begin
  if Assigned(FOnMyInfo) then begin
    LTmp := ASender.UnparsedParams;
    LServer := FetchIRCParam(LTmp);
    LVersion := FetchIRCParam(LTmp);
    LUserModes := FetchIRCParam(LTmp);
    LChanModes := FetchIRCParam(LTmp);
                                                                                                           
    OnMyInfo(ASender.Context, LServer, LVersion, LUserModes, LChanModes, LTmp);
  end;
end;

procedure TIdIRC.DoBounce(ASender: TIdCommand; ALegacy: Boolean);
var
  LHost, LPort, LInfo: string;
begin
  if Assigned(FOnBounce) then begin
    if ALegacy then begin
      LInfo := ASender.Params[0];
      LHost := FetchIRCParam(LInfo);
      LPort := FetchIRCParam(LInfo);
    end else
    begin
      LHost := ASender.Params[0];
      LPort := ASender.Params[1];
      if ASender.Params.Count > 2 then begin
        LInfo := ASender.Params[2];
      end;
    end;
                                    
    OnBounce(ASender.Context, LHost, IndyStrToInt(LPort, 0), LInfo);
  end;
end;

procedure TIdIRC.CommandISUPPORT(ASender: TIdCommand);
var
  LParams: TStringList;
  I: Integer;
begin
  if ASender.Params.Count = 1 then begin
    DoBounce(ASender, True); // legacy, deprecated
    Exit;
  end;
  if Assigned(FOnISupport) then
  begin
    LParams := TStringList.Create;
    try
      for I := 1 to ASender.Params.Count-1 do // skip nickname
      begin
        LParams.Add(ASender.Params[I]);
      end;
      OnISupport(ASender.Context, LParams);
    finally
      LParams.Free;
    end;
  end;
end;

procedure TIdIRC.CommandBOUNCE(ASender: TIdCommand);
begin
  DoBounce(ASender, False);
end;

procedure TIdIRC.CommandAWAY(ASender: TIdCommand);
var
  LCmd: Integer;
begin
  LCmd := IndyStrToInt(ASender.CommandHandler.Command, 0);
  case LCmd of
    301:
    begin
      if Assigned(FOnAway) then begin
        OnAway(ASender.Context, FSenderNick, FSenderHost, ASender.Params[0], True);
      end;
    end;
    305, 306:
    begin
      FUserAway := (LCmd = 306);
      if Assigned(FOnAway) then begin
        OnAway(ASender.Context, GetUsedNickname, '', ASender.Params[0], FUserAway);
      end;
    end;
  end;
end;

procedure TIdIRC.CommandUSERHOST(ASender: TIdCommand);
begin
  if Assigned(FOnUserInfo) then begin
    OnUserInfoReceived(ASender.Context, ASender.UnparsedParams);
  end;
end;

procedure TIdIRC.CommandISON(ASender: TIdCommand);
begin
  if Assigned(FOnIsOnIRC) then begin
    OnIsOnIRC(ASender.Context, FSenderNick, FSenderHost);
  end;
end;

procedure TIdIRC.CommandWHOIS(ASender: TIdCommand);
begin
  if not Assigned(FWhoIs) then begin
    FWhoIs := TStringList.Create;
  end;
  FWhoIs.Add(ASender.Params[0]);
end;

procedure TIdIRC.CommandENDOFWHOIS(ASender: TIdCommand);
begin
  CommandWHOIS(ASender);
  if Assigned(FOnWhoIs) then begin
    OnWhoIs(ASender.Context, FWhoIs);
  end;
  FWhoIs.Clear;
end;

procedure TIdIRC.CommandWHOWAS(ASender: TIdCommand);
begin
  if not Assigned(FWhoWas) then begin
    FWhoWas := TStringList.Create;
  end;
  FWhoWas.Add(ASender.Params[0]);
end;

procedure TIdIRC.CommandENDOFWHOWAS(ASender: TIdCommand);
begin
  CommandWHOWAS(ASender);
  if Assigned(FOnWhoWas) then begin
    OnWhoWas(ASender.Context, FWhoWas);
  end;
  FWhoWas.Clear;
end;

procedure TIdIRC.CommandLISTSTART(ASender: TIdCommand);
begin
  if not Assigned(FSvrList) then begin
    FSvrList := TStringList.Create;
  end else begin
    FSvrList.Clear;
  end;
end;

procedure TIdIRC.CommandLIST(ASender: TIdCommand);
begin
  if not Assigned(FSvrList) then begin
    FSvrList := TStringList.Create;
  end;
  FSvrList.Add(ASender.Params[0] + ' ' + ASender.Params[1] + ' ' + ASender.Params[2]); {do not localize}
end;

procedure TIdIRC.CommandLISTEND(ASender: TIdCommand);
begin
  CommandLIST(ASender);
  if Assigned(FOnSvrList) then begin
    OnServerListReceived(ASender.Context, FSvrList);
  end;
  FSvrList.Clear;
end;

procedure TIdIRC.CommandINVITING(ASender: TIdCommand);
begin
  if Assigned(FOnInviting) then begin
    OnInviting(ASender.Context, FSenderNick, FSenderHost);
  end;
end;

procedure TIdIRC.CommandSUMMONING(ASender: TIdCommand);
begin
  if Assigned(FOnSummon) then begin
    OnSummon(ASender.Context, FSenderNick, FSenderHost);
  end;
end;

procedure TIdIRC.CommandINVITELIST(ASender: TIdCommand);
begin
  if not Assigned(FInvites) then begin
    FInvites := TStringList.Create;
  end;
                                   
  FInvites.Add(ASender.Params[0] + ' ' + ASender.Params[1]); {do not localize}
end;

procedure TIdIRC.CommandENDOFINVITELIST(ASender: TIdCommand);
begin
  if not Assigned(FInvites) then begin
    FInvites := TStringList.Create;
  end;
  FInvites.Add(ASender.Params[0]);
  if Assigned(FOnINVList) then begin
    OnInvitationListReceived(ASender.Context, FSenderNick, FInvites);
  end;
  FInvites.Clear;
end;

procedure TIdIRC.CommandEXCEPTLIST(ASender: TIdCommand);
begin
  if not Assigned(FExcepts) then begin
    FExcepts := TStringList.Create;
  end;
                                   
  FExcepts.Add(ASender.Params[0] + ' ' + ASender.Params[1]); {do not localize}
end;

procedure TIdIRC.CommandENDOFEXCEPTLIST(ASender: TIdCommand);
begin
  if not Assigned(FExcepts) then begin
    FExcepts := TStringList.Create;
  end;
  FExcepts.Add(ASender.Params[0]);
  if Assigned(FOnEXCList) then begin
    OnExceptionListReceived(ASender.Context, FSenderNick, FExcepts);
  end;
  FExcepts.Clear;
end;

procedure TIdIRC.CommandWHOREPLY(ASender: TIdCommand);
begin
  if not Assigned(FWho) then begin
    FWho := TStringList.Create;
  end;
  FWho.Add('');        
end;

procedure TIdIRC.CommandENDOFWHO(ASender: TIdCommand);
begin
  if not Assigned(FWho) then begin
    FWho := TStringList.Create;
  end;
  FWho.Add(ASender.Params[0]);
  if Assigned(FOnWho) then begin
    OnWho(ASender.Context, FWho);
  end;
  FWho.Clear;
end;

procedure TIdIRC.CommandNAMEREPLY(ASender: TIdCommand);
var
  i: Integer;
  LNames: string;
  LNameList: TStringList;
begin
  if not Assigned(FNames) then begin
    FNames := TStringList.Create;
  end;
  // AWinkelsdorf 3/10/2010 Rewrote logic to split Names into single Lines of FNames
  if ASender.Params.Count >= 4 then begin // Names are in [3]
    LNames := StringsReplace(ASender.Params[3], [' '], [',']); {do not localize}
    LNameList := TStringList.Create;
    try
      LNameList.CommaText := LNames;
      for i := 0 to LNameList.Count - 1 do
      begin
        if LNameList[i] <> '' then
          FNames.Add(LNameList[i]);
      end;
    finally
      LNameList.Free;
    end;
  end else begin
    FNames.Add(ASender.Params[0]);
  end;
end;

procedure TIdIRC.CommandENDOFNAMES(ASender: TIdCommand);
var
  LChannel: string;
begin
  if not Assigned(FNames) then begin
    FNames := TStringList.Create;
  end;
  LChannel := '';
  if ASender.Params.Count > 0 then begin
    LChannel := ASender.Params[1];
  end;
  if Assigned(FOnNickList) then begin
    OnNicknamesListReceived(ASender.Context, LChannel, FNames);
  end;
  FNames.Clear;
end;

procedure TIdIRC.CommandLINKS(ASender: TIdCommand);
var
  LHopCnt, LInfo: String;
begin
  if not Assigned(FLinks) then begin
    FLinks := TStringList.Create;
  end;
  LInfo := ASender.Params[2];
  LHopCnt := Fetch(LInfo);
                                   
  FLinks.Add(ASender.Params[0] + ' ' + ASender.Params[1] + ' ' + LHopCnt + ' ' + LInfo); {do not localize}
end;

procedure TIdIRC.CommandENDOFLINKS(ASender: TIdCommand);
begin
  if not Assigned(FLinks) then begin
    FLinks := TStringList.Create;
  end;
  FLinks.Add(ASender.Params[0]);
  if Assigned(FOnKnownSvrs) then begin
    OnKnownServersListReceived(ASender.Context, FLinks);
  end;
  FLinks.Clear;
end;

procedure TIdIRC.CommandBANLIST(ASender: TIdCommand);
begin
  if not Assigned(FBans) then begin
    FBans := TStringList.Create;
  end;
                                   
  FBans.Add(ASender.Params[0] + ' ' + ASender.Params[1]); {do not localize}
end;

procedure TIdIRC.CommandENDOFBANLIST(ASender: TIdCommand);
begin
  if not Assigned(FBans) then begin
    FBans := TStringList.Create;
  end;
  FBans.Add(ASender.Params[0]);
  if Assigned(FOnBanList) then begin
    OnBanListReceived(ASender.Context, FSenderNick, FBans);
  end;
  FBans.Clear;
end;

procedure TIdIRC.CommandINFO(ASender: TIdCommand);
begin
         
end;

procedure TIdIRC.CommandENDOFINFO(ASender: TIdCommand);
begin
  if Assigned(FOnUserInfo) then begin
    OnUserInfoReceived(ASender.Context, ASender.UnparsedParams);
  end;
end;

procedure TIdIRC.CommandMOTD(ASender: TIdCommand);
begin
  if not Assigned(FMotd) then begin
    FMotd := TStringList.Create;
  end;
  FMotd.Add(ASender.Params[0]);
end;

procedure TIdIRC.CommandENDOFMOTD(ASender: TIdCommand);
begin
  if not Assigned(FMotd) then begin
    FMotd := TStringList.Create;
  end;
  if Assigned(FOnMOTD) then begin
    OnMOTD(ASender.Context, FMotd);
  end;
  FMotd.Clear;
end;

procedure TIdIRC.CommandREHASHING(ASender: TIdCommand);
begin
  if Assigned(FOnRehash) then begin
    OnRehash(ASender.Context, FSenderNick, FSenderHost);
  end;
end;

procedure TIdIRC.CommandUSERSSTART(ASender: TIdCommand);
begin
  if not Assigned(FUsers) then begin
    FUsers := TStringList.Create;
  end else begin
    FUsers.Clear;
  end;
end;

procedure TIdIRC.CommandUSERS(ASender: TIdCommand);
begin
  if ASender.CommandHandler.Command = '393' then {do not localize}
  begin
    if not Assigned(FUsers) then begin
      FUsers := TStringList.Create;
    end;
                                     
    FUsers.Add(ASender.Params[0] + ' ' + ASender.Params[1] + ' ' + ASender.Params[2]); {do not localize}
  end;
end;

procedure TIdIRC.CommandENDOFUSERS(ASender: TIdCommand);
begin
  if not Assigned(FUsers) then begin
    FUsers := TStringList.Create;
  end;
  if Assigned(FOnSvrUsers) then begin
    OnServerUsersListReceived(ASender.Context, FUsers);
  end;
  FUsers.Clear;
end;

procedure TIdIRC.CommandENDOFSTATS(ASender: TIdCommand);
begin
  if Assigned(FOnSvrStats) then begin
    OnServerStatsReceived(ASender.Context, nil);        
  end;
end;

procedure TIdIRC.CommandSERVLIST(ASender: TIdCommand);
begin
  // <name> <server> <mask> <type> <hopcount> <info>
end;

procedure TIdIRC.CommandSERVLISTEND(ASender: TIdCommand);
begin
  // <mask> <type> :<info>
end;

procedure TIdIRC.CommandTIME(ASender: TIdCommand);
var
  LServer, LTimeString: String;
begin
  if Assigned(FOnSvrTime) then begin
    LServer := ASender.Params[0];
    case ASender.Params.Count of
      2: begin // "<server> :<time string>"
        LTimeString := ASender.Params[1];
        end;
      4: begin // "<server> <timestamp> <offset> :<time string>" or "<server> <timezone name> <microseconds> :<time string>"
        LTimeString := IndyFormat('%s %s %s', [ASender.Params[1], ASender.Params[2], ASender.Params[3]]); {do not localize}
        end;
      7: begin // "<server> <year> <month> <day> <hour> <minute> <second>"
        LTimeString := IndyFormat('%s %s %s %s %s %s', {do not localize}
          [ASender.Params[1], ASender.Params[2], ASender.Params[3],
          ASender.Params[4], ASender.Params[5], ASender.Params[6]]);
        end;
    end;
    OnServerTime(ASender.Context, LServer, LTimeString);
  end;
end;

procedure TIdIRC.CommandSERVICE(ASender: TIdCommand);
begin
  if Assigned(FOnService) then begin
    OnService(ASender.Context);
  end;
end;

procedure TIdIRC.CommandVERSION(ASender: TIdCommand);
begin
  if Assigned(FOnSvrVersion) then begin
    OnServerVersion(ASender.Context, ASender.Params[0], ASender.Params[1], ASender.Params[2]);
  end;
end;

procedure TIdIRC.CommandCHANMODE(ASender: TIdCommand);
begin
  if Assigned(FOnChanMode) then begin
    OnChannelMode(ASender.Context, FSenderNick, FSenderHost, ASender.Params[0], ASender.Params[1], ASender.Params[2]);
  end;
end;

procedure TIdIRC.CommandOPER(ASender: TIdCommand);
begin
  if Assigned(FOnOp) then begin
    OnOp(ASender.Context, FSenderNick, FSenderHost, ASender.Params[0]);
  end;
end;

procedure TIdIRC.CommandNICKINUSE(ASender: TIdCommand);
begin
  if ASender.CommandHandler.Command = '433' then {do not localize}
  begin
    if (Connected) and (FAltNickname <> '') then
    begin
      if not FAltNickUsed then begin
        // try only once using AltNickname (FAltNickUsed is cleared in .Connect)
        SetNickname(FAltNickname);
        FAltNickUsed := True;
      end
      else
      begin
        // already tried to use AltNickName...
        if Assigned(FOnNickError) then begin
          OnNicknameError(ASender.Context, IndyStrToInt(ASender.CommandHandler.Command));
        end;
      end;
    end;
  end;
end;

procedure TIdIRC.ParseDCC(AContext: TIdContext; const ADCC: String);
const
  IdIRCDCC: array[0..3] of String = ('SEND', 'CHAT', 'RESUME', 'ACCEPT');  {do not localize}
var
  LTmp, LType, LArg, LAddr, LPort, LSize: String;
begin
  LTmp := ADCC;
  LType := FetchIRCParam(LTmp);
  LArg := FetchIRCParam(LTmp);
  LAddr := FetchIRCParam(LTmp);
  LPort := FetchIRCParam(LTmp);
  LSize := FetchIRCParam(LTmp);
  //
  case PosInStrArray(LType, IdIRCDCC) of
    0: {SEND}
      begin
        if Assigned(FOnDCCSend) then begin
          FOnDCCSend(AContext, FSenderNick, LAddr, ExtractFileName(LArg), IndyStrToInt(LPort), IndyStrToInt64(LSize));
        end;
      end;
    1: {CHAT}
      begin
        if Assigned(FOnDCCChat) then begin
          FOnDCCChat(AContext, FSenderNick, LAddr, IndyStrToInt(LPort));
        end;
      end;
    2: {RESUME}
      begin
        if Assigned(FOnDCCResume) then begin
          FOnDCCResume(AContext, FSenderNick, LAddr, LArg, IndyStrToInt(LPort), IndyStrToInt64(LSize));
        end;
      end;
    3: {ACCEPT}
      begin
        if Assigned(FOnDCCAccept) then begin
          FOnDCCAccept(AContext, FSenderNick, LAddr, LArg, IndyStrToInt(LPort), IndyStrToInt64(LSize));
        end;
      end;
  end;
end;

function TIdIRC.GetUsedNickname: String;
begin
  if FAltNickUsed then
    Result := FAltNickname
  else
    Result := FNickname;
end;

procedure TIdIRC.SetNickname(const AValue: String);
begin
  if not Connected then begin
    FNickname := AValue;
  end else begin
    Raw(IndyFormat('NICK %s', [AValue])); {do not localize}
  end;
end;

procedure TIdIRC.SetUsername(const AValue: String);
begin
  if not Connected then begin
    FUsername := AValue;
  end else begin
    Raw(IndyFormat('USER %s %s %s :%s', [AValue, GetUserMode, '*', FRealName]));  {do not localize}
  end;
end;

procedure TIdIRC.SetIdIRCUserMode(AValue: TIdIRCUserModes);
begin
  FUserMode := AValue;
end;

procedure TIdIRC.SetIdIRCReplies(AValue: TIdIRCReplies);
begin
  FReplies.Assign(AValue);
end;

function TIdIRC.IsChannel(const AChannel: String): Boolean;
begin
  //Result := (Length(AChannel) > 0) and CharIsInSet(AChannel, 1, ['&','#','+','!']);  {do not localize}
  Result := CharIsInSet(AChannel, 1, '&#+!');  {do not localize}
end;

function TIdIRC.IsOp(const ANickname: String): Boolean;
begin
  Result := TextStartsWith(ANickname, '@');
end;

function TIdIRC.IsVoice(const ANickname: String): Boolean;
begin
  Result := TextEndsWith(ANickname, '+');
end;

procedure TIdIRC.Say(const ATarget, AMsg: String);
begin
  Raw(IndyFormat('PRIVMSG %s :%s', [ATarget, AMsg])); {do not localize}
end;

procedure TIdIRC.Notice(const ATarget, AMsg: String);
begin
  Raw(IndyFormat('NOTICE %s :%s', [ATarget, AMsg]));  {do not localize}
end;

procedure TIdIRC.Action(const ATarget, AMsg: String);
begin
  CTCPQuery(ATarget, 'ACTION', AMsg); {do not localize}
end;

procedure TIdIRC.CTCPQuery(const ATarget, ACommand, AParameters: String);
var
  LTmp: String;
begin
  LTmp := UpperCase(ACommand);
  if AParameters <> '' then begin
    LTmp := LTmp + ' ' + AParameters;
  end;
  Say(ATarget, XDelim+CTCPQuote(LTmp)+XDelim);  {do not localize}
end;

procedure TIdIRC.CTCPReply(const ATarget, ACTCP, AReply: String);
var
  LTmp: String;
begin
  LTmp := ACTCP;
  if AReply <> '' then begin
    LTmp := LTmp + ' ' + AReply;
  end;
  Notice(ATarget, XDelim+CTCPQuote(LTmp)+XDelim); {do not localize}
end;

procedure TIdIRC.Join(const AChannel: String; const AKey: String = '');
begin
  if IsChannel(AChannel) then begin
    if AKey <> '' then begin
      Raw(IndyFormat('JOIN %s %s', [AChannel, AKey])) {do not localize}
    end else begin
      Raw(IndyFormat('JOIN %s', [AChannel])); {do not localize}
    end;
  end;
end;

procedure TIdIRC.Part(const AChannel: String; const AReason: String = '');
begin
  if IsChannel(AChannel) then begin
    if AReason <> '' then begin
      Raw(IndyFormat('PART %s :%s', [AChannel, AReason])) {do not localize}
    end else begin
      Raw(IndyFormat('PART %s', [AChannel])); {do not localize}
    end;
  end;
end;

procedure TIdIRC.Kick(const AChannel, ANickname: String; const AReason: String = '');
begin
  if IsChannel(AChannel) then begin
    if AReason <> '' then begin
      Raw(IndyFormat('KICK %s %s :%s', [AChannel, ANickname, AReason]));  {do not localize}
    end else begin
      Raw(IndyFormat('KICK %s %s', [AChannel, ANickname]));  {do not localize}
    end;
  end;
end;

procedure TIdIRC.SetChannelMode(const AChannel, AMode: String; const AParams: String = '');
begin
  if IsChannel(AChannel) then begin
    if AParams = '' then begin
      Raw(IndyFormat('MODE %s %s', [AChannel, AMode])); {do not localize}
    end else begin
      Raw(IndyFormat('MODE %s %s %s', [AChannel, AMode, AParams])); {do not localize}
    end;
  end;
end;

procedure TIdIRC.SetUserMode(const ANickname, AMode: String);
begin
  Raw(IndyFormat('MODE %s %s', [ANickname, AMode]));  {do not localize}
end;

procedure TIdIRC.GetChannelTopic(const AChannel: String);
begin
  if IsChannel(AChannel) then begin
    Raw(IndyFormat('TOPIC %s', [AChannel]));  {do not localize}
  end;
end;

procedure TIdIRC.SetChannelTopic(const AChannel, ATopic: String);
begin
  if IsChannel(AChannel) then begin
    Raw(IndyFormat('TOPIC %s :%s', [AChannel, ATopic]));  {do not localize}
  end;
end;

procedure TIdIRC.SetAway(const AMsg: String);
begin
  if AMsg <> '' then begin
    Raw(IndyFormat('AWAY :%s', [AMsg])); {do not localize}
  end else begin
    Raw('AWAY');  {do not localize}
  end;
end;

procedure TIdIRC.Op(const AChannel, ANickname: String);
begin
  SetChannelMode(AChannel, '+o', ANickname);  {do not localize}
end;

procedure TIdIRC.Deop(const AChannel, ANickname: String);
begin
  SetChannelMode(AChannel, '-o', ANickname);  {do not localize}
end;

procedure TIdIRC.Voice(const AChannel, ANickname: String);
begin
  SetChannelMode(AChannel, '+v', ANickname);  {do not localize}
end;

procedure TIdIRC.Devoice(const AChannel, ANickname: String);
begin
  SetChannelMode(AChannel, '-v', ANickname);  {do not localize}
end;

procedure TIdIRC.Ban(const AChannel, AHostmask: String);
begin
  SetChannelMode(AChannel, '+b', AHostmask);  {do not localize}
end;

procedure TIdIRC.Unban(const AChannel, AHostmask: String);
begin
  SetChannelMode(AChannel, '-b', AHostmask);  {do not localize}
end;

procedure TIdIRC.RegisterService(const ANickname, ADistribution, AInfo: String; AType: Integer);
begin
  Raw(IndyFormat('SERVICE %s * %s %s 0 :%s',  {do not localize}
    [ANickname, ADistribution, AType, AInfo]));
end;

procedure TIdIRC.ListChannelNicknames(const AChannel: String; const ATarget: String = '');
begin
  if IsChannel(AChannel) then begin
    if ATarget <> '' then begin
      Raw(IndyFormat('NAMES %s %s', [AChannel, ATarget]));  {do not localize}
    end else begin
      Raw(IndyFormat('NAMES %s', [AChannel]));  {do not localize}
    end;
  end;
end;

procedure TIdIRC.ListChannel(const AChannel: String; const ATarget: String = '');
begin
  if IsChannel(AChannel) then begin
    if ATarget <> '' then begin
      Raw(IndyFormat('LIST %s %s', [AChannel, ATarget])); {do not localize}
    end else begin
      Raw(IndyFormat('LIST %s', [AChannel])); {do not localize}
    end;
  end;
end;

procedure TIdIRC.Invite(const ANickname, AChannel: String);
begin
  if IsChannel(AChannel) then begin
    Raw(IndyFormat('INVITE %s %s', [ANickname, AChannel])); {do not localize}
  end;
end;

procedure TIdIRC.GetMessageOfTheDay(const ATarget: String = '');
begin
  if ATarget <> '' then begin
    Raw(IndyFormat('MOTD %s', [ATarget]));  {do not localize}
  end else begin
    Raw('MOTD');  {do not localize}
  end;
end;

procedure TIdIRC.GetNetworkStatus(const AHostMask: String = ''; const ATarget: String = '');
begin
  if (AHostMask = '') and (ATarget = '') then begin
    Raw('LUSERS');  {do not localize}
  end
  else if AHostMask = '' then begin
    Raw(IndyFormat('LUSERS %s', [ATarget]));  {do not localize}
  end
  else if ATarget = '' then begin
    Raw(IndyFormat('LUSERS %s', [AHostMask]));  {do not localize}
  end else begin
    Raw(IndyFormat('LUSERS %s %s', [AHostMask, ATarget]));  {do not localize}
  end;
end;

procedure TIdIRC.GetServerVersion(const ATarget: String = '');
begin
  if ATarget = '' then begin
    Raw('VERSION'); {do not localize}
  end else begin
    Raw(IndyFormat('VERSION %s', [ATarget])); {do not localize}
  end;
end;

procedure TIdIRC.GetServerStatus(AQuery: TIdIRCStat; const ATarget: String = '');
const
  IdIRCStatChars: array[TIdIRCStat] of Char = ('l', 'm', 'o', 'u'); {do not localize}
begin
  if ATarget <> '' then begin
    Raw(IndyFormat('STATS %s %s', [IdIRCStatChars[AQuery], ATarget])); {do not localize}
  end else begin
    Raw(IndyFormat('STATS %s', [IdIRCStatChars[AQuery]])); {do not localize}
  end;
end;

procedure TIdIRC.ListKnownServerNames(const ARemoteHost: String = ''; const AHostMask: String = '');
begin
  if (ARemoteHost = '') and (AHostMask = '') then begin
    Raw('LINKS'); {do not localize}
  end
  else if ARemoteHost = '' then begin
    Raw(IndyFormat('LINKS %s', [AHostMask])); {do not localize}
  end else begin
    Raw(IndyFormat('LINKS %s %s', [ARemoteHost, AHostMask])); {do not localize}
  end;
end;

procedure TIdIRC.QueryServerTime(const ATarget: String = '');
begin
  if ATarget <> '' then begin
    Raw(IndyFormat('TIME %s', [ATarget]));  {do not localize}
  end else begin
    Raw('TIME');  {do not localize}
  end;
end;

procedure TIdIRC.RequestServerConnect(const ATargetHost: String; APort: Integer;
  const ARemoteHost: String = '');
begin
  if ARemoteHost <> '' then begin
    Raw(IndyFormat('CONNECT %s %d %s', [ATargetHost, APort, ARemoteHost])); {do not localize}
  end else begin
    Raw(IndyFormat('CONNECT %s %d', [ATargetHost, APort])); {do not localize}
  end;
end;

procedure TIdIRC.TraceServer(const ATarget: String = '');
begin
  if ATarget <> '' then begin
    Raw(IndyFormat('TRACE %s', [ATarget])); {do not localize}
  end else begin
    Raw('TRACE'); {do not localize}
  end;
end;

procedure TIdIRC.GetAdminInfo(const ATarget: String = '');
begin
  if ATarget <> '' then begin
    Raw(IndyFormat('ADMIN %s', [ATarget])); {do not localize}
  end else begin
    Raw('ADMIN'); {do not localize}
  end;
end;

procedure TIdIRC.GetServerInfo(const ATarget: String = '');
begin
  if ATarget <> '' then begin
    Raw(IndyFormat('INFO %s', [ATarget]));  {do not localize}
  end else begin
    Raw('INFO');  {do not localize}
  end;
end;

procedure TIdIRC.ListNetworkServices(const AHostMask: String = ''; const AType: String = '');
begin
  if (AHostMask = '') and (AType = '') then begin
    Raw('SERVLIST');  {do not localize}
  end
  else if AType <> '' then begin
    Raw(IndyFormat('SERVLIST %s %s', [AHostMask, AType]));  {do not localize}
  end else begin
    Raw(IndyFormat('SERVLIST %s', [AHostMask]));  {do not localize}
  end;
end;

procedure TIdIRC.QueryService(const AServiceName, AMessage: String);
begin
  Raw(IndyFormat('SQUERY %s :%s', [AServiceName, AMessage]));  {do not localize}
end;

procedure TIdIRC.Who(const AMask: String; AOnlyAdmins: Boolean);
begin
  if (AMask = '') and (not AOnlyAdmins) then begin
    Raw('WHO'); {do not localize}
  end
  else if AOnlyAdmins then begin
    Raw(IndyFormat('WHO %s o', [AMask])); {do not localize}
  end else begin
    Raw(IndyFormat('WHO %s', [AMask])); {do not localize}
  end;
end;

procedure TIdIRC.WhoIs(const AMask: String; const ATarget: String = '');
begin
  if ATarget <> '' then begin
    Raw(IndyFormat('WHOIS %s %s', [ATarget, AMask])); {do not localize}
  end else begin
    Raw(IndyFormat('WHOIS %s', [AMask])); {do not localize}
  end;
end;

procedure TIdIRC.WhoWas(const ANickname: String; ACount: Integer = -1; const ATarget: String = '');
begin
  if (ATarget = '') and (ACount < 0) then begin
    Raw(IndyFormat('WHOWAS %s', [ANickname]));  {do not localize}
  end
  else if ATarget <> '' then begin
    Raw(IndyFormat('WHOWAS %s %d %s', [ANickname, ACount, ATarget]));  {do not localize}
  end
  else begin
    Raw(IndyFormat('WHOWAS %s %d', [ANickname, ACount])); {do not localize}
  end;
end;

procedure TIdIRC.Kill(const ANickname, AComment: String);
begin
  Raw(IndyFormat('KILL %s :%s', [ANickname, AComment])); {do not localize}
end;

procedure TIdIRC.Ping(const AServer1: String; const AServer2: String = '');
begin
  if AServer2 <> '' then begin
    Raw(IndyFormat('PING %s %s', [AServer1, AServer2]));  {do not localize}
  end else begin
    Raw(IndyFormat('PING %s', [AServer1])); {do not localize}
  end;
end;

procedure TIdIRC.Pong(const AServer1: String; const AServer2: String = '');
begin
  if AServer2 <> '' then begin
    Raw(IndyFormat('PONG %s %s', [AServer1, AServer2]));  {do not localize}
  end else begin
    Raw(IndyFormat('PONG %s', [AServer1])); {do not localize}
  end;
end;

procedure TIdIRC.Error(const AMessage: String);
begin
  Raw(IndyFormat('ERROR :%s', [AMessage]));  {do not localize}
end;

procedure TIdIRC.ReHash;
begin
  Raw('REHASH');  {do not localize}
end;

procedure TIdIRC.Die;
begin
  Raw('DIE'); {do not localize}
end;

procedure TIdIRC.Restart;
begin
  Raw('RESTART'); {do not localize}
end;

procedure TIdIRC.Summon(const ANickname: String; const ATarget: String = '';
  const AChannel: String = '');
begin
  if (ATarget = '') and (AChannel = '') then begin
    Raw(IndyFormat('SUMMON %s', [ANickname]));  {do not localize}
  end
  else if AChannel <> '' then
  begin
    if IsChannel(AChannel) then begin
      Raw(IndyFormat('SUMMON %s %s %s', [ANickname, ATarget, AChannel])); {do not localize}
    end;
  end else begin
    Raw(IndyFormat('SUMMON %s %s', [ANickname, ATarget]));  {do not localize}
  end;
end;

procedure TIdIRC.ListServerUsers(const ATarget: String = '');
begin
  if ATarget <> '' then begin
    Raw(IndyFormat('USERS %s', [ATarget])); {do not localize}
  end else begin
    Raw('USERS'); {do not localize}
  end;
end;

procedure TIdIRC.SayWALLOPS(const AMessage: String);
begin
  Raw(IndyFormat('WALLOPS :%s', [AMessage]));  {do not localize}
end;

procedure TIdIRC.GetUserInfo(const ANickname: String);
begin
  Raw(IndyFormat('USERHOST %s', [ANickname]));  {do not localize}
end;

procedure TIdIRC.GetUsersInfo(const ANicknames: array of string);
var
  I: Integer;
  S: string;
begin
  if Length(ANicknames) > 0 then
  begin
    for I := Low(ANicknames) to High(ANicknames) do begin
      S := S + ' ' + ANicknames[I]; {do not localize}
    end;
    Raw(IndyFormat('USERHOST%s', [S]));  {do not localize}
  end;
end;

procedure TIdIRC.IsOnIRC(const ANickname: String);
begin
  Raw(IndyFormat('ISON %s', [ANickname]));  {do not localize}
end;

procedure TIdIRC.IsOnIRC(const ANicknames: array of String);
var
  I: Integer;
  S: string;
begin
  if Length(ANicknames) > 0 then
  begin
    for I := Low(ANicknames) to High(ANicknames) do begin
      S := S + ' ' + ANicknames[I]; {do not localize}
    end;
    Raw(IndyFormat('ISON%s', [S]));  {do not localize}
  end;
end;

procedure TIdIRC.BecomeOp(const ANickname, APassword: String);
begin
  Raw(IndyFormat('OPER %s %s', [ANickname, APassword]));  {do not localize}
end;

procedure TIdIRC.SQuit(const AHost, AComment: String);
begin
  Raw(IndyFormat('SQUIT %s :%s', [AHost, AComment]));  {do not localize}
end;

procedure TIdIRC.SetChannelLimit(const AChannel: String; ALimit: Integer);
begin
  SetChannelMode(AChannel, '+l', IntToStr(ALimit)); {do not localize}
end;

procedure TIdIRC.SetChannelKey(const AChannel, AKey: String);
begin
  SetChannelMode(AChannel, '+k', AKey); {do not localize}
end;

procedure TIdIRC.SetIOHandler(AValue: TIdIOHandler);
begin
  inherited SetIOHandler(AValue);
  //we do it this way so that if a user is using a custom value <> default, the port
  //is not set when the IOHandler is changed.
  if (IOHandler is TIdSSLIOHandlerSocketBase) then begin
    if Port = IdPORT_IRC then begin
      Port := IdPORT_IRCS;
    end;
  end else begin
    if Port = IdPORT_IRCS then begin
      Port := IdPORT_IRC;
    end;
  end;
end;

end.


