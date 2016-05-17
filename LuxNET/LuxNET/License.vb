Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.IO
Imports System.IO.Compression
Imports System.Net
Imports System.Net.Security
Imports System.Reflection
Imports System.Runtime.CompilerServices
Imports System.Runtime.InteropServices
Imports System.Security.Cryptography
Imports System.Security.Cryptography.X509Certificates
Imports System.Text
Imports System.Threading
Imports System.Windows.Forms
Imports System.Environment

Namespace LuxNET
    Friend NotInheritable Class License
        ' Methods
        Public Sub BanCurrentUser(ByVal reason As String)
            Me.Instance.GetMethod("BanCurrentUser").Invoke(Nothing, New Object() {reason})
        End Sub

        Private Function CheckCore() As Boolean
            Dim runtimeDirectory As String = RuntimeEnvironment.GetRuntimeDirectory
            Dim systemVersion As String = RuntimeEnvironment.GetSystemVersion
            Dim ch As Char = systemVersion.Chars(1)
            Dim hostCLR As Boolean = (Integer.Parse(ch.ToString) >= 4)
            If hostCLR Then
                Dim cid As New Guid("9280188D-0E8E-4867-B30C-7FA83884E8DE")
                Dim guid2 As New Guid("B79B0ACD-F5CD-409B-B5A5-A16244610B92")
                Dim meta As IMeta = DirectCast(License.CreateInstance(cid, GetType(IMeta).GUID), IMeta)
                Dim runtime As IRuntime = DirectCast(meta.GetRuntime(systemVersion, GetType(IRuntime).GUID), IRuntime)
                Me.SN = DirectCast(runtime.GetInterface(guid2, GetType(IStrongName).GUID), IStrongName)
            End If
            Dim path As Object = path.ChangeExtension(path.Combine(runtimeDirectory, "mscorlib"), "dll")
            Dim str4 As String = path.ChangeExtension(path.Combine(runtimeDirectory, "system"), "dll")
            Dim token As Byte() = New Byte() {&HB7, &H7A, &H5C, &H56, &H19, &H34, &HE0, &H89}
            If Not Me.IsTrusted(path, token, hostCLR) Then
                Return False
            End If
            If Not Me.IsTrusted(str4, token, hostCLR) Then
                Return False
            End If
            Return True
        End Function

        <DllImport("mscoree.dll", EntryPoint:="CLRCreateInstance", PreserveSig:=False)> _
        Private Shared Function CreateInstance(<MarshalAs(UnmanagedType.LPStruct)> ByVal cid As Guid, <MarshalAs(UnmanagedType.LPStruct)> ByVal iid As Guid) As <MarshalAs(UnmanagedType.Interface)> Object
        End Function

        Private Function Decompress(ByVal data As Byte()) As Byte()
            Dim array As Byte() = New Byte(((BitConverter.ToInt32(data, 0) - 1) + 1) - 1) {}
            Dim stream2 As New MemoryStream(data, 4, (data.Length - 4))
            Dim stream As New DeflateStream(stream2, CompressionMode.Decompress, False)
            stream.Read(array, 0, array.Length)
            stream.Close()
            stream2.Close()
            Return array
        End Function

        Public Function Decrypt(ByVal data As Byte()) As Byte()
            Me.InitializeRm()
            Dim count As Integer = BitConverter.ToInt32(data, 0)
            Dim src As Byte() = Me.Decryptor.TransformFinalBlock(data, 4, (data.Length - 4))
            Dim dst As Byte() = New Byte(((count - 1) + 1) - 1) {}
            Buffer.BlockCopy(src, 0, dst, 0, count)
            Return dst
        End Function

        Private Sub DownloadChecksums()
            Try
                Me.Checksums = Me.WC.DownloadString(("http://seal.nimoru.com/Base/checksumSE.php" & Me.UID)).Split(New Char() {ChrW(0)})
            Catch exception1 As Exception
                ProjectData.SetProjectError(exception1)
                Dim exception As Exception = exception1
                Thread.Sleep(500)
                Me.Checksums = Me.WC.DownloadString(("https://s3.amazonaws.com/nimoru/checksumSE.txt" & Me.UID)).Split(New Char() {Convert.ToChar(&H7C)})
                ProjectData.ClearProjectError()
            End Try
        End Sub

        Private Sub DownloadComponents()
            If Not Directory.Exists(Me.LocationPath) Then
                Directory.CreateDirectory(Me.LocationPath)
            End If
            If Not File.Exists(Me.GizmoDllLocation) Then
                Me.DownloadGizmoDll()
            End If
            If (Me.MD5File(Me.GizmoDllLocation) <> Me.Checksums(1)) Then
                Me.DownloadGizmoDll()
            End If
            If Not File.Exists(Me.GizmoLocation) Then
                Me.DownloadGizmo()
            End If
            If (Me.MD5File(Me.GizmoLocation) <> Me.Checksums(2)) Then
                Me.DownloadGizmo()
            End If
            If Not File.Exists(Me.LicenseLocation) Then
                Me.DownloadLicense()
            End If
            If (Me.MD5File(Me.LicenseLocation) <> Me.Checksums(3)) Then
                Me.DownloadLicense()
            End If
        End Sub

        Private Sub DownloadGizmo()
            Dim data As Byte() = Me.WC.DownloadData((Me.Checksums(0) & Me.Checksums(2) & ".co"))
            data = Me.GizmoDecompress(data)
            Dim str As String = Me.MD5(data)
            If (Me.Checksums(2) <> str) Then
                Me.Fail(Me.GizmoLocation)
            Else
                File.WriteAllBytes(Me.GizmoLocation, data)
            End If
        End Sub

        Private Sub DownloadGizmoDll()
            Dim data As Byte() = Me.WC.DownloadData((Me.Checksums(0) & Me.Checksums(1) & ".co"))
            data = Me.Decompress(data)
            Dim str As String = Me.MD5(data)
            If (Me.Checksums(1) <> str) Then
                Me.Fail(Me.GizmoDllLocation)
            Else
                File.WriteAllBytes(Me.GizmoDllLocation, data)
            End If
        End Sub

        Private Sub DownloadLicense()
            Dim startInfo As New ProcessStartInfo
            startInfo.Arguments = String.Format("""{0}"" ""{1}"" {2} -s", (Me.Checksums(0) & Me.Checksums(3) & ".co"), Me.LicenseLocation, Me.Checksums(3))
            startInfo.FileName = Me.GizmoLocation
            startInfo.UseShellExecute = False
            Dim process As Process = process.Start(startInfo)
            If Not process.WaitForExit(&H4E20) Then
                Environment.Exit(0)
            End If
            If (process.ExitCode <> &H1E6C) Then
                Environment.Exit(0)
            End If
        End Sub

        Public Function Encrypt(ByVal data As String) As String
            Me.InitializeRm()
            Dim bytes As Byte() = Encoding.UTF8.GetBytes(data)
            Dim src As Byte() = Me.Encryptor.TransformFinalBlock(bytes, 0, bytes.Length)
            Dim dst As Byte() = New Byte(((src.Length + 3) + 1) - 1) {}
            Buffer.BlockCopy(BitConverter.GetBytes(data.Length), 0, dst, 0, 4)
            Buffer.BlockCopy(src, 0, dst, 4, src.Length)
            Return Convert.ToBase64String(dst)
        End Function

        Private Sub ErrorKill(ByVal message As String)
            MessageBox.Show(message, "Loader Error", MessageBoxButtons.OK, MessageBoxIcon.Hand)
            Environment.Exit(0)
            License.ExitProcess(0)
        End Sub

        <DllImport("kernel32.dll")> _
        Private Shared Sub ExitProcess(ByVal code As UInt32)
        End Sub

        Private Sub Fail(ByVal path As String)
            File.Delete(path)
            Me.ErrorKill("Failed to initialize all the required components.")
        End Sub

        Public Function GetPostMessage(ByVal postID As Integer) As String
            Return CStr(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetPostMessage").Invoke(Nothing, New Object() {postID})))
        End Function

        Public Function GetVariable(ByVal name As String) As String
            Return CStr(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetVariable").Invoke(Nothing, New Object() {name})))
        End Function

        Private Function GizmoDecompress(ByVal data As Byte()) As Byte()
            Return DirectCast(Assembly.Load(File.ReadAllBytes(Me.GizmoDllLocation)).GetType("H").GetMethod("Decompress").Invoke(Nothing, New Object() {data}), Byte())
        End Function

        Private Function HashToString(ByVal data As Byte()) As String
            Return BitConverter.ToString(data).ToLower.Replace("-", String.Empty)
        End Function

        Public Sub Initialize()
            If Not LicenseGlobal.LicenseInitialize Then
                LicenseGlobal.LicenseInitialize = True
                If String.IsNullOrEmpty(Me.ID) Then
                    Me.ErrorKill("Unable to initialize due to missing Net Seal ID.")
                Else
                    ServicePointManager.Expect100Continue = False
                    ServicePointManager.DefaultConnectionLimit = 5
                    Try
                        Me.WC = New CookieClient
                        Dim folderPath As String = Environment.GetFolderPath(SpecialFolder.CommonApplicationData)
                        Me.LocationPath = Path.Combine(folderPath, "Nimoru")
                        Me.LicenseLocation = Path.Combine(Me.LocationPath, "LicenseSE")
                        Me.GizmoDllLocation = Path.Combine(Me.LocationPath, "GizmoDll")
                        Me.GizmoLocation = Path.Combine(Me.LocationPath, "GizmoSE")
                        Me.OverrideSSL()
                        Me.DownloadChecksums()
                        Me.DownloadComponents()
                        Me.RestoreSSL()
                        Me.Endpoint = Me.Checksums(5)
                        Me.ValidateSignature()
                        Me.Instance.GetMethod("SetID").Invoke(Nothing, New Object() {Me.ID})
                        Me.Instance.GetMethod("SetCatch").Invoke(Nothing, New Object() {Me.Catch})
                        Me.Instance.GetMethod("SetDisableUpdates").Invoke(Nothing, New Object() {Me.DisableUpdates})
                        Me.Instance.GetMethod("SetRunHook").Invoke(Nothing, New Object() {Me.RunHook})
                        Me.Instance.GetMethod("SetBanHook").Invoke(Nothing, New Object() {Me.BanHook})
                        Me.Instance.GetMethod("SetRenewHook").Invoke(Nothing, New Object() {Me.RenewHook})
                        Me.Instance.GetMethod("SetScan").Invoke(Nothing, New Object() {CByte(Me.Protection)})
                    Catch exception1 As Exception
                        ProjectData.SetProjectError(exception1)
                        Dim exception As Exception = exception1
                        Dim builder As New StringBuilder
                        builder.AppendLine(DateTime.UtcNow.ToString)
                        builder.AppendLine()
                        builder.AppendLine(exception.Message)
                        builder.AppendLine(exception.StackTrace)
                        File.WriteAllText("loader.log", builder.ToString)
                        Me.ErrorKill("Unable to continue due to an error. Exception written to 'loader.log' file.")
                        ProjectData.ClearProjectError()
                        Return
                        ProjectData.ClearProjectError()
                    End Try
                    Try
                        Me.Instance.GetMethod("RunWE").Invoke(Nothing, New Object() {Me.Version, Me.ProductVersion, Me.Endpoint})
                    Catch exception2 As Exception
                        ProjectData.SetProjectError(exception2)
                        Me.ErrorKill("Unable to initialize license file.")
                        ProjectData.ClearProjectError()
                    End Try
                End If
            End If
        End Sub

        Public Sub Initialize(ByVal programID As String)
            Me.ID = programID
            Me.Initialize()
        End Sub

        Private Sub InitializeRm()
            If Not Me.RmInitialize Then
                Me.RmInitialize = True
                Dim managed As New RijndaelManaged
                managed.Padding = PaddingMode.Zeros
                managed.Mode = CipherMode.CBC
                managed.Key = Me.PrivateKey
                managed.IV = Me.PrivateKey
                Me.Encryptor = managed.CreateEncryptor
                Me.Decryptor = managed.CreateDecryptor
            End If
        End Sub

        Public Sub InstallUpdates()
            Me.Instance.GetMethod("InstallUpdates").Invoke(Nothing, Nothing)
        End Sub

        Private Function IsTrusted(ByVal path As String, ByVal token As Byte(), ByVal hostCLR As Boolean) As Boolean
            Dim flag As Boolean
            Dim num2 As Integer
            If hostCLR Then
                If ((Me.SN.StrongNameSignatureVerificationEx(path, True, flag) <> 0) OrElse Not flag) Then
                    Return False
                End If
            ElseIf (Not License.StrongNameSignatureVerificationEx(path, True, flag) OrElse Not flag) Then
                Return False
            End If
            Dim publicKeyToken As Byte() = Assembly.LoadFile(path).GetName.GetPublicKeyToken
            If ((publicKeyToken Is Nothing) OrElse (publicKeyToken.Length <> 8)) Then
                Return False
            End If
            Dim index As Integer = 0
            Do
                If (publicKeyToken(index) <> token(index)) Then
                    Return False
                End If
                index += 1
                num2 = 7
            Loop While (index <= num2)
            Return True
        End Function

        Private Function MD5(ByVal data As Byte()) As String
            Dim provider As New MD5CryptoServiceProvider
            Return Me.HashToString(provider.ComputeHash(data))
        End Function

        Private Function MD5File(ByVal path As String) As String
            Dim inputStream As New FileStream(path, FileMode.Open, FileAccess.Read)
            Dim provider As New MD5CryptoServiceProvider
            Dim str As String = Me.HashToString(provider.ComputeHash(inputStream))
            inputStream.Close()
            Return str
        End Function

        Private Sub OverrideSSL()
            Me.SSLCallback = ServicePointManager.ServerCertificateValidationCallback
            ServicePointManager.ServerCertificateValidationCallback = New RemoteCertificateValidationCallback(AddressOf Me.ValidateSSL)
        End Sub

        Private Sub RestoreSSL()
            ServicePointManager.ServerCertificateValidationCallback = Me.SSLCallback
        End Sub

        Public Sub ShowAccount()
            Me.Instance.GetMethod("ShowAccount").Invoke(Nothing, Nothing)
        End Sub

        Public Function SpendPoints(ByVal count As Integer) As Boolean
            Return CBool(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("SpendPoints").Invoke(Nothing, New Object() {count})))
        End Function

        <DllImport("mscoree.dll", CharSet:=CharSet.Unicode)> _
        Private Shared Function StrongNameSignatureVerificationEx(ByVal fileName As String, ByVal force As Boolean, ByRef genuine As Boolean) As Boolean
        End Function

        Private Sub ValidateSignature()
            If (Me.ValidateCore AndAlso Not Me.CheckCore) Then
                Throw New InvalidDataException("Core framework files are not trusted.")
            End If
            Dim input As FileStream = File.OpenRead(Me.LicenseLocation)
            Dim reader As New BinaryReader(input)
            Dim rawAssembly As Byte() = reader.ReadBytes(CInt(input.Length))
            input.Position = 2
            Dim rgbSignature As Byte() = reader.ReadBytes(40)
            Dim rgbData As Byte() = reader.ReadBytes(CInt(((input.Length - rgbSignature.Length) - 2)))
            reader.Close()
            Dim provider As New DSACryptoServiceProvider
            provider.ImportCspBlob(Convert.FromBase64String("BgIAAAAiAABEU1MxAAQAAKVlurdZMaHymNk04yRy3VGj0Bhf6gGIBsGr1zk42LrdnwYLfvn7MBAiYoCH2cD07M/HuM6NW1WqJQVF2omwH5S211wfvBCutU92RxXldmfvd06l8eQqmppztYIrXdxmW0BRlosBKPM5ms6YXZnoMKseAoqZ6Ajza8U9QCJMkSHSR+O23EoGj9V+7xwkCoYHklFtLJzERB6y/DW1BCCHhLblzpFz+mht1CD6xAi2QBNY7vZcWdbqo+ZLT4y7sw8jU61liYBuZLA/t+6KHhoIwZ+NIErsCHW5RD9ln5VpMC66wBCcY594ZTIManIuvmpw4eQaUXZPoMogf29gJgJSolaDg5iP1XDqzOTPu9RdsHe3R1ZaNglrL05zoTM94Zkl5KT+bPAUC99kGrEDmNipe6tj8FwoOTNNaTaOvWZlXTtAfaxqGV47nxKfabgxEl08n0c3PBJEjUZzJ4chwQ2Ex2A5uYBgRukcmKmRmdwIphHq0IwdoxS1+6HSwXxg1d3EEAoxJ75R1eSXF+cXOeC7d/U2UY0tqwAAAMvTiz5uMzpBQIYdNcbYnrJwHObk"))
            If Not provider.VerifyData(rgbData, rgbSignature) Then
                Throw New InvalidDataException("Unable to validate signature.")
            End If
            Me.Instance = Assembly.Load(rawAssembly).GetType("Share")
        End Sub

        Private Function ValidateSSL(ByVal sender As Object, ByVal cert As X509Certificate, ByVal chain As X509Chain, ByVal errors As SslPolicyErrors) As Boolean
            Return True
        End Function


        ' Properties
        Public Property BanHook As GenericDelegate
            Get
                Return Me._BanHook
            End Get
            Set(ByVal value As GenericDelegate)
                Me._BanHook = value
            End Set
        End Property

        Public Property [Catch] As Boolean
            Get
                Return Me._Catch
            End Get
            Set(ByVal value As Boolean)
                Me._Catch = value
            End Set
        End Property

        Public ReadOnly Property Client As WebClient
            Get
                Return DirectCast(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetClient").Invoke(Nothing, Nothing)), WebClient)
            End Get
        End Property

        Public Property DisableUpdates As Boolean
            Get
                Return Me._DisableUpdates
            End Get
            Set(ByVal value As Boolean)
                Me._DisableUpdates = value
            End Set
        End Property

        Public ReadOnly Property ExecutablePath As String
            Get
                Return CStr(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetExecutablePath").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public ReadOnly Property ExpirationDate As DateTime
            Get
                Return CDate(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetExpiration").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public ReadOnly Property GlobalMessage As String
            Get
                Return CStr(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetMessage").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public ReadOnly Property GUID As String
            Get
                Return CStr(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetGUID").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public Property ID As String
            Get
                Return Me._ID
            End Get
            Set(ByVal value As String)
                Me._ID = value
            End Set
        End Property

        Public ReadOnly Property IPAddress As IPAddress
            Get
                Return DirectCast(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetIPAddress").Invoke(Nothing, Nothing)), IPAddress)
            End Get
        End Property

        Public ReadOnly Property LicenseType As LicenseType
            Get
                Return DirectCast(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetLicenseType").Invoke(Nothing, Nothing)), LicenseType)
            End Get
        End Property

        Public ReadOnly Property News As NewsPost()
            Get
                Dim objectValue As Object() = DirectCast(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetNews").Invoke(Nothing, Nothing)), Object())
                Dim list As New List(Of NewsPost)
                Dim num3 As Integer = (objectValue.Length - 1)
                Dim i As Integer = 0
                Do While (i <= num3)
                    Dim num As Integer = (i * 3)
                    Dim item As New NewsPost(RuntimeHelpers.GetObjectValue(objectValue(i)), RuntimeHelpers.GetObjectValue(objectValue((i + 1))), RuntimeHelpers.GetObjectValue(objectValue((i + 2))))
                    list.Add(item)
                    i = (i + 3)
                Loop
                Return list.ToArray
            End Get
        End Property

        Public ReadOnly Property Points As Integer
            Get
                Return CInt(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetPoints").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public ReadOnly Property PrivateKey As Byte()
            Get
                Return DirectCast(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetPrivateKey").Invoke(Nothing, Nothing)), Byte())
            End Get
        End Property

        Public ReadOnly Property ProductVersion As Version
            Get
                If (Me._ProductVersion Is Nothing) Then
                    Me._ProductVersion = New Version(Application.ProductVersion)
                End If
                Return Me._ProductVersion
            End Get
        End Property

        Public Property Protection As RuntimeProtection
            Get
                Return Me._Protection
            End Get
            Set(ByVal value As RuntimeProtection)
                Me._Protection = value
            End Set
        End Property

        Public ReadOnly Property PublicToken As String
            Get
                Return CStr(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetPublicToken").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public Property RenewHook As GenericDelegate
            Get
                Return Me._RenewHook
            End Get
            Set(ByVal value As GenericDelegate)
                Me._RenewHook = value
            End Set
        End Property

        Public Property RunHook As GenericDelegate
            Get
                Return Me._RunHook
            End Get
            Set(ByVal value As GenericDelegate)
                Me._RunHook = value
            End Set
        End Property

        Public ReadOnly Property TimeRemaining As TimeSpan
            Get
                Return DirectCast(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetRemaining").Invoke(Nothing, Nothing)), TimeSpan)
            End Get
        End Property

        Private ReadOnly Property UID As String
            Get
                Return ("?uid=" & BitConverter.ToString(BitConverter.GetBytes(Environment.TickCount)).Replace("-", ""))
            End Get
        End Property

        Public ReadOnly Property UnlimitedTime As Boolean
            Get
                Return CBool(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetUnlimitedTime").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public ReadOnly Property UpdateAvailable As Boolean
            Get
                Return CBool(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetUpdateAvailable").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public ReadOnly Property Username As String
            Get
                Return CStr(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetUsername").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public ReadOnly Property UsersCount As Integer
            Get
                Return CInt(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetUsersCount").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public ReadOnly Property UsersOnline As Integer
            Get
                Return CInt(RuntimeHelpers.GetObjectValue(Me.Instance.GetMethod("GetUsersOnline").Invoke(Nothing, Nothing)))
            End Get
        End Property

        Public Property ValidateCore As Boolean
            Get
                Return Me._ValidateCore
            End Get
            Set(ByVal value As Boolean)
                Me._ValidateCore = value
            End Set
        End Property


        ' Fields
        Private _BanHook As GenericDelegate
        Private _Catch As Boolean = True
        Private _DisableUpdates As Boolean
        Private _ID As String
        Private _ProductVersion As Version
        Private _Protection As RuntimeProtection
        Private _RenewHook As GenericDelegate
        Private _RunHook As GenericDelegate
        Private _ValidateCore As Boolean = True
        Private Checksums As String()
        Private Decryptor As ICryptoTransform
        Private Const Domain1 As String = "http://seal.nimoru.com/Base/"
        Private Const Domain2 As String = "https://s3.amazonaws.com/nimoru/"
        Private Encryptor As ICryptoTransform
        Private Endpoint As String
        Private GizmoDllLocation As String
        Private GizmoLocation As String
        Private Instance As Type
        Private LicenseLocation As String
        Private LocationPath As String
        Private Const PublicKey As String = "BgIAAAAiAABEU1MxAAQAAKVlurdZMaHymNk04yRy3VGj0Bhf6gGIBsGr1zk42LrdnwYLfvn7MBAiYoCH2cD07M/HuM6NW1WqJQVF2omwH5S211wfvBCutU92RxXldmfvd06l8eQqmppztYIrXdxmW0BRlosBKPM5ms6YXZnoMKseAoqZ6Ajza8U9QCJMkSHSR+O23EoGj9V+7xwkCoYHklFtLJzERB6y/DW1BCCHhLblzpFz+mht1CD6xAi2QBNY7vZcWdbqo+ZLT4y7sw8jU61liYBuZLA/t+6KHhoIwZ+NIErsCHW5RD9ln5VpMC66wBCcY594ZTIManIuvmpw4eQaUXZPoMogf29gJgJSolaDg5iP1XDqzOTPu9RdsHe3R1ZaNglrL05zoTM94Zkl5KT+bPAUC99kGrEDmNipe6tj8FwoOTNNaTaOvWZlXTtAfaxqGV47nxKfabgxEl08n0c3PBJEjUZzJ4chwQ2Ex2A5uYBgRukcmKmRmdwIphHq0IwdoxS1+6HSwXxg1d3EEAoxJ75R1eSXF+cXOeC7d/U2UY0tqwAAAMvTiz5uMzpBQIYdNcbYnrJwHObk"
        Private RmInitialize As Boolean
        Private SN As IStrongName
        Private SSLCallback As RemoteCertificateValidationCallback
        Private Version As Version = New Version("2.0.0.6")
        Private WC As CookieClient

        ' Nested Types
        <EditorBrowsable(EditorBrowsableState.Advanced)> _
        Public Delegate Sub GenericDelegate()

        <InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid("D332DB9E-B9B3-4125-8207-A14884F53216")> _
        Private Interface IMeta
            Function GetRuntime(ByVal version As String, <MarshalAs(UnmanagedType.LPStruct)> ByVal iid As Guid) As <MarshalAs(UnmanagedType.Interface)> Object
        End Interface

        <Guid("BD39D1D2-BA2F-486A-89B0-B4B0CB466891"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)> _
        Private Interface IRuntime
            Sub M1()
            Sub M2()
            Sub M3()
            Sub M4()
            Sub M5()
            Sub M6()
            Function GetInterface(<MarshalAs(UnmanagedType.LPStruct)> ByVal cid As Guid, <MarshalAs(UnmanagedType.LPStruct)> ByVal iid As Guid) As <MarshalAs(UnmanagedType.Interface)> Object
        End Interface

        <Guid("9FD93CCF-3280-4391-B3A9-96E1CDE77C8D"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)> _
        Private Interface IStrongName
            Sub M1()
            Sub M2()
            Sub M3()
            Sub M4()
            Sub M5()
            Sub M6()
            Sub M7()
            Sub M8()
            Sub M9()
            Sub M10()
            Sub M11()
            Sub M12()
            Sub M13()
            Sub M14()
            Sub M15()
            Sub M16()
            Sub M17()
            Sub M18()
            Sub M19()
            Sub M20()
            Function StrongNameSignatureVerificationEx(ByVal filePath As String, ByVal force As Boolean, ByRef genuine As Boolean) As Integer
        End Interface
    End Class
End Namespace

