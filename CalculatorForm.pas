unit CalculatorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CalculatorState, ComCtrls;

type
  TfrmCalculator = class(TForm)
    btnCE: TButton;
    btnC: TButton;
    btnDel: TButton;
    btnDiv: TButton;
    btnNum7: TButton;
    btnNum8: TButton;
    btnNum9: TButton;
    btnMul: TButton;
    btnNum4: TButton;
    btnNum5: TButton;
    btnNum6: TButton;
    btnMinus: TButton;
    btnNum1: TButton;
    btnNum2: TButton;
    btnNum3: TButton;
    btnPlus: TButton;
    btnOppo: TButton;
    btnNum0: TButton;
    btnDot: TButton;
    btnEqual: TButton;
    edtCurrent: TEdit;
    procedure NumClick(Sender: TObject); //数字按钮行为
    procedure FormCreate(Sender: TObject); //创建窗口
    procedure ManipClick(Sender: TObject); //双目
    procedure EqualClick(Sender: TObject); //等于
    procedure DotClick(Sender: TObject); //小数点
    procedure NegtClick(Sender: TObject); //相反数
    procedure CClick(Sender: TObject); //清空
    procedure DelClick(Sender: TObject); //退格
    procedure CEClick(Sender: TObject); //清空输入
    procedure FormDestroy(Sender: TObject); //销除窗口
  private
    { Private declarations }
    WindowsCalculator: TCalculator;
  public
    { Public declarations }
  end;

var
  frmCalculator: TfrmCalculator;

implementation

{$R *.dfm}

procedure TfrmCalculator.CClick(Sender: TObject);
begin
  Self.WindowsCalculator.CurrentState.ProcessClear(WindowsCalculator);
  Self.edtCurrent.Text := '0';
end;

procedure TfrmCalculator.CEClick(Sender: TObject);
begin
  Self.WindowsCalculator.CurrentState.ProcessCE(WindowsCalculator);
  Self.edtCurrent.Text := self.WindowsCalculator.ReturnCalculation;
end;

procedure TfrmCalculator.DelClick(Sender: TObject);
begin
  Self.WindowsCalculator.CurrentState.ProcessDel(WindowsCalculator);
  Self.edtCurrent.Text := Self.WindowsCalculator.ReturnCalculation;
end;

procedure TfrmCalculator.DotClick(Sender: TObject);
begin
  Self.WindowsCalculator.CurrentState.ProcessDot(WindowsCalculator);
  Self.edtCurrent.Text := Self.WindowsCalculator.ReturnCalculation;
end;

procedure TfrmCalculator.EqualClick(Sender: TObject);
begin
  Self.WindowsCalculator.CurrentState.ProcessEqual(WindowsCalculator);
  Self.edtCurrent.Text := Self.WindowsCalculator.ReturnCalculation + '=' + Self.WindowsCalculator.GetResult;
end;

procedure TfrmCalculator.NumClick(Sender: TObject);
begin
  Self.WindowsCalculator.CurrentState.ProcessNumber(WindowsCalculator, (Sender as TButton).Tag);
  Self.edtCurrent.Text := Self.WindowsCalculator.ReturnCalculation;
end;

procedure TfrmCalculator.NegtClick(Sender: TObject);
begin
  Self.WindowsCalculator.CurrentState.ProcessNegt(WindowsCalculator);
  Self.edtCurrent.Text := Self.WindowsCalculator.ReturnCalculation;
end;

procedure TfrmCalculator.ManipClick(Sender: TObject);
begin
  Self.WindowsCalculator.CurrentState.ProcessManipulator(WindowsCalculator, (Sender as TButton).Caption);
  Self.edtCurrent.Text := Self.WindowsCalculator.ReturnCalculation;
end;

procedure TfrmCalculator.FormCreate(Sender: TObject);
begin
  WindowsCalculator := TCalculator.Create;
end;

procedure TfrmCalculator.FormDestroy(Sender: TObject);
begin
  FreeAndNil(WindowsCalculator);
end;

end.
