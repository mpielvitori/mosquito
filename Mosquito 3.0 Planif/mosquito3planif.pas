unit mosquito3planif;

interface

{En esta version el agente se mueve por todo el entorno imitando el
 vagabundeo de un mosquito.
 El entorno se simula como un campo de potencial artificial para evitar
 obstáculos que lo repelen y alcanzar las fuentes que son detectadas por el
 agente, cuando se encuentran cercanas a él.}

uses
  Windows, grafo_obj, matriz, listacpun, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, Grids, MPlayer, jpeg, Menus;

type
  TForm1 = class(TForm)
    Mover: TTimer;
    Energia: TProgressBar;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button2: TButton;
    Label2: TLabel;
    Edit4: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    Image1: TImage;
    Muerte: TTimer;
    Label10: TLabel;
    Label11: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    MainMenu1: TMainMenu;
    Crear1: TMenuItem;
    Objeto1: TMenuItem;
    Fuente1: TMenuItem;
    Mosquito1: TMenuItem;
    Ejecutar1: TMenuItem;
    Inicio1: TMenuItem;
    Coordenadas1: TMenuItem;
    Manual: TMenuItem;
    Tamao2: TMenuItem;
    Coordenadas2: TMenuItem;
    Manual1: TMenuItem;
    Tamao1: TMenuItem;
    Label8: TLabel;
    Label9: TLabel;
    Button1: TButton;
    Pausa1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Image2: TImage;
    mosquito: TShape;
    p: TShape;
    Label12: TLabel;
    Edit8: TEdit;
    c: TShape;
    Tapa: TShape;
    Mapa1: TMenuItem;
    Crear2: TMenuItem;
    Limpiar1: TMenuItem;
    Velocidad1: TMenuItem;
    N1001: TMenuItem;
    N751: TMenuItem;
    N501: TMenuItem;
    N251: TMenuItem;

    procedure MoverTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure MuerteTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Coordenadas1Click(Sender: TObject);
    procedure ManualClick(Sender: TObject);
    procedure Tamao2Click(Sender: TObject);
    procedure Inicio1Click(Sender: TObject);
    procedure Coordenadas2Click(Sender: TObject);
    procedure Manual1Click(Sender: TObject);
    procedure Tamao1Click(Sender: TObject);
    procedure Mosquito1Click(Sender: TObject);
    procedure Pausa1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Crear2Click(Sender: TObject);
    procedure Limpiar1Click(Sender: TObject);
    procedure N1001Click(Sender: TObject);
    procedure N751Click(Sender: TObject);
    procedure N501Click(Sender: TObject);
    procedure N251Click(Sender: TObject);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  s:string;
  n,code:integer;
  fuentes,objetos:lista;
  posim:posicion;
  m:matrix;
  m_entorno:matrix;
  obsta:lista_obstaculos;

implementation

{$R *.DFM}

uses
  MmSystem;

var
  variable: Integer = 0;
  lim: Integer = 600;
  booleana: boolean = true;
  crear: boolean = false;
  mov: boolean = false;
  mue: boolean = false;
  cont:integer=80;
  topes: boolean = false;
  ult_tope:integer=0;
  ult_left:integer=0;
  moski_fil:integer=1;
  moski_col:integer=1;
  mosquito_carga:real=0;
  ult_fil:integer=1;
  ult_col:integer=1;
  pica:boolean=false;

procedure actualizar_mapa(moski:tshape; i:integer);
var fila,columna:integer;
begin
     {Este procedimiento va creando un mapa del entorno en una matriz,
      guardando la información que obtiene al llegar a un obstáculo o a
      una fuente.}
      
     for fila:=min to 26 do
             for columna:=min to max do
              begin
               if  (moski.top>m[fila,columna].t) and (moski.top<m[fila,columna].t+20) and (moski.left>m[fila,columna].l) and (moski.left<m[fila,columna].l+20) and (m[fila,columna].estado=0) then
                begin
                     if i=1 then
                      m[fila,columna].shape.Brush.Color:=clred
                     else
                      m[fila,columna].shape.Brush.Color:=clblack;
                     m[fila,columna].estado:=i;
                     m[fila,columna].shape.visible:=true;
                end;
              end;
end;

procedure esquivar(energia:Tprogressbar; mosquito:tshape);
var p:posicion; t,l,fila,columna:integer;
begin
     {"Esquivar" es el procedimiento que esquiva los obstaculos que el
      agente encuentra frente a el a medida que avanza.
      Por cada paso que da chequea los obstaculos del entorno.
      Si se encuentra con uno de ellos, corrige su posicion, para no chocar.}

      l:=mosquito.left;
      t:=mosquito.top;
      p:=objetos.inicio;
      while (p<>nulo) do
       begin
         if ((mosquito.top) < ((p.dato.top)+(p.dato.height)+6)) and ((mosquito.top) > ((p.dato.top)-10)) and ((mosquito.left) < ((p.dato.left)+(p.dato.width)+6)) and ((mosquito.left) > ((p.dato.left)-10)) then
         begin
         actualizar_mapa(mosquito,-1);
         if ((mosquito.left) < ((p.dato.left)+(p.dato.width)+6)) and ((mosquito.left) >= ((p.dato.left)+(p.dato.width)-2)) then
         begin
          mosquito.left:=(p.dato.left)+(p.dato.width)+6;
          mosquito.top:=mosquito.top-2;
         end
         else
          if ((mosquito.left) > ((p.dato.left)-10)) and ((mosquito.left) < (p.dato.left)) then
           begin
            mosquito.left:=(p.dato.left)-14;
            mosquito.top:=mosquito.top-2
           end
           else
            if ((mosquito.top) < ((p.dato.top)+(p.dato.height)+6)) and ((mosquito.top) >= ((p.dato.top)+(p.dato.height)-2)) then
             begin
              mosquito.top:=(p.dato.top)+(p.dato.height)+6;
              mosquito.left:=mosquito.left-2
             end
             else
              if ((mosquito.top) > ((p.dato.top)-10)) and ((mosquito.top) < (p.dato.top)) then
               begin
                mosquito.top:=(p.dato.top)-14;
                mosquito.left:=mosquito.left-2
               end;
          ult_tope:=t;
          ult_left:=l;
         end;
         p:=p.prox;
       end;
      energia.position:=energia.position-1;
end;

procedure vagabundear(energia:Tprogressbar; mosquito:tshape);
var l,t:integer;
begin
     {"Vagabundear" es el procedimiento que da un bagabundeo al agente,
      imitando al de un mosquito.
      Por cada paso que da chequea los limites del entorno.
      Si se encuentra con uno de ellos, corrige su posicion, para no chocar.
      Si no es asi, sigue su vagabundeo un tanto aleatorio.
      Cuando recorre una cierta distancia, cambia de direccion.
      A su ves tambien llama al procedimiento de "esquivar" para esquivar
      cualquier posible obstaculo con que se encuentre.}

     l:=mosquito.left;
     t:=mosquito.top;
     if cont=80 then
       begin
        PlaySound ('20',0, snd_Async);
        mosquito.top:=mosquito.top+random(4)-1;
        mosquito.left:=mosquito.left+random(4)-1;
        if topes then
         topes:=false
        else
         topes:=true;
        cont:=0;
       end
     else
      begin
       cont:=cont+1;
       if (mosquito.top>=506) then
        begin
         actualizar_mapa(mosquito,-1);
         mosquito.top:=mosquito.top-random(1)-1;
         mosquito.left:=mosquito.left+random(4)-2;
         topes:=true;
      end
     else
        if (mosquito.top<=6) then
         begin
          actualizar_mapa(mosquito,-1);
          mosquito.top:=mosquito.top+random(1)+1;
          mosquito.left:=mosquito.left+random(4)-2;
          topes:=true;
         end
        else
         if (mosquito.left>=786) then
          begin
           actualizar_mapa(mosquito,-1);
           mosquito.left:=mosquito.left-random(1)-1;
           mosquito.top:=mosquito.top+random(4)-2;
           topes:=false;
          end
         else
          if (mosquito.left<=6) then
           begin
            actualizar_mapa(mosquito,-1);
            mosquito.left:=mosquito.left+random(1)+1;
            mosquito.top:=mosquito.top+random(4)-2;
            topes:=false;
           end
          else
              if (topes) then
               begin
                if (mosquito.top-ult_tope)<=0 then
                 mosquito.top:=mosquito.top-random(3)-1
                else
                 mosquito.top:=mosquito.top+random(3)+1;
                mosquito.left:=mosquito.left+random(4)-2;
               end
              else
               begin
                if (mosquito.left-ult_left)<0 then
                 mosquito.left:=mosquito.left-random(3)-1
               else
                 mosquito.left:=mosquito.left+random(3)+1;
               mosquito.top:=mosquito.top+random(4)-2;
               end;
      end;
      ult_tope:=t;
      ult_left:=l;
      esquivar(energia,mosquito);
      energia.position:=energia.position-1;
end;


procedure picar(energia:Tprogressbar; mosquito:tshape);
var suma,menor,x,i,ny,nx,xy,yx,v,st,sl,t,l,l2,t2,aux,tn,ln:integer; pos:posicion_o; mascerca,p,posix,posiy:posicion; b,o:boolean;
begin
      {"Picar" es el procedimiento que intenta llegar hasta la fuente mas
       cercana.
       Por cada paso que el agente da, busca dentro de las fuentes
       existentes en el entorno, la fuente mas cercana a él.
       Una vez que la localiza se acerca a ella haciendo la menor cantidad
       de movimiento posible.
       A su ves tambien llama al procedimiento de "esquivar" para esquivar
       cualquier posible obstaculo con que se encuentre, de forma reactiva.
       En caso de detectar un obstáculo que se le interpone en el camino,
       planifica uno para poder llegar hasta el objetivo sin colisionar.}

      mascerca:=nulo;
      tn:=mosquito.top;
      ln:=mosquito.left;
      if fuentes.inicio <> nulo then
       begin
          suma:=1900;
          p:=fuentes.inicio;
          while p<>nulo do
           begin
            if p.dato.left > mosquito.left then
             nx:=p.dato.left - mosquito.left
            else
             nx:=mosquito.left - p.dato.left;
            if p.dato.top > mosquito.top then
             ny:=p.dato.top - mosquito.top
            else
             ny:=mosquito.top - p.dato.top;
            if (nx+ny) < suma then
             begin
              suma:=nx+ny;
              mascerca:=p;
              pica:=true;
             end;
            p:=p.prox;
           end;
       end;
       b:=false;
       if (mascerca<>nulo) then
        o:=false
       else
        o:=true;
       pos:=obsta.inicio;
       while (pos<>nulo) and not(o) do
         begin
          if  (mosquito.left+10<pos.dato.N2.l) and (mascerca.dato.Left>pos.dato.N2.l) and ((mosquito.top+20)>pos.dato.N1.t) and ((mosquito.top-20)<pos.dato.N3.t) then
           o:=true
          else
           if  (mosquito.left-10>pos.dato.N1.l) and (mascerca.dato.Left<pos.dato.N1.l) and ((mosquito.top+20)>pos.dato.N1.t) and ((mosquito.top-20)<pos.dato.N3.t) then
            o:=true
           else
            if  (mosquito.top+10<pos.dato.N4.t) and (mascerca.dato.top>pos.dato.N4.t) and ((mosquito.left+20)>pos.dato.N1.l) and ((mosquito.left-20)<pos.dato.N2.l) then
             o:=true
            else
             if  (mosquito.top-10>pos.dato.N1.t) and (mascerca.dato.top<pos.dato.N1.t) and ((mosquito.left+20)>pos.dato.N1.l) and ((mosquito.left-20)<pos.dato.N2.l) then
              o:=true;
          if (o) then
           begin
            menor:=99999;
            n:=distancia(mosquito.top,pos.dato.N1.t,mosquito.left,pos.dato.N1.l);
            energia.position:=energia.position-1;
            if (n < menor) and (pos.dato.N1.estado<>1) then
             begin
               t:=pos.dato.N1.t;
               l:=pos.dato.N1.l;
               menor:=n;
             end;
            n:=distancia(mosquito.top,pos.dato.N2.t,mosquito.left,pos.dato.N2.l);
            if (n < menor) and (pos.dato.N2.estado<>1) then
             begin
               t:=pos.dato.N2.t;
               l:=pos.dato.N2.l;
               menor:=n;
             end;
            n:=distancia(mosquito.top,pos.dato.N3.t,mosquito.left,pos.dato.N3.l);
            if (n < menor) and (pos.dato.N3.estado<>1) then
             begin
               t:=pos.dato.N3.t;
               l:=pos.dato.N3.l;
               menor:=n;
             end;
            n:=distancia(mosquito.top,pos.dato.N4.t,mosquito.left,pos.dato.N4.l);
            if (n < menor) and (pos.dato.N4.estado<>1) then
             begin
               t:=pos.dato.N4.t;
               l:=pos.dato.N4.l;
               menor:=n;
             end;
             if (t) > (mosquito.top-2)then
              begin
               st:=(t) - (mosquito.top-2);
               t2:=1;
              end
             else
              if (t) < (mosquito.top+2)then
               begin
                st:=(mosquito.top+2)-(t);
                t2:=-1;
               end;
             if (l) > (mosquito.left-2) then
              begin
               sl:=(l) - (mosquito.left-2);
               l2:=1;
              end
             else
              if (l) < (mosquito.left+2) then
               begin
                sl:=(mosquito.left+2)-(l);
                l2:=-1;
               end;
             if sl>st then
              begin
               aux:=(sl div st);
               mosquito.left:=mosquito.left+(3*l2);
               mosquito.top:=mosquito.top+((3 div aux)*t2);
              end
             else
               if st>sl then
                begin
                 aux:=st div sl;
                 mosquito.top:=mosquito.top+(3*t2);
                 mosquito.left:=mosquito.left+((3 div aux)*l2);
                end
               else
                begin
                 mosquito.top:=mosquito.top+(3*t2);
                 mosquito.left:=mosquito.left+(3*l2);
                end;
              if (mosquito.top+4>pos.dato.N1.t) and (mosquito.top-4<pos.dato.N1.t) and (mosquito.left+4>pos.dato.N1.l) and (mosquito.left-4<pos.dato.N1.l) then
                pos.dato.N1.estado:=1;
              if (mosquito.top+4>pos.dato.N2.t) and (mosquito.top-4<pos.dato.N2.t) and (mosquito.left+4>pos.dato.N2.l) and (mosquito.left-4<pos.dato.N2.l) then
                pos.dato.N2.estado:=1;
              if (mosquito.top+4>pos.dato.N3.t) and (mosquito.top-4<pos.dato.N3.t) and (mosquito.left+4>pos.dato.N3.l) and (mosquito.left-4<pos.dato.N3.l) then
                pos.dato.N3.estado:=1;
              if (mosquito.top+4>pos.dato.N4.t) and (mosquito.top-4<pos.dato.N4.t) and (mosquito.left+4>pos.dato.N4.l) and (mosquito.left-4<pos.dato.N4.l) then
                pos.dato.N4.estado:=1;
           end;
          pos:=pos^.prox;
         end;
       if (pica) and not(o) then
        begin
           x:=1;
           pica:=false;
           for i:=1 to 2 do
            begin
             x:=x*(-1);
             if ((mascerca.dato.top)+((mascerca.dato.height)/2)) > (mosquito.top-2)then
              begin
               st:=((mascerca.dato.top)+((mascerca.dato.height) div 2)) - (mosquito.top-2);
               t:=1;
              end
             else
              if ((mascerca.dato.top)+((mascerca.dato.height)/2)) < (mosquito.top+2)then
               begin
                st:=(mosquito.top+2)-((mascerca.dato.top)+((mascerca.dato.height) div 2));
                t:=-1;
               end;
             if ((mascerca.dato.left)+((mascerca.dato.width)/2)) > (mosquito.left-2) then
              begin
               sl:=((mascerca.dato.left)+((mascerca.dato.width) div 2)) - (mosquito.left-2);
               l:=1;
              end
             else
              if ((mascerca.dato.left)+((mascerca.dato.width)/2)) < (mosquito.left+2) then
               begin
                sl:=(mosquito.left+2)-((mascerca.dato.left)+((mascerca.dato.width) div 2));
                l:=-1;
               end;
             if sl>st then
              begin
               aux:=(sl div st);
               mosquito.left:=mosquito.left+(6*l);
               mosquito.top:=mosquito.top+((6 div aux)*t);
              end
             else
               if st>sl then
                begin
                 aux:=st div sl;
                 mosquito.top:=mosquito.top+(6*t);
                 mosquito.left:=mosquito.left+((6 div aux)*l);
                end
               else
                begin
                 mosquito.top:=mosquito.top+(6*t);
                 mosquito.left:=mosquito.left+(6*l);
                end;
             ult_tope:=tn;
             ult_left:=ln;
             esquivar(energia,mosquito);
             mosquito.Refresh;
             tn:=mosquito.top;
             ln:=mosquito.left;
             sleep(45);
            end;
           energia.position:=energia.position-1;
          end;
      if cont=80 then
       begin
        cont:=0;
       end
      else
        cont:=cont+1;
end;

procedure TForm1.MoverTimer(Sender: TObject);
var i,fila,columna:integer;   p:posicion; salir:boolean; pos:posicion_o;
begin
   {Este es el procedimiento que decide a que procedimiento llamar
    dependiendo del nivel de energia del agente.}

  if (energia.position> 1196) then
        begin
   pos:=obsta.inicio;
     while (pos<>nulo) do
      begin
       pos.dato.N1.estado:=0;
       pos.dato.N2.estado:=0;
       pos.dato.N3.estado:=0;
       pos.dato.N4.estado:=0;
       pos:=pos^.prox;
      end;
      end;
   salir:=false;
   p:=nulo;
   if energia.position>0 then
     begin
        p:=fuentes.inicio;
        while (p<>nulo) and (not(salir)) do
         begin
          {En caso de estar sobre una fuente, incrementa la energia(pica).}

          if (mosquito.top>= p.dato.top) and (mosquito.top <= ((p.dato.top)+(p.dato.height)-5)) and (mosquito.left>= p.dato.left) and (mosquito.left <= ((p.dato.left)+(p.dato.width)-5)) then
           begin
            PlaySound (nil, 0, 0);
            actualizar_mapa(mosquito,1);
            energia.position:=energia.position+6;
            salir:=true;
            Image1.visible:=false;
           end
          else
           p:=p^.prox;
         end;
       if (p=nulo) or (energia.position> 1196) then
        begin
         if (energia.position> 1196) then
          begin
           PlaySound ('20',0, snd_Async);
           cont:=0;
          end;
         if (energia.position>lim) then
           vagabundear(energia,mosquito)
         else
          begin
             picar(energia,mosquito);
             if not(pica) then
              vagabundear(energia,mosquito);
             if energia.position<90 then
               begin
                     Image1.visible:=true;
                     Image1.top:= mosquito.Top - 35;
                     Image1.left:= mosquito.left - 9;
               end;
          end;
         end;
     end
    else
    {Si se termina la energia del agente, se limpia la pantalla.}

      begin
     PlaySound (nil, 0, 0);
     label1.visible:=false;
     label2.visible:=false;
     form1.color:=clwhite;
     energia.visible:=false;
     mosquito.visible:=true;
     mosquito.refresh;
     pausa1.checked:=false;
     objeto1.checked:=false;
     coordenadas2.checked:=false;
     manual.checked:=false;
     tamao2.checked:=false;
     fuente1.checked:=false;
     coordenadas1.checked:=false;
     manual1.checked:=false;
     tamao1.checked:=false;
     mosquito1.checked:=false;
     edit1.visible:=false;
     edit1.enabled:=false;
     edit2.visible:=false;
     edit2.enabled:=false;
     edit3.visible:=false;
     edit3.enabled:=false;
     edit4.visible:=false;
     edit4.enabled:=false;
     edit5.visible:=false;
     edit5.enabled:=false;
     edit6.visible:=false;
     edit6.enabled:=false;
     edit7.visible:=false;
     edit7.enabled:=false;
     edit8.visible:=false;
     edit8.enabled:=false;
     label3.visible:=false;
     label3.enabled:=false;
     label4.visible:=false;
     label4.enabled:=false;
     label5.visible:=false;
     label5.enabled:=false;
     label6.visible:=false;
     label6.enabled:=false;
     label7.visible:=false;
     label7.enabled:=false;
     label8.visible:=false;
     label8.enabled:=false;
     label9.visible:=false;
     label9.enabled:=false;
     label10.visible:=false;
     label10.enabled:=false;
     label11.visible:=false;
     label11.enabled:=false;
     label12.visible:=false;
     label12.enabled:=false;
     button2.enabled:=false;
     button2.visible:=false;
     button1.enabled:=false;
     button1.visible:=false;
     mover.enabled:=false;
     Image1.top:= mosquito.Top - 35;
     Image1.left:= mosquito.left - 9;
     Image1.visible:=true;
     sleep(500);
     muerte.enabled:=true;
    end;
end;
procedure TForm1.Button2Click(Sender: TObject);
var  ob:obstaculo; b1,nuevo:boolean; p:tshape; x,y,f_arr,f_aba,c_izq,c_der,h,w,fila,columna,lm,l,t:integer; distancia:real; pos,pos_aux:posicion_o;
begin
     {Haciendo 'click' en el boton de crear, se crea un objeto o una fuente
      tomando las coordenadas y el tamaño establecidos en los cuadros.
      Se creará una fuente o un obstáculo, dependiendo de lo que se halla
      elegido antes.}

     if mover.enabled=true then
      begin
       b1:=true;
       mover.enabled:=false;
      end
     else
      b1:=false;
     p:= tshape.Create(p);
     with  (p) do
      if booleana=false then
       begin
         Parent := self;
         SendToBack;
         val(edit1.text,n,code);
         Left := n;
         x:=n;
         val(edit2.text,n,code);
         Top := n;
         y:=n;
         brush.color:=clred;
         shape:=stroundrect;
         val(edit3.text,n,code);
         width:=n;
         w:=n;
         val(edit4.text,n,code);
         height:=n;
         h:=n;
         variable:=variable+1;
         str(variable,s);
         name:='martin'+s;
         agregar (fuentes,p);
       end
      else
         begin
         Parent := self;
         SendToBack;
         val(edit1.text,n,code);
         Left := n;
         x:=n;
         val(edit2.text,n,code);
         Top := n;
         y:=n;
         brush.color:=clhighlight;
         shape:=strectangle;
         val(edit3.text,n,code);
         width:=n;
         w:=n;
         val(edit4.text,n,code);
         height:=n;
         h:=n;
         variable:=variable+1;
         str(variable,s);
         name:='martin'+s;
         agregar (objetos,p);
       end;
     if (booleana) then
     {Si se está creando un obstáculo que no está muy cerca de algun otro,
      se le crea un nuevo grafo para la posterior planificacion de caminos.
      Si se está creando un obstáculo que está muy cerca de algun otro,
      se fusiona el grafo del obstáculo existente, con el nuevo.}

      begin
       nuevo:=true;
       pos:=obsta.inicio;
       pos_aux:=nulo;
       while (pos<>nulo) do
         begin
          if (x+15+w>pos.dato.N1.l) and (x-25<pos.dato.N2.l) and (y+15+h>pos.dato.N1.t) and (y-25<pos.dato.N4.t) then
           begin
           if pos_aux=nulo then
           begin
            pos_aux:=pos;
            if (x+w+2>pos.dato.N2.l) then
             begin
              pos.dato.N2.l:=x+w;
              pos.dato.N4.l:=x+w;
             end;
            if (x-5<pos.dato.N1.l) then
             begin
              pos.dato.N1.l:=x-12;
              pos.dato.N3.l:=x-12;
             end;
            if (y+2+h>pos.dato.N3.t) then
             begin
              pos.dato.N3.t:=y+h;
              pos.dato.N4.t:=y+h;
             end;
            if (y-5<pos.dato.N1.t) then
             begin
              pos.dato.N1.t:=y-12;
              pos.dato.N2.t:=y-12;
             end;
            nuevo:=false;
           end
           else
            begin
             if (pos_aux.dato.N2.l>pos.dato.N2.l) then
             begin
              pos.dato.N2.l:=pos_aux.dato.N2.l;
              pos.dato.N4.l:=pos_aux.dato.N2.l;
             end
             else
              begin
               pos_aux.dato.N2.l:=pos.dato.N2.l;
               pos_aux.dato.N4.l:=pos.dato.N2.l;
              end;
            if (pos_aux.dato.N1.l<pos.dato.N1.l) then
             begin
              pos.dato.N1.l:=pos_aux.dato.N1.l;
              pos.dato.N3.l:=pos_aux.dato.N1.l;
             end
            else
             begin
              pos_aux.dato.N1.l:=pos.dato.N1.l;
              pos_aux.dato.N3.l:=pos.dato.N1.l;
             end;
            if (pos_aux.dato.N3.t>pos.dato.N3.t) then
             begin
              pos.dato.N3.t:=pos_aux.dato.N3.t;
              pos.dato.N4.t:=pos_aux.dato.N3.t;
             end
            else
             begin
              pos_aux.dato.N3.t:=pos.dato.N3.t;
              pos_aux.dato.N4.t:=pos.dato.N3.t;
             end;
            if (pos_aux.dato.N1.t<pos.dato.N1.t) then
             begin
              pos.dato.N1.t:=pos_aux.dato.N1.t;
              pos.dato.N2.t:=pos_aux.dato.N1.t;
             end
            else
             begin
              pos_aux.dato.N1.t:=pos.dato.N1.t;
              pos_aux.dato.N2.t:=pos.dato.N1.t;
             end;
            pos_aux:=pos;
            end;
           end;
          pos:=pos^.prox;
         end;
       if nuevo then
        begin
         new(ob.n1);
         ob.N1.t:=y-12;
         ob.N1.l:=x-12;
         new(ob.n2);
         ob.N2.t:=y-12;
         ob.N2.l:=x+w+2;
         new(ob.n3);
         ob.N3.t:=y+h+2;
         ob.N3.l:=x-12;
         new(ob.n4);
         ob.N4.t:=y+h+2;
         ob.N4.l:=x+w+2;
         agregar_o(obsta,ob);
        end;
      end;
    if b1 then
      mover.enabled:=true;

end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var  ob:obstaculo; b1,nuevo:boolean; p:tshape; f_arr,f_aba,c_izq,c_der,h,w,fila,columna,lm:integer; distancia:real; pos,pos_aux:posicion_o;
begin
     {Se crea un objeto o una fuente manualmente tomando el tamaño
      establecido en los cuadros y las coordenadas de la posicion del
      cursor al hacer 'click'.
      Se creará una fuente o un obstáculo, dependiendo de lo que se halla
      elegido antes.}

     if crear=true then
     begin
     if mover.enabled=true then
      begin
       b1:=true;
       mover.enabled:=false;
      end
     else
      b1:=false;
     p:= tshape.Create(p);
     with  (p) do
       if booleana=false then
        begin
            Parent := self;
            SendToBack;
            val(edit3.text,n,code);
            width:=n;
            w:=n;
            val(edit4.text,n,code);
            height:=n;
            h:=n;
            Left := x;
            Top := y;
            brush.color:=clred;
            shape:=stroundrect;
            variable:=variable+1;
            str(variable,s);
            name:='martin'+s;
            agregar (fuentes,p);
        end
       else
          begin
            Parent := self;
            SendToBack;
            val(edit3.text,n,code);
            width:=n;
            w:=n;
            val(edit4.text,n,code);
            height:=n;
            h:=n;
            Left := x;
            Top := y;
            brush.color:=clhighlight;
            shape:=strectangle;
            variable:=variable+1;
            str(variable,s);
            name:='martin'+s;
            agregar (objetos,p);
          end;
     if (booleana) then
     {Si se está creando un obstáculo que no está muy cerca de algun otro,
      se le crea un nuevo grafo para la posterior planificacion de caminos.
      Si se está creando un obstáculo que está muy cerca de algun otro,
      se fusiona el grafo del obstáculo existente, con el nuevo.}

      begin
       nuevo:=true;
       pos:=obsta.inicio;
       pos_aux:=nulo;
       while (pos<>nulo) do
         begin
          if (x+15+w>pos.dato.N1.l) and (x-25<pos.dato.N2.l) and (y+15+h>pos.dato.N1.t) and (y-25<pos.dato.N4.t) then
           begin
           if pos_aux=nulo then
           begin
            pos_aux:=pos;
            if (x+w+2>pos.dato.N2.l) then
             begin
              pos.dato.N2.l:=x+w;
              pos.dato.N4.l:=x+w;
             end;
            if (x-5<pos.dato.N1.l) then
             begin
              pos.dato.N1.l:=x-12;
              pos.dato.N3.l:=x-12;
             end;
            if (y+2+h>pos.dato.N3.t) then
             begin
              pos.dato.N3.t:=y+h;
              pos.dato.N4.t:=y+h;
             end;
            if (y-5<pos.dato.N1.t) then
             begin
              pos.dato.N1.t:=y-12;
              pos.dato.N2.t:=y-12;
             end;
            nuevo:=false;
           end
           else
            begin
             if (pos_aux.dato.N2.l>pos.dato.N2.l) then
             begin
              pos.dato.N2.l:=pos_aux.dato.N2.l;
              pos.dato.N4.l:=pos_aux.dato.N2.l;
             end
             else
              begin
               pos_aux.dato.N2.l:=pos.dato.N2.l;
               pos_aux.dato.N4.l:=pos.dato.N2.l;
              end;
            if (pos_aux.dato.N1.l<pos.dato.N1.l) then
             begin
              pos.dato.N1.l:=pos_aux.dato.N1.l;
              pos.dato.N3.l:=pos_aux.dato.N1.l;
             end
            else
             begin
              pos_aux.dato.N1.l:=pos.dato.N1.l;
              pos_aux.dato.N3.l:=pos.dato.N1.l;
             end;
            if (pos_aux.dato.N3.t>pos.dato.N3.t) then
             begin
              pos.dato.N3.t:=pos_aux.dato.N3.t;
              pos.dato.N4.t:=pos_aux.dato.N3.t;
             end
            else
             begin
              pos_aux.dato.N3.t:=pos.dato.N3.t;
              pos_aux.dato.N4.t:=pos.dato.N3.t;
             end;
            if (pos_aux.dato.N1.t<pos.dato.N1.t) then
             begin
              pos.dato.N1.t:=pos_aux.dato.N1.t;
              pos.dato.N2.t:=pos_aux.dato.N1.t;
             end
            else
             begin
              pos_aux.dato.N1.t:=pos.dato.N1.t;
              pos_aux.dato.N2.t:=pos.dato.N1.t;
             end;
            pos_aux:=pos;
            end;
           end;
          pos:=pos^.prox;
         end;
       if nuevo then
        begin
         new(ob.n1);
         ob.N1.t:=y-12;
         ob.N1.l:=x-12;
         new(ob.n2);
         ob.N2.t:=y-12;
         ob.N2.l:=x+w+2;
         new(ob.n3);
         ob.N3.t:=y+h+2;
         ob.N3.l:=x-12;
         new(ob.n4);
         ob.N4.t:=y+h+2;
         ob.N4.l:=x+w+2;
         agregar_o(obsta,ob);
        end;
      end;
      if b1 then
       mover.enabled:=true;
     end;
end;

procedure TForm1.FormActivate(Sender: TObject);
var n,code,fila,columna,x,y:integer; pos:posicion_o;
begin
     pos:=obsta.inicio;
     while (pos<>nulo) do
      begin
       pos.dato.N1.estado:=0;
       pos.dato.N2.estado:=0;
       pos.dato.N3.estado:=0;
       pos.dato.N4.estado:=0;
       pos:=pos^.prox;
      end;
     randomize;
     ult_tope:=mosquito.top;
     ult_left:=mosquito.left;
     crear_matriz_vacia(m);
     crear_lista_vacia(fuentes);
     crear_lista_vacia(objetos);
     crear_lista_obstaculos(obsta);
     Label2.color:=$0099CBE6;
     Label2.Caption :='Hoy es: '+DateToStr(Date);
     //crea el mapa
     c:= Tshape.create  (c);
     with (c) do
      begin
       parent := self;
       top:=380;
       left:=580;
       width:=40*5;
       height:=26*5;
       brush.color:=$0099CBE6;
       pen.Style:=psclear;
       bringtofront;
       visible:=true;
       enabled:=false;
      end;
     y:=-20;
     for fila:=1 to 26 do
       begin
       x:=-20;
       y:=y+20;
          for columna:=1 to 40 do
           begin
            x:=x+20;
            m[fila,columna].carga:=0;
            m[fila,columna].l:=x;
            m[fila,columna].t:=y;
            c:= Tshape.create  (c);
            with (c) do
             begin
              Parent := self;
              top:=y-(15*(fila-1))+380;
              left:=x-(15*(columna-1))+580;
              width:=6;
              height:=6;
              brush.Style:=bsclear;
              bringtofront;
              visible:=true;
              enabled:=true;
             end;
            m[fila,columna].shape:=c;
           end;
       end;
end;
procedure TForm1.MuerteTimer(Sender: TObject);
var p:posicion;
begin
     {Cuando el nivel de energía llega a cierto límite, aparece un ángel,
      siguiendo los pasos del agente.}

     //La gatita Kittie hace su trabajo...

     Image1.top:=Image1.top - 4;
     mosquito.Top:=mosquito.Top - 4;
     Image1.left:=Image1.left - 1;
     mosquito.left:=mosquito.left - 1;
     mosquito.refresh;
     image1.refresh;
     if (image1.top < -150) or (image1.left < -100) then
            //final de la vida del mosquito
            begin
             PlaySound ('FOGBLAST',0, snd_Async);
             image2.visible:=true;
             Image1.visible:=false;
             mosquito.visible:=false;
             muerte.enabled:=false;
             mover.enabled:=false;
            end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var m:boolean;
begin
     {Haciendo 'click' en el botón de "Actualizar" se toman los datos del
      agente, establecidos en los cuadros, y se lo actualiza.}

     if mover.enabled=true then
      begin
       m:=true;
       mover.enabled:=false;
       val(Edit8.text,n,code);
       lim:=n;
       val(Edit5.text,n,code);
       Energia.position:=n;
       val(Edit7.text,n,code);
       mosquito.top:=n;
       val(Edit6.text,n,code);
       mosquito.left:=n;
       mosquito.refresh;
       mosquito.visible:=true;
       if energia.position>90 then
        image1.visible:=false;
      end
     else
      m:=false;
     val(Edit5.text,n,code);
     Energia.position:=n;
     val(Edit7.text,n,code);
     mosquito.top:=n;
     val(Edit6.text,n,code);
     mosquito.left:=n;
     mosquito.refresh;
     mosquito.visible:=true;
     if m then
      mover.enabled:=true;
end;

procedure TForm1.Coordenadas1Click(Sender: TObject);
begin
     {Se ocultan o visualizan los cuadros de coordenadas de obstáculos.}

     if Coordenadas1.checked=true then
      begin
       Coordenadas1.checked:=false;
       button2.enabled:=false;
       button2.visible:=false;
       edit1.visible:=false;
       edit1.enabled:=false;
       edit2.visible:=false;
       edit2.enabled:=false;
       label9.visible:=false;
       label9.enabled:=false;
       label3.visible:=false;
       label3.enabled:=false;
       label4.visible:=false;
       label4.enabled:=false;
     end
    else
      begin
       crear:=false;
       booleana:=true;
       manual.checked:=false;
       coordenadas1.checked:=true;
       button2.enabled:=true;
       button2.visible:=true;
       edit1.visible:=true;
       edit1.enabled:=true;
       edit2.visible:=true;
       edit2.enabled:=true;
       label9.caption:='Objeto:';
       label9.visible:=true;
       label9.enabled:=true;
       label3.visible:=true;
       label3.enabled:=true;
       label4.visible:=true;
       label4.enabled:=true;
      end;
      if tamao2.checked=false then
       begin
        edit3.visible:=false;
        edit3.enabled:=false;
        edit4.visible:=false;
        edit4.enabled:=false;
        label5.visible:=false;
        label5.enabled:=false;
        label6.visible:=false;
        label6.enabled:=false;
       end;
      if (coordenadas1.checked=true) or (manual.checked=true) then
        begin
         objeto1.checked:=true;
         fuente1.checked:=false;
         mosquito1.checked:=false;
         manual1.checked:=false;
         coordenadas2.checked:=false;
         tamao1.checked:=false;
        end
      else
        begin
         tamao2.checked:=false;
         edit3.visible:=false;
         edit3.enabled:=false;
         edit4.visible:=false;
         edit4.enabled:=false;
         label5.visible:=false;
         label5.enabled:=false;
         label6.visible:=false;
         label6.enabled:=false;
         objeto1.checked:=false;
         coordenadas1.checked:=false;
         manual.checked:=false;
        end;
end;

procedure TForm1.ManualClick(Sender: TObject);
begin
     {Se activa o desactiva el modo manual de crear obstáculos.}

     if manual.checked=true then
      begin
       crear:=false;
      end
    else
      begin
       label9.visible:=false;
       label9.enabled:=false;
       crear:=true;
       booleana:=true;
       manual.checked:=true;
       coordenadas1.checked:=false;
       button2.enabled:=false;
       button2.visible:=false;
       edit1.visible:=false;
       edit1.enabled:=false;
       edit2.visible:=false;
       edit2.enabled:=false;
       label3.visible:=false;
       label3.enabled:=false;
       label4.visible:=false;
       label4.enabled:=false;
      end;
       if tamao2.checked=false then
        begin
         edit3.visible:=false;
         edit3.enabled:=false;
         edit4.visible:=false;
         edit4.enabled:=false;
         label5.visible:=false;
         label5.enabled:=false;
         label6.visible:=false;
         label6.enabled:=false;
        end;
      if (coordenadas1.checked=true) or (manual.checked=true) then
        begin
         objeto1.checked:=true;
         fuente1.checked:=false;
         mosquito1.checked:=false;
         manual1.checked:=false;
         coordenadas2.checked:=false;
         tamao1.checked:=false;
        end
      else
        begin
         tamao2.checked:=false;
         edit3.visible:=false;
         edit3.enabled:=false;
         edit4.visible:=false;
         edit4.enabled:=false;
         label5.visible:=false;
         label5.enabled:=false;
         label6.visible:=false;
         label6.enabled:=false;
         objeto1.checked:=false;
         coordenadas1.checked:=false;
         manual.checked:=false;
        end;
end;

procedure TForm1.Tamao2Click(Sender: TObject);
begin
     {Se ocultan o visualizan los cuadros de tamaño de obstáculos.}

     if (coordenadas1.checked=true) or (manual.checked=true) then
      if tamao2.checked=true then
       begin
        tamao2.checked:=false;
        edit3.visible:=false;
        edit3.enabled:=false;
        edit4.visible:=false;
        edit4.enabled:=false;
        label5.visible:=false;
        label5.enabled:=false;
        label6.visible:=false;
        label6.enabled:=false;
       end
      else
       begin
        tamao2.checked:=true;
        edit3.visible:=true;
        edit3.enabled:=true;
        edit4.visible:=true;
        edit4.enabled:=true;
        label5.visible:=true;
        label5.enabled:=true;
        label6.visible:=true;
        label6.enabled:=true;
       end;
end;

procedure TForm1.Inicio1Click(Sender: TObject);
var pos:posicion_o;
begin
     {Comienza el movimiento del mosquito limpiando la pantalla.}
     pos:=obsta.inicio;
     while (pos<>nulo) do
      begin
       pos.dato.N1.estado:=0;
       pos.dato.N2.estado:=0;
       pos.dato.N3.estado:=0;
       pos.dato.N4.estado:=0;
       pos:=pos^.prox;
      end;
     Image1.visible:=false;
     mosquito.BringToFront;
     energia.SendToBack;
     mosquito.brush.color:=clblack;
     label2.visible:=true;
     form1.color:=$0099CBE6;
     image2.visible:=false;
     val(Edit5.text,n,code);
     Energia.position:=n;
     val(Edit8.text,n,code);
     lim:=n;
     label12.visible:=false;
     label12.enabled:=false;
     edit8.visible:=false;
     edit8.enabled:=false;
     val(Edit7.text,n,code);
     mosquito.top:=n;
     val(Edit6.text,n,code);
     mosquito.left:=n;
     mosquito.visible:=true;
     mosquito.refresh;
     pausa1.checked:=false;
     objeto1.checked:=false;
     coordenadas2.checked:=false;
     manual.checked:=false;
     tamao2.checked:=false;
     fuente1.checked:=false;
     coordenadas1.checked:=false;
     manual1.checked:=false;
     tamao1.checked:=false;
     mosquito1.checked:=false;
     edit1.visible:=false;
     edit1.enabled:=false;
     edit2.visible:=false;
     edit2.enabled:=false;
     edit3.visible:=false;
     edit3.enabled:=false;
     edit4.visible:=false;
     edit4.enabled:=false;
     edit5.visible:=false;
     edit5.enabled:=false;
     edit6.visible:=false;
     edit6.enabled:=false;
     edit7.visible:=false;
     edit7.enabled:=false;
     label3.visible:=false;
     label3.enabled:=false;
     label4.visible:=false;
     label4.enabled:=false;
     label5.visible:=false;
     label5.enabled:=false;
     label6.visible:=false;
     label6.enabled:=false;
     label7.visible:=false;
     label7.enabled:=false;
     label8.visible:=false;
     label8.enabled:=false;
     label9.visible:=false;
     label9.enabled:=false;
     label10.visible:=false;
     label10.enabled:=false;
     label11.visible:=false;
     label11.enabled:=false;
     button2.enabled:=false;
     button2.visible:=false;
     button1.enabled:=false;
     button1.visible:=false;
     energia.visible:=true;
     label1.Visible:=true;
     mover.enabled:=true;
end;

procedure TForm1.Coordenadas2Click(Sender: TObject);
begin
     {Se ocultan o visualizan los cuadros de coordenadas de fuentes.}

     if Coordenadas2.checked=true then
      begin
       Coordenadas2.checked:=false;
       button2.enabled:=false;
       button2.visible:=false;
       edit1.visible:=false;
       edit1.enabled:=false;
       edit2.visible:=false;
       edit2.enabled:=false;
       label9.visible:=false;
       label9.enabled:=false;
       label3.visible:=false;
       label3.enabled:=false;
       label4.visible:=false;
       label4.enabled:=false;
     end
    else
      begin
       crear:=false;
       booleana:=false;
       manual1.checked:=false;
       coordenadas2.checked:=true;
       button2.enabled:=true;
       button2.visible:=true;
       edit1.visible:=true;
       edit1.enabled:=true;
       edit2.visible:=true;
       edit2.enabled:=true;
       label3.visible:=true;
       label3.enabled:=true;
       label4.visible:=true;
       label4.enabled:=true;
       label9.caption:='Fuente:';
       label9.visible:=true;
       label9.enabled:=true;
      end;
       if tamao1.checked=false then
      begin
       edit3.visible:=false;
      edit3.enabled:=false;
      edit4.visible:=false;
      edit4.enabled:=false;
      label5.visible:=false;
     label5.enabled:=false;
     label6.visible:=false;
     label6.enabled:=false;
     end;
      if (coordenadas2.checked=true) or (manual1.checked=true) then
        begin
         objeto1.checked:=false;
         fuente1.checked:=true;
         mosquito1.checked:=false;
          manual.checked:=false;
         coordenadas1.checked:=false;
         tamao2.checked:=false;
        end
      else
        begin
         tamao1.checked:=false;
      edit3.visible:=false;
      edit3.enabled:=false;
      edit4.visible:=false;
      edit4.enabled:=false;
      label5.visible:=false;
     label5.enabled:=false;
     label6.visible:=false;
     label6.enabled:=false;
         fuente1.checked:=false;
         coordenadas2.checked:=false;
         manual1.checked:=false;
        end;
end;

procedure TForm1.Manual1Click(Sender: TObject);
begin
     {Se activa o desactiva el modo manual de crear fuentes.}

     if manual1.checked=true then
      begin
       crear:=false;
       manual1.checked:=false;
     end
    else
      begin
       label9.visible:=false;
       label9.enabled:=false;
       crear:=true;
       booleana:=false;
       manual1.checked:=true;
       coordenadas2.checked:=false;
       button2.enabled:=false;
       button2.visible:=false;
       edit1.visible:=false;
       edit1.enabled:=false;
       edit2.visible:=false;
       edit2.enabled:=false;
       label3.visible:=false;
       label3.enabled:=false;
       label4.visible:=false;
       label4.enabled:=false;
      end;
       if tamao1.checked=false then
      begin
       edit3.visible:=false;
      edit3.enabled:=false;
      edit4.visible:=false;
      edit4.enabled:=false;
      label5.visible:=false;
     label5.enabled:=false;
     label6.visible:=false;
     label6.enabled:=false;
     end;
      if (coordenadas2.checked=true) or (manual1.checked=true) then
        begin
         objeto1.checked:=false;
         fuente1.checked:=true;
         mosquito1.checked:=false;
          manual.checked:=false;
         coordenadas1.checked:=false;
         tamao2.checked:=false;
        end
      else
        begin
         tamao1.checked:=false;
         edit3.visible:=false;
         edit3.enabled:=false;
         edit4.visible:=false;
         edit4.enabled:=false;
         label5.visible:=false;
         label5.enabled:=false;
         label6.visible:=false;
         label6.enabled:=false;
         fuente1.checked:=false;
         coordenadas2.checked:=false;
         manual1.checked:=false;
        end;
end;

procedure TForm1.Tamao1Click(Sender: TObject);
begin
     {Se ocultan o visualizan los cuadros de tamaño de las fuentes.}

     if (coordenadas2.checked=true) or (manual1.checked=true) then
      if tamao1.checked=true then
       begin
        tamao1.checked:=false;
        edit3.visible:=false;
        edit3.enabled:=false;
        edit4.visible:=false;
        edit4.enabled:=false;
        label5.visible:=false;
        label5.enabled:=false;
        label6.visible:=false;
        label6.enabled:=false;
       end
     else
      begin
       tamao1.checked:=true;
       edit3.visible:=true;
       edit3.enabled:=true;
       edit4.visible:=true;
       edit4.enabled:=true;
       label5.visible:=true;
       label5.enabled:=true;
       label6.visible:=true;
       label6.enabled:=true;
      end;
end;

procedure TForm1.Mosquito1Click(Sender: TObject);
begin
   {Se ocultan o visualizan los cuadros de información del agente.}

   if mosquito1.checked=false then
    begin
     energia.visible:=true;
     label1.visible:=true;
     mosquito1.checked:=true;
     label12.visible:=true;
     label12.enabled:=true;
     label8.visible:=true;
     label8.enabled:=true;
     label7.visible:=true;
     label7.enabled:=true;
     label10.visible:=true;
     label10.enabled:=true;
     label11.visible:=true;
     label11.enabled:=true;
     edit5.visible:=true;
     edit5.enabled:=true;
     edit6.visible:=true;
     edit6.enabled:=true;
     edit7.visible:=true;
     edit7.enabled:=true;
     edit8.visible:=true;
     edit8.enabled:=true;
     button1.visible:=true;
     button1.enabled:=true;
    end
   else
    begin
     if (mover.enabled=true) or (pausa1.checked=true) then
      begin
       energia.visible:=true;
       label1.visible:=true;
      end
     else
      begin
       energia.visible:=false;
       label1.visible:=false;
      end;
     mosquito1.checked:=false;
     label8.visible:=false;
     label8.enabled:=false;
     label7.visible:=false;
     label7.enabled:=false;
     label10.visible:=false;
     label10.enabled:=false;
     label11.visible:=false;
     label11.enabled:=false;
     edit5.visible:=false;
     edit5.enabled:=false;
     edit6.visible:=false;
     edit6.enabled:=false;
     edit7.visible:=false;
     edit7.enabled:=false;
     button1.visible:=false;
     button1.enabled:=false;
     label12.visible:=false;
     label12.enabled:=false;
     edit8.visible:=false;
     edit8.enabled:=false;
    end;

end;

procedure TForm1.Pausa1Click(Sender: TObject);
begin
     {Detiene o reanuda el programa.}

     if pausa1.checked=false then
       begin
       PlaySound (nil, 0, 0);
       pausa1.checked:=true;
       if mover.enabled=true then
        begin
         mover.enabled:=false;
         mov:=true;
        end;
       if muerte.enabled=true then
        begin
         mue:=true;
         muerte.enabled:=false;
        end;
       end
     else
       begin
        pausa1.checked:=false;
        if mov then
          mover.enabled:=true;
       if mue then
         muerte.enabled:=true;
      end;
end;

procedure TForm1.About1Click(Sender: TObject);
var m:boolean;
begin
    {Muestra información sobre el programa.}

    m:=false;
    if mover.Enabled=true then
     begin
      m:=true;
      mover.Enabled:=false;
      PlaySound (nil, 0, 0);
     end;
    MessageDlg ('Seminario de Actualización'#13 +
     'Tema "El Mosquito"'#13+ 'Version 3.0 con Planificación de caminos'#13 + ''#13 + 'Autor: Martin Pielvitori'#13 +
     'Legajo: 69184',
     mtInformation, [mbOK], 0);
    if (m) then
     begin
      mover.Enabled:=true;
      PlaySound ('20',0, snd_Async);
     end;
end;

procedure TForm1.Crear2Click(Sender: TObject);
var n,code,fila,columna,x,y:integer;
begin
     {Visualiza el mapa del entorno en tamaño real.}

     crear_matriz_vacia(m_entorno);
     y:=-20;
     for fila:=1 to 26 do
       begin
       x:=-20;
       y:=y+20;
          for columna:=1 to 40 do
           begin
            x:=x+20;
            c:= Tshape.create  (c);
            with (c) do
             begin
              parent := self;
              top:=y;
              left:=x;
              width:=20;
              height:=20;
              brush.style:=bsclear;
              pen.Style:=psdot;
              sendtoback;
              enabled:=false;
             end;
            m_entorno[fila,columna].shape:=c;
           end;
       end;
end;

procedure TForm1.Limpiar1Click(Sender: TObject);
var fila,columna:integer;
begin
     {Borra el mapa de tamaño real visualizado.}
     
     for fila:=1 to 26 do
       for columna:=1 to 40 do
         with (c) do
           m_entorno[fila,columna].shape.Visible:=false;
end;


procedure TForm1.N1001Click(Sender: TObject);
begin
     mover.Interval:=15;
end;

procedure TForm1.N751Click(Sender: TObject);
begin
     mover.Interval:=55;
end;

procedure TForm1.N501Click(Sender: TObject);
begin
     mover.Interval:=95;
end;

procedure TForm1.N251Click(Sender: TObject);
begin
     mover.Interval:=135;
end;

end.



