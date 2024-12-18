unit UProd00;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Mask;

type
  TFProd00 = class(TForm)
    PanBack: TPanel;
    PanInfo: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    mFilPes: TComboBox;
    BitBtn2: TBitBtn;
    PanGrid: TPanel;
    DBGrid1: TDBGrid;
    PanBot: TPanel;
    BtNov: TBitBtn;
    BtAlt: TBitBtn;
    BtExc: TBitBtn;
    BtVis: TBitBtn;
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BtFirst: TBitBtn;
    BtPrior: TBitBtn;
    BtNext: TBitBtn;
    BtLast: TBitBtn;
    mStatus: TRadioGroup;
    PanLegend: TPanel;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label5: TLabel;
    Panel4: TPanel;
    Label6: TLabel;
    BitBtn5: TBitBtn;
    TbAux: TFDQuery;
    Panel5: TPanel;
    Label7: TLabel;
    TbAux2: TFDQuery;
    TbAux3: TFDQuery;
    mDadPes: TMaskEdit;
    procedure BtNovClick(Sender: TObject);
    procedure BtAltClick(Sender: TObject);
    procedure BtExcClick(Sender: TObject);
    procedure BtVisClick(Sender: TObject);
    procedure BtFirstClick(Sender: TObject);
    procedure BtPriorClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
    procedure BtLastClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mFilPesExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure AbreForm(Op  : Integer);
  public
    { Public declarations }
  end;

var
  FProd00: TFProd00;

implementation

{$R *.dfm}

uses UProd01, UDmCad, UMain;

procedure TFProd00.AbreForm(Op: Integer);
begin
  FProd01 := TFProd01.Create(Op, self);
  try
    FProd01.ShowModal;
  finally
    FProd01.Release;
  end;
end;

procedure TFProd00.BitBtn1Click(Sender: TObject);
begin
  if (DmCad.TbProducaoSTATUS.AsString = 'AG')  then begin
    MessageDlg('Lote n�o iniciado na produ��o!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'AR')  then begin
    MessageDlg('Lote aguardando revis�o!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'FI')  then begin
    MessageDlg('Lote j� finalizado!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'CA')  then begin
    MessageDlg('Lote Cancelado!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja Finalizar a Produ��o?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Update TbProducao Set STATUS = ''AR'' Where NumLote = :pNumLote');
  TbAux.ParamByName('pNumLote').AsInteger := DmCad.TbProducaoNUMLOTE.AsInteger;
  TbAux.ExecSQL;

  MessageDlg('Produ��o finalizada com sucesso!', mtInformation, [mbOk], 0);

  DmCad.TbProducao.Refresh;
end;

procedure TFProd00.BitBtn2Click(Sender: TObject);
begin
  Dmcad.TbProducao.Close;
  Dmcad.TbProducao.SQL.Clear;
  Dmcad.TbProducao.SQL.Add('Select * From TbProducao where 1 = 1');

  case mFilPes.ItemIndex of
    0:
    begin
      if mDadPes.Text <> '' then  begin
        Dmcad.TbProducao.SQL.Add(' And NumLote = :pNumLote');
        Dmcad.TbProducao.ParamByName('pNumLote').AsInteger := StrToInt(mDadPes.Text);
      end;
    end;
    1:
    begin
      if mDadPes.Text <> '' then  begin
        Dmcad.TbProducao.SQL.Add(' AND DESCRICAO LIKE :pDesPro');
        Dmcad.TbProducao.ParamByName('pDesPro').AsString := '%' + UpperCase(mDadPes.Text) + '%';
      end;
    end;
    2:
    begin
      if mDadPes.Text <> '' then  begin
        Dmcad.TbProducao.SQL.Add(' AND DataLote = :pDataLote');
        Dmcad.TbProducao.ParamByName('pDataLote').AsDateTime := StrToDate(mDadPes.Text);
      end;
    end;
  end;

  case mStatus.ItemIndex of
    0: DmCad.TbProducao.SQL.Add(' AND Status = ''AG''');
    1: DmCad.TbProducao.SQL.Add(' AND Status = ''EP''');
    2: DmCad.TbProducao.SQL.Add(' AND Status = ''AR''');
    3: DmCad.TbProducao.SQL.Add(' AND Status = ''FI''');
    5: DmCad.TbProducao.SQL.Add('AND Status = ''CA''');
  end;

  DmCad.TbProducao.SQL.Add('Order By NumLote Desc');

  Dmcad.TbProducao.Open;

  if Dmcad.TbProducao.RecordCount = 0 then begin
    MessageDlg('Nenhum lote de produ��o encontrado. Verifique os filtros e tente novamente.', mtInformation, [mbOk], 0);
    Exit;
  end;

end;

procedure TFProd00.BitBtn3Click(Sender: TObject);
Var
  QtdEmEstoque : Double;
  QtdVariacao : Double;
begin
  QtdEmEstoque := 0;

  if (DmCad.TbProducaoSTATUS.AsString = 'EP')  then begin
    MessageDlg('Lote em produ��o. Finalize a produ��o para marca-lo como revisado.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'AG')  then begin
    MessageDlg('Lote n�o iniciado na produ��o. Inicie o lote para poder alterar seu status.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'FI')  then begin
    MessageDlg('Lote j� finalizado. N�o � poss�vel revis�-lo novamente.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'CA')  then begin
    MessageDlg('Lote Cancelado!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja marcar como revisado e inserir os produtos do lote em estoque?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  try
    ///////////////////////////////////////// Inserindo varia��es no estoque ////////////////////////////////////////////
    TbAux.Close;
    TbAux.SQL.Clear;
    TbAux.SQL.Add('Select * From TbItemProducao Where NumLote = :pNumLote');
    TbAux.ParamByName('pNumLote').AsInteger := DmCad.TbProducaoNUMLOTE.AsInteger;
    TbAux.Open;


    TbAux.First;

    while not TbAux.Eof do begin
      TbAux2.Close;
      TbAux2.SQL.Clear;
      TbAux2.SQL.Add('Select VarQtd From TbVarProduto Where IdPro = :pIdPro And NumLan = :pNumLan');
      TbAux2.ParamByName('pIdPro').AsInteger := TbAux.FieldByName('CodPro').AsInteger;
      TbAux2.ParamByName('pNumLan').AsInteger := TbAux.FieldByName('CodVariacao').AsInteger;
      TbAux2.Open;

      QtdEmEstoque := TbAux2.Fields[0].AsFloat;

      TbAux2.Close;
      TbAux2.SQL.Clear;
      TbAux2.SQL.Add('Update TbVarProduto Set VarQtd = :pQtd Where IdPro = :pIdPro And NumLan = :pNumLan');
      TbAux2.ParamByName('pQtd').AsFloat := QtdEmEstoque + TbAux.FieldByName('Quantidade').AsFloat;
      TbAux2.ParamByName('pIdPro').AsInteger := TbAux.FieldByName('CodPro').AsInteger;
      TbAux2.ParamByName('pNumLan').AsInteger := TbAux.FieldByName('CodVariacao').AsInteger;
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

    DmCad.TbPro.Refresh;

    MessageDlg('Os produtos foram atualizados com sucesso, e o lote em quest�o foi finalizado!', mtInformation, [mbOk], 0);
  except on E: Exception do
    begin
      MessageDlg('N�o foi poss�vel gravar o lote no banco de dados. Tente Novamente.'
      + #13 + E.Message, mtInformation, [mbOk], 0);
      Exit;
    end;
  end;


  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Update TbProducao Set STATUS = ''FI'' Where NumLote = :pNumLote');
  TbAux.ParamByName('pNumLote').AsInteger := DmCad.TbProducaoNUMLOTE.AsInteger;
  TbAux.ExecSQL;


  DmCad.TbProducao.Refresh;
end;

procedure TFProd00.BitBtn4Click(Sender: TObject);
begin
  if (DmCad.TbProducaoSTATUS.AsString = 'EP')  then begin
    MessageDlg('Lote j� em produ��o!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'AR')  then begin
    MessageDlg('Lote aguardando revis�o!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'FI')  then begin
    MessageDlg('Lote j� finalizado!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'CA')  then begin
    MessageDlg('Lote Cancelado!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja Iniciar a Produ��o?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Update TbProducao Set STATUS = ''EP'' Where NumLote = :pNumLote');
  TbAux.ParamByName('pNumLote').AsInteger := DmCad.TbProducaoNUMLOTE.AsInteger;
  TbAux.ExecSQL;

  MessageDlg('Lote iniciado com sucesso!', mtInformation, [mbOk], 0);

  DmCad.TbProducao.Refresh;
end;

procedure TFProd00.BitBtn5Click(Sender: TObject);
begin
  Close;
end;

procedure TFProd00.BtAltClick(Sender: TObject);
begin
  if DmCad.TbProducao.IsEmpty then begin
    MessageDlg('Nenhum lote de produ��o encontrado. Verifique!!!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'FI') then begin
    MessageDlg('Lote j� finalizado. N�o � poss�vel alter�-lo.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'CA') then begin
    MessageDlg('Lote cancelado. N�o � poss�vel alter�-lo.', mtInformation, [mbOk], 0);
    Exit;
  end;

  AbreForm(2);
end;

procedure TFProd00.BtExcClick(Sender: TObject);
begin
  if DmCad.TbProducao.IsEmpty then begin
    MessageDlg('Nenhum lote de produ��o encontrado. Verifique!!!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'FI')  then begin
    MessageDlg('Lote j� finalizado!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if (DmCad.TbProducaoSTATUS.AsString = 'CA')  then begin
    MessageDlg('Lote Cancelado!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja Realmente cancelar este lote de produ��o?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Update TbProducao Set STATUS = ''CA'' Where NumLote = :pNumLote');
  TbAux.ParamByName('pNumLote').AsInteger := DmCad.TbProducaoNUMLOTE.AsInteger;
  TbAux.ExecSQL;

  MessageDlg('Lote cancelado com sucesso!', mtInformation, [mbOk], 0);

  DmCad.TbProducao.Refresh;
end;

procedure TFProd00.BtFirstClick(Sender: TObject);
begin
  DmCad.TbProducao.First;
end;

procedure TFProd00.BtLastClick(Sender: TObject);
begin
  DmCad.TbProducao.Last;
end;

procedure TFProd00.BtNextClick(Sender: TObject);
begin
  DmCad.TbProducao.Next;
end;

procedure TFProd00.BtNovClick(Sender: TObject);
begin
  AbreForm(1);
end;

procedure TFProd00.BtPriorClick(Sender: TObject);
begin
  DmCad.TbProducao.Prior;
end;

procedure TFProd00.BtVisClick(Sender: TObject);
begin
  if DmCad.TbProducao.IsEmpty then begin
    MessageDlg('Nenhum lote de produ��o encontrado. Verifique!!!', mtInformation, [mbOk], 0);
    Exit;
  end;
  AbreForm(4);
end;

procedure TFProd00.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if DmCad.TbProducaoSTATUS.AsString = 'AI' then
  begin
    DBGrid1.Canvas.Brush.Color := $00FFF2E6;
  end;

  if DmCad.TbProducaoSTATUS.AsString = 'EP' then
  begin
    DBGrid1.Canvas.Brush.Color := $00FFBB7D;
  end;

  if DmCad.TbProducaoSTATUS.AsString = 'AR' then
  begin
    DBGrid1.Canvas.Brush.Color := $007DF5FF;
  end;

  if DmCad.TbProducaoSTATUS.AsString = 'FI' then
  begin
    DBGrid1.Canvas.Brush.Color := $007EFE82;
  end;

  if DmCad.TbProducaoSTATUS.AsString = 'CA' then begin
    DBGrid1.Canvas.Brush.Color := $007E7EFE;
  end;

   if gdSelected in State then
  begin
    DBGrid1.Canvas.Brush.Color := $00FF472D;
    DBGrid1.Canvas.Font.Color := clHighlightText;
  end;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;


procedure TFProd00.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Main.TbProducao.Refresh;
end;

procedure TFProd00.FormShow(Sender: TObject);
begin
  mDadPes.SetFocus;
end;

procedure TFProd00.mFilPesExit(Sender: TObject);
begin
  if mFilPes.ItemIndex = 2 then begin
    mDadPes.Clear;
    mDadPes.EditMask :='00/00/0000';
  end
  else begin
    mDadPes.Clear;
    mDadPes.EditMask := '';
  end;
  mDadPes.SetFocus;
end;

end.
