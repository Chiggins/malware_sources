  ; ===========================================
  ; wininet.inc copyright MASM32 1998 - 2005
  ; ===========================================

IFNDEF WININET_INC
WININET_INC equ <1>

CommitUrlCacheEntryA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CommitUrlCacheEntry equ <CommitUrlCacheEntryA>

CommitUrlCacheEntryW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateMD5SSOHash PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateUrlCacheContainerA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateUrlCacheContainer equ <CreateUrlCacheContainerA>

CreateUrlCacheContainerW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateUrlCacheEntryA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateUrlCacheEntry equ <CreateUrlCacheEntryA>

CreateUrlCacheEntryW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateUrlCacheGroup PROTO :DWORD,:DWORD
DeleteIE3Cache PROTO :DWORD,:DWORD,:DWORD,:DWORD
DeleteUrlCacheContainerA PROTO :DWORD,:DWORD
DeleteUrlCacheContainer equ <DeleteUrlCacheContainerA>

DeleteUrlCacheContainerW PROTO :DWORD,:DWORD
DeleteUrlCacheEntryA PROTO :DWORD
DeleteUrlCacheEntry equ <DeleteUrlCacheEntryA>

DeleteUrlCacheEntryW PROTO :DWORD
DeleteUrlCacheGroup PROTO :DWORD,:DWORD,:DWORD,:DWORD
DetectAutoProxyUrl PROTO :DWORD,:DWORD,:DWORD
DoConnectoidsExist PROTO 
ExportCookieFileA PROTO :DWORD,:DWORD
ExportCookieFile equ <ExportCookieFileA>

ExportCookieFileW PROTO :DWORD,:DWORD
FindCloseUrlCache PROTO :DWORD
FindFirstUrlCacheContainerA PROTO :DWORD,:DWORD,:DWORD,:DWORD
FindFirstUrlCacheContainer equ <FindFirstUrlCacheContainerA>

FindFirstUrlCacheContainerW PROTO :DWORD,:DWORD,:DWORD,:DWORD
FindFirstUrlCacheEntryA PROTO :DWORD,:DWORD,:DWORD
FindFirstUrlCacheEntry equ <FindFirstUrlCacheEntryA>

FindFirstUrlCacheEntryExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindFirstUrlCacheEntryEx equ <FindFirstUrlCacheEntryExA>

FindFirstUrlCacheEntryExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindFirstUrlCacheEntryW PROTO :DWORD,:DWORD,:DWORD
FindFirstUrlCacheGroup PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindNextUrlCacheContainerA PROTO :DWORD,:DWORD,:DWORD
FindNextUrlCacheContainer equ <FindNextUrlCacheContainerA>

FindNextUrlCacheContainerW PROTO :DWORD,:DWORD,:DWORD
FindNextUrlCacheEntryA PROTO :DWORD,:DWORD,:DWORD
FindNextUrlCacheEntry equ <FindNextUrlCacheEntryA>

FindNextUrlCacheEntryExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindNextUrlCacheEntryEx equ <FindNextUrlCacheEntryExA>

FindNextUrlCacheEntryExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindNextUrlCacheEntryW PROTO :DWORD,:DWORD,:DWORD
FindNextUrlCacheGroup PROTO :DWORD,:DWORD,:DWORD
FindP3PPolicySymbol PROTO :DWORD
ForceNexusLookup PROTO 
ForceNexusLookupExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FreeP3PObject PROTO :DWORD
FreeUrlCacheSpaceA PROTO :DWORD,:DWORD,:DWORD
FreeUrlCacheSpace equ <FreeUrlCacheSpaceA>

FreeUrlCacheSpaceW PROTO :DWORD,:DWORD,:DWORD
FtpCommandA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpCommand equ <FtpCommandA>

FtpCommandW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpCreateDirectoryA PROTO :DWORD,:DWORD
FtpCreateDirectory equ <FtpCreateDirectoryA>

FtpCreateDirectoryW PROTO :DWORD,:DWORD
FtpDeleteFileA PROTO :DWORD,:DWORD
FtpDeleteFile equ <FtpDeleteFileA>

FtpDeleteFileW PROTO :DWORD,:DWORD
FtpFindFirstFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpFindFirstFile equ <FtpFindFirstFileA>

FtpFindFirstFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpGetCurrentDirectoryA PROTO :DWORD,:DWORD,:DWORD
FtpGetCurrentDirectory equ <FtpGetCurrentDirectoryA>

FtpGetCurrentDirectoryW PROTO :DWORD,:DWORD,:DWORD
FtpGetFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpGetFile equ <FtpGetFileA>

FtpGetFileEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpGetFileSize PROTO :DWORD,:DWORD
FtpGetFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpOpenFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpOpenFile equ <FtpOpenFileA>

FtpOpenFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpPutFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpPutFile equ <FtpPutFileA>

FtpPutFileEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpPutFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FtpRemoveDirectoryA PROTO :DWORD,:DWORD
FtpRemoveDirectory equ <FtpRemoveDirectoryA>

FtpRemoveDirectoryW PROTO :DWORD,:DWORD
FtpRenameFileA PROTO :DWORD,:DWORD,:DWORD
FtpRenameFile equ <FtpRenameFileA>

FtpRenameFileW PROTO :DWORD,:DWORD,:DWORD
FtpSetCurrentDirectoryA PROTO :DWORD,:DWORD
FtpSetCurrentDirectory equ <FtpSetCurrentDirectoryA>

FtpSetCurrentDirectoryW PROTO :DWORD,:DWORD
GetDiskInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetDiskInfo equ <GetDiskInfoA>

GetP3PPolicy PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetP3PRequestStatus PROTO :DWORD
GetUrlCacheConfigInfoA PROTO :DWORD,:DWORD,:DWORD
GetUrlCacheConfigInfo equ <GetUrlCacheConfigInfoA>

GetUrlCacheConfigInfoW PROTO :DWORD,:DWORD,:DWORD
GetUrlCacheEntryInfoA PROTO :DWORD,:DWORD,:DWORD
GetUrlCacheEntryInfo equ <GetUrlCacheEntryInfoA>

GetUrlCacheEntryInfoExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetUrlCacheEntryInfoEx equ <GetUrlCacheEntryInfoExA>

GetUrlCacheEntryInfoExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetUrlCacheEntryInfoW PROTO :DWORD,:DWORD,:DWORD
GetUrlCacheGroupAttributeA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetUrlCacheGroupAttribute equ <GetUrlCacheGroupAttributeA>

GetUrlCacheGroupAttributeW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetUrlCacheHeaderData PROTO :DWORD,:DWORD
GopherCreateLocatorA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GopherCreateLocator equ <GopherCreateLocatorA>

GopherCreateLocatorW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GopherFindFirstFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GopherFindFirstFile equ <GopherFindFirstFileA>

GopherFindFirstFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GopherGetAttributeA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GopherGetAttribute equ <GopherGetAttributeA>

GopherGetAttributeW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GopherGetLocatorTypeA PROTO :DWORD,:DWORD
GopherGetLocatorType equ <GopherGetLocatorTypeA>

GopherGetLocatorTypeW PROTO :DWORD,:DWORD
GopherOpenFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GopherOpenFile equ <GopherOpenFileA>

GopherOpenFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpAddRequestHeadersA PROTO :DWORD,:DWORD,:DWORD,:DWORD
HttpAddRequestHeaders equ <HttpAddRequestHeadersA>

HttpAddRequestHeadersW PROTO :DWORD,:DWORD,:DWORD,:DWORD
HttpCheckDavComplianceA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpCheckDavCompliance equ <HttpCheckDavComplianceA>

HttpCheckDavComplianceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpEndRequestA PROTO :DWORD,:DWORD,:DWORD,:DWORD
HttpEndRequest equ <HttpEndRequestA>

HttpEndRequestW PROTO :DWORD,:DWORD,:DWORD,:DWORD
HttpOpenRequestA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpOpenRequest equ <HttpOpenRequestA>

HttpOpenRequestW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpQueryInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpQueryInfo equ <HttpQueryInfoA>

HttpQueryInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpSendRequestA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpSendRequest equ <HttpSendRequestA>

HttpSendRequestExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpSendRequestEx equ <HttpSendRequestExA>

HttpSendRequestExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HttpSendRequestW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ImportCookieFileA PROTO :DWORD
ImportCookieFile equ <ImportCookieFileA>

ImportCookieFileW PROTO :DWORD
IncrementUrlCacheHeaderData PROTO :DWORD,:DWORD
InternetAlgIdToStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetAlgIdToString equ <InternetAlgIdToStringA>

InternetAlgIdToStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetAttemptConnect PROTO :DWORD
InternetAutodial PROTO :DWORD,:DWORD
InternetAutodialCallback PROTO :DWORD,:DWORD
InternetAutodialHangup PROTO :DWORD
InternetCanonicalizeUrlA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetCanonicalizeUrl equ <InternetCanonicalizeUrlA>

InternetCanonicalizeUrlW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetCheckConnectionA PROTO :DWORD,:DWORD,:DWORD
InternetCheckConnection equ <InternetCheckConnectionA>

InternetCheckConnectionW PROTO :DWORD,:DWORD,:DWORD
InternetClearAllPerSiteCookieDecisions PROTO 
InternetCloseHandle PROTO :DWORD
InternetCombineUrlA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetCombineUrl equ <InternetCombineUrlA>

InternetCombineUrlW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetConfirmZoneCrossingA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetConfirmZoneCrossing equ <InternetConfirmZoneCrossingA>

InternetConfirmZoneCrossingW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetConnectA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetConnect equ <InternetConnectA>

InternetConnectW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetCrackUrlA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetCrackUrl equ <InternetCrackUrlA>

InternetCrackUrlW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetCreateUrlA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetCreateUrl equ <InternetCreateUrlA>

InternetCreateUrlW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetDialA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetDial equ <InternetDialA>

InternetDialW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetEnumPerSiteCookieDecisionA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetEnumPerSiteCookieDecision equ <InternetEnumPerSiteCookieDecisionA>

InternetEnumPerSiteCookieDecisionW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetErrorDlg PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetFindNextFileA PROTO :DWORD,:DWORD
InternetFindNextFile equ <InternetFindNextFileA>

InternetFindNextFileW PROTO :DWORD,:DWORD
InternetFortezzaCommand PROTO :DWORD,:DWORD,:DWORD
InternetGetCertByURLA PROTO :DWORD,:DWORD,:DWORD
InternetGetCertByURL equ <InternetGetCertByURLA>

InternetGetConnectedState PROTO :DWORD,:DWORD
InternetGetConnectedStateExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetGetConnectedStateEx equ <InternetGetConnectedStateExA>

InternetGetConnectedStateExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetGetCookieA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetGetCookie equ <InternetGetCookieA>

InternetGetCookieExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetGetCookieEx equ <InternetGetCookieExA>

InternetGetCookieExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetGetCookieW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetGetLastResponseInfoA PROTO :DWORD,:DWORD,:DWORD
InternetGetLastResponseInfo equ <InternetGetLastResponseInfoA>

InternetGetLastResponseInfoW PROTO :DWORD,:DWORD,:DWORD
InternetGetPerSiteCookieDecisionA PROTO :DWORD,:DWORD
InternetGetPerSiteCookieDecision equ <InternetGetPerSiteCookieDecisionA>

InternetGetPerSiteCookieDecisionW PROTO :DWORD,:DWORD
InternetGoOnlineA PROTO :DWORD,:DWORD,:DWORD
InternetGoOnline equ <InternetGoOnlineA>

InternetGoOnlineW PROTO :DWORD,:DWORD,:DWORD
InternetHangUp PROTO :DWORD,:DWORD
InternetInitializeAutoProxyDll PROTO :DWORD
InternetLockRequestFile PROTO :DWORD,:DWORD
InternetOpenA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetOpen equ <InternetOpenA>

InternetOpenUrlA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetOpenUrl equ <InternetOpenUrlA>

InternetOpenUrlW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetOpenW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetQueryDataAvailable PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetQueryFortezzaStatus PROTO :DWORD,:DWORD
InternetQueryOptionA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetQueryOption equ <InternetQueryOptionA>

InternetQueryOptionW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetReadFile PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetReadFileExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetReadFileEx equ <InternetReadFileExA>

InternetReadFileExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetSecurityProtocolToStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetSecurityProtocolToString equ <InternetSecurityProtocolToStringA>

InternetSecurityProtocolToStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetSetCookieA PROTO :DWORD,:DWORD,:DWORD
InternetSetCookie equ <InternetSetCookieA>

InternetSetCookieExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetSetCookieEx equ <InternetSetCookieExA>

InternetSetCookieExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetSetCookieW PROTO :DWORD,:DWORD,:DWORD
InternetSetDialStateA PROTO :DWORD,:DWORD,:DWORD
InternetSetDialState equ <InternetSetDialStateA>

InternetSetDialStateW PROTO :DWORD,:DWORD,:DWORD
InternetSetFilePointer PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetSetOptionA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetSetOption equ <InternetSetOptionA>

InternetSetOptionExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetSetOptionEx equ <InternetSetOptionExA>

InternetSetOptionExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternetSetOptionW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetSetPerSiteCookieDecisionA PROTO :DWORD,:DWORD
InternetSetPerSiteCookieDecision equ <InternetSetPerSiteCookieDecisionA>

InternetSetPerSiteCookieDecisionW PROTO :DWORD,:DWORD
InternetSetStatusCallbackA PROTO :DWORD,:DWORD
InternetSetStatusCallback equ <InternetSetStatusCallbackA>

InternetSetStatusCallbackW PROTO :DWORD,:DWORD
InternetShowSecurityInfoByURLA PROTO :DWORD,:DWORD
InternetShowSecurityInfoByURL equ <InternetShowSecurityInfoByURLA>

InternetShowSecurityInfoByURLW PROTO :DWORD,:DWORD
InternetTimeFromSystemTimeA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetTimeFromSystemTime equ <InternetTimeFromSystemTimeA>

InternetTimeFromSystemTimeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetTimeToSystemTimeA PROTO :DWORD,:DWORD,:DWORD
InternetTimeToSystemTime equ <InternetTimeToSystemTimeA>

InternetTimeToSystemTimeW PROTO :DWORD,:DWORD,:DWORD
InternetUnlockRequestFile PROTO :DWORD
InternetWriteFile PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetWriteFileExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InternetWriteFileEx equ <InternetWriteFileExA>

InternetWriteFileExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
IsDomainLegalCookieDomainA PROTO :DWORD,:DWORD
IsDomainLegalCookieDomain equ <IsDomainLegalCookieDomainA>

IsDomainLegalCookieDomainW PROTO :DWORD,:DWORD
IsHostInProxyBypassList PROTO :DWORD,:DWORD,:DWORD
IsProfilesEnabled PROTO 
IsUrlCacheEntryExpiredA PROTO :DWORD,:DWORD,:DWORD
IsUrlCacheEntryExpired equ <IsUrlCacheEntryExpiredA>

IsUrlCacheEntryExpiredW PROTO :DWORD,:DWORD,:DWORD
LoadUrlCacheContent PROTO 
MapResourceToPolicy PROTO :DWORD,:DWORD,:DWORD,:DWORD
ParseX509EncodedCertificateForListBoxEntry PROTO :DWORD,:DWORD,:DWORD,:DWORD
PerformOperationOverUrlCacheA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PerformOperationOverUrlCache equ <PerformOperationOverUrlCacheA>

PrivacyGetZonePreferenceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PrivacySetZonePreferenceW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ReadUrlCacheEntryStream PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegisterUrlCacheNotification PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResumeSuspendedDownload PROTO :DWORD,:DWORD
RetrieveUrlCacheEntryFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD
RetrieveUrlCacheEntryFile equ <RetrieveUrlCacheEntryFileA>

RetrieveUrlCacheEntryFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD
RetrieveUrlCacheEntryStreamA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RetrieveUrlCacheEntryStream equ <RetrieveUrlCacheEntryStreamA>

RetrieveUrlCacheEntryStreamW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RunOnceUrlCache PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetUrlCacheConfigInfoA PROTO :DWORD,:DWORD
SetUrlCacheConfigInfo equ <SetUrlCacheConfigInfoA>

SetUrlCacheConfigInfoW PROTO :DWORD,:DWORD
SetUrlCacheEntryGroupA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetUrlCacheEntryGroup equ <SetUrlCacheEntryGroupA>

SetUrlCacheEntryGroupW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetUrlCacheEntryInfoA PROTO :DWORD,:DWORD,:DWORD
SetUrlCacheEntryInfo equ <SetUrlCacheEntryInfoA>

SetUrlCacheEntryInfoW PROTO :DWORD,:DWORD,:DWORD
SetUrlCacheGroupAttributeA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetUrlCacheGroupAttribute equ <SetUrlCacheGroupAttributeA>

SetUrlCacheGroupAttributeW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetUrlCacheHeaderData PROTO :DWORD,:DWORD
ShowCertificate PROTO :DWORD,:DWORD
ShowClientAuthCerts PROTO :DWORD
ShowSecurityInfo PROTO :DWORD,:DWORD
ShowX509EncodedCertificate PROTO :DWORD,:DWORD,:DWORD
UnlockUrlCacheEntryFileA PROTO :DWORD,:DWORD
UnlockUrlCacheEntryFile equ <UnlockUrlCacheEntryFileA>

UnlockUrlCacheEntryFileW PROTO :DWORD,:DWORD
UnlockUrlCacheEntryStream PROTO :DWORD,:DWORD
UpdateUrlCacheContentPath PROTO :DWORD
UrlZonesDetach PROTO 

ELSE
echo -----------------------------------------
echo WARNING Duplicate include file wininet.inc
echo -----------------------------------------
ENDIF
