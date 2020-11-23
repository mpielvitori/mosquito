program mosquito3planif_p;

uses
  Forms,
  mosquito3planif in 'mosquito3planif.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
