unit grafo_obj;

interface

uses
    ExtCtrls, StdCtrls;

const
        nulo=nil;

type
        tipo_est=0..1;
        posicion_vertice = ^nodo_vertice;

        nodo_vertice = record
                        estado:tipo_est;
                        l,t:integer;
                       end;


        obstaculo = record
                          nombre:string;
                          N1,N2,N3,N4:posicion_vertice;
                    end;

        posicion_o = ^nodo_obstaculo;
        nodo_obstaculo = record
                        dato: obstaculo;
                        ante, prox: posicion_o;
        end;

        lista_obstaculos = record
                   inicio, final: posicion_o;
        end;

        procedure crear_lista_obstaculos(var l: lista_obstaculos);
        function lista_obstaculos_vacia(var l: lista_obstaculos): boolean;
        function lista_obstaculos_llena(var l: lista_obstaculos):boolean;
        procedure eliminar_o(var l:lista_obstaculos; p:posicion_o);
        function distancia(t1,t2,l1,l2:integer):integer;
        function buscar(var l:lista_obstaculos; x:string):posicion_o;
        procedure agregar_o(var l:lista_obstaculos; x:obstaculo);

implementation

procedure crear_lista_obstaculos(var l: lista_obstaculos);
begin
        l.inicio:= nulo;
        l.final:= nulo;
end;

function lista_obstaculos_vacia(var l: lista_obstaculos): boolean;
begin
        lista_obstaculos_vacia := (l.inicio = nulo);
end;

function lista_obstaculos_llena(var l: lista_obstaculos):boolean;
var q: posicion_o;
begin
        new(q);
        lista_obstaculos_llena := (q=nulo);
        dispose(q);
end;

procedure eliminar_o(var l:lista_obstaculos; p:posicion_o);
var q:posicion_o;
begin
     if not(lista_obstaculos_vacia(l)) then
      begin
       q:=p;
       if (p=l.inicio) and (p=l.final) then
        crear_lista_obstaculos(l)
       else
        if (p=l.inicio) then
         begin
          l.inicio:=l.inicio^.prox;
          l.inicio^.ante:=nulo;
         end
        else
         if (p=l.final) then
          begin
           l.final:=l.final^.ante;
           l.final^.prox:=nulo;
          end
         else
          begin
           p^.ante^.prox:=p^.prox;
           p^.prox^.ante:=p^.ante;
          end;
       dispose(q);
      end;
end;



function distancia(t1,t2,l1,l2:integer):integer;
var aux:integer;
begin
     if t1 > t2 then
      aux:=t1-t2
     else
      aux:=t2-t1;
     if l1 > l2 then
      aux:=l1-l2+aux
     else
      aux:=l2-l1+aux;

     distancia:=aux;
end;

function buscar(var l:lista_obstaculos; x:string):posicion_o;
var q: posicion_o;
    encontre : boolean;
begin
            buscar := nulo;
            q := l.inicio;
            encontre := false;
            while (q <> nulo) and (not(encontre)) do
                if q.dato.nombre<>x then
                        q := q^.prox
                else
                        encontre := true;
            if encontre then buscar := q;
end;


procedure agregar_o (var l:lista_obstaculos; x:obstaculo);
var q: posicion_o;
begin
        if not(lista_obstaculos_llena(l)) then
        begin
                new(q);
                q^.dato := x;
                q^.prox := nulo;
                q^.ante := l.final;
                if lista_obstaculos_vacia(l) then
                        l.inicio :=q
                else
                        l.final^.prox := q;
                l.final := q;
        end;

end;





end.

