unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Generics.Collections, Vcl.Menus, Vcl.Clipbrd, Winapi.ShellAPI;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    PMI_Browser: TMenuItem;
    PMI_Copy: TMenuItem;
    Label1: TLabel;
    lbl_GitHub: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PMI_CopyClick(Sender: TObject);
    procedure PMI_BrowserClick(Sender: TObject);
    procedure lbl_GitHubMouseEnter(Sender: TObject);
    procedure lbl_GitHubMouseLeave(Sender: TObject);
    procedure lbl_GitHubClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
   VendorDictionary;

function GetDosOutput(CommandLine: string; Work: string = 'C:\'): String;
var
    SA: TSecurityAttributes;
    SI: TStartupInfo;
    PI: TProcessInformation;
    StdOutPipeRead, StdOutPipeWrite: THandle;
    WasOK: Boolean;
    Buffer: Array[0 .. 255] of Byte;
    BytesRead: Cardinal;
    WorkDir: string;
    Handle: Boolean;
    Encoding: TEncoding;
    Partial: String;
begin
    Result := '';
    with SA do
    begin
        nLength := SizeOf(SA);
        bInheritHandle := True;
        lpSecurityDescriptor := nil;
    end;
    CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
    try
        with SI do
        begin
            FillChar(SI, SizeOf(SI), 0);
            cb := SizeOf(SI);
            dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
            wShowWindow := SW_HIDE;
            hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
            hStdOutput := StdOutPipeWrite;
            hStdError := StdOutPipeWrite;
        end;
        WorkDir := Work;
        Handle := CreateProcess(nil, PWideChar('cmd.exe /C ' + CommandLine), nil, nil, True, 0, nil, PWideChar(WorkDir), SI, PI);
        CloseHandle(StdOutPipeWrite);
        if Handle then
            try
               Encoding := TEncoding.GetEncoding(GetOEMCP);
                repeat
                    WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
                    if BytesRead > 0 then
                    begin
                        Buffer[BytesRead] := $00;
                        Partial := Encoding.GetString(Buffer);
                        Result := Result + Copy(Partial, 0, BytesRead);
                    end;
                until not WasOK or (BytesRead = 0);
                WaitForSingleObject(PI.hProcess, INFINITE);
            finally
                CloseHandle(PI.hThread);
                CloseHandle(PI.hProcess);
            end;
    finally
        CloseHandle(StdOutPipeRead);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   I: Integer;
   Item: TListItem;
   DOSLine: String;
   DosOutput, Line: TStringList;
   vIP, vMAC, vType, vVendor: String;
begin
   try
      CreateVendorDictionary;
   finally
   end;

   DosOutput := TStringList.Create;
   try
      DosOutput.Text := Trim(GetDosOutput('arp -a'));
   finally
   end;

   if DosOutput.Count > 2 then
   begin
      DosOutput.Delete(0);
      DosOutput.Delete(0);
   end;

   Line := TStringList.Create;
   for I := 0 to DOSOutput.Count - 1 do
   begin
      DOSLine := Trim(DosOutput.Strings[I]);
      Line.Delimiter := Char(20);
      Line.DelimitedText := DOSLine;

      if Line.Count < 3 then
         Continue;

      vIP   := Trim(Line.Strings[0]);
      vMAC  := UpperCase(Trim(Line.Strings[1]).Replace('-', ':'));
      vType := Trim(Line.Strings[2]);

      if (LowerCase(vType) <> 'dinâmico') and (LowerCase(vType) <> 'dynamic') then
         Continue;

      if vMAC <> '' then
      begin
         if not VendorDict.TryGetValue(Copy(vMAC, 0, 8), vVendor) then
            if not VendorDict.TryGetValue(Copy(vMAC, 0, 10), vVendor) then
               if not VendorDict.TryGetValue(Copy(vMAC, 0, 13), vVendor) then
                  if not VendorDict.TryGetValue(vMAC, vVendor) then
                     vVendor := 'Desconhecido';
      end;

      ListView1.Items.BeginUpdate;
      Item := ListView1.Items.Add;

      Item.Caption := VIP;
      Item.SubItems.Add(vMAC);
      Item.SubItems.Add(vType);
      Item.SubItems.Add(vVendor);

      ListView1.Items.EndUpdate;
   end;
   VendorDict.Free;
end;

procedure TForm1.lbl_GitHubClick(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open', PWideChar('https://github.com/Delutto/Printer_IP_Finder'), nil, nil, 0);
end;

procedure TForm1.lbl_GitHubMouseEnter(Sender: TObject);
begin
   lbl_GitHub.Font.Style := [fsUnderline];
end;

procedure TForm1.lbl_GitHubMouseLeave(Sender: TObject);
begin
   lbl_GitHub.Font.Style := [];
end;

procedure TForm1.PMI_BrowserClick(Sender: TObject);
begin
   if (Assigned(ListView1.Selected)) and (Trim(ListView1.Selected.Caption) <> '') then
      ShellExecute(Application.Handle, 'open', PWideChar('http://' + Trim(ListView1.Selected.Caption)), nil, nil, 0);
end;

procedure TForm1.PMI_CopyClick(Sender: TObject);
begin
   if (Assigned(ListView1.Selected)) and (Trim(ListView1.Selected.Caption) <> '') then
      Clipboard.AsText := Trim(ListView1.Selected.Caption);
end;

end.
