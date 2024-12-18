program Projeto;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Main},
  UPro000 in 'UPro000.pas' {FPro000},
  UDmCad in 'UDmCad.pas' {DmCad: TDataModule},
  UPro001 in 'UPro001.pas' {FPro001},
  UPass in 'UPass.pas' {FPass},
  UProd00 in 'UProd00.pas' {FProd00},
  UProd01 in 'UProd01.pas' {FProd01},
  UVen00 in 'UVen00.pas' {FVen00},
  UVen01 in 'UVen01.pas' {FVen01};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TDmCad, DmCad);
  Application.Run;
end.
