program BloggerDesktop;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  main in 'main.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  BloggerDesktop.ChatGPT in 'BloggerDesktop.ChatGPT.pas' {Frame1: TFrame},
  helpers in 'helpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Polar Dark');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
