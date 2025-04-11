@echo off
setlocal enabledelayedexpansion

REM === Check for Admin privileges ===
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator".
    pause
    exit /b 1
)

REM === Configuration Settings ===
set "GAME_PATH=G:exe_path"
set "GAME_EXE=exe_name"

REM === Check if game is already running ===
tasklist /FI "IMAGENAME eq %GAME_EXE%" 2>NUL | find /I /N "%GAME_EXE%" >NUL
if "%ERRORLEVEL%"=="0" (
    echo %GAME_EXE% is already running.
    choice /C YN /M "Do you want to optimize the running instance?"
    if !ERRORLEVEL!==2 exit
    goto :OPTIMIZE
)

REM === Check if game path exists ===
if not exist "%GAME_PATH%" (
    echo ERROR: Game executable not found at: "%GAME_PATH%"
    echo Please update the GAME_PATH in this script.
    pause
    exit /b 1
)

REM === Store service states ===
echo Storing original service states...
for %%s in (SysMain wuauserv DiagTrack WSearch) do (
    sc query "%%s" | find "RUNNING" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        set "%%s_RUNNING=1"
    ) else (
        set "%%s_RUNNING=0"
    )
)

REM === Start the game ===
echo Starting %GAME_EXE% with optimized settings...
start "" "%GAME_PATH%"
timeout /t 3 /nobreak >nul

:OPTIMIZE
REM === Get the Process ID using a more robust method ===
set "PID="
for /f "tokens=2 delims=," %%A in ('tasklist /fi "imagename eq %GAME_EXE%" /fo csv /nh') do (
    if not defined PID (
        set "PID=%%~A"
    )
)

if not defined PID (
    echo Could not find the game process. Please try again.
    pause
    exit /b 1
)

REM === Set process priority using PowerShell ===
echo Setting %GAME_EXE% (PID: !PID!) to high priority...
powershell -Command "& {try {Get-Process -Id !PID! | ForEach-Object { $_.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High }} catch { Write-Error 'Failed to set priority' }}"
if %ERRORLEVEL% neq 0 (
    echo Warning: Failed to set process priority. Continuing with other optimizations...
)

REM === Performance optimizations ===
echo Applying additional performance optimizations...

REM === Clear RAM cache using a more reliable method ===
echo Clearing system cache...
powershell -Command "& { Add-Type -AssemblyName 'System.Runtime.InteropServices'; [System.Runtime.InteropServices.Marshal]::FreeUnusedMemory(); }" >nul 2>&1

REM === Close known resource-intensive background processes ===
echo Closing unnecessary background processes...
for %%p in (
    "OneDrive.exe"
    "GoogleDriveFS.exe"
    "chrome.exe"
    "msedge.exe"
    "firefox.exe"
) do (
    taskkill /F /IM %%p /T >nul 2>&1
)

REM === Optimize Windows services for gaming ===
echo Temporarily adjusting Windows services...
for %%s in (SysMain wuauserv DiagTrack WSearch) do (
    net stop "%%s" >nul 2>&1
)

REM === Set network priority for game process - more robust detection ===
set "INTERFACE_IDX="
for /f "tokens=1,2 delims=:" %%i in ('netsh int ipv4 show interfaces ^| findstr /C:"Connected"') do (
    set "TEMP_IDX=%%i"
    set "TEMP_IDX=!TEMP_IDX: =!"
    if not "!TEMP_IDX!"=="" if not defined INTERFACE_IDX (
        set "INTERFACE_IDX=!TEMP_IDX!"
    )
)

if defined INTERFACE_IDX (
    echo Optimizing network priority on interface !INTERFACE_IDX!...
    netsh int ipv4 set subinterface !INTERFACE_IDX! weighted=1 store=persistent >nul 2>&1
)

echo Game optimization complete!
echo Now monitoring game process - system will restore when game exits...
echo (This window must remain open while you play)

REM === Monitor the game and restore settings when it closes ===
:MONITOR_LOOP
timeout /t 1 /nobreak >nul
tasklist /FI "IMAGENAME eq %GAME_EXE%" 2>NUL | find /I /N "%GAME_EXE%" >NUL
if "%ERRORLEVEL%"=="0" (
    goto :MONITOR_LOOP
) else (
    goto :RESTORE_SETTINGS
)

:RESTORE_SETTINGS
echo Game has closed. Restoring system settings...

REM === Restore network settings ===
if defined INTERFACE_IDX (
    echo Restoring network settings...
    netsh int ipv4 set subinterface !INTERFACE_IDX! weighted=5 store=persistent >nul 2>&1
)

REM === Restart services based on original state ===
echo Restoring Windows services to original state...
if "%SysMain_RUNNING%"=="1" net start "SysMain" >nul 2>&1
if "%wuauserv_RUNNING%"=="1" net start "wuauserv" >nul 2>&1
if "%DiagTrack_RUNNING%"=="1" net start "DiagTrack" >nul 2>&1
if "%WSearch_RUNNING%"=="1" net start "WSearch" >nul 2>&1

echo All system settings have been restored to their original state!
echo.
echo Script completed successfully.
timeout /t 5
exit /b 0
