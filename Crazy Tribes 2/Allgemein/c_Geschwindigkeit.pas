unit c_Geschwindigkeit;

interface

type
  TLaufstufe = (cLangsam, cMittel, cSchnell);

type
  RGeschwVoll = Record const
    Scout: Integer = 315000;   // 5.25;
    Ranger: Integer = 361000; //6.0166666;
    Gunner: Integer = 406000; //6.7666666;
    Knocker: Integer = 586000; //9.75;
    Mortar: Integer = 541000 ;//9;
    Molotov: Integer = 496000  ;//8.0266666;
    Biker: Integer = 135000   ;//2.25;
    Trike: Integer = 180000 ;//3;
    Buggy: Integer = 225000 ;//3.75;
    Pickup: Integer = 361000;
    Carrack: Integer = 676000;
  End;


type
  RGeschwMittel = Record const
    Scout: Integer = 332000;   // 5.25;
    Ranger: Integer = 380000; //6.0166666;
    Gunner: Integer = 427000; //6.7666666;
    Knocker: Integer = 617000; //9.75;
    Mortar: Integer = 570000 ;//9;
    Molotov: Integer = 522000  ;//8.0266666;
    Biker: Integer = 142000   ;//2.25;
    Trike: Integer = 190000 ;//3;
    Buggy: Integer = 237000 ;//3.75;
    Pickup: Integer = 380000;
    Carrack: Integer = 712000;
  End;

type
  RGeschwLangsam = Record const
    Scout: Integer = 350000;   // 5.25;
    Ranger: Integer = 400000; //6.0166666;
    Gunner: Integer = 450000; //6.7666666;
    Knocker: Integer = 650000; //9.75;
    Mortar: Integer = 600000 ;//9;
    Molotov: Integer = 550000  ;//8.0266666;
    Biker: Integer = 150000   ;//2.25;
    Trike: Integer = 200000 ;//3;
    Buggy: Integer = 250000 ;//3.75;
    Pickup: Integer = 400000;
    Carrack: Integer = 750000;
  End;

type
  RGeschwindigkeit = Record
    Langsam: RGeschwLangsam;
    Mittel : RGeschwMittel;
    Schnell: RGeschwVoll;
  End;



implementation

end.
