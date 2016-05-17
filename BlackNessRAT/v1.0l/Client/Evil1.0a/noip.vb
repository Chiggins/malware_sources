Imports System.Text

Public Class noip

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox1.CheckedChanged
        
    End Sub

    Private Sub noip_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        CheckBox1.Checked = True
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        If CheckBox1.Checked = True Then
        End If
        Dim webclient = New Net.WebClient()
        Dim utf8 = New UTF8Encoding
        'http://dynupdate.no-ip.com/dns?username=%22d7m@hotmail.co.uk%22&password=%22cerberus%22&hostname=%22pixelfrag.zapto.org%20%22

        Dim page As String = utf8.GetString(webclient.DownloadData("http://dynupdate.no-ip.com/dns?username=" & TextBox1.Text & "&password=" & TextBox2.Text & "&hostname=" & TextBox3.Text))
        '   MsgBox(status(1))
        Dim pagedata() As String = page.Split(":")
        RichTextBox1.Text = pagedata(1)
        If pagedata(1).Contains("0") Then
            MsgBox("Success - IP address is current, no update performed", MsgBoxStyle.Information, "")
        End If
        If pagedata(1).Contains("1") Then
            MsgBox("Success - DNS hostname update successful", MsgBoxStyle.Information, "")

        End If
        If pagedata(1).Contains("2") Then

            MsgBox("Error - Hostname supplied does not exist", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("3") Then
            MsgBox("Error - Invalid username", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("4") Then
            MsgBox("Error - Invalid password", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("5") Then
            MsgBox("Error - Too many updates sent. Updates are blocked until 1 hour passes since last status of 5 returned.", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("6") Then
            MsgBox("Error - Account disabled due to violation of No-IP terms of service. Our terms of service can be viewed at http://www.no-ip.com/legal/tos", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("7") Then
            MsgBox("Error - Invalid IP. Invalid IP submitted is improperly formated, is a private LAN RFC 1918 address, or an abuse blacklisted address.", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("8") Then
            MsgBox("Error - Disabled / Locked hostname", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("9") Then
            MsgBox("Host updated is configured as a web redirect and no update was performed.", MsgBoxStyle.Information, "")
        End If
        If pagedata(1).Contains("10") Then
            MsgBox("Error - Group supplied does not exist", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("11") Then
            MsgBox("Success - DNS group update is successful", MsgBoxStyle.Information, "")
        End If
        If pagedata(1).Contains("12") Then
            MsgBox("Success - DNS group is current, no update performed.", MsgBoxStyle.Information, "")
        End If
        If pagedata(1).Contains("13") Then
            MsgBox("Error - Update client support not available for supplied hostname or group", MsgBoxStyle.Critical, "")

        End If
        If pagedata(1).Contains("14") Then
            MsgBox("Error - Hostname supplied does not have offline settings configured. Returned if sending offline=YES on a host that does not have any offline actions configured.", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("99") Then
            MsgBox("Error - Client disabled. Client should exit and not perform any more updates without user intervention.", MsgBoxStyle.Critical, "")
        End If
        If pagedata(1).Contains("100") Then
            MsgBox("Error - User input error usually returned if missing required request parameters", MsgBoxStyle.Critical, "")
        End If
    End Sub
End Class