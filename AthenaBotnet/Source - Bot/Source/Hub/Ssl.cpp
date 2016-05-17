#include "../Includes/includes.h"

//#include "sspi.h"

/*static DWORD g_cbMaxToken;
static PSecurityFunctionTable g_pFuncs;
PTCHAR  g_pszPackage = TEXT("NTLM");
// name of the entity you are authenticating to
PTCHAR  g_pszTarget = NULL;
// name of user being authenticated
PTCHAR  g_pszUser;
// name of user's domain
PTCHAR g_pszDomain;
// password of user being authenticated
PTCHAR g_pszPassword;
PBYTE g_pInBuf = NULL;
PBYTE g_pOutBuf = NULL;
DWORD g_cbMaxMessage = 0;
CredHandle g_hcred;       // Credential Handle
SecHandle  g_hctxt;       // Context Handle

#define SEC_SUCCESS(Status) ((Status) >= 0)


BOOL InitPackage (DWORD *pcbMaxMessage)
//
// Routine Description:
//    Finds, loads, and initializes the security package
// Return Value:
//    Returns TRUE is successful; otherwise FALSE is returned.
//
{
   SECURITY_STATUS ss;
   PSecPkgInfo pkgInfo;


    g_pFuncs = InitSecurityInterface();
   // Query for the package of interest
   //
   ss = g_pFuncs->QuerySecurityPackageInfo (g_pszPackage, &pkgInfo);
   if(!SEC_SUCCESS(ss))
   {
      fprintf (stderr, "Could not query package info for %s, error %X\n", g_pszPackage, ss);
      return FALSE;
   }

   *pcbMaxMessage = pkgInfo->cbMaxToken;

   g_pFuncs->FreeContextBuffer(pkgInfo);

   return TRUE;
}

BOOL GenClientContext (
         BYTE *pIn,
         DWORD cbIn,
         BYTE *pOut,
         DWORD *pcbOut,
         BOOL *pfDone)
//
// Routine Description:
//    Optionally takes an input buffer coming from the server and returns
//    a buffer of information to send back to the server.  Also returns
//    an indication of whether or not the context is complete.
// Return Value:
//    Returns TRUE is successful; otherwise FALSE is returned.
//
{
   SECURITY_STATUS   ss;
   TimeStamp         Lifetime;
   SecBufferDesc     OutBuffDesc;
   SecBuffer         OutSecBuff;
   SecBufferDesc     InBuffDesc;
   SecBuffer         InSecBuff;
   ULONG             ContextAttributes;
   BOOL              fNewContext = FALSE;
   // NTLM and KERBEROS packages use the SEC_WINNT_AUTH_IDENTITY structure
   // to pass user credentials
   SEC_WINNT_AUTH_IDENTITY AuthData, *pAuthData = NULL;


   if (!pIn)  {
      // first call - get the credential handle
      fNewContext = TRUE;
      // if the user credentials are available, use them by supplying a
      // SEC_WINNT_AUTH_IDENTITY structure. This structure is package
      // specific - it is accepted by NTLM and KERBEROS
      // Otherwise authentication is attempted using the
      // default cached credentials, if any
       if (g_pszUser)
       {
#ifdef UNICODE
           AuthData.Flags = SEC_WINNT_AUTH_IDENTITY_UNICODE;
#else
           AuthData.Flags = SEC_WINNT_AUTH_IDENTITY_ANSI;
#endif
           AuthData.User = g_pszUser;
           AuthData.Domain = g_pszDomain;
           AuthData.Password = g_pszPassword;
           AuthData.UserLength = _tcslen(g_pszUser);
           AuthData.DomainLength = g_pszDomain ? _tcslen(g_pszDomain): 0;
           AuthData.PasswordLength =
                    g_pszPassword ? _tcslen(g_pszPassword): 0;
           _tprintf(TEXT("User: %s\n"),g_pszUser);

           pAuthData = &AuthData;
       }
      ss = g_pFuncs->AcquireCredentialsHandle (
                     NULL,   // principal
                     g_pszPackage,
                     SECPKG_CRED_OUTBOUND,
                     NULL,   // LOGON id
                     pAuthData,
                     NULL,   // get key fn
                     NULL,   // get key arg
                     &g_hcred,
                     &Lifetime
                     );
      if (!SEC_SUCCESS (ss))
      {
         fprintf (stderr, "AcquireCreds failed: %X\n", ss);
         return(FALSE);
      }
   }

   // prepare output buffer
   //
   OutBuffDesc.ulVersion = 0;
   OutBuffDesc.cBuffers = 1;
   OutBuffDesc.pBuffers = &OutSecBuff;

   OutSecBuff.cbBuffer = *pcbOut;
   OutSecBuff.BufferType = SECBUFFER_TOKEN;
   OutSecBuff.pvBuffer = pOut;

   // prepare input buffer
   //
   if (!fNewContext)  {
      InBuffDesc.ulVersion = 0;
      InBuffDesc.cBuffers = 1;
      InBuffDesc.pBuffers = &InSecBuff;

      InSecBuff.cbBuffer = cbIn;
      InSecBuff.BufferType = SECBUFFER_TOKEN;
      InSecBuff.pvBuffer = pIn;
   }

   ss = g_pFuncs->InitializeSecurityContext (
                  &g_hcred,
                  fNewContext ? NULL : &g_hctxt,
                  g_pszTarget,
                  0,   // context requirements
                  0,   // reserved1
                  SECURITY_NATIVE_DREP,
                  fNewContext ? NULL : &InBuffDesc,
                  0,   // reserved2
                  &g_hctxt,
                  &OutBuffDesc,
                  &ContextAttributes,
                  &Lifetime
                  );
   if (!SEC_SUCCESS (ss))  {
      fprintf (stderr, "init context failed: %X\n", ss);
      return FALSE;
   }


   // Complete token -- if applicable
   //
   if ((SEC_I_COMPLETE_NEEDED == ss) || (SEC_I_COMPLETE_AND_CONTINUE == ss))  {
      if (g_pFuncs->CompleteAuthToken) {
         ss = g_pFuncs->CompleteAuthToken (&g_hctxt, &OutBuffDesc);
         if (!SEC_SUCCESS(ss))  {
            fprintf (stderr, "complete failed: %X\n", ss);
            return FALSE;
         }
      }
      else {
         fprintf (stderr, "Complete not supported.\n");
         return FALSE;
      }
   }

   *pcbOut = OutSecBuff.cbBuffer;

   *pfDone = !((SEC_I_CONTINUE_NEEDED == ss) ||
            (SEC_I_COMPLETE_AND_CONTINUE == ss));

   return TRUE;
}


BOOL SendBytes (SOCKET s, PBYTE pBuf, DWORD cbBuf)
{
   PBYTE pTemp = pBuf;
   int cbSent, cbRemaining = cbBuf;

   if (0 == cbBuf)
      return(TRUE);

   while (cbRemaining) {
      cbSent = send (s, pTemp, cbRemaining, 0);
      if (SOCKET_ERROR == cbSent) {
         fprintf (stderr, "send failed: %u\n", GetLastError ());
         return FALSE;
      }

      pTemp += cbSent;
      cbRemaining -= cbSent;
   }

   return TRUE;
}

BOOL ReceiveBytes (SOCKET s, PBYTE pBuf, DWORD cbBuf, DWORD *pcbRead)
{
   PBYTE pTemp = pBuf;
   int cbRead, cbRemaining = cbBuf;

   while (cbRemaining) {
      cbRead = recv (s, pTemp, cbRemaining, 0);
      if (0 == cbRead) {
            fprintf(stderr,"!ReceiveBytes: peer closed connection\n");
            break;
        }

      if (SOCKET_ERROR == cbRead) {
         fprintf (stderr, "recv failed: %u\n", GetLastError ());
         return FALSE;
      }

      cbRemaining -= cbRead;
      pTemp += cbRead;
   }

   *pcbRead = cbBuf - cbRemaining;

   return TRUE;
}

BOOL SendMsg (SOCKET s, PBYTE pBuf, DWORD cbBuf)
//
// Routine Description:
//    Sends a message over the socket by first sending a DWORD that
//    represents the size of the message followed by the message itself.
// Return Value:
//    Returns TRUE is successful; otherwise FALSE is returned.
//
{
   if (0 == cbBuf)
      return(TRUE);

   // send the size of the message
   //
   if (!SendBytes (s, (PBYTE)&cbBuf, sizeof (cbBuf)))
      return(FALSE);

   // send the body of the message
   //
   if (!SendBytes (s, pBuf, cbBuf))
      return(FALSE);

   return(TRUE);
}

BOOL ReceiveMsg (SOCKET s, PBYTE pBuf, DWORD cbBuf, DWORD *pcbRead)
//
// Routine Description:
//    Receives a message over the socket.  The first DWORD in the message
//    will be the message size.  The remainder of the bytes will be the
//    actual message.
// Return Value:
//    Returns TRUE is successful; otherwise FALSE is returned.
//
{
   DWORD cbRead;
   DWORD cbData;

   // find out how much data is in the message
   //
   if (!ReceiveBytes (s, (PBYTE)&cbData, sizeof (cbData), &cbRead))
      return(FALSE);

   if (sizeof (cbData) != cbRead) {
      if (cbRead)
            fprintf(stderr,"!ReceiveMsg: cbRead == %u, should be %u\n",cbRead,sizeof(cbData));
      return(FALSE);
   }

   // Read the full message
   //
   if (!ReceiveBytes (s, pBuf, cbData, &cbRead))
      return(FALSE);

   if (cbRead != cbData) {
      if (cbRead)
         fprintf(stderr,"!ReceiveMsg(2): cbRead == %u, should be %u\n",cbRead,cbData);
      return(FALSE);
    }

   *pcbRead = cbRead;

   return(TRUE);
}

BOOL DoAuthentication(SOCKET s)
//
// Routine Description:
//    Manages the authentication conversation with the server through the
//    supplied socket handle.
//
// Assumptions:
//    The connection to the server is assumed to have been
//    already established. If they are needed, the user name, domain name
//    and password variables should have been initialized.
// Return Value:
//    Returns TRUE is successful; otherwise FALSE is returned.
//
{
   BOOL done = FALSE;
   BOOL fSuccess = FALSE;
   DWORD cbOut, cbIn;
   if (!InitPackage (&g_cbMaxMessage))
      return FALSE;

   g_pInBuf = (PBYTE) malloc (g_cbMaxMessage);
   g_pOutBuf = (PBYTE) malloc (g_cbMaxMessage);
   SecInvalidateHandle(&g_hcred);
   SecInvalidateHandle(&g_hctxt);
   if (NULL == g_pInBuf || NULL == g_pOutBuf)
      return FALSE;

   cbOut = g_cbMaxMessage;
   //
   // Acquire the credentials Handle and create the security context
   if (!GenClientContext (NULL, 0, g_pOutBuf, &cbOut, &done))
      goto cleanup;

   // Send the first authentication token to the server
   if (!SendMsg (s, g_pOutBuf, cbOut))
      goto cleanup;

   while (!done) {
      // get the response from the server
      if (!ReceiveMsg (s, g_pInBuf, g_cbMaxMessage, &cbIn))
         goto cleanup;

      // generate the subsequent subsequent authentication tokens
      cbOut = g_cbMaxMessage;
      if (!GenClientContext (g_pInBuf, cbIn, g_pOutBuf, &cbOut, &done))
         goto cleanup;

      // send the subsequent authentication tokens to the server
      if (!SendMsg (s, g_pOutBuf, cbOut))
         goto cleanup;
   }

    printf("DoAuthentication, user authenticated\n");
    fSuccess = TRUE;

cleanup:
   g_pFuncs->DeleteSecurityContext(&g_hctxt);
   g_pFuncs->FreeCredentialHandle(&g_hcred);
   free(g_pInBuf);
   free(g_pOutBuf);
   return(fSuccess);
}
*/
