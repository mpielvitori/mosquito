unit mosquito1;

interface

{En esta version se visualiza y mueve un agente por el entorno.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    mosqui: TShape;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.BitBtn1Click(Sender: TObject);
var x,j,h,i,n,t:integer;
begin
   {Este procedimiento mueve al agente a través del entorno, tratando de
    imitar el movimiento de un mosquito.}

   t:=-6;
   for h:=1 to 2 do
   begin
    t:=t*(-1);
    x:=1;
    n:=random(15)+8;
    for j:=1 to n do
     begin
      x:=x*(-1);
      for i:=1 to 2 do
       begin
        mosqui.top:=t+mosqui.top;
        mosqui.left:=((random(4)+1)*x)+mosqui.left;
        mosqui.Refresh;
        sleep(150);
       end;
     end;
   end;
end;

end.
