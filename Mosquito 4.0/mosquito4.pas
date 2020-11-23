unit mosquito4;

interface

{En esta version el agente se mueve por todo el entorno imitando el
 vagabundeo de un mosquito.
 El entorno se simula como un campo de potencial artificial para evitar
 obstáculos que lo repelen y alcanzar las fuentes que son detectadas por el
 agente, cuando se encuentran cercanas a él.}

uses
  Windows, matriz, listacpun, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
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
    i1: TImage;
    p: TShape;
    Label12: TLabel;
    Edit8: TEdit;
    c: TShape;
    Velocidad1: TMenuItem;
    N1001: TMenuItem;
    N751: TMenuItem;
    N501: TMenuItem;
    N251: TMenuItem;
    Tapa: TShape;
    i2: TImage;
    i3: TImage;
    i4: TImage;
    i5: TImage;
    mosquito: TShape;
    i12: TImage;
    i13: TImage;
    i14: TImage;
    i15: TImage;
    i16: TImage;
    i18: TImage;
    i19: TImage;
    i20: TImage;
    i21: TImage;
    i22: TImage;
    i6: TImage;
    i7: TImage;
    i8: TImage;
    i9: TImage;
    i10: TImage;
    i23: TImage;
    i24: TImage;
    i25: TImage;

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
    procedure N751Click(Sender: TObject);
    procedure N501Click(Sender: TObject);
    procedure N251Click(Sender: TObject);
    procedure N1001Click(Sender: TObject);
    
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
  mascerca:posicion=nulo;


procedure esquivar(energia:Tprogressbar; mosquito:tshape);
var p:posicion; t,l,fila,columna,aux_fil,aux_col,i,j:integer; menor:real;
begin
      {Este procedimiento evita los obstaculos asegurandose de que la
       posición del agente este siempre en una zona con carga negativa
       o nula(zona en la que no hay obstaculos).}

      menor:=1;
      for fila:=min to 26 do
         for columna:=min to max do
          begin
               if  (mosquito.top>m[fila,columna].t) and (mosquito.top<m[fila,columna].t+20) and (mosquito.left>m[fila,columna].l) and (mosquito.left<m[fila,columna].l+20) then
                begin
                     if m[fila,columna].carga>0 then
                      begin
                        for i:=columna-1 to columna+1 do
                         for j:=fila-1 to fila+1 do
                          if ((fila<>j) or (columna<>i)) and (i > 0) and (i < 41) and (j > 0) and (j < 27) then
                           begin
                            if (m[j,i].carga<menor) then
                             begin
                              aux_fil:=j;
                              aux_col:=i;
                              menor:=m[j,i].carga;
                             end;
                           end;
                        if aux_fil<moski_fil then
                         mosquito.top:=mosquito.top-3
                        else
                         if aux_fil>moski_fil then
                          mosquito.top:=mosquito.top+3;
                        if aux_col<moski_col then
                         mosquito.left:=mosquito.left-3
                        else
                         if aux_col>moski_col then
                          mosquito.left:=mosquito.left+3;
                      end;
                end;
              end;

end;

procedure vagabundear(energia:Tprogressbar; mosquito:tshape);
var i,l,t:integer;   p:tshape;
begin
    {"Vagabundear" es el procedimiento que da un bagabundeo al agente,
     imitando al de un mosquito.
     Cuando recorre una cierta distancia, cambia de direccion.
     A su ves tambien llama al procedimiento de "esquivar" para esquivar
     cualquier posible obstaculo o limite del entorno con que se encuentre.}

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


procedure picar(energia:Tprogressbar; mosquito:tshape; var edit2:tedit);
var suma,x,i,j,ny,nx,xy,yx,v,st,sl,t,l,aux_fil,aux_col,tn,ln,dist:integer; p,posix,posiy:posicion; b,b2:boolean; menor:real;
begin
      {"Picar" es el procedimiento que lleva al agente hasta la fuente
       atraído por sus cargas atractivas.}

      tn:=mosquito.top;
      ln:=mosquito.left;
      dist:=1900;
       if (fuentes.inicio <> nulo) then
        begin
           if cont=80 then
            begin
             PlaySound ('20',0, snd_Async);
             cont:=0;
            end
           else
            cont:=cont+1;
           menor:=3;
           for i:=moski_col-1 to moski_col+1 do
            for j:=moski_fil-1 to moski_fil+1 do
             if ((moski_fil<>j) or (moski_col<>i)) and (i > 0) and (i < 41) and (j > 0) and (j < 27) then
              begin
               if (m[j,i].carga<menor) and (m[j,i].estado=0) and (m[j,i].carga<3) then
                begin
                 aux_fil:=j;
                 aux_col:=i;
                 menor:=m[j,i].carga;
                end;
              end;
           if aux_fil<moski_fil then
            mosquito.top:=mosquito.top-3
           else
            if aux_fil>moski_fil then
             mosquito.top:=mosquito.top+3;
           if aux_col<moski_col then
            mosquito.left:=mosquito.left-3
           else
            if aux_col>moski_col then
             mosquito.left:=mosquito.left+3;
           ult_fil:=moski_fil;
           ult_col:=moski_col;
           energia.position:=energia.position-1;
        end;
end;

procedure TForm1.MoverTimer(Sender: TObject);
var i,j,fila,columna,suma,nx,ny:integer; p:posicion; sale:boolean;
begin
   val(Edit8.text,n,code);
   lim:=n;
   if energia.position>0 then
     begin
        //calcula la posicion del mosquito.
        for fila:=min to 26 do
         for columna:=min to max do
          begin
               if  (mosquito.top>m[fila,columna].t) and (mosquito.top<m[fila,columna].t+20) and (mosquito.left>m[fila,columna].l) and (mosquito.left<m[fila,columna].l+20) then
                begin
                     moski_fil:=fila;
                     moski_col:=columna;
                     mosquito_carga:=m[fila,columna].carga;
                     if energia.position<lim then
                      m[fila,columna].estado:=1;
                end;
              end;
         if  (energia.position>1196) then
         //Pone el de las celdas en 0.
          for fila:=min to 26 do
           for columna:=min to max do
             m[fila,columna].estado:=0;
         if (m[moski_fil,moski_col].carga=-11) and (energia.position<1196) then
         //Busca la fuente mas cercana.
          begin
           suma:=1900;
           p:=fuentes.inicio;
           while (p<>nulo) do
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
               end;
              p:=p.prox;
             end;
           if (energia.position<1196) and (mosquito.top>= mascerca.dato.top) and (mosquito.top <= ((mascerca.dato.top)+(mascerca.dato.height)-5)) and (mosquito.left>= mascerca.dato.left) and (mosquito.left <= ((mascerca.dato.left)+(mascerca.dato.width)-5)) then
           //Si el agente esta encima de la fuente, sube el nivel de la energía.
             begin
              energia.Position:=energia.Position+6;
              PlaySound (nil, 0, 0);
              image1.Visible:=false;
              if energia.Position>1196 then
                PlaySound ('20',0, snd_Async);
             end
           else
            begin
            //Acerca el agente, hasta posicionarlo justo encima de la fuente.
            if (mascerca.dato.top+(mascerca.dato.height/2))<mosquito.top then
             mosquito.top:=mosquito.top-4
            else
             if (mascerca.dato.top+(mascerca.dato.height/2))>mosquito.top then
              mosquito.top:=mosquito.top+4;
            if ((mascerca.dato.left+(mascerca.dato.width/2))<mosquito.left) then
             mosquito.left:=mosquito.left-4
            else
             if ((mascerca.dato.left+(mascerca.dato.width/2))>mosquito.left) then
              mosquito.left:=mosquito.left+4;
            end;
          end
         else
          if (energia.position>lim) then
           vagabundear(energia,mosquito)
          else
           begin
             {Si el agente alcanza a detectar las cargas de alguna fuente
              que lo atraen, se llama al procedimiento "picar".}

             if mosquito_carga<0 then
              picar(energia,mosquito,edit2)
             else
              //Sino se llama a "Vagabundear"
              vagabundear(energia,mosquito);
             if energia.position<190 then
               begin
                     Image1.visible:=true;
                     Image1.top:= mosquito.Top - 35;
                     Image1.left:= mosquito.left - 9;
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
     label1.visible:=false;
     label2.visible:=false;
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
var p:tshape; b1:boolean; lm,f_arr,f_aba,c_izq,c_der,t,l,h,w,fila,columna:integer; distancia,menor:real;
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
         l:=n;
         val(edit2.text,n,code);
         Top := n;
         t:=n;
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
         l:=n;
         val(edit2.text,n,code);
         Top := n;
         t:=n;
         brush.Color:=clhighlight;
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
       {Se crea a la fuente o al obstaculo con un campo de potencial, a
        su alrededor.
        La carga aumenta a medida que se acerca a la fuente u objeto, y
        hacia los centros.}

       c_izq:=999;
       c_der:=0;
       f_arr:=999;
       f_aba:=0;
       for fila:=min to 26 do
        for columna:=min to max do
         begin
          if  (t+h>m[fila,columna].t) and (t<m[fila,columna].t+10) and (l+w>m[fila,columna].l) and (l<m[fila,columna].l+10) then
           begin
            if  fila<f_arr then
             f_arr:=fila;
            if  fila>f_aba then
             f_aba:=fila;
            if  columna<c_izq then
             c_izq:=columna;
            if  columna>c_der then
             c_der:=columna;
            if not(booleana) then
             begin
              m[fila,columna].carga:=-11;
              lm:=10;
             end
            else
             begin
              m[fila,columna].carga:=2;
              lm:=1;
             end;
           end;
         end;
         for n:=1 to lm do
           begin
             for columna:=c_izq-n to c_der+n do
              begin
               if (columna > 0) and (columna < 41) then
                begin
                 if (f_arr-n > 0) and (f_arr-n < 27) then
                  if (lm<>10) or (m[f_arr-n,columna].carga=0) then
                  begin
                   if lm=10 then
                    begin
                     if (columna<c_izq) then
                      distancia:=(c_izq-columna)/10
                     else
                       if (columna>c_der) then
                        distancia:=(columna-c_der)/10
                       else
                        distancia:=0;
                     m[f_arr-n,columna].carga:=n-11+distancia;
                    end
                   else
                    begin
                     m[f_arr-n,columna].carga:=2;
                    end;
                  end;
                 if (f_aba+n > 0) and (f_aba+n < 27) then
                 if (lm<>10) or (m[f_aba+n,columna].carga=0) then
                  begin
                   if lm=10 then
                    begin
                     if (columna<c_izq) then
                      distancia:=(c_izq-columna)/10
                     else
                       if (columna>c_der) then
                        distancia:=(columna-c_der)/10
                       else
                        distancia:=0;
                     m[f_aba+n,columna].carga:=n-11+distancia;
                    end
                   else
                    begin
                     m[f_aba+n,columna].carga:=2;
                    end;
                  end;
                end;
              end;
             for fila:=f_arr-n to f_aba+n do
              begin
               if (fila > 0) and (fila < 27) then
                begin
                 if (c_izq-n > 0) and  (c_izq-n < 41) then
                 if (lm<>10) or (m[fila,c_izq-n].carga=0)  then
                  begin
                   if lm=10 then
                    begin
                     if (fila<f_arr) then
                      distancia:=(f_arr-fila)/10
                     else
                       if (fila>f_aba) then
                        distancia:=(fila-f_aba)/10
                       else
                        distancia:=0;
                     m[fila,c_izq-n].carga:=n-11+distancia;
                    end
                   else
                    begin
                     m[fila,c_izq-n].carga:=2;
                    end;
                  end;
                 if (c_der+n > 0) and (c_der+n < 41) then
                 if (lm<>10) or (m[fila,c_der+n].carga=0)then
                  begin
                   if lm=10 then
                    begin
                     if (fila<f_arr) then
                      distancia:=(f_arr-fila)/10
                     else
                       if (fila>f_aba) then
                        distancia:=(fila-f_aba)/10
                       else
                        distancia:=0;
                     m[fila,c_der+n].carga:=n-11+distancia;
                    end
                   else
                    begin
                     m[fila,c_der+n].carga:=2;
                    end;
                  end;
                end;
              end;
         end;
    if b1 then
      mover.enabled:=true;

end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var  b1:boolean; p:tshape; f_arr,f_aba,c_izq,c_der,h,w,fila,columna,lm:integer; distancia:real;
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
       {Se crea a la fuente o al obstaculo con un campo de potencial, a
        su alrededor.
        La carga aumenta a medida que se acerca a la fuente u objeto, y
        hacia los centros.}

       c_izq:=999;
       c_der:=0;
       f_arr:=999;
       f_aba:=0;
       for fila:=min to 26 do
        for columna:=min to max do
         begin
          if  (y+h>m[fila,columna].t) and (y<m[fila,columna].t+10) and (x+w>m[fila,columna].l) and (x<m[fila,columna].l+10) then
           begin
            if  fila<f_arr then
             f_arr:=fila;
            if  fila>f_aba then
             f_aba:=fila;
            if  columna<c_izq then
             c_izq:=columna;
            if  columna>c_der then
             c_der:=columna;
            if not(booleana) then
             begin
              m[fila,columna].carga:=-11;
              lm:=10;
             end
            else
             begin
              m[fila,columna].carga:=2;
              lm:=1;
             end;
           end;
         end;
         for n:=1 to lm do
           begin
             for columna:=c_izq-n to c_der+n do
              begin
               if (columna > 0) and (columna < 41) then
                begin
                 if (f_arr-n > 0) and (f_arr-n < 27) then
                  if (lm<>10) or (m[f_arr-n,columna].carga=0) then
                  begin
                   if lm=10 then
                    begin
                     if (columna<c_izq) then
                      distancia:=(c_izq-columna)/10
                     else
                       if (columna>c_der) then
                        distancia:=(columna-c_der)/10
                       else
                        distancia:=0;
                     m[f_arr-n,columna].carga:=n-11+distancia;
                    end
                   else
                    begin
                     m[f_arr-n,columna].carga:=1;
                    end;
                  end;
                 if (f_aba+n > 0) and (f_aba+n < 27) then
                 if (lm<>10) or (m[f_aba+n,columna].carga=0) then
                  begin
                   if lm=10 then
                    begin
                     if (columna<c_izq) then
                      distancia:=(c_izq-columna)/10
                     else
                       if (columna>c_der) then
                        distancia:=(columna-c_der)/10
                       else
                        distancia:=0;
                     m[f_aba+n,columna].carga:=n-11+distancia;
                    end
                   else
                    begin
                     m[f_aba+n,columna].carga:=1;
                    end;
                  end;
                end;
              end;
             for fila:=f_arr-n to f_aba+n do
              begin
               if (fila > 0) and (fila < 27) then
                begin
                 if (c_izq-n > 0) and  (c_izq-n < 41) then
                 if (lm<>10) or ((m[fila,c_izq-n].carga<=0)and(m[fila,c_izq-n].carga>-11))  then
                  begin
                   if lm=10 then
                    begin
                     if (fila<f_arr) then
                      distancia:=(f_arr-fila)/10
                     else
                       if (fila>f_aba) then
                        distancia:=(fila-f_aba)/10
                       else
                        distancia:=0;
                     m[fila,c_izq-n].carga:=n-11+distancia;
                    end
                   else
                    begin
                     m[fila,c_izq-n].carga:=1;
                    end;
                  end;
                 if (c_der+n > 0) and (c_der+n < 41) then
                 if (lm<>10) or (m[fila,c_der+n].carga=0)then
                  begin
                   if lm=10 then
                    begin
                     if (fila<f_arr) then
                      distancia:=(f_arr-fila)/10
                     else
                       if (fila>f_aba) then
                        distancia:=(fila-f_aba)/10
                       else
                        distancia:=0;
                     m[fila,c_der+n].carga:=n-11+distancia;
                    end
                   else
                    begin
                     m[fila,c_der+n].carga:=1;
                    end;
                  end;
                end;
              end;
           end;
      if b1 then
       mover.enabled:=true;
     end;
end;

procedure TForm1.FormActivate(Sender: TObject);
var n,code,fila,columna,x,y:integer;
begin
     {Se inicializa el formulario poniendo la fecha, e inicializando las
      listas que almacenarán las fuentes y los obstáculos.
      Creando una matriz para usar el campo de potencial.}

     randomize;
     ult_tope:=mosquito.top;
     ult_left:=mosquito.left;
     crear_matriz_vacia(m);
     crear_lista_vacia(fuentes);
     crear_lista_vacia(objetos);
     Label2.color:=$0099CBE6;
     Label2.Caption :='Hoy es: '+DateToStr(Date);
     y:=-20;
     val(edit8.text,n,code);
     lim:=n;
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
           end;
       end;
     //Se carga con carga repulsiva a los extremos.
     columna:=1;
     for fila:=1 to 26 do
      begin
       m[fila,columna].carga:=2;
       m[fila,columna+39].carga:=2;
      end;
     fila:=1;
     for columna:=1 to 40 do
      begin
       m[fila,columna].carga:=2;
       m[fila+25,columna].carga:=2;
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
             i1.visible:=true;
             i1.refresh;
             sleep(150);
             i2.visible:=true;
             i2.refresh;
             sleep(150);
             i3.visible:=true;
             i3.refresh;
             sleep(150);
             i4.visible:=true;
             i4.refresh;
             sleep(150);
             i5.visible:=true;
             i5.refresh;
             sleep(150);
             i6.visible:=true;
             i6.refresh;
             sleep(150);
             i7.visible:=true;
             i7.refresh;
             sleep(150);
             i8.visible:=true;
             i8.refresh;
             sleep(150);
             i9.visible:=true;
             i9.refresh;
             sleep(150);
             i10.visible:=true;
             i10.refresh;
             sleep(150);
             i12.visible:=true;
             i12.refresh;
             sleep(150);
             i13.visible:=true;
             i13.refresh;
             sleep(150);
             i14.visible:=true;
             i14.refresh;
             sleep(150);
             i15.visible:=true;
             i15.refresh;
             sleep(150);
             i16.visible:=true;
             i16.refresh;
             sleep(150);
             i18.visible:=true;
             i18.refresh;
             sleep(150);
             i19.visible:=true;
             i19.refresh;
             sleep(150);
             i20.visible:=true;
             i20.refresh;
             sleep(150);
             i21.visible:=true;
             i21.refresh;
             sleep(150);
             i22.visible:=true;
             i22.refresh;
             sleep(150);
             i23.visible:=true;
             i23.refresh;
             sleep(150);
             i24.visible:=true;
             i24.refresh;
             sleep(150);
             i25.visible:=true;
             Image1.visible:=false;
             mosquito.visible:=false;
             muerte.enabled:=false;
             mover.enabled:=false;
             PlaySound ('FOGBLAST',0, snd_Async);
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
       end
     else
      m:=false;
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
begin
     {Comienza el movimiento del mosquito limpiando la pantalla.}

     Image1.visible:=false;
     mosquito.BringToFront;
     mosquito.brush.color:=clblack;
     label2.visible:=true;
     form1.color:=$0099CBE6;
     i1.visible:=false;
     i2.visible:=false;
     i3.visible:=false;
     i4.visible:=false;
     i5.visible:=false;
     i6.visible:=false;
     i7.visible:=false;
     i8.visible:=false;
     i9.visible:=false;
     i10.visible:=false;
     i12.visible:=false;
     i13.visible:=false;
     i14.visible:=false;
     i15.visible:=false;
     i16.visible:=false;
     i18.visible:=false;
     i19.visible:=false;
     i20.visible:=false;
     i21.visible:=false;
     i22.visible:=false;
     i23.visible:=false;
     i24.visible:=false;
     i25.visible:=false;
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
     energia.SendToBack;

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
         begin
          mover.enabled:=true;
          PlaySound ('20',0, snd_Async);
         end;
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
     'Tema "El Mosquito"'#13+ 'Version 4.0'#13 + ''#13 + 'Autor: Martin Pielvitori'#13 +
     'Legajo: 69184',
     mtInformation, [mbOK], 0);
    if (m) then
     begin
      mover.Enabled:=true;
      PlaySound ('20',0, snd_Async);
     end;
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

procedure TForm1.N1001Click(Sender: TObject);
begin
     mover.Interval:=15;
end;

end.



