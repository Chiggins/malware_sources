;-------------------------------------------------------------------------------
; CoLib.inc   Common data, structures, functions and macros
;              to be used as a template for in-process com server objects
;
; Copyright (c) 9/28/00  Ernest Murphy
; For educational use only. Any commercial re-use only by written license
;
;
;-------------------------------------------------------------------------------

; standard dll exports
DllMain                 PROTO :DWORD, :DWORD, :DWORD
DllRegisterServer       PROTO
DllUnregisterServer     PROTO
DllCanUnloadNow         PROTO
DllGetClassObject       PROTO :DWORD, :DWORD, :DWORD

; standard interface implimentations

; IUnknown interface implimentations
QueryInterface          PROTO :DWORD, :DWORD, :DWORD
AddRef                  PROTO :DWORD
Release                 PROTO :DWORD
NDQueryInterface        PROTO :DWORD, :DWORD, :DWORD
NDAddRef                PROTO :DWORD
NDRelease               PROTO :DWORD

; IDispatch interface implimentations
GetTypeInfoCount        PROTO :DWORD, :DWORD
GetTypeInfo             PROTO :DWORD, :DWORD, :DWORD, :DWORD
GetIDsOfNames           PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
Invoke_                 PROTO :DWORD, :DWORD, :DWORD, :DWORD, :WORD,  :DWORD, :DWORD, :DWORD, :DWORD

; Class Factory interface implimentations
CreateInstance          PROTO :DWORD, :DWORD, :DWORD, :DWORD
LockServer              PROTO :DWORD, :DWORD

; internal helper functions
Register                PROTO :DWORD
SetSubKey               PROTO :DWORD, :DWORD, :DWORD
GetNextToken            PROTO
AddReplacements         PROTO :DWORD
GuardedDeleteKey        PROTO :DWORD, :DWORD
AllocObject             PROTO :DWORD, :DWORD, :DWORD, :DWORD
DeallocObject           PROTO :DWORD
GetCachedTypeInfo       PROTO :DWORD, :DWORD, :DWORD

; external helper functions
ComPtrAssign            PROTO :DWORD, :DWORD
ComQIPtrAssign          PROTO :DWORD, :DWORD, :DWORD

; constructor and destructor prototypes. These must be followed 
;  by all implimented classes. this_ passes the object reference, 
;  use pObjectData macro to reference member data
ConstructorProto        TYPEDEF PROTO this_:DWORD, :DWORD
Constructor             TYPEDEF PTR ConstructorProto
DestructorProto         TYPEDEF PROTO this_:DWORD
Destructor              TYPEDEF PTR DestructorProto


.data 

externdef       g_hModule:DWORD
externdef       g_hHeap:DWORD
externdef       g_ObjectCount:DWORD


ClassItem STRUCT  DWORD
    m_clsid             DWORD   0       ; CLSID; GUID of this class
    m_Flags             DWORD   0       ; flags for AGGREGATION, 
                                        ;  DISPINTERFACE and 
                                        ;  ISupportErrorInfo
    m_pTypeLibInfo      DWORD   0       ; type info map
    m_pIMap             DWORD   0       ; InterfaceMap for this object
    m_pConstructor      DWORD   0       ; custom object constructor function
    m_pDestructor       DWORD   0       ; custom object destructor function
    m_pData             DWORD   0       ; reference to class custom data
    m_ObjectSize        DWORD   0       ; byte count of object
ClassItem ENDS

END_CLASS_MAP MACRO 
    LOCAL LastClassItem
    LastClassItem       ClassItem       {0, 0, 0, 0, 0, 0, 0}
ENDM

TypeLibInfo   STRUCT  DWORD
    m_pIID_TYPELIB      DWORD   0       ; GUID for this type lib
    m_MajorVer          DWORD   0       ; Major Version of type lib
    m_MinorVer          DWORD   0       ; Minor Version of type lib
TypeLibInfo   ENDS

InterfaceItem STRUCT  DWORD
    m_refiid            DWORD   0       ; iid; the GUID of this interface
    m_pVtbl             DWORD   0       ; pointer to implementation table
InterfaceItem ENDS

END_INTERFACE_MAP MACRO 
    LOCAL LastInterfaceItem
    LastInterfaceItem   InterfaceItem    {0, 0}
ENDM

AggItem STRUCT  DWORD
    m_pInnerUnknown     DWORD   0       ; Inner IUnknown of object
    m_pNextItem         DWORD   0       ; pointer to next item 
                                        ; in list if any, NULL if last item
AggItem ENDS

ObjectData   STRUCT  DWORD
    m_RefCount       DWORD      1       ; reference count
    m_pUnkOuter      DWORD      0       ; aggregating object's IUnknown
    m_lcid           DWORD      0       ; current LCID of this object (to cache pti)
    m_pti            DWORD      0       ; object type library info pointer
    m_pAggList       DWORD      0       ; pointer to first aggregated object
    m_pClassItem     DWORD      0       ; object item data pointer
    m_pEntry0        DWORD      0       ; first IMap entry (skips custom data)
ObjectData   ENDS

ObjectEntry  STRUCT  DWORD
    m_pVtbl         DWORD       0       ; interface object
    m_pBase         DWORD       0       ; pointer to base
ObjectEntry  ENDS

; generic object
GenericObject    STRUCT  DWORD
    ObjectData0     ObjectData  { }     ; base values
    CustomData      DWORD        ?      ; info on the object to impliment, 
    ObjectEntry1    ObjectEntry { }
GenericObject    ENDS

CFmembers   STRUCT  DWORD
    m_pClassItem   DWORD       NULL
CFmembers   ENDS

; declare the ClassFactory object structure
; this is only run-time instanced
ClassFactObject STRUCT  DWORD
    ObjectData0     ObjectData  { }     ; base values
    CFMembers       CFmembers   { }     ; info on the object to impliment
    ObjectEntry0    ObjectEntry { }     ; non-delegating Unknown
    ObjectEntry1    ObjectEntry { }     ; IClassFactory   
ClassFactObject ENDS


;--------------------------------------------------------------------------------------
AGGREGATABLE        EQU         1H
DISPINTERFACE       EQU         2H
SUPPORT_ERROR_INFO  EQU         4H
SUPPLY_TYPE_INFO    EQU         8H

IDD_RGS_SCRIPT      EQU         100
IDS_FORCE_REMOVE    EQU         200
IDS_NO_REMOVE       EQU         201
IDS_MODULE          EQU         202
IDS_TypeLib         EQU         203
IDS_REGISTRY        EQU         204

MAX_TOKEN           EQU         4096

pIID_IUnknown       EQU         OFFSET IID_IUnknown
pIID_IClassFactory  EQU         OFFSET IID_IClassFactory
pIID_IDispatch      EQU         OFFSET IID_IDispatch

pvtIUnknown         TEXTEQU     <QueryInterface, AddRef, Release>

pvtIDispatch        TEXTEQU     <pvtIUnknown, GetTypeInfoCount, \
                                 GetTypeInfo, GetIDsOfNames, Invoke_>

;--------------------------------------------------------------------------------------
pObjectBase MACRO pObject:REQ, reg:REQ, _offset:VARARG
    .code
    ; cast object to the base ClassItem interface
    mov reg, pObject                                ; get object
    mov reg, (ObjectEntry PTR[reg]).m_pBase         ; walk to base data
    IFNB <_offset>
        add reg, _offset
    ENDIF
ENDM

;--------------------------------------------------------------------------------------
pObjectData MACRO pObject:REQ, reg:REQ, _offset:VARARG
    .code
    mov reg, pObject                                ; get object
    mov reg, (ObjectEntry PTR[reg]).m_pBase         ; walk to base data
    add reg, SIZEOF ObjectData
    IFNB <_offset>
        add reg, _offset
    ENDIF
ENDM

;--------------------------------------------------------------------------------------
DeclareGuid MACRO gName:req, IID:vararg
    .data
    IFNB  <IID>
        gName       GUID        IID
    ELSE
        gName       GUID        s&gName
    ENDIF
    p&gName     EQU         OFFSET gName
ENDM

;--------------------------------------------------------------------------------------