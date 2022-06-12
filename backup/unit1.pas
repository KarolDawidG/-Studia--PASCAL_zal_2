// Autor: Glinkowski Dawid; nr indeksu 154837;  rok akademicki: 1; wydzial: informatyka; grupa: D1, semestr: I.
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  PElist= ^tlistEl;
  tlistEl=  record
  nastepny: PElist;
  dane: integer;
  end;

  slist= object
    public
      head: PElist; // początek listy
      constructor   init;
      procedure   losowa_lista;
      procedure   posortowana_lista;
      procedure   nowy_element (v: integer);
      procedure   usuwanie_z_poczatku;
      procedure   rozdzielenie (var l1, l2: slist);
      procedure   laczenie (var l1, l2: slist);
      procedure   sortuj_przez_scalanie();
  end;

  { TLosowanie }

  TLosowanie = class(TForm)
    INFO: TButton;
    KONIEC: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Losuj: TButton;
    Sortuj: TButton;
    ListBox_niePosortowany: TListBox;
    ListBox_Posortowany: TListBox;
    procedure INFOClick(Sender: TObject);
    procedure KONIECClick(Sender: TObject);
    procedure LosujClick(Sender: TObject);
    procedure SortujClick(Sender: TObject);

  private
  public
  end;

var
  Losowanie: TLosowanie;
  L: slist;
  i: integer;

implementation

{$R *.lfm}

{ TLosowanie }

procedure TLosowanie.LosujClick(Sender: TObject);
begin
  Randomize;
  ListBox_niePosortowany.clear;
  ListBox_Posortowany.clear;
  L.init;
  for i := 1 to 20 do                    // dodaje 20 razy losowa wartosc do listy
      L.nowy_element (random(999));
  L.losowa_lista;
end;

procedure TLosowanie.KONIECClick(Sender: TObject);
begin
      close;
end;

procedure TLosowanie.INFOClick(Sender: TObject);
begin
     Application.MessageBox('Autor: Glinkowski Dawid; nr indeksu 154837;  rok akademicki: 1; wydzial: informatyka; grupa: D1, semestr: I.','Informacje o autorze;',0);
end;

procedure TLosowanie.SortujClick(Sender: TObject);
begin
  ListBox_Posortowany.clear;
  L.sortuj_przez_scalanie;
   L.posortowana_lista;
  end;

constructor slist.init;
begin
  head := nil;
end;

procedure slist.losowa_lista;              // Procedura wyświetla zawartość elementów listy
var
  p: PElist;
  nr: integer;
begin
  nr:= 1;
  p:= head;
  while p <> nil do
  begin
    Losowanie.ListBox_niePosortowany.Items.Add(IntToStr(nr)+ '  :  ' +IntToStr(p^.dane));
    inc (nr);
    p := p^.nastepny;
  end;
end;

procedure slist.posortowana_lista;        // Procedura wyświetla zawartość elementów listy
var
  zmienna_posortowana: PElist;
  nr: integer;
begin
  nr:= 1;
  zmienna_posortowana:= head;
  while zmienna_posortowana <> nil do
  begin
    Losowanie.ListBox_Posortowany.Items.Add(IntToStr(nr)+ '  :  ' +IntToStr(zmienna_posortowana^.dane));
    inc (nr);
    zmienna_posortowana := zmienna_posortowana^.nastepny;
  end;
end;

procedure slist.nowy_element ( v : integer );           // Procedura dołączania na początek listy
var
  nowa : PElist;
begin
  new ( nowa );
  nowa^.nastepny := head;
  nowa^.dane := v;
  head    := nowa;
end;

procedure slist.usuwanie_z_poczatku;              // Procedura usuwa pierwszy element
var
  pp : PElist;
begin
  pp := head;
  if pp <> nil then
  begin
    head := pp^.nastepny;
    dispose ( pp );
  end;
end;

procedure slist.rozdzielenie ( var l1, l2 : slist );      // Dokonuje podziału listy
var
  p1, p2 : PElist;
  s : boolean;
begin
  s := false;
  l1.nowy_element ( 0 );
  l2.nowy_element ( 0 );
  p1 := l1.head;
  p2 := l2.head;
  while head <> nil do
  begin
    if s then
    begin
      p2^.nastepny := head;
      p2 := p2^.nastepny;
    end
    else
    begin
      p1^.nastepny := head;
      p1 := p1^.nastepny;
    end;
    head := head^.nastepny;
    s := not s;
  end;
  p1^.nastepny := nil;
  p2^.nastepny := nil;
  l1.usuwanie_z_poczatku( );
 l2.usuwanie_z_poczatku( );
end;

procedure slist.laczenie ( var l1, l2 : slist );     // Scala dwie obce listy
var
  element : PElist;
begin
  nowy_element ( 0 );
  element := head;
  while( l1.head <> nil ) and ( l2.head <> nil ) do
  begin
    if l1.head^.dane < l2.head^.dane then
    begin
      element^.nastepny := l2.head;
      l2.head := l2.head^.nastepny;
    end
    else
    begin
      element^.nastepny := l1.head;
      l1.head := l1.head^.nastepny;
    end;
    element := element^.nastepny;
  end;
  while l1.head <> nil do
  begin
    element^.nastepny := l1.head;
    l1.head := l1.head^.nastepny;
    element := element^.nastepny;
  end;
  while l2.head <> nil do
  begin
    element^.nastepny := l2.head;
    l2.head := l2.head^.nastepny;
    element := element^.nastepny;
  end;
  usuwanie_z_poczatku( );
end;

procedure slist.sortuj_przez_scalanie( );      // Sortuje listę przez scalanie
var
  h1, h2 : slist;
begin
  if( head <> nil ) and ( head^.nastepny <> nil ) then
  begin
    h2.init;
    h1.init;
    rozdzielenie ( h2, h1 );
    h2.sortuj_przez_scalanie;
    h1.sortuj_przez_scalanie;
    laczenie ( h2, h1 );
  end;
end;

end.
