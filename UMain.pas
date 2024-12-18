unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TMain = class(TForm)
    PanFundo: TPanel;
    BancoDados: TFDConnection;
    PanBot: TPanel;
    Panel1: TPanel;
    BtProd: TSpeedButton;
    Panel2: TPanel;
    BtPro: TSpeedButton;
    Panel3: TPanel;
    BtExit: TSpeedButton;
    PanName: TPanel;
    lbn: TLabel;
    LbUser: TLabel;
    PanGrid: TPanel;
    DBGrid1: TDBGrid;
    PanLegend: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    TbProducao: TFDQuery;
    DsProducao: TDataSource;
    TbProducaoNUMLOTE: TIntegerField;
    TbProducaoDESCRICAO: TStringField;
    TbProducaoDATALOTE: TDateField;
    TbProducaoSTATUS: TStringField;
    TbProducaoDesStatus: TStringField;
    Panel9: TPanel;
    mBtVen: TSpeedButton;
    procedure BtProClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtExitClick(Sender: TObject);
    procedure BtProdClick(Sender: TObject);
    procedure TbProducaoCalcFields(DataSet: TDataSet);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mBtVenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
        User : String;
        UserID : Integer;
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses UPro000, UPass, UProd00, UVen00;

procedure TMain.BtExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMain.BtProClick(Sender: TObject);
begin
  FPro000 := TFPro000.Create(self);
  try
    FPro000.ShowModal;
  finally
    FPro000.Release;
  end;
end;

procedure TMain.BtProdClick(Sender: TObject);
begin
  FProd00 := TFProd00.Create(self);
  try
    FProd00.ShowModal;
  finally
    FProd00.Release;
  end;
end;

procedure TMain.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if TbProducaoSTATUS.AsString = 'AI' then
  begin
    DBGrid1.Canvas.Brush.Color := $00FFF2E6;
  end;

  if TbProducaoSTATUS.AsString = 'EP' then
  begin
    DBGrid1.Canvas.Brush.Color := $00FFBB7D;
  end;

  if TbProducaoSTATUS.AsString = 'AR' then
  begin
    DBGrid1.Canvas.Brush.Color := $007DF5FF;
  end;

  if TbProducaoSTATUS.AsString = 'FI' then
  begin
    DBGrid1.Canvas.Brush.Color := $007EFE82;
  end;

  if TbProducaoSTATUS.AsString = 'CA' then begin
    DBGrid1.Canvas.Brush.Color := $007E7EFE;
  end;

   if gdSelected in State then
  begin
    DBGrid1.Canvas.Brush.Color := $00FF472D;
    DBGrid1.Canvas.Font.Color := clHighlightText;
  end;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  if not BancoDados.Connected then
    BancoDados.Connected := True;

  FPass := TFPass.Create(self);
  try
    FPass.ShowModal;
  finally
    FPass.Release;
  end;

  LbUser.Caption := User;
  if not TbProducao.Active then TbProducao.Open;

  if UserID = 1 then begin
    Panel1.Visible := True;
    Panel2.Visible := True;
    Panel9.Visible := True;
  end
  else if UserID = 2 then begin
    Panel1.Visible := True;
    Panel2.Visible := True;
    Panel9.Visible := False;
  end
  else begin
    Panel1.Visible := False;
    Panel2.Visible := True;
    Panel9.Visible := True;
  end;
  
end;

procedure TMain.mBtVenClick(Sender: TObject);
begin
  FVen00 := TFVen00.Create(self);
  try
    FVen00.ShowModal;
  finally
    FVen00.Release;
  end;
end;

procedure TMain.TbProducaoCalcFields(DataSet: TDataSet);
begin
  if TbProducaoSTATUS.AsString = 'AG' then
    TbProducaoDESSTATUS.AsString := 'Aguardando In�cio'
  else if TbProducaoSTATUS.AsString = 'EP' then
    TbProducaoDESSTATUS.AsString := 'Em Produ��o'
  else if TbProducaoSTATUS.AsString = 'AR' then
    TbProducaoDESSTATUS.AsString := 'A Revisar'
  else if TbProducaoSTATUS.AsString = 'FI' then
    TbProducaoDESSTATUS.AsString := 'Finalizado'
  else if TbProducaoSTATUS.AsString = 'CA' then
    TbProducaoDESSTATUS.AsString := 'Cancelado';
end;

end.
