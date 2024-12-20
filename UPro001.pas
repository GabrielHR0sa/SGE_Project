unit UPro001;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, Vcl.DBCtrls, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids;

type
  TFPro001 = class(TForm)
    DsProDmCad: TDataSource;
    TbAux: TFDQuery;
    PanBack: TPanel;
    Pages: TPageControl;
    PagDadPro: TTabSheet;
    PanDadCad: TPanel;
    Label5: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    mIdPro: TDBEdit;
    Panel4: TPanel;
    mDesPro: TDBEdit;
    mPesPro: TDBEdit;
    mCodBarPro: TDBEdit;
    PanCus: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Panel7: TPanel;
    mPreCusPro: TDBEdit;
    mPreVenPro: TDBEdit;
    PanEst: TPanel;
    Label15: TLabel;
    Panel9: TPanel;
    mQtdPro: TDBEdit;
    VarPro: TTabSheet;
    PanVar: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Panel12: TPanel;
    mQtdVar: TDBEdit;
    mEanVar: TDBEdit;
    mDesVar: TDBEdit;
    mSkuVar: TDBEdit;
    mNumLanVar: TDBEdit;
    PanVarBot: TPanel;
    BtNovVar: TBitBtn;
    BtAltVar: TBitBtn;
    BtExcVar: TBitBtn;
    BtGraVar: TBitBtn;
    BtCanVar: TBitBtn;
    BtFirstV: TBitBtn;
    BtPriorV: TBitBtn;
    BtNextV: TBitBtn;
    BtLastV: TBitBtn;
    PanGrid: TPanel;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel10: TPanel;
    BtNov: TBitBtn;
    BtAlt: TBitBtn;
    BtExc: TBitBtn;
    BtGra: TBitBtn;
    BtSai: TBitBtn;
    BtCan: TBitBtn;
    BtFirst: TBitBtn;
    BtPrior: TBitBtn;
    BtNext: TBitBtn;
    BtLast: TBitBtn;
    DsVarProDmCad: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure DsProDmCadStateChange(Sender: TObject);
    procedure BtNovClick(Sender: TObject);
    procedure BtAltClick(Sender: TObject);
    procedure BtExcClick(Sender: TObject);
    procedure BtCanClick(Sender: TObject);
    procedure BtGraClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BtFirstClick(Sender: TObject);
    procedure BtPriorClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
    procedure BtLastClick(Sender: TObject);
    procedure DsVarProDmCadStateChange(Sender: TObject);
    procedure BtFirstVClick(Sender: TObject);
    procedure BtPriorVClick(Sender: TObject);
    procedure BtNextVClick(Sender: TObject);
    procedure BtLastVClick(Sender: TObject);
    procedure BtNovVarClick(Sender: TObject);
    procedure BtAltVarClick(Sender: TObject);
    procedure BtExcVarClick(Sender: TObject);
    procedure BtGraVarClick(Sender: TObject);
    procedure BtCanVarClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure GerarIDProduto;
    procedure GerarNumLanVariacao;
    procedure AdicionaSaldoProduto;
    procedure GerarCodBarProduto;
    function  CanSave : Boolean;
    function  CanSavePro : Boolean;
  public
    { Public declarations }
    FOpcao : Integer;
    constructor Create(op: Integer; Aowner : TComponent);
  end;

var
  FPro001: TFPro001;

implementation

{$R *.dfm}

uses UDmCad, UMain;

procedure TFPro001.AdicionaSaldoProduto;
Var
  QtdVariacao : Double;
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select Sum(VarQtd) From TbVarProduto Where IdPro = :IdPro');
  TbAux.ParamByName('IdPro').AsInteger := DmCad.TbProID.AsInteger;
  TbAux.Open;

  QtdVariacao := TbAux.Fields[0].AsFloat;

  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('UPDATE TbProduto SET Quantidade = :QtdVariacao WHERE Id = :IdPro');
  TbAux.ParamByName('QtdVariacao').AsFloat := QtdVariacao;
  TbAux.ParamByName('IdPro').AsInteger := DmCad.TbProID.AsInteger;
  TbAux.ExecSQL;

  DmCad.TbPro.Refresh;

end;

procedure TFPro001.BitBtn1Click(Sender: TObject);
begin
  if DmCad.TbPro.State in DsEditModes then
    DmCad.TbPro.Cancel;

  Close;
end;

procedure TFPro001.BtAltClick(Sender: TObject);
begin
  if DmCad.TbVarPro.State in DsEditModes then begin
    MessageDlg('H� varia��es em edi��o, finalize a opera��o antes.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if Pages.ActivePageIndex <> 0 then
  Pages.ActivePageIndex := 0;


  DmCad.TbPro.Edit;
  mDesPro.SetFocus;
end;

procedure TFPro001.BtAltVarClick(Sender: TObject);
begin
  if DmCad.TbVarPro.IsEmpty then begin
    MessageDlg('Nenhuma vari��o encontrada. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbVarPro.Edit;
  mDesVar.SetFocus;
end;

procedure TFPro001.BtCanClick(Sender: TObject);
begin
  DmCad.TbPro.Cancel;
end;

procedure TFPro001.BtCanVarClick(Sender: TObject);
begin
  DmCad.TbVarPro.Cancel;
end;

procedure TFPro001.BtExcClick(Sender: TObject);
begin
    if DmCad.TbVarPro.State in DsEditModes then begin
    MessageDlg('H� varia��es em edi��o, finalize a opera��o antes.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir este produto?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  try
    DmCad.TbPro.Delete;
    DmCad.TbPro.ApplyUpdates;
    DmCad.TbPro.CommitUpdates;

    MessageDlg('Produto exclu�do com sucesso!', mtInformation, [mbOk], 0);
  except
    MessageDlg('N�o foi poss�vel exclu�r o produto.', mtInformation, [mbOk], 0);
  end;
end;

procedure TFPro001.BtExcVarClick(Sender: TObject);
begin
  if DmCad.TbVarPro.IsEmpty then begin
    MessageDlg('Nenhuma varia��o encontrada. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir esta varia��o do produto?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  try
    DmCad.TbVarPro.Delete;
    DmCad.TbVarPro.ApplyUpdates;
    DmCad.TbVarPro.CommitUpdates;

    AdicionaSaldoProduto;

    MessageDlg('Varia��o exclu�da com sucesso!', mtInformation, [mbOk], 0);
  except
    MessageDlg('N�o foi poss�vel exclu�r a varia��o.', mtInformation, [mbOk], 0);
  end;
end;

procedure TFPro001.BtFirstClick(Sender: TObject);
begin
  DmCad.TbPro.First;
end;

procedure TFPro001.BtFirstVClick(Sender: TObject);
begin
  DmCad.TbVarPro.First;
end;

procedure TFPro001.BtGraClick(Sender: TObject);
begin
  if not CanSavePro then begin
    MessageDlg('Falta preenchimento de campos obrigat�rios. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbPro.ApplyUpdates;
  DmCad.TbPro.CommitUpdates;
end;

procedure TFPro001.BtGraVarClick(Sender: TObject);
begin
  if not CanSave then begin
    MessageDlg('Falta preenchimento de campos obrigat�rios. Verifique!', mtInformation, [mbOk], 0);
    Exit;
  end;

  DmCad.TbVarPro.ApplyUpdates;
  DmCad.TbVarPro.CommitUpdates;

  AdicionaSaldoProduto;
end;

procedure TFPro001.BtLastClick(Sender: TObject);
begin
  DmCad.TbPro.Last;
end;

procedure TFPro001.BtLastVClick(Sender: TObject);
begin
  DmCad.TbVarPro.Last;
end;

procedure TFPro001.BtNextClick(Sender: TObject);
begin
  DmCad.TbPro.Next;
end;

procedure TFPro001.BtNextVClick(Sender: TObject);
begin
  DmCad.TbVarPro.Next;
end;

procedure TFPro001.BtNovClick(Sender: TObject);
begin
  if DmCad.TbVarPro.State in DsEditModes then begin
    MessageDlg('H� varia��es em edi��o, finalize a opera��o antes.', mtInformation, [mbOk], 0);
    Exit;
  end;

  if Pages.ActivePageIndex <> 0 then
  Pages.ActivePageIndex := 0;

  DmCad.TbPro.Append;
  GerarIDProduto;
  GerarCodBarProduto;
  mDesPro.SetFocus;
end;

procedure TFPro001.BtNovVarClick(Sender: TObject);
begin
  DmCad.TbVarPro.Append;
  GerarNumLanVariacao;
  mDesVar.SetFocus;
end;

procedure TFPro001.BtPriorClick(Sender: TObject);
begin
  DmCad.TbPro.Prior;
end;

procedure TFPro001.BtPriorVClick(Sender: TObject);
begin
  DmCad.TbVarPro.Prior;
end;

function TFPro001.CanSave: Boolean;
begin
  Result := False;

  Result := mDesVar.Text <> '';
  Result := (mQtdVar.Text <> '') and Result;
end;

function TFPro001.CanSavePro: Boolean;
begin
  Result := False;

  Result := mDesPro.Text <> '';
end;

constructor TFPro001.Create(op: Integer; Aowner: TComponent);
begin
  inherited Create(Aowner);
  FOpcao := op;
end;

procedure TFPro001.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then begin
    DBGrid1.Canvas.Brush.Color := $00FF472D;
    DBGrid1.Canvas.Font.Color := clHighlightText;
  end
  else begin
    if DmCad.TbVarPro.RecNo mod 2 = 1 then
      DBGrid1.Canvas.Brush.Color := $00D1D1D1
    else
      DBGrid1.Canvas.Brush.Color := clWhite;

  end;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFPro001.DsProDmCadStateChange(Sender: TObject);
begin
  case DmCad.TbPro.State of
    dsInsert:
    begin
      VarPro.Enabled := False;

      BtNov.Enabled := False;
      BtAlt.Enabled := False;
      BtExc.Enabled := False;
      BtCan.Enabled := True;
      BtGra.Enabled := True;
      BtFirst.Enabled := False;
      BtPrior.Enabled := False;
      BtNext.Enabled := False;
      BtLast.Enabled := False;
      PanDadCad.Enabled := True;
      PanCus.Enabled := True;
      //PanEst.Enabled := True;
    end;
    dsEdit:
    begin
      VarPro.Enabled := False;

      BtNov.Enabled := False;
      BtAlt.Enabled := False;
      BtExc.Enabled := False;
      BtCan.Enabled := True;
      BtGra.Enabled := True;
      BtFirst.Enabled := False;
      BtPrior.Enabled := False;
      BtNext.Enabled := False;
      BtLast.Enabled := False;
      PanDadCad.Enabled := True;
      PanCus.Enabled := True;
      //PanEst.Enabled := True;

    end;
    dsBrowse:
    begin
      VarPro.Enabled := True;

      BtNov.Enabled := True;
      BtAlt.Enabled := True;
      BtExc.Enabled := True;
      BtCan.Enabled := False;
      BtGra.Enabled := False;
      BtFirst.Enabled := True;
      BtPrior.Enabled := True;
      BtNext.Enabled := True;
      BtLast.Enabled := True;
      PanDadCad.Enabled := False;
      PanCus.Enabled := False;
      //PanEst.Enabled := False;

    end;
  end;
end;

procedure TFPro001.DsVarProDmCadStateChange(Sender: TObject);
begin
   case DmCad.TbVarPro.State of
    dsInsert:
    begin
      BtNovVar.Enabled := False;
      BtAltVar.Enabled := False;
      BtExcVar.Enabled := False;
      BtCanVar.Enabled := True;
      BtGraVar.Enabled := True;
      BtFirstV.Enabled := False;
      BtPriorV.Enabled := False;
      BtNextV.Enabled := False;
      BtLastV.Enabled := False;
      PanGrid.Enabled := True;
      PanVar.Enabled := True;
      PanVarBot.Enabled := True;
    end;
    dsEdit:
    begin
      BtNovVar.Enabled := False;
      BtAltVar.Enabled := False;
      BtExcVar.Enabled := False;
      BtCanVar.Enabled := True;
      BtGraVar.Enabled := True;
      PanGrid.Enabled := True;
      BtFirstV.Enabled := False;
      BtPriorV.Enabled := False;
      BtNextV.Enabled := False;
      BtLastV.Enabled := False;
      PanVar.Enabled := True;
      PanVarBot.Enabled := True;
    end;
    dsBrowse:
    begin
      BtNovVar.Enabled := True;
      BtAltVar.Enabled := True;
      BtExcVar.Enabled := True;
      BtCanVar.Enabled := False;
      BtGraVar.Enabled := False;
      PanGrid.Enabled := True;
      BtFirstV.Enabled := True;
      BtPriorV.Enabled := True;
      BtNextV.Enabled := True;
      BtLastV.Enabled := True;
      PanVar.Enabled := False;
      PanVarBot.Enabled := True;

    end;
  end;
end;

procedure TFPro001.FormCreate(Sender: TObject);
begin
  if (Main.UserID = 2) or (Main.UserID = 3) then begin
    BtNov.Enabled := False;
    BtAlt.Enabled := False;
    BtExc.Enabled := False;
    VarPro.Enabled := False;
  end;
end;

procedure TFPro001.FormShow(Sender: TObject);
begin
  if not DmCad.TbPro.Active then DmCad.TbPro.Open;
  if not DmCad.TbVarPro.Active then DmCad.TbVarPro.Open;

 if Pages.ActivePageIndex <> 0 then
  Pages.ActivePageIndex := 0;

  case FOpcao of
    1: BtNov.Click;
    2: BtAlt.Click;
    3: BtExc.SetFocus;
  end;
end;

procedure TFPro001.GerarCodBarProduto;
Var
  CodBar : String;
begin
  CodBar := mIdPro.Text;

  Codbar := StringOfChar('0', 13 - Length(Codbar)) + Codbar;

  DmCad.TbProCODBARRAS.AsString := CodBar;
end;

procedure TFPro001.GerarIDProduto;
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select MAX(ID) From TbProduto');
  TbAux.Open;

  DmCad.TbProID.AsInteger := TbAux.Fields[0].AsInteger + 1;
end;

procedure TFPro001.GerarNumLanVariacao;
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select MAX(NUMLAN) From TbVarProduto Where IDPRO = :ID');
  TbAux.ParamByName('ID').AsInteger := DmCad.TbProID.AsInteger;
  TbAux.Open;

  DmCad.TbVarProNUMLAN.AsInteger := TbAux.Fields[0].AsInteger + 1;
end;

end.
