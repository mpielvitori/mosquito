unit matriz;
interface
uses
   listacpun, Dialogs, ExtCtrls, StdCtrls;

const
     nulo=0;
     min=1;
     max=40;

type
    indices=min..max;
    tipo_est=0..1;
    tipoelemento=record
                       t,l:integer;
                       carga:real;
                       shape:tshape;
                       estado:integer;

                 end;
    matrix=array[indices,indices] of tipoelemento;

    procedure crear_matriz_vacia(var m:matrix);


implementation

procedure crear_matriz_vacia(var m:matrix);
var fila,columna,left,top:integer;
begin
     top:=-20;
     for fila:=min to 26 do
       begin
       left:=-20;
       top:=top+20;
          for columna:=min to max do
           begin
            left:=left+20;
            m[fila,columna].carga:=0;
            m[fila,columna].l:=left;
            m[fila,columna].t:=top;
           end;
       end;
end;

end.
