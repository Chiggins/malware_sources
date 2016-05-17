Imports System

Namespace LuxNET
    <Flags> _
    Friend Enum RuntimeProtection As Byte
        ' Fields
        Debuggers = 1
        DebuggersEx = 2
        FullScan = 15
        None = 0
        Parent = 8
        Timing = 4
        VirtualMachine = &H10
    End Enum
End Namespace
