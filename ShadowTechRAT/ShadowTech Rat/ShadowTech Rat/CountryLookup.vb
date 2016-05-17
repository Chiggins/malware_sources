'========================================================================================
'Copyright 2003 David G. Miles - davidmiles@bigfoot.com - All Rights Reserved
'Copyright 2007 MaxMind LLC - support@maxmind.com - All Rights Reserved
'
' This library is free software; you can redistribute it and/or
' modify it under the terms of the GNU General Public
' License as published by the Free Software Foundation; either
' version 2 of the License, or (at your option) any later version.
'
' This library is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
' General Public License for more details.
'
' You should have received a copy of the GNU General Public
' License along with this library; if not, write to the Free Software
' Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'========================================================================================

'------------------------------------------------------------------------------------------------
' This class uses an IP lookup database from MaxMind, specifically
' the GeoIP Free Database.
'
' The database and the c# implementation of this class
' are available from http://www.maxmind.com/app/csharp
'
' Note that this class does not work properly if the
' developer is testing on a WAN or localhost - obviously
' the IP is not one that is external and therefore in the
' GeoIP Database
'------------------------------------------------------------------------------------------------

Imports System
Imports System.IO
Imports System.Data
Imports System.Net

Public Class CountryLookup

    Public _MemoryStream As MemoryStream

    Private Shared CountryBegin As Long = 16776960
    Private Shared CountryName As String() = {"N/A", "Asia/Pacific Region", "Europe", "Andorra", "United Arab Emirates", "Afghanistan", "Antigua and Barbuda", "Anguilla", "Albania", "Armenia", "Netherlands Antilles", "Angola", "Antarctica", "Argentina", "American Samoa", "Austria", "Australia", "Aruba", "Azerbaijan", "Bosnia and Herzegovina", "Barbados", "Bangladesh", "Belgium", "Burkina Faso", "Bulgaria", "Bahrain", "Burundi", "Benin", "Bermuda", "Brunei Darussalam", "Bolivia", "Brazil", "Bahamas", "Bhutan", "Bouvet Island", "Botswana", "Belarus", "Belize", "Canada", "Cocos (Keeling) Islands", "Congo, The Democratic Republic of the", "Central African Republic", "Congo", "Switzerland", "Cote D'Ivoire", "Cook Islands", "Chile", "Cameroon", "China", "Colombia", "Costa Rica", "Cuba", "Cape Verde", "Christmas Island", "Cyprus", "Czech Republic", "Germany", "Djibouti", "Denmark", "Dominica", "Dominican Republic", "Algeria", "Ecuador", "Estonia", "Egypt", "Western Sahara", "Eritrea", "Spain", "Ethiopia", "Finland", "Fiji", "Falkland Islands (Malvinas)", "Micronesia, Federated States of", "Faroe Islands", "France", "France, Metropolitan", "Gabon", "United Kingdom", "Grenada", "Georgia", "French Guiana", "Ghana", "Gibraltar", "Greenland", "Gambia", "Guinea", "Guadeloupe", "Equatorial Guinea", "Greece", "South Georgia and the South Sandwich Islands", "Guatemala", "Guam", "Guinea-Bissau", "Guyana", "Hong Kong", "Heard Island and McDonald Islands", "Honduras", "Croatia", "Haiti", "Hungary", "Indonesia", "Ireland", "Israel", "India", "British Indian Ocean Territory", "Iraq", "Iran, Islamic Republic of", "Iceland", "Italy", "Jamaica", "Jordan", "Japan", "Kenya", "Kyrgyzstan", "Cambodia", "Kiribati", "Comoros", "Saint Kitts and Nevis", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Cayman Islands", "Kazakstan", "Lao People's Democratic Republic", "Lebanon", "Saint Lucia", "Liechtenstein", "Sri Lanka", "Liberia", "Lesotho", "Lithuania", "Luxembourg", "Latvia", "Libyan Arab Jamahiriya", "Morocco", "Monaco", "Moldova, Republic of", "Madagascar", "Marshall Islands", "Macedonia, the Former Yugoslav Republic of", "Mali", "Myanmar", "Mongolia", "Macao", "Northern Mariana Islands", "Martinique", "Mauritania", "Montserrat", "Malta", "Mauritius", "Maldives", "Malawi", "Mexico", "Malaysia", "Mozambique", "Namibia", "New Caledonia", "Niger", "Norfolk Island", "Nigeria", "Nicaragua", "Netherlands", "Norway", "Nepal", "Nauru", "Niue", "New Zealand", "Oman", "Panama", "Peru", "French Polynesia", "Papua New Guinea", "Philippines", "Pakistan", "Poland", "Saint Pierre and Miquelon", "Pitcairn", "Puerto Rico", "Palestinian Territory, Occupied", "Portugal", "Palau", "Paraguay", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saudi Arabia", "Solomon Islands", "Seychelles", "Sudan", "Sweden", "Singapore", "Saint Helena", "Slovenia", "Svalbard and Jan Mayen", "Slovakia", "Sierra Leone", "San Marino", "Senegal", "Somalia", "Suriname", "Sao Tome and Principe", "El Salvador", "Syrian Arab Republic", "Swaziland", "Turks and Caicos Islands", "Chad", "French Southern Territories", "Togo", "Thailand", "Tajikistan", "Tokelau", "Turkmenistan", "Tunisia", "Tonga", "Timor-Leste", "Turkey", "Trinidad and Tobago", "Tuvalu", "Taiwan, Province of China", "Tanzania, United Republic of", "Ukraine", "Uganda", "United States Minor Outlying Islands", "United States", "Uruguay", "Uzbekistan", "Holy See (Vatican City State)", "Saint Vincent and the Grenadines", "Venezuela", "Virgin Islands, British", "Virgin Islands, U.S.", "Vietnam", "Vanuatu", "Wallis and Futuna", "Samoa", "Yemen", "Mayotte", "Yugoslavia", "South Africa", "Zambia", "Montenegro", "Zimbabwe", "Anonymous Proxy", "Satellite Provider", "Other", "Aland Islands", "Guernsey", "Isle of Man", "Jersey", "Saint Barthelemy", "Saint Martin"}
    Private Shared CountryCode As String() = {"--", "AP", "EU", "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AN", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BM", "BN", "BO", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "FX", "GA", "GB", "GD", "GE", "GF", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IN", "IO", "IQ", "IR", "IS", "IT", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "ST", "SV", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TM", "TN", "TO", "TL", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "RS", "ZA", "ZM", "ME", "ZW", "A1", "A2", "O1", "AX", "GG", "IM", "JE", "BL", "MF"}

    Public Sub New(ByVal ms As MemoryStream)

        _MemoryStream = ms

    End Sub

    Public Sub New(ByVal FileLocation As String)

        '------------------------------------------------------------------------------------------------
        ' Load the passed in GeoIP Data file to the memorystream
        '------------------------------------------------------------------------------------------------

        Dim _FileStream As New FileStream(FileLocation, FileMode.Open, FileAccess.Read)

        _MemoryStream = New MemoryStream()

        Dim _Byte(256) As Byte

        While _FileStream.Read(_Byte, 0, _Byte.Length) <> 0

            _MemoryStream.Write(_Byte, 0, _Byte.Length)

        End While

        _FileStream.Close()

    End Sub

    Private Function ConvertIPAddressToNumber(ByVal _IPAddress As IPAddress) As Long

        '------------------------------------------------------------------------------------------------
        ' Convert an IP Address, (e.g. 127.0.0.1), to the numeric equivalent
        '------------------------------------------------------------------------------------------------

        Dim _Address() As String = Split(_IPAddress.ToString, ".")

        If UBound(_Address) = 3 Then

            Return CDbl(16777216 * _Address(0) + 65536 * _Address(1) + 256 * _Address(2) + _Address(3))

        Else

            Return 0

        End If

    End Function

    Private Function ConvertIPNumberToAddress(ByVal _IPNumber As Long) As String

        '------------------------------------------------------------------------------------------------
        ' Convert an IP Number to the IP Address equivalent
        '------------------------------------------------------------------------------------------------

        Dim _IPNumberPart1 As String = CStr(Int(_IPNumber / 16777216) Mod 256)
        Dim _IPNumberPart2 As String = CStr(Int(_IPNumber / 65536) Mod 256)
        Dim _IPNumberPart3 As String = CStr(Int(_IPNumber / 256) Mod 256)
        Dim _IPNumberPart4 As String = CStr(Int(_IPNumber) Mod 256)

        Return _IPNumberPart1 & "." & _IPNumberPart2 & "." & _IPNumberPart3 & "." & _IPNumberPart4

    End Function

    Public Shared Function FileToMemory(ByVal FileLocation As String) As MemoryStream

        '------------------------------------------------------------------------------------------------
        ' Read a given file into a Memory Stream to return as the result
        '------------------------------------------------------------------------------------------------

        Dim _FileStream As New FileStream(FileLocation, FileMode.Open, FileAccess.Read)
        Dim _MemStream As New MemoryStream()

        Dim _Byte(256) As Byte

        While _FileStream.Read(_Byte, 0, _Byte.Length) <> 0

            _MemStream.Write(_Byte, 0, _Byte.Length)

        End While

        _FileStream.Close()

        Return _MemStream

    End Function

    Public Overloads Function LookupCountryCode(ByVal _IPAddress As IPAddress) As String

        '------------------------------------------------------------------------------------------------
        ' Look up the country code, e.g. US, for the passed in IP Address
        '------------------------------------------------------------------------------------------------

        Return CountryCode(CInt(SeekCountry(0, ConvertIPAddressToNumber(_IPAddress), 31)))

    End Function

    Public Overloads Function LookupCountryCode(ByVal _IPAddress As String) As String

        '------------------------------------------------------------------------------------------------
        ' Look up the country code, e.g. US, for the passed in IP Address
        '------------------------------------------------------------------------------------------------

        Dim _Address As IPAddress

        Try

            _Address = _Address.Parse(_IPAddress)

        Catch ex As FormatException

            Return "--"

        End Try

        Return LookupCountryCode(_Address)

    End Function

    Public Overloads Function LookupCountryName(ByVal addr As IPAddress) As String

        '------------------------------------------------------------------------------------------------
        ' Look up the country name, e.g. United States, for the IP Address
        '------------------------------------------------------------------------------------------------

        Return CountryName(CInt(SeekCountry(0, ConvertIPAddressToNumber(addr), 31)))

    End Function

    Public Overloads Function LookupCountryName(ByVal _IPAddress As String) As String

        '------------------------------------------------------------------------------------------------
        ' Look up the country name, e.g. United States, for the IP Address
        '------------------------------------------------------------------------------------------------

        Dim _Address As IPAddress

        Try

            _Address = IPAddress.Parse(_IPAddress)

        Catch e As FormatException

            Return "N/A"

        End Try

        Return LookupCountryName(_Address)

    End Function

    Private Function vbShiftLeft(ByVal Value As Long, _
    ByVal Count As Integer) As Long

        '------------------------------------------------------------------------------------------------
        ' Replacement for Bitwise operators which are missing in VB.NET,
        ' these functions are present in .NET 1.1, but for developers
        ' using 1.0, replacement functions must be implemented
        '------------------------------------------------------------------------------------------------

        Dim _Iterator As Integer

        vbShiftLeft = Value

        For _Iterator = 1 To Count

            vbShiftLeft = vbShiftLeft * 2

        Next

    End Function

    Private Function vbShiftRight(ByVal Value As Long, _
    ByVal Count As Integer) As Long

        '------------------------------------------------------------------------------------------------
        ' Replacement for Bitwise operators which are missing in VB.NET,
        ' these functions are present in .NET 1.1, but for developers
        ' using 1.0, replacement functions must be implemented
        '------------------------------------------------------------------------------------------------

        Dim _Iterator As Integer

        vbShiftRight = Value

        For _Iterator = 1 To Count

            vbShiftRight = vbShiftRight \ 2

        Next

    End Function

    Private Function SeekCountry(ByVal StartOffset As Long, _
                                 ByVal IPNumber As Long, _
                                 ByVal SearchDepth As Integer) As Long

        '------------------------------------------------------------------------------------------------
        ' Seek the country position from the GeoIP data in the memory stream
        '------------------------------------------------------------------------------------------------

        Dim _Buffer(6) As Byte
        Dim x(2) As Long

        If SearchDepth = 0 Then

        End If

        Try

            _MemoryStream.Seek(6 * StartOffset, 0)
            _MemoryStream.Read(_Buffer, 0, 6)

        Catch ex As IOException

        End Try

        Dim _Iterator As Integer

        For _Iterator = 0 To 1

            x(_Iterator) = 0

            Dim j As Integer

            For j = 0 To 2

                Dim _Part As Integer = _Buffer((_Iterator * 3 + j))

                If _Part < 0 Then

                    _Part += 256
                End If

                x(_Iterator) += vbShiftLeft(_Part, (j * 8))

            Next j

        Next _Iterator

        If (IPNumber And vbShiftLeft(1, SearchDepth)) > 0 Then

            If x(1) >= CountryBegin Then

                Return x(1) - CountryBegin

            End If

            Return SeekCountry(x(1), IPNumber, SearchDepth - 1)

        Else

            If x(0) >= CountryBegin Then

                Return x(0) - CountryBegin

            End If

            Return SeekCountry(x(0), IPNumber, SearchDepth - 1)

        End If

    End Function

End Class
