unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
   I: Integer;
   Lista: TStringList;
   Line: TArray<String>;
begin
   Lista := TStringList.Create;
   try
      Lista.LoadFromFile('mac-vendors.txt');
   finally
   end;
   for I := 0 to Lista.Count - 1 do
   begin
      Line := Trim(Lista.Strings[I]).Split(['=']);
      Memo1.Lines.Add('VendorDict.TryAdd(''' + Line[0] + ''',''' + Line[1] + ''');');
   end;
end;

end.
