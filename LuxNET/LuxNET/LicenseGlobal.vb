Imports Microsoft.VisualBasic.CompilerServices
Imports System

Namespace LuxNET
    <StandardModule> _
    Friend NotInheritable Class LicenseGlobal
        ' Fields
        Friend Shared LicenseInitialize As Boolean
        Friend Shared Seal As License = New License
    End Class
End Namespace