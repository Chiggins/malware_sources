#pragma once
#include "Settings.h"
#include "Base.h"
#include <wininet.h>

#define HTTP_HEADER "Accept: application/octet-stream\r\nContent-Type: application/octet-stream\r\nConnection: close\r\n"

__declspec(align(1)) struct Authhdr {
	WORD version;
	char sversion[16];
	char hwid[8];
	unsigned char nonce[2];
	char action[8];
	char pcname[32];
	DWORD size;
	unsigned char sig[4];
	unsigned char data[0];
};
class PanelRequest
{
public:
	PanelRequest();
	~PanelRequest();
	void setAction(std::string &action);
	bool execute(std::string &response);
	bool execute();

	void addParameter(std::string &name, std::string &val);

	static unsigned int httpRequest(const char *host, const char *path, unsigned short port, const char *useragent, const char *postdata, unsigned int pdatalen, char **response, unsigned int *rlen);
private:
	std::string action;
	std::vector<std::pair<std::string, std::string>> params;

	static char *urlencode(const unsigned char *data, unsigned int length, char *buf);
	static void xorEncrypt(void *data, unsigned int length, const unsigned char *key, unsigned int klen);
	CRITICAL_SECTION cs;

	bool execute(std::string *response);
};

