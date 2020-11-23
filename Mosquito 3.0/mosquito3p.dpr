program mosquito3p;

uses
  Forms,
  mosquito3 in 'mosquito3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
