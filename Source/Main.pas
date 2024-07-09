unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.Menus, Vcl.ComCtrls, Math, Vcl.MPlayer;

type
  TfrmMain = class(TForm)
    imgLogo: TImage;
    lblHeading: TLabel;
    btnNewGame: TButton;
    mmMain: TMainMenu;
    Game1: TMenuItem;
    Help1: TMenuItem;
    pnlTimeRemaining: TPanel;
    pnlYourScore: TPanel;
    pnlRecordScore: TPanel;
    lblTimeRemaining: TLabel;
    tmrTimeRemaining: TTimer;
    lblYourScore: TLabel;
    lblRecordScore: TLabel;
    lblRecordHeading: TLabel;
    lblScoreHeading: TLabel;
    lblTimeHeading: TLabel;
    NewGame1: TMenuItem;
    NewGame2: TMenuItem;
    ClearRecord1: TMenuItem;
    ClearRecord2: TMenuItem;
    Howtoplay1: TMenuItem;
    Howtoplay2: TMenuItem;
    sbarMain: TStatusBar;
    lblAbout1: TLabel;
    lblAbout2: TLabel;
    lblAbout3: TLabel;
    imgSharkSide: TImage;
    imgFishSide: TImage;
    Image1: TImage;
    pnlGameBoard: TPanel;
    pbarTime: TProgressBar;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    btnStart: TButton;
    btnEnd: TButton;
    mpSoundPlayer: TMediaPlayer;
    procedure btnNewGameClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnEndClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    iRecord : Integer;
    sDifficulty : string;
    function ReadRecordScore : Integer;
    function HexToDec(pHex_String : string) : Integer;
    procedure ClickSound;
  end;

var
  frmMain: TfrmMain;


implementation

{$R *.dfm}

uses Difficulty_Input;

procedure TfrmMain.btnEndClick(Sender: TObject);
begin
  // END game play button
  // Play the Button Click Sound
  ClickSound;
end;

procedure TfrmMain.btnNewGameClick(Sender: TObject);
begin
  // New Game Button Click
  // Show Difficulty Input Selector Form
  frmDifficultyInput.Show;
  // Play the Button Click Sound
  ClickSound;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  // START game play button
  // Play the Button Click Sound
  ClickSound;
end;

procedure TfrmMain.ClickSound;
begin
  // Play Button Click Sound
  mpSoundPlayer.FileName := 'Click.wav';
  mpSoundPlayer.Play;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  // On form ACTIVATE
  // Show/display the running record score from the file.
  lblRecordScore.Caption := IntToStr(ReadRecordScore);
end;

function TfrmMain.HexToDec(pHex_String: string): Integer;
var
  I, iLength, iPower : Integer;
begin
  // Convert a Hexidecimal Number to a Decimal Number
  iLength := Length(pHex_String);
  Result := 0;
  for I := iLength downto 1 do
    begin
      iPower := iLength - I;
      Result := Result + (StrToInt(pHex_String[I] ) *
                                          Round((Power(16, iPower))));
    end;
end;

function TfrmMain.ReadRecordScore : Integer;
var
  txtFile : Textfile;
  sLine : string;
begin
  // Read the Record Score from the text file and return the integer value.
  { Note: The Record Score is stored as a Hexidecimal Number }
  try
    AssignFile(txtFile, 'Record_Score.txt');
    Reset(txtFile);
    // Read the Hexidecimal Record Score from the File
    Readln(txtFile, sLine);
    // Convert the Hex number into a decimal (using HexToDec)
    Result := HexToDec(sLine);
    CloseFile(txtFile);
  except
    // Display Error 1 Message: Cannot find the record score file!
    MessageDlg('Error 1: Cannot find file: "Record_Score.txt".'
    + ' It may be missing or corrupted.', TMsgDlgType.mtError, [mbOK], 0);
    // Assign a default placeholder for the record score display.
    lblRecordScore.Caption := '--';
  end;
end;

end.

