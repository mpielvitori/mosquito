unit listacpun;

interface
uses
    ExtCtrls, StdCtrls;

const
        nulo=nil;

type

        posicion = ^nodo_lista;
        nodo_lista = record
                        dato: tshape;
                        ante, prox: posicion;
        end;
        lista = record
                   inicio, final: posicion;
        end;
        procedure crear_lista_vacia(var l: lista);
        function lista_vacia(var l: lista): boolean;
        function lista_llena(var l: lista):boolean;
        procedure agregar(var l:lista; x:tshape);

implementation
procedure crear_lista_vacia(var l: lista);
begin
        l.inicio:= nulo;
        l.final:= nulo;
end;

function lista_vacia(var l: lista): boolean;
begin
        lista_vacia := (l.inicio = nulo);
end;

function lista_llena(var l: lista):boolean;
var q: posicion;
begin
        new(q);
        lista_llena := (q=nulo);
        dispose(q);
end;

procedure agregar (var l:lista; x:tshape);
var q: posicion;
begin
        if not(lista_llena(l)) then
        begin
                new(q);
                q^.dato := x;
                q^.prox := nulo;
                q^.ante := l.final;
                if lista_vacia(l) then
                        l.inicio :=q
                else
                        l.final^.prox := q;
                l.final := q;
        end;

end;

end.
