unit Game_Over;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TfrmGameOver = class(TForm)
    lblHeading: TLabel;
    imgShark: TImage;
    btnNewGame: TButton;
    btnClose: TButton;
    lblScoreHeading: TLabel;
    pnlEndScore: TPanel;
    lblEndScore: TLabel;
    lblTimeHeading: TLabel;
    pnlTime: TPanel;
    lblTime: TLabel;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGameOver: TfrmGameOver;

implementation

{$R *.dfm}

uses Main;

procedure TfrmGameOver.btnCloseClick(Sender: TObject);
begin
  // Close form
  lblHeading.Caption := 'Game Over';
  frmGameOver.Close;
end;

end.
