@echo off
chcp 949 1> NUL 2> NUL
set "PATH=%~dp0\bin;%~dp0\tools;%PATH%"
setlocal enabledelayedexpansion enableextensions

pushd "%~dp0"
set TARGET=be.wazabe.appdrawer
if "%~1" == "" (
  echo   # ������ ���� ��Ű������ �Է��ϼ���
  set /p TARGET_USER="(�Է� ���� ���� Ű ������ "be.wazabe.appdrawer" ����) > "
  if "!TARGET_USER!" NEQ "" (
    set TARGET=!TARGET_USER!
  )
) else (
set TARGET=%~1
)

echo   # ���� ������� ���� �����մϴ�.
echo adb shell monkey -p %TARGET% -c android.intent.category.LAUNCHER 1
adb shell monkey -p %TARGET% -c android.intent.category.LAUNCHER 1

echo # ���� Ű �Ǵ� �ƹ� Ű�� ���� �� â�� ��������!
pause > nul
