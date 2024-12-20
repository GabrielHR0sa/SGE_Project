unit UVen01;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.DBCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFVen01 = class(TForm)
    PanFundo: TPanel;
    PanVenda: TPanel;
    Panel12: TPanel;
    mDatPed: TDBEdit;
    PanIte: TPanel;
    BtNovIte: TBitBtn;
    BtAltIte: TBitBtn;
    BtExcIte: TBitBtn;
    BtGraIte: TBitBtn;
    BtCanIte: TBitBtn;
    BtFirstI: TBitBtn;
    BtPriorI: TBitBtn;
    BtNextI: TBitBtn;
    BtLastI: TBitBtn;
    Panel10: TPanel;
    BtNov: TBitBtn;
    BtAlt: TBitBtn;
    BtGra: TBitBtn;
    BtSai: TBitBtn;
    BtCan: TBitBtn;
    BtFirst: TBitBtn;
    BtPrior: TBitBtn;
    BtNext: TBitBtn;
    BtLast: TBitBtn;
    PanTot: TPanel;
    mQtdPed: TDBEdit;
    Label18: TLabel;
    Totbr: TLabel;
    mVlrPed: TDBEdit;
    mObsPed: TDBEdit;
    DatPed: TLabel;
    Label1: TLabel;
    PanNum: TPanel;
    mNumPed: TDBEdit;
    Label16: TLabel;
    PanGrid: TPanel;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    PanDadIte: TPanel;
    Label3: TLabel;
    mPro: TDBLookupComboBox;
    mVar: TDBLookupComboBox;
    Label2: TLabel;
    mQtd: TDBEdit;
    Label4: TLabel;
    DsVendaDmCad: TDataSource;
    TbAux: TFDQuery;
    Panel2: TPanel;
    DsItemVendaDmCad: TDataSource;
    Panel3: TPanel;
    Label5: TLabel;
    mVlr: TDBEdit;
    DsIteVen: TDataSource;
    TbPro: TFDQuery;
    TbProID: TIntegerField;
    TbProDESCRICAO: TStringField;
    DsPro: TDataSource;
    TbVarPro: TFDQuery;
    TbVarProNUMLAN: TIntegerField;
    TbVarProVARDES: TStringField;
    DsVarPro: TDataSource;
    TbAux2: TFDQuery;
    TbAux3: TFDQuery;
    procedure BtFirstIClick(Sender: TObject);
    procedure BtPriorIClick(Sender: TObject);
    procedure BtNextIClick(Sender: TObject);
    procedure BtLastIClick(Sender: TObject);
    procedure BtSaiClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtNovClick(Sender: TObject);
    procedure BtAltClick(Sender: TObject);
    procedure BtGraClick(Sender: TObject);
    procedure BtCanClick(Sender: TObject);
    procedure DsVendaDmCadStateChange(Sender: TObject);
    procedure DsItemVendaDmCadStateChange(Sender: TObject);
    procedure BtNovIteClick(Sender: TObject);
    procedure BtAltIteClick(Sender: TObject);
    procedure BtExcIteClick(Sender: TObject);
    procedure BtGraIteClick(Sender: TObject);
    procedure BtCanIteClick(Sender: TObject);
    procedure mProExit(Sender: TObject);
    procedure mQtdExit(Sender: TObject);
    procedure BtFirstClick(Sender: TObject);
    procedure BtPriorClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
    procedure BtLastClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DsIteVenDataChange(Sender: TObject; Field: TField);
    procedure mVarExit(Sender: TObject);
  private
    { Private declarations }
    procedure GerarNumPed;
    procedure GerarNumLan;
    procedure PreencheQtdEValor;
    procedure RetiraProdutosEstoque;
    function  CanSave : Boolean;
    function  CanSaveIte : Boolean;
  public
    { Public declarations }
    FOpcao : Integer;
    constructor Create(op: Integer; Aowner : TComponent);
  end;

var
  FVen01: TFVen01;

implementation

{$R *.dfm}

uses UDmCad, UMain;

procedure TFVen01.BtAltClick(Sender: TObject);
begin
  if  DmCad.TbVenda.isEmpty then begin
    MessageDlg('Nenhuma venda encontrada. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if Main.BancoDados.InTransaction then
    Main.BancoDados.RollBack;

  Main.BancoDados.StartTransaction;

  DmCad.TbVenda.Edit;
end;

procedure TFVen01.BtAltIteClick(Sender: TObject);
begin
  if DmCad.TbItemVenda.isEmpty then begin
    MessageDlg('Nenhum item encontrado.', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbItemVenda.Edit;
end;

procedure TFVen01.BtCanClick(Sender: TObject);
begin
  if DmCad.TbItemVenda.State in DsEditModes then begin
    MessageDlg('H� itens em edi��o, finalize a opera��o antes de cancelar.', mtInformation, [mbOk], 0);
    Exit;
  end;

  Main.BancoDados.RollBack;
  DmCad.TbVenda.Cancel;
  DmCad.TbVenda.CancelUpdates;
  DmCad.TbItemVenda.Cancel;
  DmCad.TbItemVenda.CancelUpdates;
end;

procedure TFVen01.BtCanIteClick(Sender: TObject);
begin
  DmCad.TbItemVenda.Cancel;
end;

procedure TFVen01.BtExcIteClick(Sender: TObject);
begin
  if DmCad.TbItemVenda.isEmpty then begin
    MessageDlg('Nenhum item encontrado.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir este item?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  DmCad.TbItemVenda.Delete;

  PreencheQtdEValor;

  DmCad.TbItemVenda.ApplyUpdates;
  DmCad.TbItemVenda.CommitUpdates;
end;

procedure TFVen01.BtFirstClick(Sender: TObject);
begin
  DmCad.TbVenda.First;
end;

procedure TFVen01.BtFirstIClick(Sender: TObject);
begin
  if DmCad.TbItemVenda.IsEmpty then Exit;

  DmCad.TbItemVenda.First;
end;

procedure TFVen01.BtGraClick(Sender: TObject);
begin
  if not CanSave then begin
    MessageDlg('Falta preenchimento de campos obrigat�rios. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbVendaQUANTIDADE.AsFloat = 0) or (DmCad.TbVendaTOTBRU.AsFloat = 0) then begin
    MessageDlg('Insira pelo menos um item no pedido antes de grav�-lo.', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbVenda.ApplyUpdates;
  DmCad.TbVenda.CommitUpdates;

  RetiraProdutosEstoque;

  end;

procedure TFVen01.BtGraIteClick(Sender: TObject);
begin
  if not CanSaveIte then  begin
    MessageDlg('Falta preenchimento de campos obrigat�rios. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  PreencheQtdEValor;

  DmCad.TbItemVenda.ApplyUpdates;
  DmCad.TbItemVenda.CommitUpdates;
end;

procedure TFVen01.BtLastClick(Sender: TObject);
begin
  DmCad.TbVenda.Last;
end;

procedure TFVen01.BtLastIClick(Sender: TObject);
begin
  if DmCad.TbItemVenda.IsEmpty then Exit;

  DmCad.TbItemVenda.Last;
end;

procedure TFVen01.BtNextClick(Sender: TObject);
begin
  DmCad.TbVenda.Next;
end;

procedure TFVen01.BtNextIClick(Sender: TObject);
begin
  if DmCad.TbItemVenda.IsEmpty then Exit;

  DmCad.TbItemVenda.Next;
end;

procedure TFVen01.BtNovClick(Sender: TObject);
begin
  if Main.BancoDados.InTransaction then
    Main.BancoDados.RollBack;

  Main.BancoDados.StartTransaction;

  DmCad.TbVenda.Append;
  GerarNumPed;
  mDatPed.SetFocus;
end;

procedure TFVen01.BtNovIteClick(Sender: TObject);
begin
  DmCad.TbItemVenda.Append;
  GerarNumLan;
  mPro.SetFocus;
end;

procedure TFVen01.BtPriorClick(Sender: TObject);
begin
  DmCad.TbVenda.Prior;
end;

procedure TFVen01.BtPriorIClick(Sender: TObject);
begin
  if DmCad.TbItemVenda.IsEmpty then Exit;

  DmCad.TbItemVenda.Prior;
end;

procedure TFVen01.BtSaiClick(Sender: TObject);
begin
  Close;
end;

function TFVen01.CanSave: Boolean;
begin
  Result := False;

  Result := mDatPed.Text <> '';
end;

function TFVen01.CanSaveIte: Boolean;
begin
  Result := False;

  Result := mPro.Text <> '';
  Result := (mVar.Text <> '') and Result;
  Result := (mQtd.Text <> '') and Result;
  Result := (mVlr.Text <> '') and Result;
end;

constructor TFVen01.Create(op: Integer; Aowner: TComponent);
begin
  inherited Create(Aowner);
  FOpcao := op;
end;

procedure TFVen01.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then begin
    DBGrid1.Canvas.Brush.Color := $00FF472D;
    DBGrid1.Canvas.Font.Color := clHighlightText;
  end
  else begin
    if DmCad.TbItemVenda.RecNo mod 2 = 1 then
      DBGrid1.Canvas.Brush.Color := $00D1D1D1
    else
      DBGrid1.Canvas.Brush.Color := clWhite;

  end;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFVen01.DsItemVendaDmCadStateChange(Sender: TObject);
begin
  case DmCad.TbItemVenda.State of
    dsInsert:
    begin
      PanGrid.Enabled := False;
      PanDadIte.Enabled := True;
      BtNovIte.Enabled := False;
      BtAltIte.Enabled := False;
      BtExcIte.Enabled := False;
      BtGraIte.Enabled := True;
      BtCanIte.Enabled := True;
      BtFirstI.Enabled := False;
      BtPriorI.Enabled := False;
      BtNextI.Enabled := False;
      BtLastI.Enabled := False;

    end;
    dsEdit:
    begin
      PanGrid.Enabled := False;
      PanDadIte.Enabled := True;
      BtNovIte.Enabled := False;
      BtAltIte.Enabled := False;
      BtExcIte.Enabled := False;
      BtGraIte.Enabled := True;
      BtCanIte.Enabled := True;
      BtFirstI.Enabled := False;
      BtPriorI.Enabled := False;
      BtNextI.Enabled := False;
      BtLastI.Enabled := False;
    end;
    dsBrowse:
    begin
      PanGrid.Enabled := True;
      PanDadIte.Enabled := False;
      BtNovIte.Enabled := True;
      BtAltIte.Enabled := True;
      BtExcIte.Enabled := True;
      BtGraIte.Enabled := False;
      BtCanIte.Enabled := False;
      BtFirstI.Enabled := True;
      BtPriorI.Enabled := True;
      BtNextI.Enabled := True;
      BtLastI.Enabled := True;
    end;
  end;
end;

procedure TFVen01.DsIteVenDataChange(Sender: TObject; Field: TField);
begin
  TbVarPro.Close;
  TbVarPro.Connection := Main.BancoDados;
  TbVarPro.Open();
end;

procedure TFVen01.DsVendaDmCadStateChange(Sender: TObject);
begin
  case DmCad.TbVenda.State of
    dsInsert:
    begin
      PanVenda.Enabled := True;
      PanIte.Enabled := True;
      PanTot.Enabled := False;
      BtNov.Enabled := False;
      BtAlt.Enabled := False;
      BtGra.Enabled := True;
      BtCan.Enabled := True;
      BtSai.Enabled := False;
      BtFirst.Enabled := False;
      BtPrior.Enabled := False;
      BtNext.Enabled := False;
      BtLast.Enabled := False;
    end;
    dsEdit:
    begin
      PanVenda.Enabled := True;
      PanIte.Enabled := True;
      PanTot.Enabled := False;
      BtNov.Enabled := False;
      BtAlt.Enabled := False;
      BtGra.Enabled := True;
      BtCan.Enabled := True;
      BtSai.Enabled := False;
      BtFirst.Enabled := False;
      BtPrior.Enabled := False;
      BtNext.Enabled := False;
      BtLast.Enabled := False;
    end;
    dsBrowse:
    begin
      PanVenda.Enabled := False;
      PanIte.Enabled := False;
      PanTot.Enabled := False;
      BtNov.Enabled := True;
      BtAlt.Enabled := True;
      BtGra.Enabled := False;
      BtCan.Enabled := False;
      BtSai.Enabled := True;
      BtFirst.Enabled := True;
      BtPrior.Enabled := True;
      BtNext.Enabled := True;
      BtLast.Enabled := True;
    end;
  end;
end;

procedure TFVen01.FormCreate(Sender: TObject);
begin
  Self.Width  := PanFundo.Width  + 6;
  Self.Height := PanFundo.Height + 37;
end;

procedure TFVen01.FormShow(Sender: TObject);
begin
  TbPro.Open();
  TbVarPro.Open();

  if not DmCad.TbVenda.Active then DmCad.TbVenda.Open;
  if not DmCad.TbItemVenda.Active then DmCad.TbItemVenda.Open;

  case FOpcao of
    1: BtNov.Click;
    2: BtAlt.Click;
  end;
end;

procedure TFVen01.GerarNumLan;
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select MAX(NUMLAN) From TbItemVenda where NumPed = :pNumPed');
  TbAux.ParamByName('pNumPed').AsInteger := DmCad.TbVendaNUMPED.AsInteger;
  TbAux.Open;

  try
    DmCad.TbItemVendaNUMLAN.AsInteger := TbAux.Fields[0].AsInteger + 1;
  except
    DmCad.TbItemVendaNUMLAN.AsInteger := 1;
  end;
end;

procedure TFVen01.GerarNumPed;
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select MAX(NUMPED) From TbVenda');
  TbAux.Open;

  try
    DmCad.TbVendaNUMPED.AsInteger := TbAux.Fields[0].AsInteger + 1;
  except
    DmCad.TbVendaNUMPED.AsInteger := 1;
  end;

end;

procedure TFVen01.mProExit(Sender: TObject);
begin
  if BtCanIte.Focused or BtCan.Focused or Self.Focused then Exit;

  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select PreVenda From TbProduto Where ID = :pCodPro');
  TbAux.ParamByName('pCodPro').AsInteger := mPro.KeyValue;
  TbAux.Open;

  DmCad.TbItemVendaVLRBRU.AsFloat := TbAux.Fields[0].AsFloat;
  DmCad.TbItemVendaDESPRO.AsString := TbProDESCRICAO.AsString;

end;

procedure TFVen01.mQtdExit(Sender: TObject);
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select VarQtd From TbVarProduto Where IdPro = :pIdPro And NumLan = :pNumLan');
  TbAux.ParamByName('pIdPro').AsInteger := DmCad.TbItemVendaCODPRO.AsInteger;
  TbAux.ParamByName('pNumLan').AsInteger := DmCad.TbItemVendaCODVAR.AsInteger;
  TbAux.Open;

  if DmCad.TbItemVendaQUANTIDADE.AsFloat > TbAux.Fields[0].AsFloat then begin
    MessageDlg('Quantidade informada � maior do que a quantidade em estoque.', mtInformation, [mbOk], 0);
    mQtd.SetFocus;
    Exit;
  end;

  DmCad.TbItemVendaVLRBRU.AsFloat := (DmCad.TbItemVendaQUANTIDADE.AsFloat * DmCad.TbItemVendaVLRBRU.AsFloat);
end;

procedure TFVen01.mVarExit(Sender: TObject);
begin
  DmCad.TbItemVendaDESVAR.AsString := TbVarProVARDES.AsString;
end;

procedure TFVen01.PreencheQtdEValor;
begin
  DmCad.TbVendaQUANTIDADE.AsFloat := 0;
  DmCad.TbVendaTOTBRU.AsFloat := 0;

  DmCad.TbItemVenda.First;
  while not DmCad.TbItemVenda.Eof  do begin
    DmCad.TbVendaQUANTIDADE.AsFloat := DmCad.TbVendaQUANTIDADE.AsFloat + DmCad.TbItemVendaQUANTIDADE.AsFloat;
    DmCad.TbVendaTOTBRU.AsFloat := DmCad.TbVendaTOTBRU.AsFloat + DmCad.TbItemVendaVLRBRU.AsFloat;

    DmCad.TbItemVenda.Next;
  end;

end;

procedure TFVen01.RetiraProdutosEstoque;
Var
  QtdEmEstoque, QtdVariacao : Double;
begin
 try
    ///////////////////////////////////////// Inserindo varia��es no estoque ////////////////////////////////////////////
    TbAux.Close;
    TbAux.SQL.Clear;
    TbAux.SQL.Add('Select * From TbItemVenda Where NumPed = :pNumPed');
    TbAux.ParamByName('pNumPed').AsInteger := DmCad.TbVendaNUMPED.AsInteger;
    TbAux.Open;


    TbAux.First;

    while not TbAux.Eof do begin
      TbAux2.Close;
      TbAux2.SQL.Clear;
      TbAux2.SQL.Add('Select VarQtd From TbVarProduto Where IdPro = :pIdPro And NumLan = :pNumLan');
      TbAux2.ParamByName('pIdPro').AsInteger := TbAux.FieldByName('CodPro').AsInteger;
      TbAux2.ParamByName('pNumLan').AsInteger := TbAux.FieldByName('CodVar').AsInteger;
      TbAux2.Open;

      QtdEmEstoque := TbAux2.Fields[0].AsFloat;

      TbAux2.Close;
      TbAux2.SQL.Clear;
      TbAux2.SQL.Add('Update TbVarProduto Set VarQtd = :pQtd Where IdPro = :pIdPro And NumLan = :pNumLan');
      TbAux2.ParamByName('pQtd').AsFloat := QtdEmEstoque - TbAux.FieldByName('Quantidade').AsFloat;
      TbAux2.ParamByName('pIdPro').AsInteger := TbAux.FieldByName('CodPro').AsInteger;
      TbAux2.ParamByName('pNumLan').AsInteger := TbAux.FieldByName('CodVar').AsInteger;
      TbAux2.ExecSql;


      ///////////////////////////////////////// Atualizando saldo total produto ////////////////////////////////////////////
      TbAux3.Close;
      TbAux3.SQL.Clear;
      TbAux3.SQL.Add('Select Sum(VarQtd) From TbVarProduto Where IdPro = :IdPro');
      TbAux3.ParamByName('IdPro').AsInteger := TbAux.FieldByName('CodPro').AsInteger;
      TbAux3.Open;

      QtdVariacao := TbAux3.Fields[0].AsFloat;

      TbAux3.Close;
      TbAux3.SQL.Clear;
      TbAux3.SQL.Add('UPDATE TbProduto SET Quantidade = :QtdVariacao WHERE Id = :IdPro');
      TbAux3.ParamByName('QtdVariacao').AsFloat := QtdVariacao;
      TbAux3.ParamByName('IdPro').AsInteger := TbAux.FieldByName('CodPro').AsInteger;
      TbAux3.ExecSQL;


      TbAux.Next;
    end;

    if not DmCad.TbPro.Active then DmCad.TbPro.Open;
    if not DmCad.TbVarPro.Active then DmCad.TbVarPro.Open;

    DmCad.TbPro.Refresh;
    DmCad.TbVarPro.Refresh;

    Main.BancoDados.Commit;
    MessageDlg('Pedido de venda gerado com sucesso. Os itens do pedido tiveram suas quantidades retiradas do estoque!', mtInformation, [mbOk], 0);
    except on E: Exception do
    begin
      Main.BancoDados.RollBack;
      DmCad.TbVenda.Cancel;
      DmCad.TbVenda.CancelUpdates;
      DmCad.TbItemVenda.Cancel;
      DmCad.TbItemVenda.CancelUpdates;
      MessageDlg('N�o foi poss�vel gerar o pedido. Tente Novamente.'
      + #13 + E.Message, mtInformation, [mbOk], 0);
      Exit;
    end;
  end;
end;

end.
