unit UVen00;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.Mask;

type
  TFVen00 = class(TForm)
    Panel1: TPanel;
    PanBot: TPanel;
    BtNov: TBitBtn;
    BtAlt: TBitBtn;
    BtVis: TBitBtn;
    BtExit: TBitBtn;
    BtFirst: TBitBtn;
    BtPrior: TBitBtn;
    BtNext: TBitBtn;
    BtLast: TBitBtn;
    PanGrid: TPanel;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    PanInfo: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    mFilPes: TComboBox;
    BitBtn2: TBitBtn;
    mDadPes: TMaskEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure BtExitClick(Sender: TObject);
    procedure BtFirstClick(Sender: TObject);
    procedure BtPriorClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
    procedure BtLastClick(Sender: TObject);
    procedure BtNovClick(Sender: TObject);
    procedure BtAltClick(Sender: TObject);
    procedure BtVisClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mFilPesExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure AbreForm(Op : Integer);
  public
    { Public declarations }
  end;

var
  FVen00: TFVen00;

implementation

{$R *.dfm}

uses UDmCad, UVen01, UMain;

procedure TFVen00.BtAltClick(Sender: TObject);
begin
  if DmCad.TbVenda.isEmpty then begin
    MessageDlg('Nenhuma venda encontrada.', mtInformation, [mbOk], 0);
    Exit;
  end;

  AbreForm(2);
end;

procedure TFVen00.BtExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFVen00.BtFirstClick(Sender: TObject);
begin
  if DmCad.TbVenda.isEmpty then begin
    MessageDlg('Nenhuma venda encontrada.', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbVenda.First;
end;

procedure TFVen00.BtLastClick(Sender: TObject);
begin
    if DmCad.TbVenda.isEmpty then begin
    MessageDlg('Nenhuma venda encontrada.', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbVenda.Last;
end;

procedure TFVen00.BtNextClick(Sender: TObject);
begin
    if DmCad.TbVenda.isEmpty then begin
    MessageDlg('Nenhuma venda encontrada.', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbVenda.Next;
end;

procedure TFVen00.BtNovClick(Sender: TObject);
begin
  AbreForm(1);
end;

procedure TFVen00.BtPriorClick(Sender: TObject);
begin
  if DmCad.TbVenda.isEmpty then begin
    MessageDlg('Nenhuma venda encontrada.', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbVenda.Prior;
end;

procedure TFVen00.BtVisClick(Sender: TObject);
begin
  if DmCad.TbVenda.isEmpty then begin
    MessageDlg('Nenhuma venda encontrada.', mtInformation, [mbOk], 0);
    Exit;
  end;

  AbreForm(4);
end;

procedure TFVen00.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then begin
    DBGrid1.Canvas.Brush.Color := $00FF472D;
    DBGrid1.Canvas.Font.Color := clHighlightText;
  end
  else begin
    if DmCad.TbVenda.RecNo mod 2 = 1 then
      DBGrid1.Canvas.Brush.Color := $00D1D1D1
    else
      DBGrid1.Canvas.Brush.Color := clWhite;

  end;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFVen00.FormShow(Sender: TObject);
begin
  mDadPes.SetFocus;
end;

procedure TFVen00.mFilPesExit(Sender: TObject);
begin
  if mFilPes.ItemIndex = 1 then begin
    mDadPes.Clear;
    mDadPes.EditMask :='00/00/0000';
  end
  else begin
    mDadPes.Clear;
    mDadPes.EditMask := '';
  end;
  mDadPes.SetFocus;
end;

procedure TFVen00.AbreForm(Op: Integer);
begin

  FVen01 := TFVen01.Create(Op, self);
  try
    //FVen01.Op := Op;
    FVen01.ShowModal;
  finally
    FVen01.Release;
  end;
end;

procedure TFVen00.BitBtn2Click(Sender: TObject);
begin
  Dmcad.TbVenda.Close;
  Dmcad.TbVenda.SQL.Clear;
  Dmcad.TbVenda.SQL.Add('Select * From TbVenda where 1 = 1');

  case mFilPes.ItemIndex of
    0:
    begin
      if mDadPes.Text <> '' then  begin
        Dmcad.TbVenda.SQL.Add(' And NumPed = :pNumPed');
        Dmcad.TbVenda.ParamByName('pNumPed').AsInteger := StrToInt(mDadPes.Text);
      end;
    end;
    1:
    begin
      if mDadPes.Text <> '' then  begin
        Dmcad.TbVenda.SQL.Add(' AND DatPed = :pDatPro');
        Dmcad.TbVenda.ParamByName('pDatPro').AsDateTime := StrToDate(mDadPes.Text);
      end;
    end;
  end;

  DmCad.TbVenda.SQL.Add('Order By NumPed Desc');

  Dmcad.TbVenda.Open;

  if Dmcad.TbVenda.RecordCount = 0 then begin
    MessageDlg('Nenhuma venda encontrada. Verifique os filtros e tente novamente.', mtInformation, [mbOk], 0);
    Exit;
  end;
end;

end.
