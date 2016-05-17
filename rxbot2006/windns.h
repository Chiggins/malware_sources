1 /*
2  * DNS support
3  *
4  * Copyright (C) 2006 Matthew Kehrer
5  * 
6  * This library is free software; you can redistribute it and/or
7  * modify it under the terms of the GNU Lesser General Public
8  * License as published by the Free Software Foundation; either
9  * version 2.1 of the License, or (at your option) any later version.
10  *
11  * This library is distributed in the hope that it will be useful,
12  * but WITHOUT ANY WARRANTY; without even the implied warranty of
13  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
14  * Lesser General Public License for more details.
15  *
16  * You should have received a copy of the GNU Lesser General Public
17  * License along with this library; if not, write to the Free Software
18  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
19  */
20 
21 #ifndef __WINE_WINDNS_H
22 #define __WINE_WINDNS_H
23 
24 #ifdef __cplusplus
25 extern "C" {
26 #endif
27 
28 #define DNS_TYPE_ZERO       0x0000
29 #define DNS_TYPE_A          0x0001
30 #define DNS_TYPE_NS         0x0002
31 #define DNS_TYPE_MD         0x0003
32 #define DNS_TYPE_MF         0x0004
33 #define DNS_TYPE_CNAME      0x0005
34 #define DNS_TYPE_SOA        0x0006
35 #define DNS_TYPE_MB         0x0007
36 #define DNS_TYPE_MG         0x0008
37 #define DNS_TYPE_MR         0x0009
38 #define DNS_TYPE_NULL       0x000a
39 #define DNS_TYPE_WKS        0x000b
40 #define DNS_TYPE_PTR        0x000c
41 #define DNS_TYPE_HINFO      0x000d
42 #define DNS_TYPE_MINFO      0x000e
43 #define DNS_TYPE_MX         0x000f
44 #define DNS_TYPE_TEXT       0x0010
45 #define DNS_TYPE_RP         0x0011
46 #define DNS_TYPE_AFSDB      0x0012
47 #define DNS_TYPE_X25        0x0013
48 #define DNS_TYPE_ISDN       0x0014
49 #define DNS_TYPE_RT         0x0015
50 #define DNS_TYPE_NSAP       0x0016
51 #define DNS_TYPE_NSAPPTR    0x0017
52 #define DNS_TYPE_SIG        0x0018
53 #define DNS_TYPE_KEY        0x0019
54 #define DNS_TYPE_PX         0x001a
55 #define DNS_TYPE_GPOS       0x001b
56 #define DNS_TYPE_AAAA       0x001c
57 #define DNS_TYPE_LOC        0x001d
58 #define DNS_TYPE_NXT        0x001e
59 #define DNS_TYPE_EID        0x001f
60 #define DNS_TYPE_NIMLOC     0x0020
61 #define DNS_TYPE_SRV        0x0021
62 #define DNS_TYPE_ATMA       0x0022
63 #define DNS_TYPE_NAPTR      0x0023
64 #define DNS_TYPE_KX         0x0024
65 #define DNS_TYPE_CERT       0x0025
66 #define DNS_TYPE_A6         0x0026
67 #define DNS_TYPE_DNAME      0x0027
68 #define DNS_TYPE_SINK       0x0028
69 #define DNS_TYPE_OPT        0x0029
70 #define DNS_TYPE_UINFO      0x0064
71 #define DNS_TYPE_UID        0x0065
72 #define DNS_TYPE_GID        0x0066
73 #define DNS_TYPE_UNSPEC     0x0067
74 #define DNS_TYPE_ADDRS      0x00f8
75 #define DNS_TYPE_TKEY       0x00f9
76 #define DNS_TYPE_TSIG       0x00fa
77 #define DNS_TYPE_IXFR       0x00fb
78 #define DNS_TYPE_AXFR       0x00fc
79 #define DNS_TYPE_MAILB      0x00fd
80 #define DNS_TYPE_MAILA      0x00fe
81 #define DNS_TYPE_ALL        0x00ff
82 #define DNS_TYPE_ANY        0x00ff
83 
84 #define DNS_TYPE_WINS       0xff01
85 #define DNS_TYPE_WINSR      0xff02
86 #define DNS_TYPE_NBSTAT     (DNS_TYPE_WINSR)
87 
88 #define DNS_QUERY_STANDARD                  0x00000000
89 #define DNS_QUERY_ACCEPT_TRUNCATED_RESPONSE 0x00000001
90 #define DNS_QUERY_USE_TCP_ONLY              0x00000002
91 #define DNS_QUERY_NO_RECURSION              0x00000004
92 #define DNS_QUERY_BYPASS_CACHE              0x00000008
93 #define DNS_QUERY_NO_WIRE_QUERY             0x00000010
94 #define DNS_QUERY_NO_LOCAL_NAME             0x00000020
95 #define DNS_QUERY_NO_HOSTS_FILE             0x00000040
96 #define DNS_QUERY_NO_NETBT                  0x00000080
97 #define DNS_QUERY_WIRE_ONLY                 0x00000100
98 #define DNS_QUERY_RETURN_MESSAGE            0x00000200
99 #define DNS_QUERY_TREAT_AS_FQDN             0x00001000
100 #define DNS_QUERY_DONT_RESET_TTL_VALUES     0x00100000
101 #define DNS_QUERY_RESERVED                  0xff000000
102 
103 typedef enum _DNS_NAME_FORMAT
104 {
105     DnsNameDomain,
106     DnsNameDomainLabel,
107     DnsNameHostnameFull,
108     DnsNameHostnameLabel,
109     DnsNameWildcard,
110     DnsNameSrvRecord
111 } DNS_NAME_FORMAT;
112 
113 typedef enum _DNS_FREE_TYPE
114 {
115     DnsFreeFlat,
116     DnsFreeRecordList,
117     DnsFreeParsedMessageFields
118 } DNS_FREE_TYPE;
119 
120 typedef enum _DNS_CHARSET
121 {
122     DnsCharSetUnknown,
123     DnsCharSetUnicode,
124     DnsCharSetUtf8,
125     DnsCharSetAnsi
126 } DNS_CHARSET;
127 
128 typedef enum _DNS_CONFIG_TYPE
129 {
130     DnsConfigPrimaryDomainName_W,
131     DnsConfigPrimaryDomainName_A,
132     DnsConfigPrimaryDomainName_UTF8,
133     DnsConfigAdapterDomainName_W,
134     DnsConfigAdapterDomainName_A,
135     DnsConfigAdapterDomainName_UTF8,
136     DnsConfigDnsServerList,
137     DnsConfigSearchList,
138     DnsConfigAdapterInfo,
139     DnsConfigPrimaryHostNameRegistrationEnabled,
140     DnsConfigAdapterHostNameRegistrationEnabled,
141     DnsConfigAddressRegistrationMaxCount,
142     DnsConfigHostName_W,
143     DnsConfigHostName_A,
144     DnsConfigHostName_UTF8,
145     DnsConfigFullHostName_W,
146     DnsConfigFullHostName_A,
147     DnsConfigFullHostName_UTF8
148 } DNS_CONFIG_TYPE;
149 
150 typedef enum _DnsSection
151 {
152     DnsSectionQuestion,
153     DnsSectionAnswer,
154     DnsSectionAuthority,
155     DnsSectionAddtional /* Not a typo, as per Microsoft's headers */
156 } DNS_SECTION;
157 
158 typedef LONG DNS_STATUS, *PDNS_STATUS;
159 typedef DWORD IP4_ADDRESS, *PIP4_ADDRESS;
160 
161 typedef struct
162 {
163     DWORD IP6Dword[4];
164 } IP6_ADDRESS, *PIP6_ADDRESS, DNS_IP6_ADDRESS, *PDNS_IP6_ADDRESS;
165 
166 #define SIZEOF_IP4_ADDRESS                   4
167 #define IP4_ADDRESS_STRING_LENGTH           16
168 #define IP6_ADDRESS_STRING_LENGTH           65
169 #define DNS_ADDRESS_STRING_LENGTH           IP6_ADDRESS_STRING_LENGTH
170 #define IP4_ADDRESS_STRING_BUFFER_LENGTH    IP4_ADDRESS_STRING_LENGTH
171 #define IP6_ADDRESS_STRING_BUFFER_LENGTH    IP6_ADDRESS_STRING_LENGTH
172 
173 typedef struct _IP4_ARRAY
174 {
175     DWORD AddrCount;
176     IP4_ADDRESS AddrArray[1];
177 } IP4_ARRAY, *PIP4_ARRAY;
178 
179 typedef struct _DNS_HEADER
180 {
181     WORD Xid;
182     BYTE RecursionDesired;
183     BYTE Truncation;
184     BYTE Authoritative;
185     BYTE Opcode;
186     BYTE IsResponse;
187     BYTE ResponseCode;
188     BYTE Reserved;
189     BYTE RecursionAvailable;
190     WORD QuestionCount;
191     WORD AnswerCount;
192     WORD NameServerCount;
193     WORD AdditionalCount;
194 } DNS_HEADER, *PDNS_HEADER;
195 
196 typedef struct _DNS_MESSAGE_BUFFER
197 {
198     DNS_HEADER MessageHead;
199     CHAR MessageBody[1];
200 } DNS_MESSAGE_BUFFER, *PDNS_MESSAGE_BUFFER;
201 
202 typedef struct
203 {
204     IP4_ADDRESS IpAddress;
205 } DNS_A_DATA, *PDNS_A_DATA;
206 
207 typedef struct _DnsRecordFlags
208 {
209     DWORD Section :2;
210     DWORD Delete :1;
211     DWORD CharSet :2;
212     DWORD Unused :3;
213     DWORD Reserved :24;
214 } DNS_RECORD_FLAGS;
215 
216 typedef struct
217 {
218     PSTR  pNamePrimaryServer;
219     PSTR  pNameAdministrator;
220     DWORD dwSerialNo;
221     DWORD dwRefresh;
222     DWORD dwRetry;
223     DWORD dwExpire;
224     DWORD dwDefaultTtl;
225 } DNS_SOA_DATAA, *PDNS_SOA_DATAA;
226 
227 typedef struct
228 {
229     PWSTR pNamePrimaryServer;
230     PWSTR pNameAdministrator;
231     DWORD dwSerialNo;
232     DWORD dwRefresh;
233     DWORD dwRetry;
234     DWORD dwExpire;
235     DWORD dwDefaultTtl;
236 } DNS_SOA_DATAW, *PDNS_SOA_DATAW;
237 
238 DECL_WINELIB_TYPE_AW(DNS_SOA_DATA)
239 DECL_WINELIB_TYPE_AW(PDNS_SOA_DATA)
240 
241 typedef struct
242 {
243     PSTR pNameHost;
244 } DNS_PTR_DATAA, *PDNS_PTR_DATAA;
245 
246 typedef struct
247 {
248     PWSTR pNameHost;
249 } DNS_PTR_DATAW, *PDNS_PTR_DATAW;
250 
251 DECL_WINELIB_TYPE_AW(DNS_PTR_DATA)
252 DECL_WINELIB_TYPE_AW(PDNS_PTR_DATA)
253 
254 typedef struct
255 {
256     PSTR pNameMailbox;
257     PSTR pNameErrorsMailbox;
258 } DNS_MINFO_DATAA, *PDNS_MINFO_DATAA;
259 
260 typedef struct
261 {
262     PWSTR pNameMailbox;
263     PWSTR pNameErrorsMailbox;
264 } DNS_MINFO_DATAW, *PDNS_MINFO_DATAW;
265 
266 DECL_WINELIB_TYPE_AW(DNS_MINFO_DATA)
267 DECL_WINELIB_TYPE_AW(PDNS_MINFO_DATA)
268 
269 typedef struct
270 {
271     PSTR pNameExchange;
272     WORD wPreference;
273     WORD Pad;
274 } DNS_MX_DATAA, *PDNS_MX_DATAA;
275 
276 typedef struct
277 {
278     PWSTR pNameExchange;
279     WORD wPreference;
280     WORD Pad;
281 } DNS_MX_DATAW, *PDNS_MX_DATAW;
282 
283 DECL_WINELIB_TYPE_AW(DNS_MX_DATA)
284 DECL_WINELIB_TYPE_AW(PDNS_MX_DATA)
285 
286 typedef struct
287 {
288     DWORD dwStringCount;
289     PSTR pStringArray[1];
290 } DNS_TXT_DATAA, *PDNS_TXT_DATAA;
291 
292 typedef struct
293 {
294     DWORD dwStringCount;
295     PWSTR pStringArray[1];
296 } DNS_TXT_DATAW, *PDNS_TXT_DATAW;
297 
298 DECL_WINELIB_TYPE_AW(DNS_TXT_DATA)
299 DECL_WINELIB_TYPE_AW(PDNS_TXT_DATA)
300 
301 typedef struct
302 {
303     DWORD dwByteCount;
304     BYTE Data[1];
305 } DNS_NULL_DATA, *PDNS_NULL_DATA;
306 
307 typedef struct
308 {
309     IP4_ADDRESS IpAddress;
310     UCHAR chProtocol;
311     BYTE BitMask[1];
312 } DNS_WKS_DATA, *PDNS_WKS_DATA;
313 
314 typedef struct
315 {
316     DNS_IP6_ADDRESS Ip6Address;
317 } DNS_AAAA_DATA, *PDNS_AAAA_DATA;
318 
319 typedef struct
320 {
321     WORD wFlags;
322     BYTE chProtocol;
323     BYTE chAlgorithm;
324     BYTE Key[1];
325 } DNS_KEY_DATA, *PDNS_KEY_DATA;
326 
327 typedef struct
328 {
329     WORD wVersion;
330     WORD wSize;
331     WORD wHorPrec;
332     WORD wVerPrec;
333     DWORD dwLatitude;
334     DWORD dwLongitude;
335     DWORD dwAltitude;
336 } DNS_LOC_DATA, *PDNS_LOC_DATA;
337 
338 typedef struct
339 {
340     PSTR pNameSigner;
341     WORD wTypeCovered;
342     BYTE chAlgorithm;
343     BYTE chLabelCount;
344     DWORD dwOriginalTtl;
345     DWORD dwExpiration;
346     DWORD dwTimeSigned;
347     WORD wKeyTag;
348     WORD Pad;
349     BYTE Signature[1];
350 } DNS_SIG_DATAA, *PDNS_SIG_DATAA;
351 
352 typedef struct
353 {
354     PWSTR pNameSigner;
355     WORD wTypeCovered;
356     BYTE chAlgorithm;
357     BYTE chLabelCount;
358     DWORD dwOriginalTtl;
359     DWORD dwExpiration;
360     DWORD dwTimeSigned;
361     WORD wKeyTag;
362     WORD Pad;
363     BYTE Signature[1];
364 } DNS_SIG_DATAW, *PDNS_SIG_DATAW;
365 
366 DECL_WINELIB_TYPE_AW(DNS_SIG_DATA)
367 DECL_WINELIB_TYPE_AW(PDNS_SIG_DATA)
368 
369 #define DNS_ATMA_MAX_ADDR_LENGTH 20
370 
371 typedef struct
372 {
373     BYTE AddressType;
374     BYTE Address[DNS_ATMA_MAX_ADDR_LENGTH];
375 } DNS_ATMA_DATA, *PDNS_ATMA_DATA;
376 
377 typedef struct
378 {
379     PSTR pNameNext;
380     WORD wNumTypes;
381     WORD wTypes[1];
382 } DNS_NXT_DATAA, *PDNS_NXT_DATAA;
383 
384 typedef struct
385 {
386     PWSTR pNameNext;
387     WORD wNumTypes;
388     WORD wTypes[1];
389 } DNS_NXT_DATAW, *PDNS_NXT_DATAW;
390 
391 DECL_WINELIB_TYPE_AW(DNS_NXT_DATA)
392 DECL_WINELIB_TYPE_AW(PDNS_NXT_DATA)
393 
394 typedef struct
395 {
396     PSTR pNameTarget;
397     WORD wPriority;
398     WORD wWeight;
399     WORD wPort;
400     WORD Pad;
401 } DNS_SRV_DATAA, *PDNS_SRV_DATAA;
402 
403 typedef struct
404 {
405     PWSTR pNameTarget;
406     WORD wPriority;
407     WORD wWeight;
408     WORD wPort;
409     WORD Pad;
410 } DNS_SRV_DATAW, *PDNS_SRV_DATAW;
411 
412 DECL_WINELIB_TYPE_AW(DNS_SRV_DATA)
413 DECL_WINELIB_TYPE_AW(PDNS_SRV_DATA)
414 
415 typedef struct
416 {
417     PSTR pNameAlgorithm;
418     PBYTE pAlgorithmPacket;
419     PBYTE pKey;
420     PBYTE pOtherData;
421     DWORD dwCreateTime;
422     DWORD dwExpireTime;
423     WORD wMode;
424     WORD wError;
425     WORD wKeyLength;
426     WORD wOtherLength;
427     UCHAR cAlgNameLength;
428     BOOL bPacketPointers;
429 } DNS_TKEY_DATAA, *PDNS_TKEY_DATAA;
430 
431 typedef struct
432 {
433     PWSTR pNameAlgorithm;
434     PBYTE pAlgorithmPacket;
435     PBYTE pKey;
436     PBYTE pOtherData;
437     DWORD dwCreateTime;
438     DWORD dwExpireTime;
439     WORD wMode;
440     WORD wError;
441     WORD wKeyLength;
442     WORD wOtherLength;
443     UCHAR cAlgNameLength;
444     BOOL bPacketPointers;
445 } DNS_TKEY_DATAW, *PDNS_TKEY_DATAW;
446 
447 DECL_WINELIB_TYPE_AW(DNS_TKEY_DATA)
448 DECL_WINELIB_TYPE_AW(PDNS_TKEY_DATA)
449 
450 typedef struct
451 {
452     PSTR pNameAlgorithm;
453     PBYTE pAlgorithmPacket;
454     PBYTE pSignature;
455     PBYTE pOtherData;
456     LONGLONG i64CreateTime;
457     WORD wFudgeTime;
458     WORD wOriginalXid;
459     WORD wError;
460     WORD wSigLength;
461     WORD wOtherLength;
462     UCHAR cAlgNameLength;
463     BOOL bPacketPointers;
464 } DNS_TSIG_DATAA, *PDNS_TSIG_DATAA;
465 
466 typedef struct
467 {
468     PWSTR pNameAlgorithm;
469     PBYTE pAlgorithmPacket;
470     PBYTE pSignature;
471     PBYTE pOtherData;
472     LONGLONG i64CreateTime;
473     WORD wFudgeTime;
474     WORD wOriginalXid;
475     WORD wError;
476     WORD wSigLength;
477     WORD wOtherLength;
478     UCHAR cAlgNameLength;
479     BOOL bPacketPointers;
480 } DNS_TSIG_DATAW, *PDNS_TSIG_DATAW;
481 
482 typedef struct
483 {
484     DWORD dwMappingFlag;
485     DWORD dwLookupTimeout;
486     DWORD dwCacheTimeout;
487     DWORD cWinsServerCount;
488     IP4_ADDRESS WinsServers[1];
489 } DNS_WINS_DATA, *PDNS_WINS_DATA;
490 
491 typedef struct
492 {
493     DWORD dwMappingFlag;
494     DWORD dwLookupTimeout;
495     DWORD dwCacheTimeout;
496     PSTR pNameResultDomain;
497 } DNS_WINSR_DATAA, *PDNS_WINSR_DATAA;
498 
499 typedef struct
500 {
501     DWORD dwMappingFlag;
502     DWORD dwLookupTimeout;
503     DWORD dwCacheTimeout;
504     PWSTR pNameResultDomain;
505 } DNS_WINSR_DATAW, *PDNS_WINSR_DATAW;
506 
507 DECL_WINELIB_TYPE_AW(DNS_WINSR_DATA)
508 DECL_WINELIB_TYPE_AW(PDNS_WINSR_DATA)
509 
510 typedef struct _DnsRecordA
511 {
512     struct _DnsRecordA *pNext;
513     PSTR pName;
514     WORD wType;
515     WORD wDataLength;
516     union
517     {
518         DWORD DW;
519         DNS_RECORD_FLAGS S;
520     } Flags;
521     DWORD dwTtl;
522     DWORD dwReserved;
523     union
524     {
525         DNS_A_DATA A;
526         DNS_SOA_DATAA SOA, Soa;
527         DNS_PTR_DATAA PTR, Ptr, NS, Ns, CNAME, Cname, MB, Mb, MD, Md, MF, Mf, MG, Mg, MR, Mr;
528         DNS_MINFO_DATAA MINFO, Minfo, RP, Rp;
529         DNS_MX_DATAA MX, Mx, AFSDB, Afsdb, RT, Rt;
530         DNS_TXT_DATAA HINFO, Hinfo, ISDN, Isdn, TXT, Txt, X25;
531         DNS_NULL_DATA Null;
532         DNS_WKS_DATA WKS, Wks;
533         DNS_AAAA_DATA AAAA;
534         DNS_KEY_DATA KEY, Key;
535         DNS_SIG_DATAA SIG, Sig;
536         DNS_ATMA_DATA ATMA, Atma;
537         DNS_NXT_DATAA NXT, Nxt;
538         DNS_SRV_DATAA SRV, Srv;
539         DNS_TKEY_DATAA TKEY, Tkey;
540         DNS_TSIG_DATAA TSIG, Tsig;
541         DNS_WINS_DATA WINS, Wins;
542         DNS_WINSR_DATAA WINSR, WinsR, NBSTAT, Nbstat;
543     } Data;
544 } DNS_RECORDA, *PDNS_RECORDA;
545 
546 typedef struct _DnsRecordW
547 {
548     struct _DnsRecordW *pNext;
549     PWSTR pName;
550     WORD wType;
551     WORD wDataLength;
552     union
553     {
554         DWORD DW;
555         DNS_RECORD_FLAGS S;
556     } Flags;
557     DWORD dwTtl;
558     DWORD dwReserved;
559     union
560     {
561         DNS_A_DATA A;
562         DNS_SOA_DATAW SOA, Soa;
563         DNS_PTR_DATAW PTR, Ptr, NS, Ns, CNAME, Cname, MB, Mb, MD, Md, MF, Mf, MG, Mg, MR, Mr;
564         DNS_MINFO_DATAW MINFO, Minfo, RP, Rp;
565         DNS_MX_DATAW MX, Mx, AFSDB, Afsdb, RT, Rt;
566         DNS_TXT_DATAW HINFO, Hinfo, ISDN, Isdn, TXT, Txt, X25;
567         DNS_NULL_DATA Null;
568         DNS_WKS_DATA WKS, Wks;
569         DNS_AAAA_DATA AAAA;
570         DNS_KEY_DATA KEY, Key;
571         DNS_SIG_DATAW SIG, Sig;
572         DNS_ATMA_DATA ATMA, Atma;
573         DNS_NXT_DATAW NXT, Nxt;
574         DNS_SRV_DATAW SRV, Srv;
575         DNS_TKEY_DATAW TKEY, Tkey;
576         DNS_TSIG_DATAW TSIG, Tsig;
577         DNS_WINS_DATA WINS, Wins;
578         DNS_WINSR_DATAW WINSR, WinsR, NBSTAT, Nbstat;
579     } Data;
580 } DNS_RECORDW, *PDNS_RECORDW;
581 
582 #if defined(__WINESRC__) || defined(UNICODE)
583 typedef DNS_RECORDW DNS_RECORD;
584 typedef PDNS_RECORDW PDNS_RECORD;
585 #else
586 typedef DNS_RECORDA DNS_RECORD;
587 typedef PDNS_RECORDA PDNS_RECORD;
588 #endif
589 
590 typedef struct _DnsRRSet
591 {
592     PDNS_RECORD pFirstRR;
593     PDNS_RECORD pLastRR;
594 } DNS_RRSET, *PDNS_RRSET;
595 
596 #define DNS_RRSET_INIT( rrset )                          \
597 {                                                        \
598     PDNS_RRSET  _prrset = &(rrset);                      \
599     _prrset->pFirstRR = NULL;                            \
600     _prrset->pLastRR = (PDNS_RECORD) &_prrset->pFirstRR; \
601 }
602 
603 #define DNS_RRSET_ADD( rrset, pnewRR ) \
604 {                                      \
605     PDNS_RRSET  _prrset = &(rrset);    \
606     PDNS_RECORD _prrnew = (pnewRR);    \
607     _prrset->pLastRR->pNext = _prrnew; \
608     _prrset->pLastRR = _prrnew;        \
609 }
610 
611 #define DNS_RRSET_TERMINATE( rrset ) \
612 {                                    \
613     PDNS_RRSET  _prrset = &(rrset);  \
614     _prrset->pLastRR->pNext = NULL;  \
615 }
616 
617 DNS_STATUS WINAPI DnsAcquireContextHandle_A(DWORD,PVOID,PHANDLE);
618 DNS_STATUS WINAPI DnsAcquireContextHandle_W(DWORD,PVOID,PHANDLE);
619 #define DnsAcquireContextHandle WINELIB_NAME_AW(DnsAcquireContextHandle_)
620 DNS_STATUS WINAPI DnsExtractRecordsFromMessage_W(PDNS_MESSAGE_BUFFER,WORD,PDNS_RECORDW*);
621 DNS_STATUS WINAPI DnsExtractRecordsFromMessage_UTF8(PDNS_MESSAGE_BUFFER,WORD,PDNS_RECORDA*);
622 DNS_STATUS WINAPI DnsModifyRecordsInSet_A(PDNS_RECORDA,PDNS_RECORDA,DWORD,HANDLE,PVOID,PVOID);
623 DNS_STATUS WINAPI DnsModifyRecordsInSet_W(PDNS_RECORDW,PDNS_RECORDW,DWORD,HANDLE,PVOID,PVOID);
624 DNS_STATUS WINAPI DnsModifyRecordsInSet_UTF8(PDNS_RECORDA,PDNS_RECORDA,DWORD,HANDLE,PVOID,PVOID);
625 #define DnsModifyRecordsInSet WINELIB_NAME_AW(DnsModifyRecordsInSet_)
626 BOOL WINAPI DnsNameCompare_A(PCSTR,PCSTR);
627 BOOL WINAPI DnsNameCompare_W(PCWSTR,PCWSTR);
628 #define DnsNameCompare WINELIB_NAME_AW(DnsNameCompare_)
629 DNS_STATUS WINAPI DnsQuery_A(PCSTR,WORD,DWORD,PVOID,PDNS_RECORDA*,PVOID*);
630 DNS_STATUS WINAPI DnsQuery_W(PCWSTR,WORD,DWORD,PVOID,PDNS_RECORDW*,PVOID*);
631 DNS_STATUS WINAPI DnsQuery_UTF8(PCSTR,WORD,DWORD,PVOID,PDNS_RECORDA*,PVOID*);
632 #define DnsQuery WINELIB_NAME_AW(DnsQuery_)
633 DNS_STATUS WINAPI DnsQueryConfig(DNS_CONFIG_TYPE,DWORD,PCWSTR,PVOID,PVOID,PDWORD);
634 BOOL WINAPI DnsRecordCompare(PDNS_RECORD,PDNS_RECORD);
635 PDNS_RECORD WINAPI DnsRecordCopyEx(PDNS_RECORD,DNS_CHARSET,DNS_CHARSET);
636 VOID WINAPI DnsRecordListFree(PDNS_RECORD,DNS_FREE_TYPE);
637 BOOL WINAPI DnsRecordSetCompare(PDNS_RECORD,PDNS_RECORD,PDNS_RECORD*,PDNS_RECORD*);
638 PDNS_RECORD WINAPI DnsRecordSetCopyEx(PDNS_RECORD,DNS_CHARSET,DNS_CHARSET);
639 PDNS_RECORD WINAPI DnsRecordSetDetach(PDNS_RECORD);
640 void WINAPI DnsReleaseContextHandle(HANDLE);
641 DNS_STATUS WINAPI DnsReplaceRecordSetA(PDNS_RECORDA,DWORD,HANDLE,PVOID,PVOID);
642 DNS_STATUS WINAPI DnsReplaceRecordSetW(PDNS_RECORDW,DWORD,HANDLE,PVOID,PVOID);
643 DNS_STATUS WINAPI DnsReplaceRecordSetUTF8(PDNS_RECORDA,DWORD,HANDLE,PVOID,PVOID);
644 #define DnsReplaceRecordSet WINELIB_NAME_AW(DnsReplaceRecordSet)
645 DNS_STATUS WINAPI DnsValidateName_A(PCSTR,DNS_NAME_FORMAT);
646 DNS_STATUS WINAPI DnsValidateName_W(PCWSTR, DNS_NAME_FORMAT);
647 DNS_STATUS WINAPI DnsValidateName_UTF8(PCSTR,DNS_NAME_FORMAT);
648 #define DnsValidateName WINELIB_NAME_AW(DnsValidateName_)
649 BOOL WINAPI DnsWriteQuestionToBuffer_W(PDNS_MESSAGE_BUFFER,PDWORD,PCWSTR,WORD,WORD,BOOL);
650 BOOL WINAPI DnsWriteQuestionToBuffer_UTF8(PDNS_MESSAGE_BUFFER,PDWORD,PCSTR,WORD,WORD,BOOL);
651 
652 #ifdef __cplusplus
653 }
654 #endif
655 
656 #endif
657 