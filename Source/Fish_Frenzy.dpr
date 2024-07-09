program Fish_Frenzy;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  Difficulty_Input in 'Difficulty_Input.pas' {frmDifficultyInput};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Green');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDifficultyInput, frmDifficultyInput);
  Application.Run;
end.
