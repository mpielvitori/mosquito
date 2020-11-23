program mosquito1p;

uses
  Forms,
  mosquito1 in 'mosquito1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
