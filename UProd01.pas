unit UProd01;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFProd01 = class(TForm)
    PanBack: TPanel;
    PanBot: TPanel;
    BtNov: TBitBtn;
    BtAlt: TBitBtn;
    BtFirst: TBitBtn;
    BtPrior: TBitBtn;
    BtNext: TBitBtn;
    BtLast: TBitBtn;
    BtGra: TBitBtn;
    BtCan: TBitBtn;
    BtSai: TBitBtn;
    PanDadCad: TPanel;
    Label9: TLabel;
    Panel4: TPanel;
    mDesPro: TDBEdit;
    Panel1: TPanel;
    Label1: TLabel;
    PanVarBot: TPanel;
    BtNovI: TBitBtn;
    BtAltI: TBitBtn;
    BtExcI: TBitBtn;
    BtGraI: TBitBtn;
    BtCanI: TBitBtn;
    BtFirstI: TBitBtn;
    BtPriorI: TBitBtn;
    BtNextI: TBitBtn;
    BtLastI: TBitBtn;
    PanProd: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Panel3: TPanel;
    mPro: TDBLookupComboBox;
    mQtd: TDBEdit;
    Label4: TLabel;
    PanGrid: TPanel;
    DBGrid1: TDBGrid;
    DsProducaoDmCad: TDataSource;
    TbAux: TFDQuery;
    DsItemProducaoDmCad: TDataSource;
    mDatLot: TDBEdit;
    mVar: TDBLookupComboBox;
    Panel2: TPanel;
    mIdPro: TDBEdit;
    Label5: TLabel;
    TbPro: TFDQuery;
    DsPro: TDataSource;
    TbVarPro: TFDQuery;
    DsVarPro: TDataSource;
    TbProID: TIntegerField;
    TbProDESCRICAO: TStringField;
    TbVarProNUMLAN: TIntegerField;
    TbVarProVARDES: TStringField;
    DsIteProdDmCad: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure BtFirstIClick(Sender: TObject);
    procedure BtPriorIClick(Sender: TObject);
    procedure BtNextIClick(Sender: TObject);
    procedure BtLastIClick(Sender: TObject);
    procedure BtFirstClick(Sender: TObject);
    procedure BtPriorClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
    procedure BtLastClick(Sender: TObject);
    procedure BtNovClick(Sender: TObject);
    procedure BtAltClick(Sender: TObject);
    procedure DsProducaoDmCadStateChange(Sender: TObject);
    procedure DsItemProducaoDmCadStateChange(Sender: TObject);
    procedure BtNovIClick(Sender: TObject);
    procedure BtAltIClick(Sender: TObject);
    procedure BtExcIClick(Sender: TObject);
    procedure BtGraIClick(Sender: TObject);
    procedure BtCanIClick(Sender: TObject);
    procedure BtSaiClick(Sender: TObject);
    procedure BtGraClick(Sender: TObject);
    procedure BtCanClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mDatLotExit(Sender: TObject);
    procedure DsIteProdDmCadDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure GerarSeqLanVariacao;
    procedure GerarNumLote;
    function CanSaveProd : Boolean;
    function CanSaveIte : Boolean;
  public
    { Public declarations }
    FOpcao : Integer;
    constructor Create(op: Integer; Aowner : TComponent);
  end;

var
  FProd01: TFProd01;

implementation

{$R *.dfm}

uses UDmCad, UMain;

{ TFProd01 }

procedure TFProd01.BtAltClick(Sender: TObject);
begin
   if (DmCad.TbProducaoSTATUS.AsString = 'FI') then begin
    MessageDlg('Lote j� finalizado. N�o � poss�vel alter�-lo.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'CA') then begin
    MessageDlg('Lote cancelado. N�o � poss�vel alter�-lo.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if DmCad.TbItemProducao.State in DsEditModes then begin
    MessageDlg('H� varia��es em edi��o, finalize a opera��o antes.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if Main.BancoDados.InTransaction then
    Main.BancoDados.RollBack;

  Main.BancoDados.StartTransaction;

  DmCad.TbProducao.Edit;
  mDesPro.SetFocus;
end;

procedure TFProd01.BtAltIClick(Sender: TObject);
begin
  if DmCad.TbItemProducao.IsEmpty then begin
    MessageDlg('Nenhum produto encontrado. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbItemProducao.Edit;
  mPro.SetFocus;
end;

procedure TFProd01.BtCanClick(Sender: TObject);
begin
  if DmCad.TbItemProducao.State in DsEditModes then begin
    MessageDlg('H� itens em edi��o, finalize a opera��o antes de cancelar.', mtInformation, [mbOk], 0);
    Exit;
  end;

  Main.BancoDados.RollBack;
  DmCad.TbProducao.Cancel;
  DmCad.TbProducao.CancelUpdates;
  DmCad.TbItemProducao.Cancel;
  DmCad.TbItemProducao.CancelUpdates;
end;

procedure TFProd01.BtCanIClick(Sender: TObject);
begin
  DmCad.TbItemProducao.Cancel;
end;

procedure TFProd01.BtExcIClick(Sender: TObject);
begin
  if DmCad.TbItemProducao.IsEmpty then begin
    MessageDlg('Nenhum produto encontrado. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir este produto do lote?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  try
    DmCad.TbItemProducao.Delete;
    DmCad.TbItemProducao.ApplyUpdates;
    DmCad.TbItemProducao.CommitUpdates;

    MessageDlg('Produto exclu�do com sucesso!', mtInformation, [mbOk], 0);
  except
    MessageDlg('N�o foi poss�vel exclu�r o produto.', mtInformation, [mbOk], 0);
  end;
end;

procedure TFProd01.BtFirstClick(Sender: TObject);
begin
  DmCad.TbProducao.First;
end;

procedure TFProd01.BtFirstIClick(Sender: TObject);
begin
  DmCad.TbItemProducao.First;
end;

procedure TFProd01.BtGraClick(Sender: TObject);
begin
  if not CanSaveProd then begin
    MessageDlg('Falta preenchimento de campos obrigat�rios. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbProducaoDATALOTE.AsDateTime := StrToDate(mDatLot.Text);
  if DmCad.TbProducaoSTATUS.AsString = '' then
    DmCad.TbProducaoSTATUS.AsString := 'AG';

  DmCad.TbProducao.ApplyUpdates;
  DmCad.TbProducao.CommitUpdates;

  Main.BancoDados.Commit;

  MessageDlg('Lote gravado com sucesso!', mtInformation, [mbOk], 0);
end;

procedure TFProd01.BtGraIClick(Sender: TObject);
begin
  if not CanSaveIte then begin
    MessageDlg('Falta preenchimento de campos obrigat�rios. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbItemProducao.ApplyUpdates;
  DmCad.TbItemProducao.CommitUpdates;
end;

procedure TFProd01.BtLastClick(Sender: TObject);
begin
  DmCad.TbProducao.Last;
end;

procedure TFProd01.BtLastIClick(Sender: TObject);
begin
  DmCad.TbItemProducao.Last;
end;

procedure TFProd01.BtNextClick(Sender: TObject);
begin
  DmCad.TbProducao.Next;
end;

procedure TFProd01.BtNextIClick(Sender: TObject);
begin
  DmCad.TbItemProducao.Next;
end;

procedure TFProd01.BtNovClick(Sender: TObject);
begin
  if DmCad.TbItemProducao.State in DsEditModes then begin
    MessageDlg('H� varia��es em edi��o, finalize a opera��o antes.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if Main.BancoDados.InTransaction then
    Main.BancoDados.RollBack;

  Main.BancoDados.StartTransaction;

  DmCad.TbProducao.Append;
  GerarNumLote;
  mDesPro.SetFocus;
end;

procedure TFProd01.BtNovIClick(Sender: TObject);
begin
  DmCad.TbItemProducao.Append;
  GerarSeqLanVariacao;
  mPro.SetFocus;
end;

procedure TFProd01.BtPriorClick(Sender: TObject);
begin
  DmCad.TbProducao.Prior;
end;

procedure TFProd01.BtPriorIClick(Sender: TObject);
begin
  DmCad.TbItemProducao.Prior;
end;

procedure TFProd01.BtSaiClick(Sender: TObject);
begin
  Close;
end;

function TFProd01.CanSaveIte: Boolean;
begin
  Result := False;

  Result := (mPro.Text <> '');
  Result := (mVar.Text <> '') and Result;
  Result := (mQtd.Text <> '') and Result;
end;

function TFProd01.CanSaveProd: Boolean;
begin
  Result := False;

  Result := (mDesPro.Text <> '');
  Result := (mDatLot.Text <> '') and Result;
end;

constructor TFProd01.Create(op: Integer; Aowner: TComponent);
begin
  inherited Create(Aowner);
  FOpcao := op;
end;

procedure TFProd01.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then begin
    DBGrid1.Canvas.Brush.Color := $00FF472D;
    DBGrid1.Canvas.Font.Color := clHighlightText;
  end
  else begin
    if DmCad.TbItemProducao.RecNo mod 2 = 1 then
      DBGrid1.Canvas.Brush.Color := $00D1D1D1
    else
      DBGrid1.Canvas.Brush.Color := clWhite;

  end;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFProd01.DsItemProducaoDmCadStateChange(Sender: TObject);
begin
   case DmCad.TbItemProducao.State of
    dsInsert:
    begin
      BtNovI.Enabled := False;
      BtAltI.Enabled := False;
      BtExcI.Enabled := False;
      BtCanI.Enabled := True;
      BtGraI.Enabled := True;
      BtFirstI.Enabled := False;
      BtPriorI.Enabled := False;
      BtNextI.Enabled := False;
      BtLastI.Enabled := False;
      PanGrid.Enabled := True;
      PanProd.Enabled := True;
      //PanVarBot.Enabled := True;
      //PanProd.Visible := True;
    end;
    dsEdit:
    begin
      BtNovI.Enabled := False;
      BtAltI.Enabled := False;
      BtExcI.Enabled := False;
      BtCanI.Enabled := True;
      BtGraI.Enabled := True;
      PanGrid.Enabled := True;
      BtFirstI.Enabled := False;
      BtPriorI.Enabled := False;
      BtNextI.Enabled := False;
      BtLastI.Enabled := False;
      PanProd.Enabled := True;
      //PanVarBot.Enabled := True;
      //PanProd.Visible := True;
    end;
    dsBrowse:
    begin
      BtNovI.Enabled := True;
      BtAltI.Enabled := True;
      BtExcI.Enabled := True;
      BtCanI.Enabled := False;
      BtGraI.Enabled := False;
      PanGrid.Enabled := True;
      BtFirstI.Enabled := True;
      BtPriorI.Enabled := True;
      BtNextI.Enabled := True;
      BtLastI.Enabled := True;
      PanProd.Enabled := False;
      //PanVarBot.Enabled := True;
      //PanProd.Visible := False;

    end;
  end;
end;

procedure TFProd01.DsIteProdDmCadDataChange(Sender: TObject; Field: TField);
begin
//  TbPro.Close;
//  TbPro.Open();
  TbVarPro.Close;
  TbVarPro.Connection := Main.BancoDados;
  TbVarPro.Open();
end;

procedure TFProd01.DsProducaoDmCadStateChange(Sender: TObject);
begin
  case DmCad.TbProducao.State of
    dsInsert:
    begin
      PanDadCad.Enabled := True;
      PanVarBot.Enabled := True;
      BtNov.Enabled := False;
      BtAlt.Enabled := False;
      BtCan.Enabled := True;
      BtGra.Enabled := True;
      BtFirst.Enabled := False;
      BtPrior.Enabled := False;
      BtNext.Enabled := False;
      BtLast.Enabled := False;
    end;
    dsEdit:
    begin
      PanDadCad.Enabled := True;
      PanVarBot.Enabled := True;
      BtNov.Enabled := False;
      BtAlt.Enabled := False;
      BtCan.Enabled := True;
      BtGra.Enabled := True;
      BtFirst.Enabled := False;
      BtPrior.Enabled := False;
      BtNext.Enabled := False;
      BtLast.Enabled := False;
    end;
    dsBrowse:
    begin
      PanDadCad.Enabled := False;
      PanVarBot.Enabled := False;
      BtNov.Enabled := True;
      BtAlt.Enabled := True;
      BtCan.Enabled := False;
      BtGra.Enabled := False;
      BtFirst.Enabled := True;
      BtPrior.Enabled := True;
      BtNext.Enabled := True;
      BtLast.Enabled := True;
    end;
  end;
end;

procedure TFProd01.FormCreate(Sender: TObject);
begin
  Self.Width  := PanBack.Width  + 6;
  Self.Height := PanBack.Height + 37;
end;

procedure TFProd01.FormShow(Sender: TObject);
begin
  TbPro.Open();
  TbVarPro.Open();

  if not DmCad.TbProducao.Active then DmCad.TbProducao.Open;
  if not DmCad.TbItemProducao.Active then DmCad.TbItemProducao.Open;

  case FOpcao of
    1: BtNov.Click;
    2: BtAlt.Click;
  end;
end;

procedure TFProd01.GerarNumLote;
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select MAX(NUMLOTE) From TbProducao');
  TbAux.Open;

  DmCad.TbProducaoNUMLOTE.AsInteger := TbAux.Fields[0].AsInteger + 1;
end;

procedure TFProd01.GerarSeqLanVariacao;
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select MAX(SEQLAN) From TbItemProducao Where NumLote = :NumLote');
  TbAux.ParamByName('NumLote').AsInteger := DmCad.TbProducaoNUMLOTE.AsInteger;
  TbAux.Open;

  DmCad.TbItemProducaoSEQLAN.AsInteger := TbAux.Fields[0].AsInteger + 1;
end;

procedure TFProd01.mDatLotExit(Sender: TObject);
begin
  if BtCan.Focused or BtSai.Focused or Self.Focused  then Exit;

  if mDatLot.Text = '' then Exit;

 try
  StrToDate(mDatLot.Text);
 except on E: Exception do
  begin
    MessageDlg('A Data informada est� incorreta ou n�o � uma data v�lida. Verifique!', mtInformation, [mbOk], 0);
    mDatLot.SetFocus;
  end;
 end;
end;

end.
