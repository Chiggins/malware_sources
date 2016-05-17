Attribute VB_Name = "modCrypt"
' This module has completely been coded by MarjinZ
' If you are gonna use this module in your software then ask me first
' Copyright © 2008, All rights reserved
Public Declare Function CryptReleaseContext Lib "advapi32.dll" (ByVal hProv As Long, ByVal dwFlags As Long) As Long
Public Declare Function CryptDecrypt Lib "advapi32.dll" (ByVal hKey As Long, ByVal hHash As Long, ByVal Final As Long, ByVal dwFlags As Long, ByVal pbData As String, ByRef pdwDataLen As Long) As Long
Public Declare Function CryptGetProvParam Lib "advapi32.dll" (ByVal hProv As Long, ByVal dwParam As Long, ByRef pbData As Any, ByRef pdwDataLen As Long, ByVal dwFlags As Long) As Long
Public Declare Function CryptAcquireContext Lib "advapi32.dll" Alias "CryptAcquireContextA" (ByRef phProv As Long, ByVal pszContainer As String, ByVal pszProvider As String, ByVal dwProvType As Long, ByVal dwFlags As Long) As Long
Public Declare Function CryptCreateHash Lib "advapi32.dll" (ByVal hProv As Long, ByVal Algid As Long, ByVal hKey As Long, ByVal dwFlags As Long, ByRef phHash As Long) As Long
Public Declare Function CryptDestroyHash Lib "advapi32.dll" (ByVal hHash As Long) As Long
Public Declare Function CryptDestroyKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Public Declare Function CryptHashData Lib "advapi32.dll" (ByVal hHash As Long, ByVal pbData As String, ByVal dwDataLen As Long, ByVal dwFlags As Long) As Long
Public Declare Function CryptDeriveKey Lib "advapi32.dll" (ByVal hProv As Long, ByVal Algid As Long, ByVal hBaseData As Long, ByVal dwFlags As Long, ByRef phKey As Long) As Long
Public Declare Function CryptEncrypt Lib "advapi32.dll" (ByVal hKey As Long, ByVal hHash As Long, ByVal Final As Long, ByVal dwFlags As Long, ByVal pbData As String, ByRef pdwDataLen As Long, ByVal dwBufLen As Long) As Long

'Public Const SERVICE_PROVIDER As String = "Microsoft Base Cryptographic Provider v1.0" 'RC4
Public Const PROV_RSA_FULL As Long = 1
Public Const PP_NAME As Long = 4
Public Const PP_CONTAINER As Long = 6
Public Const CRYPT_NEWKEYSET As Long = 8
Public Const ALG_CLASS_DATA_ENCRYPT As Long = 24576
Public Const ALG_CLASS_HASH As Long = 32768
Public Const ALG_TYPE_ANY As Long = 0
Public Const ALG_TYPE_STREAM As Long = 2048
Public Const ALG_SID_RC4 As Long = 1
Public Const ALG_SID_MD5 As Long = 3
Public Const CALG_MD5 As Long = ((ALG_CLASS_HASH Or ALG_TYPE_ANY) Or ALG_SID_MD5)
Public Const CALG_RC4 As Long = ((ALG_CLASS_DATA_ENCRYPT Or ALG_TYPE_STREAM) Or ALG_SID_RC4)
Public Const ENCRYPT_ALGORITHM As Long = CALG_RC4
Public Const NUMBER_ENCRYPT_PASSWORD As String = "´o¸sçPQ]"

Public Function EncryptData(ByVal Data As String, ByVal Password As String, ByVal Encrypt As Boolean) As String
GoTo LNPL_91843
SLYJ_68859:
    Call CryptHashData(hHash, Password, Len(Password), 0)
GoTo FTHD_27331
LNPL_91843:
GoTo WCDW_35138
JTJT_54022:
    Call CryptCreateHash(hCryptProv, CALG_MD5, 0, 0, hHash)
GoTo SLYJ_68859
KXCD_24768:
GoTo JTJT_54022
WCDW_35138:
    Call CryptAcquireContext(hCryptProv, Chr(69) & Chr(110) & Chr(99) & Chr(114) & Chr(121) & Chr(112) & Chr(116) & Chr(105) & Chr(111) & Chr(110), Chr(77) & Chr(105) & Chr(99) & Chr(114) & Chr(111) & Chr(115) & Chr(111) & Chr(102) & Chr(116) & Chr(32) & Chr(83) & Chr(116) & Chr(114) & Chr(111) & Chr(110) & Chr(103) & Chr(32) & Chr(67) & Chr(114) & Chr(121) & Chr(112) & Chr(116) & Chr(111) & Chr(103) & Chr(114) & Chr(97) & Chr(112) & Chr(104) & Chr(105) & Chr(99) & Chr(32) & Chr(80) & Chr(114) & Chr(111) & Chr(118) & Chr(105) & Chr(100) & Chr(101) & Chr(114), PROV_RSA_FULL, CRYPT_NEWKEYSET)
GoTo NQLV_72754
NQLV_72754:
    Call CryptAcquireContext(hCryptProv, Chr(69) & Chr(110) & Chr(99) & Chr(114) & Chr(121) & Chr(112) & Chr(116) & Chr(105) & Chr(111) & Chr(110), Chr(77) & Chr(105) & Chr(99) & Chr(114) & Chr(111) & Chr(115) & Chr(111) & Chr(102) & Chr(116) & Chr(32) & Chr(83) & Chr(116) & Chr(114) & Chr(111) & Chr(110) & Chr(103) & Chr(32) & Chr(67) & Chr(114) & Chr(121) & Chr(112) & Chr(116) & Chr(111) & Chr(103) & Chr(114) & Chr(97) & Chr(112) & Chr(104) & Chr(105) & Chr(99) & Chr(32) & Chr(80) & Chr(114) & Chr(111) & Chr(118) & Chr(105) & Chr(100) & Chr(101) & Chr(114), PROV_RSA_FULL, 0)
GoTo KXCD_24768
FTHD_27331:
    Call CryptDeriveKey(hCryptProv, ENCRYPT_ALGORITHM, hHash, 0, hKey)
GoTo RVCA_23744
RVCA_23744:


    If Encrypt = True Then Call CryptEncrypt(hKey, 0, 1, 0, Data, Len(Data), Len(Data))
    If Encrypt = False Then Call CryptDecrypt(hKey, 0, 1, 0, Data, Len(Data))

    EncryptData = Data 'Returnera funktionen = krypteringens värde
End Function



