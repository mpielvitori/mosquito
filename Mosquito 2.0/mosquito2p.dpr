program mosquito2p;

uses
  Forms,
  mosquito2 in 'mosquito2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
