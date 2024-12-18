unit UDmCad;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDmCad = class(TDataModule)
    TbPro: TFDQuery;
    TbProID: TIntegerField;
    TbProDESCRICAO: TStringField;
    TbProQUANTIDADE: TSingleField;
    DsPro: TDataSource;
    TbProPESO: TFMTBCDField;
    TbProCODBARRAS: TStringField;
    TbProPRECUSTO: TFMTBCDField;
    TbProPREVENDA: TFMTBCDField;
    TbVarPro: TFDQuery;
    DsVarPro: TDataSource;
    TbVarProIDPRO: TIntegerField;
    TbVarProNUMLAN: TIntegerField;
    TbVarProVARDES: TStringField;
    TbVarProVARQTD: TFMTBCDField;
    TbVarProSKU: TStringField;
    TbVarProEAN: TStringField;
    TbProducao: TFDQuery;
    DsProducao: TDataSource;
    TbProducaoNUMLOTE: TIntegerField;
    TbProducaoDESCRICAO: TStringField;
    TbProducaoDATALOTE: TDateField;
    TbProducaoSTATUS: TStringField;
    TbItemProducao: TFDQuery;
    DsItemProducao: TDataSource;
    TbItemProducaoNUMLOTE: TIntegerField;
    TbItemProducaoSEQLAN: TIntegerField;
    TbItemProducaoCODPRO: TIntegerField;
    TbItemProducaoCODVARIACAO: TIntegerField;
    TbItemProducaoQUANTIDADE: TFMTBCDField;
    TbProducaoDesStatus: TStringField;
    TbItemProducaoDesPro: TStringField;
    TbItemProducaoDesVar: TStringField;
    TbAux: TFDQuery;
    TbAux2: TFDQuery;
    TbVenda: TFDQuery;
    DsVenda: TDataSource;
    DsItemVenda: TDataSource;
    TbItemVenda: TFDQuery;
    TbVendaNUMPED: TIntegerField;
    TbVendaDATPED: TDateField;
    TbVendaOBSPED: TStringField;
    TbVendaQUANTIDADE: TFMTBCDField;
    TbVendaTOTBRU: TFMTBCDField;
    TbItemVendaNUMPED: TIntegerField;
    TbItemVendaNUMLAN: TIntegerField;
    TbItemVendaCODPRO: TIntegerField;
    TbItemVendaCODVAR: TIntegerField;
    TbItemVendaQUANTIDADE: TFMTBCDField;
    TbItemVendaVLRBRU: TFMTBCDField;
    TbItemVendaDESPRO: TStringField;
    TbItemVendaDESVAR: TStringField;
    procedure TbVarProBeforePost(DataSet: TDataSet);
    procedure TbProducaoCalcFields(DataSet: TDataSet);
    procedure TbItemProducaoCalcFields(DataSet: TDataSet);
    procedure TbItemVendaBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmCad: TDmCad;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UMain;

{$R *.dfm}

procedure TDmCad.TbItemProducaoCalcFields(DataSet: TDataSet);
begin
  TbAux.Close;
  TbAux.SQL.Clear;
  TbAux.SQL.Add('Select DESCRICAO From TBPRODUTO Where ID = :pID');
  TbAux.ParamByName('pID').AsInteger := TbItemProducaoCODPRO.AsInteger;
  TbAux.Open;

  TbItemProducaoDesPro.AsString := TbAux.Fields[0].AsString;

  TbAux2.Close;
  TbAux2.SQL.Clear;
  TbAux2.SQL.Add('Select VARDES From TBVARPRODUTO Where NumLan = :pNumLan And IdPro = :pIdPro');
  TbAux2.ParamByName('pNumLan').AsInteger := TbItemProducaoCODVARIACAO.AsInteger;
  TbAux2.ParamByName('pIdPro').AsInteger := TbItemProducaoCODPRO.AsInteger;
  TbAux2.Open;

  TbItemProducaoDesVar.AsString := TbAux2.Fields[0].AsString;
end;

procedure TDmCad.TbItemVendaBeforePost(DataSet: TDataSet);
begin
  TbItemVendaNUMPED.AsInteger := TbVendaNUMPED.AsInteger;
end;

procedure TDmCad.TbProducaoCalcFields(DataSet: TDataSet);
begin
  if TbProducaoSTATUS.AsString = 'AG' then
    TbProducaoDESSTATUS.AsString := 'Aguardando Início'
  else if TbProducaoSTATUS.AsString = 'EP' then
    TbProducaoDESSTATUS.AsString := 'Em Produção'
  else if TbProducaoSTATUS.AsString = 'AR' then
    TbProducaoDESSTATUS.AsString := 'A Revisar'
  else if TbProducaoSTATUS.AsString = 'FI' then
    TbProducaoDESSTATUS.AsString := 'Finalizado'
  else if TbProducaoSTATUS.AsString = 'CA' then
    TbProducaoDESSTATUS.AsString := 'Cancelado';
end;

procedure TDmCad.TbVarProBeforePost(DataSet: TDataSet);
begin
  TbVarProIDPRO.AsInteger := TbProID.AsInteger;
end;

end.
