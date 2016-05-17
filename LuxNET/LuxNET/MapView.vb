Imports LuxNET.My.Resources
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.IO
Imports System.Net
Imports System.Runtime.CompilerServices
Imports System.Threading
Imports System.Windows.Forms
Imports System.Xml
Public Class MapView
    Public Sub New()
        Me.ip = New ArrayList
        Me.lookupurl = "http://freegeoip.net/xml/"
        Me.doc = New XmlDocument
        Me.curntzoom = 5
        Me.InitializeComponent()
    End Sub
    Private Function ByteArray2Image(ByVal ByAr As Byte()) As Image
        Dim stream As New MemoryStream(ByAr)
        Return Image.FromStream(stream)
    End Function
    Private Function ExtractXML(ByVal input As String) As String
        Return Me.doc.DocumentElement.SelectSingleNode(input).InnerText
    End Function

    Private Function GetONEIP(ByVal lat As String, ByVal lng As String, ByVal zoom As Integer) As Object
        Dim obj2 As Object
        Try
            Dim byAr As Byte() = New WebClient().DownloadData(String.Format("http://maps.google.com/maps/api/staticmap?center={0},{1}&zoom={2}&markers=color:red|{0},{1}&size=640x378&sensor=false", lat, lng, zoom))
            obj2 = Me.ByteArray2Image(byAr)
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            obj2 = Nothing
            ProjectData.ClearProjectError()
            Return obj2
            ProjectData.ClearProjectError()
        End Try
        Return obj2
    End Function

    Private Sub MapView_Load(sender As Object, e As EventArgs) Handles Me.Load
        Try
            Me.pb_map.SizeMode = PictureBoxSizeMode.CenterImage
            Me.pb_map.Image = My.Resources._488
            Me.receiving = New Thread(New ThreadStart(AddressOf Me.Receive))
            Me.receiving.Start()
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub pb_map_MouseClick(sender As Object, e As MouseEventArgs) Handles pb_map.MouseClick
        If (Me.pb_map.Cursor Is Cursors.Hand) Then
            Me.pb_map.Image = DirectCast(Me.GetONEIP(Me.latitude, Me.longitude, Me.curntzoom), Image)
            Me.curntzoom += 1
        End If
    End Sub

    Private Sub pb_map_MouseMove(sender As Object, e As MouseEventArgs) Handles pb_map.MouseMove
        Try
            If (Me.ip.Count = 1) Then
                Dim bitmap As New Bitmap(Me.pb_map.Image)
                If (((bitmap.GetPixel(e.X, e.Y).R = &H55) And (bitmap.GetPixel(e.X, e.Y).G = &H17)) And (bitmap.GetPixel(e.X, e.Y).B = 20)) Then
                    Me.pb_map.Cursor = Cursors.Hand
                Else
                    Me.pb_map.Cursor = Cursors.Default
                End If
                GC.Collect()
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Private Sub Receive()
        Try
            Me.doc.LoadXml(Conversions.ToString(NewLateBinding.LateGet(New WebClient, Nothing, "DownloadString", New Object() {Operators.ConcatenateObject(Me.lookupurl, Me.ip.Item(0))}, Nothing, Nothing, Nothing)))
            If (Me.ip.Count = 1) Then
                Me.longitude = Me.ExtractXML("Longitude")
                Me.latitude = Me.ExtractXML("Latitude")
                Me.lbl_Info.Text = String.Format("IP:{1}{0}CountryCode:{2}{0}CountryName:{3}{0}RegionName:{4}{0}City:{5}{0}ZipCode:{6}{0}Latitude:{7}{0}Longitude:{8}{0}", New Object() {ChrW(13) & ChrW(10), Me.ExtractXML("Ip"), Me.ExtractXML("CountryCode"), Me.ExtractXML("CountryName"), Me.ExtractXML("RegionName"), Me.ExtractXML("City"), Me.ExtractXML("ZipCode"), Me.latitude, Me.longitude})
                Me.pb_map.Image = DirectCast(Me.GetONEIP(Me.latitude, Me.longitude, 4), Image)
                Dim point2 As New Point(12, 12)
                Me.lbl_Info.Location = point2
                Me.lbl_Info.BackColor = Color.White
                Me.lbl_Info.AutoSize = True
                Me.lbl_Info.Show()
                Me.pb_map.Controls.Add(Me.lbl_Info)
            Else
                Dim str As String = String.Empty
                Dim num2 As Integer = (Me.ip.Count - 1)
                Dim i As Integer = 0
                Do While (i <= num2)
                    Me.doc.LoadXml(Conversions.ToString(NewLateBinding.LateGet(New WebClient, Nothing, "DownloadString", New Object() {Operators.ConcatenateObject(Me.lookupurl, Me.ip.Item(i))}, Nothing, Nothing, Nothing)))
                    str = (str & String.Format("{0},{1}|", Me.ExtractXML("Latitude"), Me.ExtractXML("Longitude")))
                    i += 1
                Loop
                Me.pb_map.Image = Me.ByteArray2Image(New WebClient().DownloadData(("http://maps.google.com/maps/api/staticmap?center=1,1&zoom=1&markers=color:red|" & str & "&size=640x378&sensor=false")))
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Private curntzoom As Integer
    Private doc As XmlDocument
    Public ip As ArrayList
    Private latitude As String
    Private longitude As String
    Private lookupurl As String
    Private receiving As Thread
End Class