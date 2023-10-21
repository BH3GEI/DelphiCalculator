unit CalculatorState;

interface

uses
  StrUtils, SysUtils, Classes, Generics.Collections,Vcl.Dialogs;

type
  // 计算器状态基类
  TCalculator = class;


  TState = class
  //基类方法
    procedure ProcessNumber(var TCal: TCalculator; TNumber: Integer); virtual;      //处理数字
    procedure ProcessManipulator(var Tcal: TCalculator; TManip: string); virtual;   //处理运算符
    procedure ProcessNegt(var Tcal: TCalculator); virtual;                          //处理正负号
    procedure ProcessDel(var Tcal: TCalculator); virtual;                           //处理退格
    procedure ProcessDot(var Tcal: TCalculator); virtual;                           //处理小数点
    procedure ProcessEqual(var Tcal: TCalculator); virtual;                         //处理等号
    procedure ProcessClear(var Tcal: TCalculator); virtual;                         //处理C
    procedure ProcessCE(var Tcal: TCalculator); virtual;                            //处理CE
  end;

  // 运算符状态
  TManipState = class(TState)
    procedure ProcessNumber(var TCal: TCalculator; TNumber: Integer); override;
    procedure ProcessManipulator(var Tcal: TCalculator; TManip: string); override;
    procedure ProcessNegt(var Tcal: TCalculator); override;
    procedure ProcessDel(var Tcal: TCalculator); override;
    procedure ProcessDot(var Tcal: TCalculator); override;
    procedure ProcessEqual(var Tcal: TCalculator); override;
    procedure ProcessCE(var Tcal: TCalculator); override;
  end;

  // 小数点状态
  TDotState = class(TState)
    procedure ProcessNumber(var TCal: TCalculator; TNumber: Integer); override;
    procedure ProcessManipulator(var Tcal: TCalculator; TManip: string); override;
    procedure ProcessNegt(var Tcal: TCalculator); override;
    procedure ProcessDel(var Tcal: TCalculator); override;
    procedure ProcessEqual(var Tcal: TCalculator); override;
    procedure ProcessCE(var Tcal: TCalculator); override;
  end;

  // 数字状态
  TNumberState = class(TState)
    procedure ProcessNumber(var TCal: TCalculator; TNumber: Integer); override;
    procedure ProcessManipulator(var Tcal: TCalculator; TManip: string); override;
    procedure ProcessNegt(var Tcal: TCalculator); override;
    procedure ProcessDel(var Tcal: TCalculator); override;
    procedure ProcessDot(var Tcal: TCalculator); override;
    procedure ProcessEqual(var Tcal: TCalculator); override;
    procedure ProcessCE(var Tcal: TCalculator); override;
  end;

  // 结果状态
  TResultState = class(TState)
    procedure ProcessNumber(var TCal: TCalculator; TNumber: Integer); override;
    procedure ProcessManipulator(var Tcal: TCalculator; TManip: string); override;
    procedure ProcessNegt(var Tcal: TCalculator); override;
    procedure ProcessDot(var Tcal: TCalculator); override;
    procedure ProcessCE(var Tcal: TCalculator); override;
  end;

  // 清空状态
  TClearState = class(TState)
    procedure ProcessNumber(var Tcal: TCalculator; TNumber: Integer); override;
    procedure ProcessManipulator(var Tcal: TCalculator; TManip: string); override;
    procedure ProcessDot(var Tcal: TCalculator); override;
  end;


  // 计算器类
  TCalculator = class
  private
    FPresent: string;
    FDotBoolean: Boolean;
    FTypeBoolean: Boolean;
    FManipulatorStack: TStack<string>;
    FNumberStack: TStack<string>;
    FClearState: TClearState;
    FNumberState: TNumberState;
    FManipulatorState: TManipState;
    FDotState: TDotState;
    FResultState: TResultState;
    FManipulatorCount: Integer;
  public
    CurrentState: TState;
    ResultNum: Extended;
    constructor Create;
    destructor Destroy; override;
    procedure SetState(NextState: Tstate);
    procedure CheckDot(var Tcal: TCalculator);
    function GetResult: string;
    function ReturnCalculation: string;
    function PriorityOfManipulator(AManipulator: string): Integer;
  end;

implementation
{ TCalculatorState }

//基类
procedure TState.ProcessClear(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FManipulatorStack.Clear;
    FNumberStack.Clear;
    FPresent := '0';
    FDotBoolean := False;
    FTypeBoolean := True;
    ResultNum := 0;
    SetState(FClearState);
  end;
end;



procedure TState.ProcessNumber(var TCal: TCalculator; TNumber: Integer);
begin
  // 默认数字状态不做任何处理
end;

procedure TState.ProcessManipulator(var Tcal: TCalculator; TManip: string);
begin
  //同上
end;

procedure TState.ProcessNegt(var Tcal: TCalculator);
begin
  //同上
end;

procedure TState.ProcessDel(var Tcal: TCalculator);
begin
  //同上
end;

procedure TState.ProcessDot(var Tcal: TCalculator);
begin
  //同上
end;

procedure TState.ProcessEqual(var Tcal: TCalculator);
begin
  //同上
end;

procedure TState.ProcessCE(var Tcal: TCalculator);
begin
  //同上
end;


//清除状态
procedure TClearState.ProcessNumber(var TCal: TCalculator; TNumber: Integer);
begin
  with Tcal do
  begin
    FPresent := IntToStr(TNumber);
    SetState(FNumberState);
  end;
end;

procedure TClearState.ProcessManipulator(var Tcal: TCalculator; TManip: string);
begin
  with Tcal do
  begin
    FTypeBoolean := False;
    FNumberStack.Push('0');
    FPresent := TManip;
    SetState(FManipulatorState);
  end;
end;

procedure TClearState.ProcessDot(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := '0.';
    FDotBoolean := True;
    SetState(FDotState);
  end;
end;

//数字状态
procedure TNumberState.ProcessNumber(var Tcal: TCalculator; TNumber: Integer);
begin
  with Tcal do
  begin
    if FPresent = '0' then
      FPresent := IntToStr(TNumber)
    else
      FPresent := FPresent + IntToStr(TNumber);
    SetState(FNumberState);
  end;
end;

procedure TNumberState.ProcessManipulator(var Tcal: TCalculator; TManip: string);
begin
  with Tcal do
  begin
    FNumberStack.Push(FPresent);
    FPresent := TManip;
    FTypeBoolean := False;
    FDotBoolean := False;
    SetState(FManipulatorState);
  end;
end;

procedure TNumberState.ProcessNegt(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    if FPresent[1] = '-' then
      FPresent := RightStr(FPresent, Length(FPresent) - 1)
    else
      FPresent := '-' + FPresent;
    SetState(FNumberState);
  end;
end;

procedure TNumberState.ProcessDel(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := LeftStr(FPresent, Length(FPresent) - 1);
    if Length(FPresent) > 0 then
    begin
      if FPresent[Length(FPresent)] = '.' then
        SetState(FDotState)
      else
      begin
        if (Length(FPresent) = 1) and (FPresent[1] = '-') then
        begin
          FPresent := LeftStr(FPresent, Length(FPresent) - 1);
          if FManipulatorStack.Count = 0 then
          begin
            SetState(FClearState);
          end
          else
          begin
            FPresent := FManipulatorStack.pop;
            FTypeBoolean := False;
            SetState(FManipulatorState);
          end;
        end
        else
          SetState(FNumberState);
      end;
    end
    else
    begin
      if FManipulatorStack.Count = 0 then
      begin
        SetState(FClearState);
      end
      else
      begin
        FPresent := FManipulatorStack.pop;
        FTypeBoolean := False;
        SetState(FManipulatorState);
      end;
    end;
  end;
end;

procedure TNumberState.ProcessDot(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    if FDotBoolean then
    begin
      SetState(FNumberState);
      Exit;
    end;
    FPresent := FPresent + '.';
    FDotBoolean := True;
    SetState(FDotState);
  end;
end;

procedure TNumberState.ProcessEqual(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FNumberStack.Push(FPresent);
    FPresent := '';
    GetResult;
    SetState(FResultState);
  end;
end;

procedure TNumberState.ProcessCE(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := '0';
    FDotBoolean := False;
    FTypeBoolean := False;
    SetState(FNumberState);
  end;
end;


//操作符状态
procedure TManipState.ProcessNumber(var Tcal: TCalculator; TNumber: Integer);
begin
  with Tcal do
  begin
    FManipulatorStack.Push(FPresent);
    FPresent := IntToStr(TNumber);
    SetState(FNumberState);
  end;
end;

procedure TManipState.ProcessManipulator(var Tcal: TCalculator; TManip: string);
begin
  with Tcal do
  begin
    FPresent := TManip;
    SetState(FManipulatorState);
  end;
end;

procedure TManipState.ProcessNegt(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := FNumberStack.Pop;
    if FPresent[1] = '-' then
      FPresent := RightStr(FPresent, Length(FPresent) - 1)
    else
      FPresent := '-' + FPresent;
    SetState(FNumberState);
  end;
end;

procedure TManipState.ProcessDel(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := FNumberStack.Pop;
    CheckDot(Tcal);
    FTypeBoolean := True;
    SetState(FNumberState);
  end;
end;

procedure TManipState.ProcessDot(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := FNumberStack.pop;
    FDotBoolean := False;
    CheckDot(Tcal);
    if FDotBoolean then
    begin
      SetState(FNumberState);
      Exit;
    end;
    FPresent := FPresent + '.';
    FDotBoolean := True;
    FTypeBoolean := True;
    SetState(FDotState);
  end;
end;

procedure TManipState.ProcessEqual(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    GetResult;
    FPresent := '';
    GetResult;
    SetState(FResultState);
  end;
end;

procedure TManipState.ProcessCE(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := FNumberStack.Pop;
    CheckDot(Tcal);
    FTypeBoolean := True;
    SetState(FNumberState);
  end;
end;

//小数点状态
procedure TDotState.ProcessNumber(var Tcal: TCalculator; TNumber: Integer);
begin
  with Tcal do
  begin
    FPresent := FPresent + IntToStr(TNumber);
    SetState(FNumberState);
  end;
end;

procedure TDotState.ProcessManipulator(var Tcal: TCalculator; TManip: string);
begin
  with Tcal do
  begin
    FPresent := LeftStr(FPresent, Length(FPresent) - 1);
    FNumberStack.Push(FPresent);
    FPresent := TManip;
    FDotBoolean := False;
    FTypeBoolean := False;
    SetState(FManipulatorState);
  end;
end;

procedure TDotState.ProcessNegt(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := LeftStr(FPresent, Length(FPresent) - 1);
    if FPresent[1] = '-' then
      FPresent := RightStr(FPresent, Length(FPresent) - 1)
    else
      FPresent := '-' + FPresent;
    SetState(FNumberState);
  end;
end;

procedure TDotState.ProcessDel(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := LeftStr(FPresent, Length(FPresent) - 1);
    SetState(FNumberState);
  end;
end;

procedure TDotState.ProcessEqual(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := LeftStr(FPresent, Length(FPresent) - 1);
    FNumberStack.Push(FPresent);
    FDotBoolean := False;
    FTypeBoolean := True;
    FPresent := '';
    GetResult;
    SetState(FResultState);
  end;
end;

procedure TDotState.ProcessCE(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FPresent := '0';
    SetState(FNumberState);
  end;
end;


//计算结果状态
procedure TResultState.ProcessNumber(var Tcal: TCalculator; TNumber: Integer);
begin
  with Tcal do
  begin
    FManipulatorStack.Clear;
    FNumberStack.Clear;
    FPresent := '';
    FDotBoolean := False;
    FTypeBoolean := True;
    ResultNum := 0;
    FPresent := FPresent + IntToStr(TNumber);
    SetState(FNumberState);
  end;
end;

procedure TResultState.ProcessManipulator(var Tcal: TCalculator; TManip: string);
begin
  with Tcal do
  begin
    FManipulatorStack.Clear;
    FNumberStack.Clear;
    FPresent := '';
    FDotBoolean := False;
    FTypeBoolean := True;
    FNumberStack.Push(FloatToStr(ResultNum));
    FPresent := TManip;
    FDotBoolean := False;
    FTypeBoolean := False;
    SetState(FManipulatorState);
  end;
end;

procedure TResultState.ProcessNegt(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FManipulatorStack.Clear;
    FNumberStack.Clear;
    FPresent := FloatToStr(ResultNum);
    FTypeBoolean := True;
    CheckDot(Tcal);
    if FPresent[1] = '-' then
      FPresent := RightStr(FPresent, Length(FPresent) - 1)
    else
      FPresent := '-' + FPresent;
    SetState(FNumberState);
    SetState(FNumberState);
  end;
end;

procedure TResultState.ProcessDot(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FManipulatorStack.Clear;
    FNumberStack.Clear;
    FPresent := '0.';
    FDotBoolean := True;
    FTypeBoolean := True;
    ResultNum := 0;
    SetState(FDotState);
  end;
end;

procedure TResultState.ProcessCE(var Tcal: TCalculator);
begin
  with Tcal do
  begin
    FManipulatorStack.Clear;
    FNumberStack.Clear;
    FPresent := '0';
    FDotBoolean := False;
    FTypeBoolean := True;
    ResultNum := 0;
    SetState(FClearState);
  end;
end;

//实现计算器类
constructor TCalculator.Create;
begin
  FManipulatorStack := TStack<string>.Create;
  FNumberStack := TStack<string>.Create;
  FClearState := TClearState.Create;
  FNumberState := TNumberState.Create;
  FManipulatorState := TManipState.Create;
  FDotState := TDotState.Create;
  FResultState := TResultState.Create;
  CurrentState := FClearState;
  FPresent := '';
  FDotBoolean := False;
  FTypeBoolean := True;
  ResultNum := 0;
end;

destructor TCalculator.Destroy;
begin
  FreeAndNil(FResultState);
  FreeAndNil(FDotState);
  FreeAndNil(FManipulatorState);
  FreeAndNil(FNumberState);
  FreeAndNil(FClearState);
  FreeAndNil(FNumberStack);
  FreeAndNil(FManipulatorStack);
  inherited;
end;

procedure TCalculator.SetState(NextState: TState);
begin
  CurrentState := NextState;
end;

// 获取操作符的优先级
function TCalculator.PriorityOfManipulator(AManipulator: string): Integer;
begin
  if (AManipulator = '×') or (AManipulator = '÷') then
    Result := 2
  else if (AManipulator = '+') or (AManipulator = '-') then
    Result := 1
  else
    Result := -1;
end;


// 检查输入是否为小数点
procedure TCalculator.CheckDot(var Tcal: TCalculator);
var
  I: Integer;
begin
  with Tcal do
  begin
    FDotBoolean := False;
    for I := 1 to Length(FPresent) do
    begin
      if FPresent[I] = '.' then
      begin
        FDotBoolean := True;
        Break;
      end;
    end;
  end;
end;

// 计算结果
function TCalculator.GetResult;
var
  BackupNumberStack: TStack<string>;
  BackupManipulatorStack: TStack<string>;
  TempReNumberStack: TStack<string>;
  TempReManipulatorStack: TStack<string>;
  Num1, Num2: Extended;
  TempManipulator: string;
  TempNumberStack: TStack<Extended>;
  TempManipulatorStack: TStack<string>;
begin
  begin
    FManipulatorCount := 0;
    BackupNumberStack := TStack<string>.Create(FNumberStack);
    BackupManipulatorStack := TStack<string>.Create(FManipulatorStack);
    TempReNumberStack := TStack<string>.Create;
    TempReManipulatorStack := TStack<string>.Create;
    TempNumberStack := TStack<Extended>.Create;
    TempManipulatorStack := TStack<string>.Create;
    try
      while BackupNumberStack.Count > 0 do
      begin
        TempReNumberStack.push(BackupNumberStack.pop);
      end;
      while BackupManipulatorStack.Count > 0 do
      begin
        TempReManipulatorStack.push(BackupManipulatorStack.pop);
      end;
      FreeAndNil(BackupManipulatorStack);
      FreeAndNil(BackupNumberStack);
      if TempReNumberStack.Count > 0 then
        TempNumberStack.Push(StrToFloat(TempReNumberStack.pop));
      while TempReManipulatorStack.Count > 0 do
      begin
        FManipulatorCount := FManipulatorCount + 1;
        if FManipulatorCount > 2 then
        begin
          Result := '操作数过多!';
          Exit;
        end;
        TempManipulator := TempReManipulatorStack.pop;
        if TempManipulatorStack.Count = 0 then
        begin
          TempManipulatorStack.push(TempManipulator);
          TempNumberStack.Push(StrToFloat(TempReNumberStack.pop));
        end
        else if PriorityOfManipulator(TempManipulator) > PriorityOfManipulator(TempManipulatorStack.Peek) then
        begin
          TempManipulatorStack.push(TempManipulator);
          TempNumberStack.Push(StrToFloat(TempReNumberStack.pop));
        end
        else
        begin
          Num2 := TempNumberStack.pop;
          Num1 := TempNumberStack.pop;
          if TempManipulatorStack.Peek = '+' then
            Num1 := Num1 + Num2
          else if TempManipulatorStack.Peek = '-' then
            Num1 := Num1 - Num2
          else if TempManipulatorStack.Peek = '×' then
            Num1 := Num1 * Num2
          else
          begin
            if Num2 = 0 then
            begin
              Result := '错误，不能除以0!';
              Exit;
            end
            else
              Num1 := Num1 / Num2;
          end;
          TempNumberStack.Push(Num1);
          TempManipulatorStack.pop;
          TempManipulatorStack.push(TempManipulator);
          TempNumberStack.Push(StrToFloat(TempReNumberStack.pop));
        end;
      end;
      while TempManipulatorStack.Count > 0 do
      begin
        Num2 := TempNumberStack.pop;
        Num1 := TempNumberStack.pop;
        if TempManipulatorStack.Peek = '+' then
          Num1 := Num1 + Num2
        else if TempManipulatorStack.Peek = '-' then
          Num1 := Num1 - Num2
        else if TempManipulatorStack.Peek = '×' then
          Num1 := Num1 * Num2
        else
        begin
          if Num2 = 0 then
            begin
              Result := '错误，不能除以0!';
              Exit;
            end
          else
            Num1 := Num1 / Num2;
        end;
        TempNumberStack.Push(Num1);
        TempManipulatorStack.pop;
      end;
      ResultNum := TempNumberStack.Pop;
      Result := FloatToStr(ResultNum);
    finally
      FreeAndNil(TempManipulatorStack);
      FreeAndNil(TempNumberStack);
      FreeAndNil(TempReManipulatorStack);
      FreeAndNil(TempReNumberStack);
    end;
  end;
end;

// 返回计算结果
function TCalculator.ReturnCalculation: string;
var
  NumberStackBackup: TStack<string>;  // 备份数字栈
  ManipulatorStackBackup: TStack<string>;  // 备份操作符栈
  ReverseNumberStack: TStack<string>;  // 反转后的数字栈
  ReverseManipulatorStack: TStack<string>;  // 反转后的操作符栈
begin
  // 创建备份栈和临时栈
  NumberStackBackup := TStack<string>.Create(FNumberStack);
  ManipulatorStackBackup := TStack<string>.Create(FManipulatorStack);
  ReverseNumberStack := TStack<string>.Create;
  ReverseManipulatorStack := TStack<string>.Create;

  // 检查当前状态
  if CurrentState = FClearState then
  begin
    Result := '0';
    Exit;
  end;

  try
    // 反转数字栈
    while NumberStackBackup.Count > 0 do
    begin
      ReverseNumberStack.Push(NumberStackBackup.Pop);
    end;

    // 反转操作符栈
    while ManipulatorStackBackup.Count > 0 do
    begin
      ReverseManipulatorStack.Push(ManipulatorStackBackup.Pop);
    end;

    // 获取结果
    if ReverseNumberStack.Count > 0 then
      Result := ReverseNumberStack.Pop;

    while ReverseManipulatorStack.Count > 0 do
    begin
      Result := Result + ReverseManipulatorStack.Pop;

      if ReverseNumberStack.Count > 0 then
        Result := Result + ReverseNumberStack.Pop;
    end;

    Result := Result + FPresent;
  finally
    // 释放内存
    FreeAndNil(ReverseNumberStack);
    FreeAndNil(ReverseManipulatorStack);
    FreeAndNil(NumberStackBackup);
    FreeAndNil(ManipulatorStackBackup);
  end;
end;



end.
