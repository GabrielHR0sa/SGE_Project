unit UPass;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFPass = class(TForm)
    PanPass: TPanel;
    Img: TImage;
    Label1: TLabel;
    Label2: TLabel;
    mUser: TEdit;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    Panel5: TPanel;
    SpeedButton2: TSpeedButton;
    mPass: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure mPassKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPass: TFPass;

implementation

{$R *.dfm}

uses UMain;

procedure TFPass.FormCreate(Sender: TObject);
begin
  try
    img.Enabled := False;
    img.Picture.LoadFromFile('C:\Sistemas\Trabalho\fundos\logo.bmp');
    img.Enabled := True;
  except
    img.Enabled := False;
  end;
end;

procedure TFPass.mPassKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    if ((UpperCase(mUser.Text)  = 'GERENTE') and (mPass.Text = '123'))
    or ((UpperCase(mUser.Text)  = 'PRODUCAO') and (mPass.Text = '123'))
    or ((UpperCase(mUser.Text)  = 'VENDAS') and (mPass.Text = '123')) then begin
      Main.User := mUser.Text;

      if (UpperCase(mUser.Text)  = 'GERENTE') then
        Main.UserID := 1
      else if (UpperCase(mUser.Text)  = 'PRODUCAO') then
        Main.UserID := 2
      else
        Main.UserID := 3;

      Close;
    end
    else begin
      MessageDlg('Usu�rio n�o encontrado.', mtWarning, [mbOk], 0);
      Exit;
    end;
    Key := #0;
  end;

end;

procedure TFPass.SpeedButton1Click(Sender: TObject);
begin
  if ((UpperCase(mUser.Text)  = 'GERENTE') and (mPass.Text = '123'))
  or ((UpperCase(mUser.Text)  = 'PRODUCAO') and (mPass.Text = '123'))
  or ((UpperCase(mUser.Text)  = 'VENDAS') and (mPass.Text = '123')) then begin
    Main.User := mUser.Text;

    if (UpperCase(mUser.Text)  = 'GERENTE') then
      Main.UserID := 1
    else if (UpperCase(mUser.Text)  = 'PRODUCAO') then
      Main.UserID := 2
    else
      Main.UserID := 3;

    Close;
  end
  else begin
    MessageDlg('Usu�rio n�o encontrado.', mtWarning, [mbOk], 0);
    Exit;
  end;
end;

procedure TFPass.SpeedButton2Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
