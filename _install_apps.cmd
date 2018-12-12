@echo off
chcp 949 1> NUL 2> NUL
set "PATH=%~dp0\bin;%~dp0\tools;%PATH%"
setlocal enabledelayedexpansion enableextensions

pushd "%~dp0"

:check_if_device_recognized

echo # USB ���̺�� ��⸦ PC�� �����ߴ���, ADB ��ġ�� �νĵǴ��� ���� Ȯ�����ּ���:
echo   ^> adb devices  # ADB ���α׷��� �ν��� ��ġ ���
adb devices
echo.

:: https://superuser.com/questions/959036/what-is-the-windows-equivalent-of-wc-l
for /f "tokens=*" %%i in ('adb devices ^| find /c /v ""') do set lines=%%i
:: SHOULD have only one device = header + device + empty lines
if /i !lines! neq 3 (
echo ^^! ��ġ�� �νĵ��� ���� �� �����ϴ�. Ȯ�����ּ���.
echo ^(�Ǵ� ADB ��ġ�� �� ���� ����Ǿ� �־�� �մϴ�.^)
pause
echo.

goto check_if_device_recognized
)


echo # ��ġ�� �� ��� (���� ����/apps/*.apk):
set /a apps_count=0
for /r %%i in (apps\*.apk) do (
  echo   * "%%~nxi"
  call :get_app_pkg_name %%i
  
  set /a apps_count=apps_count+1
)
echo.

if /i !apps_count! lss 1 (
echo ^^! PC�� 'apps' ������ APK ������ �ϳ��� �����ϴ�.
echo.
goto ask_install_apps_in_device
)

echo # ��ġ ����� �����ϴ�. �� ��ɿ� ����:
echo ^- APK ������ ���� �� ���۵Ǵ���,
echo ^- "Success" �޽����� ǥ�õǴ��� Ȯ���ϼ���.
echo.
for /r %%i in (apps\*.apk) do (
  echo   * ��ġ: "%%~nxi"
  echo ^> adb install -r "apps\%%~nxi"
  adb install -r "apps\%%~nxi"
  echo.
)
echo.


:ask_install_apps_in_device
echo # Ȥ �� ��ġ ������ PC ���� ������ �ƴ� ��� ����������� "Apps" ������ �����̳���?
echo ^- ù ���� �� �ڵ� ��ġ�� ���� �ʾҴٸ�, ���⼭ ��ġ�غ�����.
echo.

set AREYOUSURE=N
SET /P AREYOUSURE=����� "Apps" ������ �� APK ������ ��ġ�غ����? [Y/[N]]: 
echo.
IF /I "!AREYOUSURE!" NEQ "Y" GOTO force_close_app_drawers

set INSTALL_COUNT=0
call :install_apps_in_device /sdcard/Apps
IF /I !INSTALL_COUNT! LSS 1 call :install_apps_in_device /sdcard/apps

set INSTALL_COUNT=0
call :install_apps_in_device /extsd/Apps
IF /I !INSTALL_COUNT! LSS 1 call :install_apps_in_device /extsd/apps
:: NOTE case insensitive??

echo.
goto force_close_app_drawers

:install_apps_in_device <path>
(
echo # ��� ���: %1
echo ^- ������ �ִ���, APK ������ �ִ���, '.installed' ������ ������ Ȯ���غ��ϴ�.
for /f "tokens=*" %%i in ('adb shell echo "$([ -d %1 ] && [ -f %1/*.apk ] && [ ^! -e %1/.installed ] && echo 1 || echo 0)"') do set DIR_EXIST=%%i

IF /I !DIR_EXIST! LSS 1 goto install_apps_in_device__stop

echo ^- ��ġ ����� �����մϴ�.
echo ^> adb shell "for apk in %1/*.apk; do echo App: $apk; pm install -r $apk; done"
adb shell "for apk in %1/*.apk; do echo App: $apk; pm install -r $apk; done"

set /A INSTALL_COUNT=INSTALL_COUNT+1

:install_apps_in_device__stop
echo.
exit /b  REM return to 'call' position
)

:force_close_app_drawers
echo # ��⿡�� '�� ����' ���� ���� ������ �� �ֽ��ϴ�.
echo ^- ���� ���� �� ������� �� �� ����� ���ΰ�ħ�˴ϴ�.
echo ^- E-Ink Launcher(����ũ ��ó)�� ��ü�� r12 �������ʹ� �ʿ����� �ʽ��ϴ�!
echo.

set AREYOUSURE=N
SET /P AREYOUSURE=^'�� ����^' �۵��� ���� �����ұ��? [Y/[N]]: 
echo.
IF /I "!AREYOUSURE!" NEQ "Y" GOTO finish

echo ^> adb shell am force-stop be.wazabe.appdrawer
adb shell am force-stop be.wazabe.appdrawer
echo ^> adb shell am force-stop au.radsoft.appdrawer
adb shell am force-stop au.radsoft.appdrawer
echo.

:finish
echo # ��� �� ���Ͽ� ���� ��ġ ����� �����߽��ϴ�! ���� Ű �Ǵ� �ƹ� Ű�� ���� �����ϼ���.
pause
goto _exit


:get_app_pkg_name <apk_path>
(
echo       - �� �̸�
aapt d badging "apps\%~nx1" 2>&1 | findstr /rc:"^application-label:\'.*\'"
echo       - ��Ű�� �̸�
aapt d badging "apps\%~nx1" 2>&1 | findstr /rc:"^package: name="
echo.

exit /b  REM return to 'call' position
)

:_exit