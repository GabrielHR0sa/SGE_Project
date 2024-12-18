unit UPro000;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Mask, Vcl.DBCtrls;

type
  TFPro000 = class(TForm)
    PanFundo: TPanel;
    PanInfo: TPanel;
    PanBot: TPanel;
    PanGrid: TPanel;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    BtNov: TBitBtn;
    BtAlt: TBitBtn;
    BtExc: TBitBtn;
    BtVis: TBitBtn;
    BitBtn1: TBitBtn;
    BtFirst: TBitBtn;
    BtPrior: TBitBtn;
    BtNext: TBitBtn;
    BtLast: TBitBtn;
    Label1: TLabel;
    mFilPes: TComboBox;
    Label2: TLabel;
    BitBtn2: TBitBtn;
    mDadPes: TMaskEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure BtFirstClick(Sender: TObject);
    procedure BtPriorClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
    procedure BtLastClick(Sender: TObject);
    procedure BtNovClick(Sender: TObject);
    procedure BtAltClick(Sender: TObject);
    procedure BtExcClick(Sender: TObject);
    procedure BtVisClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mFilPesExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure AbreForm(Op  : Integer);
  public
    { Public declarations }
  end;

var
  FPro000: TFPro000;

implementation

{$R *.dfm}

uses UDmCad, UMain, UPro001;

procedure TFPro000.AbreForm(Op: Integer);
begin
  FPro001 := TFPro001.Create(Op, self);
  try
    //FPro001.Op := Op;
    FPro001.ShowModal;
  finally
    FPro001.Release;
  end;
end;

procedure TFPro000.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TFPro000.BitBtn2Click(Sender: TObject);
begin
  Dmcad.TbPro.Close;
  Dmcad.TbPro.SQL.Clear;
  Dmcad.TbPro.SQL.Add('Select * From TbProduto where 1 = 1');

  case mFilPes.ItemIndex of
    0:
    begin
      if mDadPes.Text <> '' then  begin
        Dmcad.TbPro.SQL.Add(' And ID = :pCodPro');
        Dmcad.TbPro.ParamByName('pCodPro').AsInteger := StrToInt(mDadPes.Text);
      end;
    end;
    1:
    begin
      if mDadPes.Text <> '' then  begin
        Dmcad.TbPro.SQL.Add(' AND DESCRICAO LIKE :pDesPro');
        Dmcad.TbPro.ParamByName('pDesPro').AsString := '%' + UpperCase(mDadPes.Text) + '%';
      end;
    end;
  end;

  DmCad.TbPro.SQL.Add('Order By ID');

  Dmcad.TbPro.Open;

  if Dmcad.TbPro.RecordCount = 0 then begin
    MessageDlg('Nenhum produto encontrado. Verifique os filtros e tente novamente.', mtInformation, [mbOk], 0);
    Exit;
  end;

end;

procedure TFPro000.BtAltClick(Sender: TObject);
begin
  if DmCad.TbPro.IsEmpty then begin
    MessageDlg('Nenhum produto encontrado. Verifique!!!', mtInformation, [mbOk], 0);
    Exit;
  end;

  AbreForm(2);
end;

procedure TFPro000.BtExcClick(Sender: TObject);
begin
  if DmCad.TbPro.IsEmpty then begin
    MessageDlg('Nenhum produto encontrado. Verifique!!!', mtInformation, [mbOk], 0);
    Exit;
  end;
  AbreForm(3);
end;

procedure TFPro000.BtFirstClick(Sender: TObject);
begin
  if Dmcad.TbPro.IsEmpty then Exit;

  Dmcad.TbPro.First;
end;

procedure TFPro000.BtLastClick(Sender: TObject);
begin
   if Dmcad.TbPro.IsEmpty then Exit;

   Dmcad.TbPro.Last;
end;

procedure TFPro000.BtNextClick(Sender: TObject);
begin
 if Dmcad.TbPro.IsEmpty then Exit;

 Dmcad.TbPro.Next;
end;

procedure TFPro000.BtNovClick(Sender: TObject);
begin
  AbreForm(1);
end;

procedure TFPro000.BtPriorClick(Sender: TObject);
begin
 if Dmcad.TbPro.IsEmpty then Exit;

  Dmcad.TbPro.Prior;
end;

procedure TFPro000.BtVisClick(Sender: TObject);
begin
  if DmCad.TbPro.IsEmpty then begin
    MessageDlg('Nenhum produto encontrado. Verifique!!!', mtInformation, [mbOk], 0);
    Exit;
  end;
  AbreForm(4);
end;

procedure TFPro000.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then begin
    DBGrid1.Canvas.Brush.Color := $00FF472D;
    DBGrid1.Canvas.Font.Color := clHighlightText;
  end
  else begin
    if DmCad.TbPro.RecNo mod 2 = 1 then
      DBGrid1.Canvas.Brush.Color := $00D1D1D1
    else
      DBGrid1.Canvas.Brush.Color := clWhite;

  end;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFPro000.FormCreate(Sender: TObject);
begin
  if (Main.UserID = 2) or (Main.UserID = 3) then begin
    BtNov.Enabled := False;
    BtAlt.Enabled := False;
    BtExc.Enabled := False;
  end;
end;

procedure TFPro000.FormShow(Sender: TObject);
begin
  mDadPes.SetFocus;
end;

procedure TFPro000.mFilPesExit(Sender: TObject);
begin
  mDadPes.SetFocus;
end;

end.
