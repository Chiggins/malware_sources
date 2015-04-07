#ifndef _CFGIINI_H_
#define _CFGIINI_H_

BOOLEAN CfgfWriteString(PCHAR pcFile, PCHAR pcSection, PCHAR pcVariable, PCHAR pcValue, PCHAR Key);
DWORD CfgfReadString(PCHAR pcFile, PCHAR pcSection, PCHAR pcVariable, PCHAR lpDefault, PCHAR pcValue, DWORD dwValue, PCHAR Key);

PVOID CfgsWriteString(PVOID pvBuffer, PDWORD pdwBuffer, PCHAR pcSection, PCHAR pcVariable, PCHAR pcValue);
DWORD CfgsReadString(PVOID pvBuffer, DWORD dwBuffer, PCHAR pcSection, PCHAR pcVariable, PCHAR *ppcValue);

#endif
