Imports System.Reflection
Imports System.Runtime.CompilerServices
Imports System.ComponentModel

Namespace My


    ' The following events are available for MyApplication:
    ' 
    ' Startup: Raised when the application starts, before the startup form is created.
    ' Shutdown: Raised after all application forms are closed.  This event is not raised if the application terminates abnormally.
    ' UnhandledException: Raised if the application encounters an unhandled exception.
    ' StartupNextInstance: Raised when launching a single-instance application and the application is already active. 
    ' NetworkAvailabilityChanged: Raised when the network connection is connected or disconnected.
    Partial Friend Class MyApplication

        Private WithEvents MyDomain As AppDomain = AppDomain.CurrentDomain
        Private Function MyDomain_AssemblyResolve(ByVal sender As Object, ByVal args As System.ResolveEventArgs) As System.Reflection.Assembly Handles MyDomain.AssemblyResolve
            If args.Name.Contains("BetterListView") Then
                Return System.Reflection.Assembly.Load(My.Resources.Components)
            End If
            If args.Name.Contains("ImageListView") Then
                Return System.Reflection.Assembly.Load(My.Resources.ImageListView)
            End If
            Return Nothing
        End Function
    End Class


End Namespace

