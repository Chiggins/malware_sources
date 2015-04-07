  ; ===========================================
  ; shlwapi.inc copyright MASM32 1998 - 2005
  ; ===========================================

IFNDEF SHLWAPI_INC
SHLWAPI_INC equ <1>

AssocCreate PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AssocGetPerceivedType PROTO :DWORD,:DWORD,:DWORD,:DWORD
AssocIsDangerous PROTO :DWORD
AssocQueryKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AssocQueryKey equ <AssocQueryKeyA>

AssocQueryKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AssocQueryStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AssocQueryString equ <AssocQueryStringA>

AssocQueryStringByKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AssocQueryStringByKey equ <AssocQueryStringByKeyA>

AssocQueryStringByKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AssocQueryStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ChrCmpIA PROTO :DWORD,:DWORD
ChrCmpI equ <ChrCmpIA>

ChrCmpIW PROTO :DWORD,:DWORD
ColorAdjustLuma PROTO :DWORD,:DWORD,:DWORD
ColorHLSToRGB PROTO :DWORD,:DWORD,:DWORD
ColorRGBToHLS PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetAcceptLanguagesA PROTO :DWORD,:DWORD
GetAcceptLanguages equ <GetAcceptLanguagesA>

GetAcceptLanguagesW PROTO :DWORD,:DWORD
GetMenuPosFromID PROTO :DWORD,:DWORD
HashData PROTO :DWORD,:DWORD,:DWORD,:DWORD
IntlStrEqWorkerA PROTO :DWORD,:DWORD,:DWORD,:DWORD
IntlStrEqWorker equ <IntlStrEqWorkerA>

IntlStrEqWorkerW PROTO :DWORD,:DWORD,:DWORD,:DWORD
IsCharSpaceA PROTO :DWORD
IsCharSpace equ <IsCharSpaceA>

IsCharSpaceW PROTO :DWORD
PathAddBackslashA PROTO :DWORD
PathAddBackslash equ <PathAddBackslashA>

PathAddBackslashW PROTO :DWORD
PathAddExtensionA PROTO :DWORD,:DWORD
PathAddExtension equ <PathAddExtensionA>

PathAddExtensionW PROTO :DWORD,:DWORD
PathAppendA PROTO :DWORD,:DWORD
PathAppend equ <PathAppendA>

PathAppendW PROTO :DWORD,:DWORD
PathBuildRootA PROTO :DWORD,:DWORD
PathBuildRoot equ <PathBuildRootA>

PathBuildRootW PROTO :DWORD,:DWORD
PathCanonicalizeA PROTO :DWORD,:DWORD
PathCanonicalize equ <PathCanonicalizeA>

PathCanonicalizeW PROTO :DWORD,:DWORD
PathCombineA PROTO :DWORD,:DWORD,:DWORD
PathCombine equ <PathCombineA>

PathCombineW PROTO :DWORD,:DWORD,:DWORD
PathCommonPrefixA PROTO :DWORD,:DWORD,:DWORD
PathCommonPrefix equ <PathCommonPrefixA>

PathCommonPrefixW PROTO :DWORD,:DWORD,:DWORD
PathCompactPathA PROTO :DWORD,:DWORD,:DWORD
PathCompactPath equ <PathCompactPathA>

PathCompactPathExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
PathCompactPathEx equ <PathCompactPathExA>

PathCompactPathExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
PathCompactPathW PROTO :DWORD,:DWORD,:DWORD
PathCreateFromUrlA PROTO :DWORD,:DWORD,:DWORD,:DWORD
PathCreateFromUrl equ <PathCreateFromUrlA>

PathCreateFromUrlW PROTO :DWORD,:DWORD,:DWORD,:DWORD
PathFileExistsA PROTO :DWORD
PathFileExists equ <PathFileExistsA>

PathFileExistsW PROTO :DWORD
PathFindExtensionA PROTO :DWORD
PathFindExtension equ <PathFindExtensionA>

PathFindExtensionW PROTO :DWORD
PathFindFileNameA PROTO :DWORD
PathFindFileName equ <PathFindFileNameA>

PathFindFileNameW PROTO :DWORD
PathFindNextComponentA PROTO :DWORD
PathFindNextComponent equ <PathFindNextComponentA>

PathFindNextComponentW PROTO :DWORD
PathFindOnPathA PROTO :DWORD,:DWORD
PathFindOnPath equ <PathFindOnPathA>

PathFindOnPathW PROTO :DWORD,:DWORD
PathFindSuffixArrayA PROTO :DWORD,:DWORD,:DWORD
PathFindSuffixArray equ <PathFindSuffixArrayA>

PathFindSuffixArrayW PROTO :DWORD,:DWORD,:DWORD
PathGetArgsA PROTO :DWORD
PathGetArgs equ <PathGetArgsA>

PathGetArgsW PROTO :DWORD
PathGetCharTypeA PROTO :DWORD
PathGetCharType equ <PathGetCharTypeA>

PathGetCharTypeW PROTO :DWORD
PathGetDriveNumberA PROTO :DWORD
PathGetDriveNumber equ <PathGetDriveNumberA>

PathGetDriveNumberW PROTO :DWORD
PathIsContentTypeA PROTO :DWORD,:DWORD
PathIsContentType equ <PathIsContentTypeA>

PathIsContentTypeW PROTO :DWORD,:DWORD
PathIsDirectoryA PROTO :DWORD
PathIsDirectory equ <PathIsDirectoryA>

PathIsDirectoryEmptyA PROTO :DWORD
PathIsDirectoryEmpty equ <PathIsDirectoryEmptyA>

PathIsDirectoryEmptyW PROTO :DWORD
PathIsDirectoryW PROTO :DWORD
PathIsFileSpecA PROTO :DWORD
PathIsFileSpec equ <PathIsFileSpecA>

PathIsFileSpecW PROTO :DWORD
PathIsLFNFileSpecA PROTO :DWORD
PathIsLFNFileSpec equ <PathIsLFNFileSpecA>

PathIsLFNFileSpecW PROTO :DWORD
PathIsNetworkPathA PROTO :DWORD
PathIsNetworkPath equ <PathIsNetworkPathA>

PathIsNetworkPathW PROTO :DWORD
PathIsPrefixA PROTO :DWORD,:DWORD
PathIsPrefix equ <PathIsPrefixA>

PathIsPrefixW PROTO :DWORD,:DWORD
PathIsRelativeA PROTO :DWORD
PathIsRelative equ <PathIsRelativeA>

PathIsRelativeW PROTO :DWORD
PathIsRootA PROTO :DWORD
PathIsRoot equ <PathIsRootA>

PathIsRootW PROTO :DWORD
PathIsSameRootA PROTO :DWORD,:DWORD
PathIsSameRoot equ <PathIsSameRootA>

PathIsSameRootW PROTO :DWORD,:DWORD
PathIsSystemFolderA PROTO :DWORD,:DWORD
PathIsSystemFolder equ <PathIsSystemFolderA>

PathIsSystemFolderW PROTO :DWORD,:DWORD
PathIsUNCA PROTO :DWORD
PathIsUNC equ <PathIsUNCA>

PathIsUNCServerA PROTO :DWORD
PathIsUNCServer equ <PathIsUNCServerA>

PathIsUNCServerShareA PROTO :DWORD
PathIsUNCServerShare equ <PathIsUNCServerShareA>

PathIsUNCServerShareW PROTO :DWORD
PathIsUNCServerW PROTO :DWORD
PathIsUNCW PROTO :DWORD
PathIsURLA PROTO :DWORD
PathIsURL equ <PathIsURLA>

PathIsURLW PROTO :DWORD
PathMakePrettyA PROTO :DWORD
PathMakePretty equ <PathMakePrettyA>

PathMakePrettyW PROTO :DWORD
PathMakeSystemFolderA PROTO :DWORD
PathMakeSystemFolder equ <PathMakeSystemFolderA>

PathMakeSystemFolderW PROTO :DWORD
PathMatchSpecA PROTO :DWORD,:DWORD
PathMatchSpec equ <PathMatchSpecA>

PathMatchSpecW PROTO :DWORD,:DWORD
PathParseIconLocationA PROTO :DWORD
PathParseIconLocation equ <PathParseIconLocationA>

PathParseIconLocationW PROTO :DWORD
PathQuoteSpacesA PROTO :DWORD
PathQuoteSpaces equ <PathQuoteSpacesA>

PathQuoteSpacesW PROTO :DWORD
PathRelativePathToA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PathRelativePathTo equ <PathRelativePathToA>

PathRelativePathToW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PathRemoveArgsA PROTO :DWORD
PathRemoveArgs equ <PathRemoveArgsA>

PathRemoveArgsW PROTO :DWORD
PathRemoveBackslashA PROTO :DWORD
PathRemoveBackslash equ <PathRemoveBackslashA>

PathRemoveBackslashW PROTO :DWORD
PathRemoveBlanksA PROTO :DWORD
PathRemoveBlanks equ <PathRemoveBlanksA>

PathRemoveBlanksW PROTO :DWORD
PathRemoveExtensionA PROTO :DWORD
PathRemoveExtension equ <PathRemoveExtensionA>

PathRemoveExtensionW PROTO :DWORD
PathRemoveFileSpecA PROTO :DWORD
PathRemoveFileSpec equ <PathRemoveFileSpecA>

PathRemoveFileSpecW PROTO :DWORD
PathRenameExtensionA PROTO :DWORD,:DWORD
PathRenameExtension equ <PathRenameExtensionA>

PathRenameExtensionW PROTO :DWORD,:DWORD
PathSearchAndQualifyA PROTO :DWORD,:DWORD,:DWORD
PathSearchAndQualify equ <PathSearchAndQualifyA>

PathSearchAndQualifyW PROTO :DWORD,:DWORD,:DWORD
PathSetDlgItemPathA PROTO :DWORD,:DWORD,:DWORD
PathSetDlgItemPath equ <PathSetDlgItemPathA>

PathSetDlgItemPathW PROTO :DWORD,:DWORD,:DWORD
PathSkipRootA PROTO :DWORD
PathSkipRoot equ <PathSkipRootA>

PathSkipRootW PROTO :DWORD
PathStripPathA PROTO :DWORD
PathStripPath equ <PathStripPathA>

PathStripPathW PROTO :DWORD
PathStripToRootA PROTO :DWORD
PathStripToRoot equ <PathStripToRootA>

PathStripToRootW PROTO :DWORD
PathUnExpandEnvStringsA PROTO :DWORD,:DWORD,:DWORD
PathUnExpandEnvStrings equ <PathUnExpandEnvStringsA>

PathUnExpandEnvStringsW PROTO :DWORD,:DWORD,:DWORD
PathUndecorateA PROTO :DWORD
PathUndecorate equ <PathUndecorateA>

PathUndecorateW PROTO :DWORD
PathUnmakeSystemFolderA PROTO :DWORD
PathUnmakeSystemFolder equ <PathUnmakeSystemFolderA>

PathUnmakeSystemFolderW PROTO :DWORD
PathUnquoteSpacesA PROTO :DWORD
PathUnquoteSpaces equ <PathUnquoteSpacesA>

PathUnquoteSpacesW PROTO :DWORD
SHAllocShared PROTO :DWORD,:DWORD,:DWORD
SHAutoComplete PROTO :DWORD,:DWORD
SHCopyKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHCopyKey equ <SHCopyKeyA>

SHCopyKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHCreateShellPalette PROTO :DWORD
SHCreateStreamOnFileA PROTO :DWORD,:DWORD,:DWORD
SHCreateStreamOnFile equ <SHCreateStreamOnFileA>

SHCreateStreamOnFileEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHCreateStreamOnFileW PROTO :DWORD,:DWORD,:DWORD
SHCreateStreamWrapper PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHCreateThread PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHCreateThreadRef PROTO :DWORD,:DWORD
SHDeleteEmptyKeyA PROTO :DWORD,:DWORD
SHDeleteEmptyKey equ <SHDeleteEmptyKeyA>

SHDeleteEmptyKeyW PROTO :DWORD,:DWORD
SHDeleteKeyA PROTO :DWORD,:DWORD
SHDeleteKey equ <SHDeleteKeyA>

SHDeleteKeyW PROTO :DWORD,:DWORD
SHDeleteOrphanKeyA PROTO :DWORD,:DWORD
SHDeleteOrphanKey equ <SHDeleteOrphanKeyA>

SHDeleteOrphanKeyW PROTO :DWORD,:DWORD
SHDeleteValueA PROTO :DWORD,:DWORD,:DWORD
SHDeleteValue equ <SHDeleteValueA>

SHDeleteValueW PROTO :DWORD,:DWORD,:DWORD
SHEnumKeyExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHEnumKeyEx equ <SHEnumKeyExA>

SHEnumKeyExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHEnumValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHEnumValue equ <SHEnumValueA>

SHEnumValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHFreeShared PROTO :DWORD,:DWORD
SHGetInverseCMAP PROTO :DWORD,:DWORD
SHGetThreadRef PROTO :DWORD
SHGetValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetValue equ <SHGetValueA>

SHGetValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetViewStatePropertyBag PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHIsLowMemoryMachine PROTO :DWORD
SHLoadIndirectString PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHLockShared PROTO :DWORD,:DWORD
SHOpenRegStream2A PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHOpenRegStream2 equ <SHOpenRegStream2A>

SHOpenRegStream2W PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHOpenRegStreamA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHOpenRegStream equ <SHOpenRegStreamA>

SHOpenRegStreamW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHQueryInfoKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHQueryInfoKey equ <SHQueryInfoKeyA>

SHQueryInfoKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHQueryValueExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHQueryValueEx equ <SHQueryValueExA>

SHQueryValueExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegCloseUSKey PROTO :DWORD
SHRegCreateUSKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegCreateUSKey equ <SHRegCreateUSKeyA>

SHRegCreateUSKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegDeleteEmptyUSKeyA PROTO :DWORD,:DWORD,:DWORD
SHRegDeleteEmptyUSKey equ <SHRegDeleteEmptyUSKeyA>

SHRegDeleteEmptyUSKeyW PROTO :DWORD,:DWORD,:DWORD
SHRegDeleteUSValueA PROTO :DWORD,:DWORD,:DWORD
SHRegDeleteUSValue equ <SHRegDeleteUSValueA>

SHRegDeleteUSValueW PROTO :DWORD,:DWORD,:DWORD
SHRegDuplicateHKey PROTO :DWORD
SHRegEnumUSKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegEnumUSKey equ <SHRegEnumUSKeyA>

SHRegEnumUSKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegEnumUSValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegEnumUSValue equ <SHRegEnumUSValueA>

SHRegEnumUSValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegGetBoolUSValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHRegGetBoolUSValue equ <SHRegGetBoolUSValueA>

SHRegGetBoolUSValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHRegGetPathA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegGetPath equ <SHRegGetPathA>

SHRegGetPathW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegGetUSValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegGetUSValue equ <SHRegGetUSValueA>

SHRegGetUSValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegGetValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegGetValue equ <SHRegGetValueA>

SHRegGetValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegOpenUSKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegOpenUSKey equ <SHRegOpenUSKeyA>

SHRegOpenUSKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegQueryInfoUSKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegQueryInfoUSKey equ <SHRegQueryInfoUSKeyA>

SHRegQueryInfoUSKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegQueryUSValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegQueryUSValue equ <SHRegQueryUSValueA>

SHRegQueryUSValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegSetPathA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegSetPath equ <SHRegSetPathA>

SHRegSetPathW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegSetUSValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegSetUSValue equ <SHRegSetUSValueA>

SHRegSetUSValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegWriteUSValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegWriteUSValue equ <SHRegWriteUSValueA>

SHRegWriteUSValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHRegisterValidateTemplate PROTO :DWORD,:DWORD
SHReleaseThreadRef PROTO 
SHSetThreadRef PROTO :DWORD
SHSetValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHSetValue equ <SHSetValueA>

SHSetValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHSkipJunction PROTO :DWORD,:DWORD
SHStrDupA PROTO :DWORD,:DWORD
SHStrDup equ <SHStrDupA>

SHStrDupW PROTO :DWORD,:DWORD
SHUnlockShared PROTO :DWORD
StrCSpnA PROTO :DWORD,:DWORD
StrCSpn equ <StrCSpnA>

StrCSpnIA PROTO :DWORD,:DWORD
StrCSpnI equ <StrCSpnIA>

StrCSpnIW PROTO :DWORD,:DWORD
StrCSpnW PROTO :DWORD,:DWORD
StrCatBuffA PROTO :DWORD,:DWORD,:DWORD
StrCatBuff equ <StrCatBuffA>

StrCatBuffW PROTO :DWORD,:DWORD,:DWORD
StrCatChainW PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrCatW PROTO :DWORD,:DWORD
StrChrA PROTO :DWORD,:DWORD
StrChr equ <StrChrA>

StrChrIA PROTO :DWORD,:DWORD
StrChrI equ <StrChrIA>

StrChrIW PROTO :DWORD,:DWORD
StrChrNIW PROTO :DWORD,:DWORD,:DWORD
StrChrNW PROTO :DWORD,:DWORD,:DWORD
StrChrW PROTO :DWORD,:DWORD
StrCmpCA PROTO :DWORD,:DWORD
StrCmpC equ <StrCmpCA>

StrCmpCW PROTO :DWORD,:DWORD
StrCmpICA PROTO :DWORD,:DWORD
StrCmpIC equ <StrCmpICA>

StrCmpICW PROTO :DWORD,:DWORD
StrCmpIW PROTO :DWORD,:DWORD
StrCmpLogicalW PROTO :DWORD,:DWORD
StrCmpNA PROTO :DWORD,:DWORD,:DWORD
StrCmpN equ <StrCmpNA>

StrCmpNIA PROTO :DWORD,:DWORD,:DWORD
StrCmpNI equ <StrCmpNIA>

StrCmpNIW PROTO :DWORD,:DWORD,:DWORD
StrCmpNW PROTO :DWORD,:DWORD,:DWORD
StrCmpW PROTO :DWORD,:DWORD
StrCpyNW PROTO :DWORD,:DWORD,:DWORD
StrCpyW PROTO :DWORD,:DWORD
StrDupA PROTO :DWORD
StrDup equ <StrDupA>

StrDupW PROTO :DWORD
StrFormatByteSize64A PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrFormatByteSize64 equ <StrFormatByteSize64A>

StrFormatByteSizeA PROTO :DWORD,:DWORD,:DWORD
StrFormatByteSize equ <StrFormatByteSizeA>

StrFormatByteSizeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrFormatKBSizeA PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrFormatKBSize equ <StrFormatKBSizeA>

StrFormatKBSizeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrFromTimeIntervalA PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrFromTimeInterval equ <StrFromTimeIntervalA>

StrFromTimeIntervalW PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrIsIntlEqualA PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrIsIntlEqual equ <StrIsIntlEqualA>

StrIsIntlEqualW PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrNCatA PROTO :DWORD,:DWORD,:DWORD
StrNCat equ <StrNCatA>

StrNCatW PROTO :DWORD,:DWORD,:DWORD
StrPBrkA PROTO :DWORD,:DWORD
StrPBrk equ <StrPBrkA>

StrPBrkW PROTO :DWORD,:DWORD
StrRChrA PROTO :DWORD,:DWORD,:DWORD
StrRChr equ <StrRChrA>

StrRChrIA PROTO :DWORD,:DWORD,:DWORD
StrRChrI equ <StrRChrIA>

StrRChrIW PROTO :DWORD,:DWORD,:DWORD
StrRChrW PROTO :DWORD,:DWORD,:DWORD
StrRStrIA PROTO :DWORD,:DWORD,:DWORD
StrRStrI equ <StrRStrIA>

StrRStrIW PROTO :DWORD,:DWORD,:DWORD
StrRetToBSTR PROTO :DWORD,:DWORD,:DWORD
StrRetToBufA PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrRetToBuf equ <StrRetToBufA>

StrRetToBufW PROTO :DWORD,:DWORD,:DWORD,:DWORD
StrRetToStrA PROTO :DWORD,:DWORD,:DWORD
StrRetToStr equ <StrRetToStrA>

StrRetToStrW PROTO :DWORD,:DWORD,:DWORD
StrSpnA PROTO :DWORD,:DWORD
StrSpn equ <StrSpnA>

StrSpnW PROTO :DWORD,:DWORD
StrStrA PROTO :DWORD,:DWORD
StrStr equ <StrStrA>

StrStrIA PROTO :DWORD,:DWORD
StrStrI equ <StrStrIA>

StrStrIW PROTO :DWORD,:DWORD
StrStrNIW PROTO :DWORD,:DWORD,:DWORD
StrStrNW PROTO :DWORD,:DWORD,:DWORD
StrStrW PROTO :DWORD,:DWORD
StrToInt64ExA PROTO :DWORD,:DWORD,:DWORD
StrToInt64Ex equ <StrToInt64ExA>

StrToInt64ExW PROTO :DWORD,:DWORD,:DWORD
StrToIntA PROTO :DWORD
StrToInt equ <StrToIntA>

StrToIntExA PROTO :DWORD,:DWORD,:DWORD
StrToIntEx equ <StrToIntExA>

StrToIntExW PROTO :DWORD,:DWORD,:DWORD
StrToIntW PROTO :DWORD
StrTrimA PROTO :DWORD,:DWORD
StrTrim equ <StrTrimA>

StrTrimW PROTO :DWORD,:DWORD
UrlApplySchemeA PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlApplyScheme equ <UrlApplySchemeA>

UrlApplySchemeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlCanonicalizeA PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlCanonicalize equ <UrlCanonicalizeA>

UrlCanonicalizeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlCombineA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UrlCombine equ <UrlCombineA>

UrlCombineW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UrlCompareA PROTO :DWORD,:DWORD,:DWORD
UrlCompare equ <UrlCompareA>

UrlCompareW PROTO :DWORD,:DWORD,:DWORD
UrlCreateFromPathA PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlCreateFromPath equ <UrlCreateFromPathA>

UrlCreateFromPathW PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlEscapeA PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlEscape equ <UrlEscapeA>

UrlEscapeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlGetLocationA PROTO :DWORD
UrlGetLocation equ <UrlGetLocationA>

UrlGetLocationW PROTO :DWORD
UrlGetPartA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UrlGetPart equ <UrlGetPartA>

UrlGetPartW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UrlHashA PROTO :DWORD,:DWORD,:DWORD
UrlHash equ <UrlHashA>

UrlHashW PROTO :DWORD,:DWORD,:DWORD
UrlIsA PROTO :DWORD,:DWORD
UrlIs equ <UrlIsA>

UrlIsNoHistoryA PROTO :DWORD
UrlIsNoHistory equ <UrlIsNoHistoryA>

UrlIsNoHistoryW PROTO :DWORD
UrlIsOpaqueA PROTO :DWORD
UrlIsOpaque equ <UrlIsOpaqueA>

UrlIsOpaqueW PROTO :DWORD
UrlIsW PROTO :DWORD,:DWORD
UrlUnescapeA PROTO :DWORD,:DWORD,:DWORD,:DWORD
UrlUnescape equ <UrlUnescapeA>

UrlUnescapeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
wvnsprintfA PROTO :DWORD,:DWORD,:DWORD,:DWORD
wvnsprintf equ <wvnsprintfA>

wvnsprintfW PROTO :DWORD,:DWORD,:DWORD,:DWORD

ELSE
echo -----------------------------------------
echo WARNING Duplicate include file shlwapi.inc
echo -----------------------------------------
ENDIF
