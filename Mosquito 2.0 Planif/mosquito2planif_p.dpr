program mosquito2planif_p;

uses
  Forms,
  mosquito2planif in 'mosquito2planif.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
