@echo off
chcp 949 1> NUL 2> NUL
set "PATH=%~dp0\bin;%~dp0\tools;%PATH%"
setlocal enabledelayedexpansion enableextensions

pushd %~dp0
title Ridibooks Paper PRO Kitchen # �� ����

:ask_user
set TARGET_PKG=be.wazabe.appdrawer
if "%~1" == "" (
  echo # ������ ���� ��Ű������ �Է��ϰų� �Ʒ� ��Ͽ��� ��ȣ�� ��� �Է��ϼ���:
  REM NOTE echo���� ��ȣ ���� �� ��...
  echo   1. App Drawer -- �⺻ �� ���� [be.wazabe.appdrawer]
  echo   2. App Drawer -- ī�� �α� ��ǰ [au.radsoft.appdrawer]
  echo   3. E-Ink Launcher [cn.modificator.launcher]
  echo.
  set /p TARGET_PKG_USER="(�Է� ���� ���� Ű ������ 1�� �׸� ����) > "
  echo.
  if "!TARGET_PKG_USER!" NEQ "" (
    if /i "!TARGET_PKG_USER!" EQU "1" (
      set TARGET_PKG=be.wazabe.appdrawer
    ) else if /i "!TARGET_PKG_USER!" EQU "2" (
      set TARGET_PKG=au.radsoft.appdrawer
    ) else if /i "!TARGET_PKG_USER!" EQU "3" (
      set TARGET_PKG=cn.modificator.launcher
    ) else (  
      set TARGET_PKG=!TARGET_PKG_USER!
    )
  )
) else (
  set TARGET_PKG=%~1
)

echo # ���� ������� ���� �����մϴ�.
echo   ^> adb shell monkey -p !TARGET_PKG! -c android.intent.category.LAUNCHER 1
adb shell monkey -p !TARGET_PKG! -c android.intent.category.LAUNCHER 1
echo.

REM �Ű������� ��������, ó������ ���ư� �ݺ�
if "%~1" == "" goto ask_user

echo # ���� Ű �Ǵ� �ƹ� Ű�� ���� â�� ��������
pause > nul
