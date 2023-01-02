program PrinterIPFinder;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  VendorDictionary in 'VendorDictionary.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Printer IP Finder 0.9.0';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
