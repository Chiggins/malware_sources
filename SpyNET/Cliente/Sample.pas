unit Sample;

interface
//http://www.maxmind.com/download/geoip/database/

function LookupCountry(IP: string): string;
//function LookupCity(IP: string): string;
//function LookupOrg(IP: string): string;

implementation

uses GeoIP;

function LookupCountry(IP: string): string;
var
   GeoIP: TGeoIP;
   GeoIPCountry: TGeoIPCountry;
begin
  GeoIP := TGeoIP.Create('GeoIP.dat');
  try
    if GeoIP.GetCountry(IP, GeoIPCountry) = GEOIP_SUCCESS then
    begin
      Result := GeoIPCountry.CountryCode + ' - ' + GeoIPCountry.CountryName;
    end
    else
    begin
      Result := 'ERROR - ERROR';
    end;
  finally
    GeoIP.Free;
  end;
end;
{
function LookupCity(IP: string): string;
var
   GeoIP: TGeoIP;
   GeoIPCity: TGeoIPCity;
begin
  GeoIP := TGeoIP.Create('GeoIPCity.dat');
  try
    if GeoIP.GetCity(IP, GeoIPCity) = GEOIP_SUCCESS then
    begin
      Result := GeoIPCity.City + ', ' + GeoIPCity.Region + ', ' + GeoIPCity.CountryName;
    end
    else
    begin
      Result := 'ERROR';
    end;
  finally
    GeoIP.Free;
  end;
end;

function LookupOrg(IP: string): string;
var
   GeoIP: TGeoIP;
   GeoIPOrg: TGeoIPOrg;
begin
  GeoIP := TGeoIP.Create('GeoIPOrg.dat');
  try
    if GeoIP.GetOrg(IP, GeoIPOrg) = GEOIP_SUCCESS then
    begin
      Result := GeoIPOrg.Name;
    end
    else
    begin
      Result := 'ERROR';
    end;
  finally
    GeoIP.Free;
  end;
end;
}
end.
