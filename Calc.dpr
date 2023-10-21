program Calc;

uses
  Vcl.Forms,
  CalculatorForm in 'CalculatorForm.pas' {Form1},
  CalculatorState in 'CalculatorState.pas';

{$R *.res}
var
  WindowsCalculator: TCalculator;

begin
  { $IFDEF_DEBUG }
  ReportMemoryLeaksOnShutdown := True;
  { $ENDIF }
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCalculator, frmCalculator);
  Application.Run;
end.
