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
    procedure NumClick(Sender: TObject); //���ְ�ť��Ϊ
    procedure FormCreate(Sender: TObject); //��������
    procedure ManipClick(Sender: TObject); //˫Ŀ
    procedure EqualClick(Sender: TObject); //����
    procedure DotClick(Sender: TObject); //С����
    procedure NegtClick(Sender: TObject); //�෴��
    procedure CClick(Sender: TObject); //���
    procedure DelClick(Sender: TObject); //�˸�
    procedure CEClick(Sender: TObject); //�������
    procedure FormDestroy(Sender: TObject); //��������
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
