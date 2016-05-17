Imports System.IO

Public Class settings

    Public sPath = Application.StartupPath & "/Settings.ini"

    Private Declare Unicode Function WritePrivateProfileString Lib "kernel32" _
  Alias "WritePrivateProfileStringW" (ByVal lpApplicationName As String, _
  ByVal lpKeyName As String, ByVal lpString As String, _
  ByVal lpFileName As String) As Int32

    Private Declare Unicode Function GetPrivateProfileString Lib "kernel32" _
    Alias "GetPrivateProfileStringW" (ByVal lpApplicationName As String, _
    ByVal lpKeyName As String, ByVal lpDefault As String, _
    ByVal lpReturnedString As String, ByVal nSize As Int32, _
    ByVal lpFileName As String) As Int32
    Public Overloads Function INIRead(ByVal INIPath As String, _
    ByVal SectionName As String, ByVal KeyName As String, _
    ByVal DefaultValue As String) As String
        Dim n As Int32
        Dim sData As String
        sData = Space$(1024)
        n = GetPrivateProfileString(SectionName, KeyName, DefaultValue, _
        sData, sData.Length, INIPath)
        If n > 0 Then
            INIRead = sData.Substring(0, n)
        Else
            INIRead = ""
        End If
    End Function
    Public Overloads Function INIRead(ByVal INIPath As String, _
    ByVal SectionName As String, ByVal KeyName As String) As String
        Return INIRead(INIPath, SectionName, KeyName, "")
    End Function
    Public Overloads Function INIRead(ByVal INIPath As String, _
    ByVal SectionName As String) As String
        Return INIRead(INIPath, SectionName, Nothing, "")
    End Function
    Public Overloads Function INIRead(ByVal INIPath As String) As String
        Return INIRead(INIPath, Nothing, Nothing, "")
    End Function
    Public Sub INIWrite(ByVal INIPath As String, ByVal SectionName As String, _
    ByVal KeyName As String, ByVal TheValue As String)
        Call WritePrivateProfileString(SectionName, KeyName, TheValue, INIPath)
    End Sub
    Public Overloads Sub INIDelete(ByVal INIPath As String, ByVal SectionName As String, _
    ByVal KeyName As String)
        Call WritePrivateProfileString(SectionName, KeyName, Nothing, INIPath)
    End Sub
    Public Overloads Sub INIDelete(ByVal INIPath As String, ByVal SectionName As String)
        Call WritePrivateProfileString(SectionName, Nothing, Nothing, INIPath)
    End Sub

    Private Sub settings_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        TextBox3.Enabled = False
        TextBox4.Enabled = False
        Button3.Enabled = False
        TextBox1.Text = INIRead(Application.StartupPath & "/Settings.ini", "Settings", "Port")
        TextBox2.Text = INIRead(Application.StartupPath & "/Settings.ini", "Settings", "ID")
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        INIWrite(sPath, "Settings", "Port", TextBox1.Text)
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        INIWrite(sPath, "Settings", "ID", TextBox2.Text)
    End Sub



    Private Sub Button3_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button3.Click
        Try
            Dim mappingPorts
            Dim NAT
            Dim Port As Integer
            Dim LocalIP As String

            Port = TextBox3.Text
            LocalIP = TextBox4.Text

            NAT = CreateObject("HNetCfg.NATUPnP")
            mappingPorts = NAT.StaticPortMappingCollection

            mappingPorts.add(Port, "TCP", Port, LocalIP, True, "Port to open in TCP")
            mappingPorts.add(Port, "UDP", Port, LocalIP, True, "Port to open in UDP")
            Dim lv As ListViewItem = ListView1.Items.Add(Port)
            lv.SubItems.Add(LocalIP)
            lv.SubItems.Add("TCP/UDP")
            lv.SubItems.Add("Enable")

        Catch ex As Exception
            MessageBox.Show("Error Enabling UPnP: " & ex.Message)
        End Try
    End Sub

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked = True Then
            TextBox3.Enabled = True
            TextBox4.Enabled = True
            Button3.Enabled = True
        End If
        If CheckBox1.Checked = False Then
            TextBox3.Enabled = False
            TextBox4.Enabled = False
            Button3.Enabled = False
        End If
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        Dim mappingPorts
        Dim NAT
        Dim Port As Integer
        NAT = CreateObject("HNetCfg.NATUPnP")
        mappingPorts = NAT.StaticPortMappingCollection
        Port = ListView1.SelectedItems(0).Text
        mappingPorts.remove(Port, "TCP")
        mappingPorts.remove(Port, "UPD")
        ListView1.SelectedItems(0).Remove()
    End Sub

    Private Sub ButtonX1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX1.Click
        INIWrite(sPath, "Settings", "Port", TextBox1.Text)
    End Sub

    Private Sub ButtonX2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX2.Click
        INIWrite(sPath, "Settings", "ID", TextBox2.Text)
    End Sub

    Private Sub Button4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim monAncienFichier As String, monNouveauFichier As String
        monAncienFichier = "Skin.stf"
        monNouveauFichier = "BlueSkin.stf"
        File.Move(monAncienFichier, monNouveauFichier)

        Dim ex As String, newp As String
        ex = "BlackSkin.skf"
        newp = "Skin.stf"
        File.Move(ex, newp)
    End Sub

    Private Sub Button2_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim wex As String, wnewp As String
        wex = "Skin.skf"
        wnewp = "BlackSkin.stf"
        File.Move(wex, wnewp)

        Dim tt As String, tts As String
        tt = "BlueSkin.stf"
        tts = "Skin.stf"
        File.Move(tt, tts)

    End Sub
End Class



