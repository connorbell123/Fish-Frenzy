unit Main;
{ FISH FRENZY VIDEO GAME
  �2024 Connor Bell
  Last Updated: 10 July 2024 }
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.Menus, Vcl.ComCtrls, Math, Vcl.MPlayer,
  System.ImageList, Vcl.ImgList, Vcl.Buttons;

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
    shp00: TShape;
    shp10: TShape;
    shp20: TShape;
    shp21: TShape;
    shp11: TShape;
    shp01: TShape;
    shp22: TShape;
    shp12: TShape;
    shp02: TShape;
    btnStart: TButton;
    btnEnd: TButton;
    mpClick: TMediaPlayer;
    img00: TImage;
    img10: TImage;
    img20: TImage;
    img21: TImage;
    img11: TImage;
    img01: TImage;
    img22: TImage;
    img12: TImage;
    img02: TImage;
    tmrRandomAllocation: TTimer;
    mpFish: TMediaPlayer;
    mpShark: TMediaPlayer;
    procedure btnNewGameClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnEndClick(Sender: TObject);
    procedure tmrTimeRemainingTimer(Sender: TObject);
    procedure tmrRandomAllocationTimer(Sender: TObject);
    procedure img00Click(Sender: TObject);
    procedure img01Click(Sender: TObject);
    procedure img02Click(Sender: TObject);
    procedure img10Click(Sender: TObject);
    procedure img11Click(Sender: TObject);
    procedure img12Click(Sender: TObject);
    procedure img20Click(Sender: TObject);
    procedure img21Click(Sender: TObject);
    procedure img22Click(Sender: TObject);
    procedure NewGame1Click(Sender: TObject);
    procedure ClearRecord2Click(Sender: TObject);
    procedure Howtoplay2Click(Sender: TObject);
    procedure ClearRecord1Click(Sender: TObject);
    procedure Howtoplay1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    // Global Variables
    iRecord: Integer;
    sDifficulty: string;

    // File Manipulation - for reading/writing the record score.
    function ReadRecordScore: Integer;
    procedure WriteNewRecordScore(pRecord_Score: Integer);

    // Hex to Dec and Dec to Hex Functions - used for the record score.
    function HexToDec(pHex_String: string): Integer;
    function DecToHex(pDec_String: string): string;

    // Sound Effects - play sound effects
    procedure ClickSound;
    procedure FishClickSound;
    procedure SharkClickSound;

    // Game play functions
    procedure EndGame(pTotalScore, pTime: Integer);
    procedure CheckHighScore;
  end;

var
  frmMain: TfrmMain;
  iTotalTime: Integer;
  iTotalScore: Integer;

implementation

{$R *.dfm}

uses Difficulty_Input, Game_Over;

procedure TfrmMain.btnEndClick(Sender: TObject);
begin
  // END game play button
  // Play the Button Click Sound
  ClickSound;

  // End the game - stop the timer
  EndGame(iTotalTime, 60 - StrToInt(lblTimeRemaining.Caption));
  frmGameOver.lblHeading.Caption := 'GAME ENDED';

  // Disable the End button
  btnEnd.Enabled := False;
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
var
  I: Integer;
  iTotal: Integer;
begin
  // START game play button
  // Play the Button Click Sound
  ClickSound;

  // Set the Difficulty Level
  if sDifficulty = 'Beginner' then
    begin
      tmrRandomAllocation.Interval := 500;
    end
  else if sDifficulty = 'Intermediate' then
    begin
      tmrRandomAllocation.Interval := 150;
    end
  else if sDifficulty = 'Advanced' then
    begin
      tmrRandomAllocation.Interval := 95;
    end;

  // Start the Timer (countdown of how many seconds are left to play the game)
  tmrTimeRemaining.Enabled := True;
  tmrRandomAllocation.Enabled := True;

  // Enable end Button
  btnEnd.Enabled := True;
end;

procedure TfrmMain.CheckHighScore;
var
  iScoreFile: Integer;
begin
  // Check the total score earned for a game is higher than the current record.
  iScoreFile := ReadRecordScore;
  if iTotalScore > iScoreFile then
    begin
      // Write the new record to the file
      WriteNewRecordScore(iTotalScore);
    end;
end;

procedure TfrmMain.ClearRecord1Click(Sender: TObject);
begin
  // Clear the Record from the File
  WriteNewRecordScore(0);
  // Update Record Score Display
  lblRecordScore.Caption := IntToStr(ReadRecordScore);
end;

procedure TfrmMain.ClearRecord2Click(Sender: TObject);
begin
  // Close the Form - Close the Game
  frmMain.Close;
end;

procedure TfrmMain.ClickSound;
begin
  // Play Button Click Sound
  mpClick.Play;
end;

function TfrmMain.DecToHex(pDec_String: string): string;
var
  iDecimal, iResult, iRemainder : Integer;
  sResult : String;
begin
  // Convert a Decimal Integer to a Hexidecimal Number
  sResult := '';
  iDecimal := StrToInt(pDec_String);
  while iDecimal > 0 do
      begin
        iResult := iDecimal div 16;
        iRemainder := Trunc(((iDecimal / 16) - iResult) * 16);
        iDecimal := iResult;
        if iRemainder in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] then
            begin
                sResult := IntToStr(iRemainder) + sResult;
            end
        else
        if iRemainder in [10, 11, 12, 13, 14, 15] then
            begin
                case iRemainder of
                    10: sResult := 'A' + sResult;
                    11: sResult := 'B' + sResult;
                    12: sResult := 'C' + sResult;
                    13: sResult := 'D' + sResult;
                    14: sResult := 'E' + sResult;
                    15: sResult := 'F' + sResult;
                end;
            end;
      end;

  Result := sResult;
end;

procedure TfrmMain.EndGame(pTotalScore, pTime: Integer);
begin
  // End Game
  tmrTimeRemaining.Enabled := False;
  tmrRandomAllocation.Enabled := False;

  // Use the total score and time to show the game over summary.
  with frmGameOver do
    begin
      Show;
      lblTime.Caption := IntToStr(pTime);
      lblEndScore.Caption := IntToStr(pTotalScore);
    end;

  // Disable the Start/End button
  btnEnd.Enabled := False;
  btnStart.Enabled := False;

  // Reset Gameplay
  lblTimeRemaining.Caption := '60';
  lblYourScore.Caption := '0';
  lblRecordScore.Caption := IntToStr(ReadRecordScore);

  // Clear Gameboard
  img00.Hide;
  img01.Hide;
  img02.Hide;
  img10.Hide;
  img11.Hide;
  img12.Hide;
  img20.Hide;
  img21.Hide;
  img22.Hide;

  // Reset Progress Bar
  pbarTime.Position := 0;

  // Update Status Bar
  sbarMain.Panels[1].Text := ' --';

  // Check if the new score is higher than the current record.
  CheckHighScore;
end;

procedure TfrmMain.FishClickSound;
begin
  // Sound Effect for clicking on a fish
  // mpFish.FileName := 'Fish.wav';
  mpFish.Play;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  // On form ACTIVATE
  // Show/display the running record score from the file.
  lblRecordScore.Caption := IntToStr(ReadRecordScore);

  // Set Total Time - the total time left to play the game
  iTotalTime := 60;

  // Set the Total Score - zero at the beginning of the game
  iTotalScore := 0;
end;

function TfrmMain.HexToDec(pHex_String: string): Integer;
var
  I, iLength, iBase: Integer;
begin
  // Convert a Hexidecimal Number to a Decimal Number
  iLength := Length(pHex_String);
  Result := 0;
  iBase := 1;
  for I := iLength downto 1 do
    begin
      if pHex_String[I] in ['0'..'9'] then
        begin
          Result := Result + (Ord(pHex_String[I]) - 48) * iBase;
        end
      else if pHex_String[I] in ['A'..'F'] then
        begin
          Result := Result + (Ord(pHex_String[I]) - 55) * iBase;
        end;
      iBase := iBase * 16;
    end;
end;

procedure TfrmMain.Howtoplay1Click(Sender: TObject);
begin
  // How to play the game
  MessageDlg('For help visit: ' + #13 +
  'https://github.com/connorbell123/Fish-Frenzy', TMsgDlgType.mtInformation,
  [mbOK], 0);
end;

procedure TfrmMain.Howtoplay2Click(Sender: TObject);
begin
  // Display About Information
  MessageDlg('Fish Frenzy Version 1' + #13 +
      'Catch as many fish as possible, but watch out for sharks!' + #13 +
      '�2024 Connor Bell', TMsgDlgType.mtInformation, [mbClose], 0);
end;

procedure TfrmMain.img00Click(Sender: TObject);
begin
  // IMG 00 - CLICK
  if (img00.Hint = 'Fish') and (img00.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img00.Visible := False;
      FishClickSound;
    end
  else if (img00.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.img01Click(Sender: TObject);
begin
  // IMG 01 - CLICK
  if (img01.Hint = 'Fish') and (img01.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img01.Visible := False;
      FishClickSound;
    end
  else if (img01.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.img02Click(Sender: TObject);
begin
  // IMG 02 - CLICK
  if (img02.Hint = 'Fish') and (img02.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img02.Visible := False;
      FishClickSound;
    end
  else if (img02.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.img10Click(Sender: TObject);
begin
  // IMG 10 - CLICK
  if (img10.Hint = 'Fish') and (img10.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img10.Visible := False;
      FishClickSound;
    end
  else if (img10.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.img11Click(Sender: TObject);
begin
  // IMG 11 - CLICK
  if (img11.Hint = 'Fish') and (img11.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img11.Visible := False;
      FishClickSound;
    end
  else if (img11.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.img12Click(Sender: TObject);
begin
  // IMG 12 - CLICK
  if (img12.Hint = 'Fish') and (img12.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img12.Visible := False;
      FishClickSound;
    end
  else if (img12.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.img20Click(Sender: TObject);
begin
  // IMG 20 - CLICK
  if (img20.Hint = 'Fish') and (img20.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img20.Visible := False;
      FishClickSound;
    end
  else if (img20.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.img21Click(Sender: TObject);
begin
  // IMG 21 - CLICK
  if (img21.Hint = 'Fish') and (img21.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img21.Visible := False;
      FishClickSound;
    end
  else if (img21.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.img22Click(Sender: TObject);
begin
  // IMG 22 - CLICK
  if (img22.Hint = 'Fish') and (img22.Visible = True) then
    begin
      iTotalScore := iTotalScore + 10;
      lblYourScore.Caption := IntToStr(iTotalScore);
      img22.Visible := False;
      FishClickSound;
    end
  else if (img22.Hint = 'Shark') then
    begin
      // Clicked on Shark - so game is over.
      EndGame(iTotalScore, 60 - StrToInt(lblTimeRemaining.Caption));
      SharkClickSound;
    end;
end;

procedure TfrmMain.NewGame1Click(Sender: TObject);
begin
  // New Game Menu Button Click
  // Show Difficulty Input Selector Form
  frmDifficultyInput.Show;
  // Play the Button Click Sound
  ClickSound;
end;

function TfrmMain.ReadRecordScore: Integer;
var
  txtFile: Textfile;
  sLine: string;
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
    MessageDlg('Error 1: Cannot find file: "Record_Score.txt".' +
    ' It may be missing or corrupted.', TMsgDlgType.mtError, [mbOK], 0);
    // Assign a default placeholder for the record score display.
    lblRecordScore.Caption := '--';
  end;
end;

procedure TfrmMain.SharkClickSound;
begin
  // Sound Effect for clicking on a shark
  mpShark.Play;
end;

procedure TfrmMain.tmrRandomAllocationTimer(Sender: TObject);
var
  iRow, iCol: Integer;
  iImage: Integer;
begin
  // Random Fish or Shark Image - GAME PLAY
  iRow := RandomRange(0, 3);
  iCol := RandomRange(0, 3);
  {At a certain interval, a random position on the 3 x 3 grid is chosen,
  and then, at random, a shark or a fish image is placed there. }
  if (iRow = 0) and (iCol = 0) then
    begin
      img00.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img00.Picture.LoadFromFile('Shark.png');
          img00.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img00.Picture.LoadFromFile('Fish.png');
          img00.Hint := 'Fish';
        end;
    end
  else if (iRow = 0) and (iCol = 1) then
    begin
      img01.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img01.Picture.LoadFromFile('Shark.png');
          img01.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img01.Picture.LoadFromFile('Fish.png');
          img01.Hint := 'Fish';
        end;
    end
  else if (iRow = 0) and (iCol = 2) then
    begin
      img02.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img02.Picture.LoadFromFile('Shark.png');
          img02.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img02.Picture.LoadFromFile('Fish.png');
          img02.Hint := 'Fish';
        end;
    end
  else if (iRow = 1) and (iCol = 0) then
    begin
      img10.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img10.Picture.LoadFromFile('Shark.png');
          img10.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img10.Picture.LoadFromFile('Fish.png');
          img10.Hint := 'Fish';
        end;
    end
  else if (iRow = 1) and (iCol = 1) then
    begin
      img11.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img11.Picture.LoadFromFile('Shark.png');
          img11.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img11.Picture.LoadFromFile('Fish.png');
          img11.Hint := 'Fish';
        end;
    end
  else if (iRow = 1) and (iCol = 2) then
    begin
      img12.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img12.Picture.LoadFromFile('Shark.png');
          img12.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img12.Picture.LoadFromFile('Fish.png');
          img12.Hint := 'Fish';
        end;
    end
  else if (iRow = 2) and (iCol = 0) then
    begin
      img20.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img20.Picture.LoadFromFile('Shark.png');
          img20.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img20.Picture.LoadFromFile('Fish.png');
          img20.Hint := 'Fish';
        end;
    end
  else if (iRow = 2) and (iCol = 1) then
    begin
      img21.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img21.Picture.LoadFromFile('Shark.png');
          img21.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img21.Picture.LoadFromFile('Fish.png');
          img21.Hint := 'Fish';
        end;
    end
  else if (iRow = 2) and (iCol = 2) then
    begin
      img22.Visible := True;
      iImage := RandomRange(0, 100);
      if (iImage mod 2 = 0) then
        begin
          // Show the shark image.
          img22.Picture.LoadFromFile('Shark.png');
          img22.Hint := 'Shark';
        end
      else
        begin
          // Show the fish image
          img22.Picture.LoadFromFile('Fish.png');
          img22.Hint := 'Fish';
        end;
    end;
end;

procedure TfrmMain.tmrTimeRemainingTimer(Sender: TObject);
begin
  // Display the total time remaining to play the game.
  lblTimeRemaining.Caption := IntToStr(iTotalTime);
  lblTimeRemaining.Update;

  // Reduce Total Time
  iTotalTime := iTotalTime - 1;

  if iTotalTime = 0 then
    begin
      // Time is up.
      tmrTimeRemaining.Enabled := False;
      tmrRandomAllocation.Enabled := False;
    end;

  // Update Progress Bar Position
  pbarTime.Position := pbarTime.Position + 1;
end;

procedure TfrmMain.WriteNewRecordScore(pRecord_Score: Integer);
var
  txtFile: Textfile;
begin
  // Overwrite the current record score in the text file to a new one.
  AssignFile(txtFile, 'Record_Score.txt');
  Rewrite(txtFile);
  // Write the Hexidecimal Record Score to the Record Score File
  Writeln(txtFile, DecToHex(IntToStr(pRecord_Score)));
  CloseFile(txtFile);
end;

end.
