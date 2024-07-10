program Fish_Frenzy;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  Difficulty_Input in 'Difficulty_Input.pas' {frmDifficultyInput},
  Game_Over in 'Game_Over.pas' {frmGameOver};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Fish Frenzy';
  TStyleManager.TrySetStyle('Windows10 Green');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDifficultyInput, frmDifficultyInput);
  Application.CreateForm(TfrmGameOver, frmGameOver);
  Application.Run;
end.
