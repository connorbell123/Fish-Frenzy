unit Game_Over;
{ GAME OVER FORM - Display this form when the game is over or, if the game has
  been ended by the user.
  �2024 Connor Bell
  Last Updated: 10 July 2024
}
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
    procedure btnNewGameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGameOver: TfrmGameOver;

implementation

{$R *.dfm}

uses Main, Difficulty_Input;

procedure TfrmGameOver.btnCloseClick(Sender: TObject);
begin
  // Close form
  lblHeading.Caption := 'Game Over';
  frmGameOver.Close;
end;

procedure TfrmGameOver.btnNewGameClick(Sender: TObject);
begin
  with frmMain do
    begin
      // New Game Button Click
      // Show Difficulty Input Selector Form
      frmDifficultyInput.Show;
      frmGameOver.Close;
      // Play the Button Click Sound
      ClickSound;
    end;
end;

end.
