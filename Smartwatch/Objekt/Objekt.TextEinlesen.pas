unit Objekt.TextEinlesen;

interface

uses
  SysUtils, Types, Windows, Classes, Objekt.TextEinlesenWort, Objekt.TextEinlesenWortList,
  DB.ArtikelEigenschaft;

type
  TTextEinlesen = class
  private
    fWortList: TTextEinlesenWortList;
    fEigenschaftText: string;
    fArtikelEigenschaft: TDBArtikeleigenschaft;
    fArId: Integer;
    procedure WortListAufbauen;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property ArId: Integer read fArId write fArId;
    property EigenschaftText: string read fEigenschaftText write fEigenschaftText;
    procedure Start;
  end;

implementation

{ TTextEinlesen }

constructor TTextEinlesen.Create;
begin
  fWortList := TTextEinlesenWortList.Create(nil);
  fArtikelEigenschaft := TDBArtikeleigenschaft.Create(nil);
  WortListAufbauen;
end;

destructor TTextEinlesen.Destroy;
begin
  FreeAndNil(fWortList);
  FreeAndNil(fArtikelEigenschaft);
  inherited;
end;

procedure TTextEinlesen.Start;
var
  s: string;
  i1: Integer;
begin
  s := fEigenschaftText;
  for i1 := 0 to fWortList.Count -1 do
  begin
    if Pos(fWortList.Item[i1].Wort, s) > 0 then
    begin
      if fArtikelEigenschaft.Checked(fArId, fWortList.Item[i1].EnId, fWortList.Item[i1].EiId)  then
        continue;
      fArtikelEigenschaft.Init;
      fArtikelEigenschaft.AR_ID := fArId;
      fArtikelEigenschaft.EN_ID := fWortList.Item[i1].EnId;
      fArtikelEigenschaft.EI_ID := fWortList.Item[i1].EiId;
      fArtikelEigenschaft.Save;
    end;
  end;
end;

procedure TTextEinlesen.WortListAufbauen;
  procedure Add(aValue: String; aEnId, aEiId: Integer);
  var
    x: TTextEinlesenWort;
  begin
    x := fWortList.Add;
    x.Wort := aValue;
    x.EiId := aEiId;
    x.EnId := aEnId;
  end;
begin
  Add('Wasserdicht', 3, 215);
  Add('wasserdicht', 3, 215);
  Add('IP68', 3, 216);
  Add('Fitness', 20, 200);
  Add('Fitness', 2, 241);
  Add('1,3 Zoll', 16, 153);
  Add('Bluetooth', 5, 82);
  Add('Schrittzähler', 4, 77);
  Add('Schrittzählung', 4, 77);
  Add('Schritte', 4, 77);
  Add('Pulsmesser', 4, 73);
  Add('Pulsuhr', 4, 73);
  Add('Schlafmonitor', 4, 76);
  Add('Schlaf-Tracking', 4, 76);
  Add('Schlafaufzeichnung', 4, 76);
  Add('Schlafaktivität', 4, 76);
  Add('Schlafdaten', 4, 76);
  Add('Stoppuhr', 2, 42);
  Add('Damen', 17, 1);
  Add('Herren', 17, 2);
  Add('Unisex', 17, 1);
  Add('Unisex', 17, 2);
  Add('iOS', 5, 237);
  Add('Android', 5, 236);
  Add('Entfernung', 2, 218);
  Add('Distanz', 2, 218);
  Add('Kalorienverbrauch', 18, 58);
  Add('Kalorienzähler', 18, 58);
  Add('Aktivit?tstracker', 18, 217);
  Add('Aktivitätstracker', 18, 217);
  Add('Aktivität', 18, 217);
  Add('Aktivit?t', 18, 217);
  Add('Aktivitäts-Tracking', 18, 217);
  Add('Gehen', 20, 279);
  Add('Laufen', 20, 201);
  Add('Musikfunktion', 2, 32);
  Add('Musikfunktion', 2, 31);
  Add('Musiksteuerung', 2, 31);
  Add('Musiksteuerung', 2, 32);
  Add('integrierte MP3-Player', 2, 32);
  Add('integrierte MP3-Player', 2, 31);
  Add('Telefon', 2, 19);
  Add('SMS', 2, 49);
  Add('Facebook', 19, 171);
  Add('WhatsApp', 19, 170);
  Add('Spotify', 19, 172);
  Add('Messenger', 19, 175);
  Add('Twitter', 19, 176);
  Add('Linkedin', 19, 177);
  Add('VeryFitPro', 19, 220);
  Add('Google Fit', 19, 240);
  Add('Wearable', 19, 242);
  Add('Deezer', 19, 251);
  Add('EKG', 19, 257);
  Add('Apple Health', 19, 260);
  Add('Strava', 19, 261);
  Add('ZeronerHealthPro', 19, 264);
  Add('FunDo Pro', 19, 269);
  Add('YFit', 19, 271);
  Add('FitCloudPro', 19, 277);
  Add('Skype', 19, 281);
  Add('Instagram', 19, 280);
  Add('Schwimmen', 20, 202);
  Add('Rennsport', 20, 192);
  Add('Fliegen', 20, 193);
  Add('Badminton', 20, 194);
  Add('badminton', 20, 194);
  Add('Boxen', 20, 195);
  Add('Cardio', 20, 197);
  Add('Golfen', 20, 199);
  Add('Tennis', 20, 203);
  Add('Wandern', 20, 204);
  Add('Kraftsport', 20, 207);
  Add('Krafttraining', 20, 207);
  Add('Radfahren', 20, 208);
  Add('Rudern', 20, 209);
  Add('Segeln', 20, 210);
  Add('Skiing', 20, 211);
  Add('boarding', 20, 211);
  Add('Boarding', 20, 211);
  Add('Skifahren', 20, 211);
  Add('Squash', 20, 212);
  Add('Tischtennis', 20, 213);
  Add('Wassersport', 20, 214);
  Add('Klettern', 20, 227);
  Add('Gehen', 20, 279);
  Add('5ATM', 3, 223);
  Add('5 ATM', 3, 223);
  Add('Menstruationszyklus', 18, 247);
  Add('Menstruationsperiode', 18, 247);
  Add('Eisprung', 18, 247);
  Add('Schwangerschaftsperiode', 18, 247);
  Add('Herzfrequenz', 18, 219);
  Add('Bewegungsmangel', 18, 57);
  Add('Inaktivitätserinnerung', 18, 57);
  Add('Activity Reminder', 18, 57);
  Add('Blutsauerstoff', 18, 263);
  Add('Blutdruckmessung', 18, 245);
  Add('Kalorien', 18, 58);
  Add('Wetter', 2, 54);
  Add('Wassertrinken', 18, 246);
  Add('Wassererinnerung', 18, 246);
  Add('wassererinnerung', 18, 246);
  Add('UMIDIGI', 1, 7);
  Add('YAMAY', 1, 6);
  Add('Wilful', 1, 8);
  Add('HUAWEI', 1, 9);
  Add('Samsung', 1, 10);
  Add('Fossil', 1, 11);
  Add('Garmin', 1, 12);
  Add('GRDE', 1, 13);
  Add('LIFEBEE', 1, 14);
  Add('TicWatch', 1, 15);
  Add('TagoBee', 1, 244);
  Add('Fitbit', 1, 249);
  Add('YONMIG', 1, 254);
  Add('KUNGIX', 1, 259);
  Add('Letsfit', 1, 262);
  Add('jpantech', 1, 266);
  Add('Blackview', 1, 267);
  Add('EIVOTOR', 1, 268);
  Add('COULAX', 1, 270);
  Add('LIDOFIGO', 1, 272);
  Add('OPPO', 1, 273);
  Add('Diesel', 1, 274);
  Add('GOKOO', 1, 275);
  Add('YoYoFit', 1, 276);
  Add('Adhope', 1, 278);
  Add('Da Fit', 19, 282);
  Add('Kalender', 2, 26);
  Add('Remote-Kamera', 2, 28);
  Add('Bluetooth 5.0', 5, 253);
  Add('Bewegungs-Reminder', 18, 57);
  Add('Find-my-Phone', 2, 283);
  Add('Vibration', 3, 63);
  Add('Seilspringen', 20, 289);
  Add('Tanzen', 20, 288);
  Add('Yoga', 20, 287);
  Add('Laufband', 20, 286);
  Add('Basketball', 20, 285);
  Add('Fußball', 20, 284);
  Add('Lauf- und Freizeitaktivitäten', 18, 217);
  Add('NFC', 5, 97);
  Add('WLAN', 5, 99);
  Add('Tizen', 10, 122);
  Add('Beschleunigungssensor', 4, 66);
  Add('Lagesensor', 4, 70);
  Add('Höhenmesser', 4, 69);
  Add('Barometer', 4, 65);
  Add('Umgebungslichtsensor', 4, 79);
  Add('integriertes GPS', 4, 68);
  Add('integrierten GPS', 4, 68);
  Add('Anrufe', 2, 19);
  Add('Nachrichten', 2, 49);
  Add('AMOLED', 14, 226);
  Add('Skagen', 1, 290);
  Add('Withings', 1, 291);
  Add('Apple Health', 19, 260);
  Add('Google Pay', 2, 238);
  Add('Apple Pay', 2, 239);
  Add('Sprachsteuerung', 2, 250);
  Add('Sprachbefehl', 2, 250);
  Add('Android Wear', 10, 119);
  Add('Android Wear 2.0', 10, 125);
  Add('Gyrosensor', 4, 229);
  Add('Gyroskop', 4, 229);
  Add('Thermometer', 4, 78);
  Add('temperatur', 4, 78);
  Add('Temperatur', 4, 78);
  Add('Terminerinnerung', 2, 48);
  Add(' Erinnerung', 2, 48);
  Add('Google Maps', 19, 292);
  Add('Umgebungslichtsensor', 4, 79);
  Add(' 3G,', 5, 86);
  Add('GLONASS', 5, 91);
  Add('Garmin Pay', 1, 295);
  Add('1,2 Zoll', 16, 152);
  Add('Gorilla Glas', 14, 296);
  Add('Stresslevel', 2, 243);
  Add('OLED', 14, 297);
  Add('0.38 Zoll', 16, 298);
  Add('X-WATCH', 1, 299);
  Add('Android Smartphone', 5, 236);
  Add('Smartwatch Android', 5, 236);
  Add('Apple Smartphone', 5, 237);
  Add('Smartwatch iOS', 5, 237);
  Add('Wecker', 2, 53);
  Add('Jogging', 20, 201);

end;

end.
