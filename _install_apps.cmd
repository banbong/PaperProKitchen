@echo off
chcp 949 1> NUL 2> NUL
set "PATH=%~dp0\bin;%~dp0\tools;%PATH%"

pushd "%~dp0"

echo   # ���� ���� ��ġ�մϴ�:
for /r %%i in (apps\*.apk) do (
  echo   * "%%~nxi"
  call :get_app_pkg_name %%i
)
echo.

for /r %%i in (apps\*.apk) do (
  echo   * ��ġ: "%%~nxi"
  echo adb install -r "apps\%%~nxi"
  adb install -r "apps\%%~nxi"
  echo.
)
echo.

echo   # ��⿡�� '�� ����' ���� ���� �����մϴ�.
echo adb shell am force-stop be.wazabe.appdrawer
adb shell am force-stop be.wazabe.appdrawer
echo adb shell am force-stop au.radsoft.appdrawer
adb shell am force-stop au.radsoft.appdrawer
echo.

echo   # ��� �� ���Ͽ� ���� ��ġ ����� �����߽��ϴ�! ���� Ű �Ǵ� �ƹ� Ű�� ���� �����ϼ���.
pause > NUL
goto finish

:get_app_pkg_name <apk_path>
(
echo       - �� �̸�
aapt d badging "apps\%~nx1" 2>&1 | findstr /rc:"^application-label:\'.*\'"
echo       - ��Ű�� �̸�
aapt d badging "apps\%~nx1" 2>&1 | findstr /rc:"^package: name="
echo.
)

:finish