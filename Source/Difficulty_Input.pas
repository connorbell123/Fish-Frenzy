unit Difficulty_Input;
{ DIFFICULTY INPUT FORM
  This form asks the user which level they would like to play in a new game.
  ©2024 Connor Bell
  Last Updated: 10 July 2024
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage;

type
  TfrmDifficultyInput = class(TForm)
    pnlButton: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    imgFishSide: TImage;
    rgpLevel: TRadioGroup;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure rgpLevelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDifficultyInput: TfrmDifficultyInput;

implementation

{$R *.dfm}

uses Main, Game_Over;

procedure TfrmDifficultyInput.btnCancelClick(Sender: TObject);
begin
  // btnCancel CLICK

  // Play the Button Click Sound
  frmMain.ClickSound;

  // Close the Input Form
  frmDifficultyInput.Close;
end;

procedure TfrmDifficultyInput.btnOKClick(Sender: TObject);
begin
  // btnOK CLICK
  { Get Difficulty Level from the user via the Radiogroup and store in
    the variable: sDifficulty }
   case rgpLevel.ItemIndex of
    0:  frmMain.sDifficulty := 'Beginner';
    1:  frmMain.sDifficulty := 'Intermediate';
    2:  frmMain.sDifficulty := 'Advanced';
  end;

  // Play the Button Click Sound
  frmMain.ClickSound;

  // Enable Buttons for start
  frmMain.btnStart.Enabled := True;

  // Update Status Bar
  frmMain.sbarMain.Panels[1].Text := frmMain.sDifficulty;

  // Close the form
  frmDifficultyInput.Close;
end;

procedure TfrmDifficultyInput.rgpLevelClick(Sender: TObject);
begin
  // Radiogroup option click
  // Play the Click Sound
  frmMain.ClickSound;
end;

end.
