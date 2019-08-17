@echo off
chcp 949 1> NUL 2> NUL
set "PATH=%~dp0\bin;%~dp0\tools;%PATH%"
setlocal enabledelayedexpansion enableextensions

cd %~dp0
pushd %~dp0
title Ridibooks Paper Pro Kitchen # �������� �غ� ����

echo =========================================
echo Ridi Paper Pro Kitchen r13_1
echo.
echo - �ȳ���
echo https://cafe.naver.com/bookbook68912/770
echo - ������ �����
echo https://github.com/limerainne/PaperProKitchen
echo =========================================

:detect_os_arch
REM default value
set ASK_WIN7_DRVTWK=0
set USE_DPINST=1
set OS=64BIT
set DRV_W8A_UTIL_EXIST=1

REM https://helloacm.com/windows-batch-script-to-detect-windows-version/
for /f "tokens=2 delims=[]" %%i in ('ver') do set VERSION=%%i
for /f "tokens=2-3 delims=. " %%i in ("%VERSION%") do set VERSION=%%i.%%j
if "%VERSION%" == "6.0" ( 
  REM echo Windows Vista
  set USE_DPINST=1
  set ASK_WIN7_DRVTWK=1
)
if "%VERSION%" == "6.1" ( 
  REM echo Windows 7
  set USE_DPINST=1
  set ASK_WIN7_DRVTWK=1
)
if "%VERSION%" == "6.2" ( 
  REM echo Windows 8
  set USE_DPINST=1
)
if "%VERSION%" == "6.3" ( 
  REM echo Windows 8.1
  set USE_DPINST=1
)
if "%VERSION%" == "10.0" ( 
  REM echo Windows 10
  set USE_DPINST=0
)

REM https://stackoverflow.com/questions/12322308/batch-file-to-check-64bit-or-32bit-os
REM http://www.robvanderwoude.com/condexec.php
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
REM echo %OS%

REM check if powershell, (pnputil), infdefaultinstall exist
where powershell > NUL
IF %ERRORLEVEL% NEQ 0 set DRV_W8A_UTIL_EXIST=0
REM where pnputil > NUL
REM IF %ERRORLEVEL% NEQ 0 set DRV_W8A_UTIL_EXIST=0
where infdefaultinstall > NUL
IF %ERRORLEVEL% NEQ 0 set DRV_W8A_UTIL_EXIST=0



REM DEBUG
REM goto 4_2_choose_image
REM goto 6_wait_for_the_job


:0_enable_win7_driver_friendly_tweak

if %ASK_WIN7_DRVTWK% EQU 0 goto 0_notice_first_boot_app_install

echo ==== 0. Win7 ����̹� ��ġ ���� ���� Ʈ�� ====
echo.
echo Windows 7�� ���, ����̹� ���� ��ġ�� ���ϱ� ���� Ʈ���� Ȱ��ȭ�� �� �ֽ��ϴ�.
echo ^* ��Ʈ �̹����� ��쿡�� �ش��մϴ�. ADB�� Ȱ��ȭ�� ���� Ʈ���� ������� �ʽ��ϴ�.
echo.
echo ��Ʈ ���� ������ �ִ� ".win7" ������ ����� ��������� �ֻ��� ��ġ�� �־��ּ���.
echo.
pause

:0_notice_first_boot_app_install

echo ==== 0. ù ���� �� �� �ڵ� ��ġ ��� ====
echo.
echo ��� ���� ����ҿ� "Apps" ������ ����� �� �ȿ� ��ġ�� �� ���ϵ��� �̸� �־�θ�,
echo ��Ʈ �۾��� ��ģ �� ���� ���õ� �� ���� �۵��� �˾Ƽ� ��ġ�մϴ�.
echo.
echo * "Apps" ���� �̸��� ��ҹ��ڸ� ���� ������ּ���.
echo * �� �ڵ� ��ġ ����� �� ��° ���� ���� �� �����˴ϴ�.
echo   ^- ��ġ �۾��� ������ "Apps" ���� �ȿ� ".installed" ������ ����� �Ӵϴ�. �� ������ ������ �ڵ� ��ġ ����� �������� �ʽ��ϴ�.
echo * ����^: ADB�� ���� �̹������� ���� ����Դϴ�.
echo.


:1_install_driver
echo ==== 1. Google ADB ����̹� ��ġ ====
echo.
set DRIVER_PATH=drivers\GoogleUSBDriver
if %USE_DPINST% EQU 1 (
  REM install driver using DPINST tool
  echo DPInst ������ �̿��� ����̹��� ��ġ�մϴ�. �ƹ�Ű�� ������ ��Ÿ��
  echo ^- ������ ���� ���� â���� ���� ����� ����ϰ�
  echo ^- ��Ÿ�� DPInst ���� â�� ������ ���� �������ּ���.
  pause
  if %OS% == 32BIT (
    start /wait %DRIVER_PATH%\DPINST_x86.exe
  ) else if %OS% == 64BIT (
    start /wait %DRIVER_PATH%\DPINST_x64.exe
  )
) else (
  REM install driver using pnputil + powershell to elevate
  REM https://stackoverflow.com/questions/22496847/installing-a-driver-inf-file-from-command-line
  REM 'pnputil -i -a <PATH_TO_DRIVER_INF>
  REM => it seems not reliable...

  REM install driver using 'infdefaultinstall' same as right click -> install
  REM 'infdefaultinstall' <path/to/inf>
  
  if %DRV_W8A_UTIL_EXIST% == 1 (
    echo ����̹��� ��ġ�մϴ�. �ƹ�Ű�� ������ ��Ÿ��..
    echo ^- ������ ���� ���� â^(^"INF Default Install^"^)���� ���� ����� ����� ��
    echo ^- ��� �� ��Ÿ�� ��ġ �Ϸ� �޽����� Ȯ���ϼ���.
    pause
    REM powershell -command "start-process cmd -argumentlist '/c','pnputil','-i','-a','%cd%\%DRIVER_PATH%\android_winusb.inf','&','pause' -verb runas -wait"
    infdefaultinstall "%cd%\%DRIVER_PATH%\android_winusb.inf"
  ) else (
    echo ���� ���� Ž���� â���� ����̹��� ���� ��ġ�� �ּ���.
    echo android_winusb.inf ���Ͽ��� ������ Ŭ�� ^> ��ġ
    
    start /wait explorer %cd%\%DRIVER_PATH%
    
    echo ��ġ�� ��ġ�̴ٸ� ��� �������ּ���.
    pause
  )
)
REM NOTE ��ȣ¦ �� ���� ��...

echo.
echo Ȥ�� ����̹� ��ġ�� �ٽ� �õ��ؾ� �ϳ���?
echo �׷��ٸ� Y�� �Է��ϰ� ���� Ű��, ���� �ܰ�� ������ ���� Ű�� ��������.

set AREYOUSURE=N
SET /P AREYOUSURE=�ٽ� ��ġ�ұ��? [Y/[N]]: 
echo.
IF /I "!AREYOUSURE!" EQU "Y" GOTO 1_install_driver

echo.


:2_start_devmgmt
echo ==== 2. ��ġ ������ ����α� ====
echo.
echo �� ��Ÿ�� ��ġ ������ â���� ��ġ ���� �ν� ���θ� Ȯ���ϼ���.
echo ��ġ ������ â�� ���� ���ð� ������ ���� ������ �״�� �ξ� �ּ���.
echo.
echo * â�� �����̴��� �ٽ� ��� �� �ֽ��ϴ�:
echo ^- ��Ʈ ������ ��� �ִ� "_open_devmgmt.cmd" ����
echo ^- ���� ��ư ������ Ŭ�� ^> "��ġ ������" ����
echo ^- [����] ^> [����] â�� "devmgmt.msc" �Է� �� [Ȯ��] ��ư Ŭ��
start devmgmt.msc
pause

echo.


:3_shutdown_device
echo ==== 3. ��� ���� ���� ====
echo.
echo ��⸦ USB ���̺�� PC�� �����صμ���. ��Ȱ�� �ν��� ���� ������ �����մϴ�:
echo ^- ���� USB ���̺�: ���� ����, �޴��� ������ ��ǰ, ...
echo ^- PC�� ���� ���� (USB ��� ���), ����ũž�̸� �޸� ��Ʈ
echo.
echo ��Ⱑ ���� ���¿��� ���� ��ư�� �� ���� ��� ���� �޴��� ���� [Ȯ��]�� ���� ��� ������ ������.
echo.
pause

echo.


:4_reboot_into_fastboot
echo ==== 4. Fastboot ���� ��� ���� ====
echo.
echo ���� ���� ��ư �� ���� ��ư�� ��� ��� ���� ��ư�� ���ÿ� ������ �輼��.
echo ���� ��ư ������ ���� LED�� ��� ���� �ʷϺ��̾��ٰ� ������ �Ͼ������ �ٲ�� �� ��ư���� ���� ������.
echo.
pause

echo.


:5_boot_with_image
echo ==== 5. ��Ʈ �̹����� ���� ====
echo.
echo ������� ��ũ������ ����ϰ� ��ġ �����ڿ� ��Ⱑ �νĵǾ�����? �׷��� �ʴٸ�,
echo ^- USB ���̺��� �ٲ㺸�ų�,
echo ^- PC�� �ٸ� USB ��Ʈ�� ����� ������.

:5_1_fastboot_devices
echo.
echo -- Fastboot ���α׷��� �ν��� ��� ��� --
echo ^> fastboot devices
fastboot devices
echo.

echo �� ��Ͽ� ��Ⱑ �ֳ���? ����Ϸ��� Y�� �Է��ϰ� ���� Ű��, ����� ���ΰ�ġ���� ���� Ű�� ��������.

set AREYOUSURE=N
SET /P AREYOUSURE=��� �����ұ��? [Y/[N]]: 
echo.
IF /I "!AREYOUSURE!" NEQ "Y" GOTO 5_1_fastboot_devices

:5_2_choose_image
echo -- ����� �� �ִ� ��Ʈ �̹��� --
echo 1. ��Ʈ + �⺻ �� ��ġ
echo 2. ��Ʈ + �ʿ��� �ּ� �۸� ��ġ (����ƮŰ, �� ����)
echo 3. ��Ʈ�� ����
echo ---
echo 4. ADB�� Ȱ��ȭ (������Ʈ �� ADB ���� ����)
echo.

set RECV_IMAGE=0
SET /P RECV_IMAGE=����� �̹��� ��ȣ�� �Է��ϰ� ���� Ű�� �������� [1-4]: 
echo.
IF /I "%RECV_IMAGE%" GEQ "5" GOTO 5_2_choose_image
IF /I "%RECV_IMAGE%" LEQ "0" GOTO 5_2_choose_image

set RECV_IMAGE_PATH=images
if /I "%RECV_IMAGE%" == "1" (
set RECV_IMAGE_PATH=%RECV_IMAGE_PATH%/openlib_r13_full.img
) else if /I "%RECV_IMAGE%" == "2" (
set RECV_IMAGE_PATH=%RECV_IMAGE_PATH%/openlib_r13_light.img
) else if /I "%RECV_IMAGE%" == "3" (
set RECV_IMAGE_PATH=%RECV_IMAGE_PATH%/openlib_r13_basic.img
) else if /I "%RECV_IMAGE%" == "4" (
set RECV_IMAGE_PATH=%RECV_IMAGE_PATH%/open_adb_only_r1.img
)

echo ������ �̹����� �³���? �´ٸ� Y�� �Է��ϰ� ���� Ű��, �ƴ϶�� ���� Ű�� ���� �ٽ� �����ϼ���.
echo ^# !RECV_IMAGE!�� �̹���
echo ^> !RECV_IMAGE_PATH!
echo.

set AREYOUSURE=N
SET /P AREYOUSURE=��� �����ұ��? [Y/[N]]: 
echo.
IF /I "!AREYOUSURE!" NEQ "Y" GOTO 5_2_choose_image

:5_3_fastboot_boot_with_chosen_image

echo ^> fastboot boot %RECV_IMAGE_PATH%
fastboot boot %RECV_IMAGE_PATH%
echo.

echo 'downloading', 'booting', 'finished' �޽����� ���ʷ� ������? �׷��� �ʾƼ� �ٽ� �õ��Ϸ��� Y�� �Է��ϰ� ���� Ű��, �������� �Ѿ���� ���� Ű�� ��������.
set AREYOUSURE=N
SET /P AREYOUSURE=Fastboot ����� �ٽ� �������? [Y/[N]]: 
echo.
IF /I "!AREYOUSURE!" EQU "Y" GOTO 5_3_fastboot_boot_with_chosen_image


:6_wait_for_the_job
echo ==== 6. ���� ��ٷ��ּ��� ====
echo.
echo ��� ȭ���� ������ ��, ������ �̹����� ���� ��� �Ʒ��� ���� ȭ���� ǥ�õ� �� (ȭ�� ǥ�� �� �ִ� 1�� �ҿ�)
echo.
echo   ^- ��Ʈ �̹���^: ������Ʈ ��Ű�� ��ġ ȭ�� ^+ �ΰ� �� �� �׸� ^+ '��������' ����
echo   ^- ADB �̹���^: ȭ�� ���� ���� 'recovery' �޴� �۾�
echo.
echo ȭ���� �ٽ� �����̰� ���� �ΰ� �߸鼭 ���� ���õ˴ϴ�.
echo.
echo �۾� �Ϸ� �� ��Ⱑ ���� ���õǾ� ���� �� ���� ȭ���� ǥ�õǾ�����?
echo ���� �ƹ� Ű�� ���� ������ �ܰ�� �Ѿ�ּ���.
pause

echo.

:7_check_for_adb_recognization
echo ==== 7. ADB �ν� ���� ====
echo.
echo ������ �������� ADB ������ �ִٸ� ���� �����ϰ�, �ٽ� �����մϴ�.
adb kill-server > NUL 2>&1
adb start-server

echo.
echo -- ADB ���α׷��� �ν��� ��� ��� --
adb devices
echo.

echo �� ��Ͽ� ��Ⱑ ��Ÿ���� �ʴ� ���,
echo ^- ��ġ �����ڸ� Ȯ���� ���� ��Ⱑ ���� ��ġ���� ���� ���,
echo    ^-^> ��ġ �����ڿ��� ����̹��� ���� ��ġ�ϼ���.
echo ^- ��ġ �����ڿ����� ���� �νĵ����� �� ��Ͽ� ���� �ʴ� ���,
echo    ^-^> ��Ʈ ���� ������ �ִ� "_add_vendor_to_adb_usb_ini.cmd" ������ �����ϼ���.
echo.
echo �� �׸� ��Ⱑ �ֳ���? ����Ϸ��� Y�� �Է��ϰ� ���� Ű��, ����� ���ΰ�ġ���� ���� Ű�� ��������.

set AREYOUSURE=N
SET /P AREYOUSURE=��� �����ұ��? [Y/[N]]: 
echo.
IF /I "!AREYOUSURE!" EQU "Y" GOTO finish

goto 7_check_for_adb_recognization

:finish

echo �۾��� ��� ���� �� �����ϴ�. â�� �����ŵ� �����ϴ�.
echo.

cmd /K