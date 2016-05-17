#include "includes.h"
#include "externs.h"
#include <iostream>
#include <fstream>
using namespace std;

char* meglan(string toBeEncrypted, string sKey){
    string sEncrypted(toBeEncrypted);
    unsigned int iKey(sKey.length()), iIn(toBeEncrypted.length()), x(0);

    for(unsigned int i = 0; i < iIn; i++){
        sEncrypted[i] = toBeEncrypted[i] ^ sKey[x] & 10;
        if(++x == iKey){ x = 0; }
    }
    size_t size = sEncrypted.size() + 1;
    char * buffer = new char[size];
    strncpy( buffer, sEncrypted.c_str(), size );
    cout << buffer << '\n';
    return buffer;
}