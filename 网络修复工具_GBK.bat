@echo off
chcp 936 >nul
title what?

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 请求管理员权限...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

rem ===== 语言选择 =====
:langsel
echo Choose Language
echo ^<China^> ^<English^>
echo [F] [J]
set /p lang=
if /i "%lang%"=="F" goto menu_cn
if /i "%lang%"=="J" goto menu_en
goto langsel

:menu_cn
echo ====================================================
echo  【网络修复工具】  用于教室电脑以太网连不上时自助修复
echo ====================================================
echo.
echo  选项说明：
echo     1 = 自动获取IP地址（释放旧IP / 重新获取 / 刷新DNS，并显示详情）
echo     2 = 打开“网络连接”菜单（查看/启用/禁用网卡适配器）
echo.
echo  请按键选择：  输入 1 或 2 后回车（输入 0 退出）
echo ====================================================
set /p choice=请输入选项：
if "%choice%"=="1" goto fixip
if "%choice%"=="2" goto openadapter
if "%choice%"=="0" exit
echo.
echo  [!] 输入无效，请重新选择。
pause
goto menu_cn

:menu_en
echo ====================================================
echo  [Network Repair Tool]  For classroom Ethernet issues
echo ====================================================
echo.
echo  Options:
echo     1 = Auto get IP (release / renew / flush DNS, show details)
echo     2 = Open Network Connections (view/enable/disable adapters)
echo.
echo  Press 1 or 2 then Enter (0 to exit)
echo ====================================================
set /p choice=Choose:
if "%choice%"=="1" goto fixip
if "%choice%"=="2" goto openadapter
if "%choice%"=="0" exit
echo.
echo  [!] Invalid input, please retry.
pause
goto menu_en

:fixip
echo ====================================================
echo  正在执行：自动获取IP地址 / Running: auto get IP
echo ====================================================
echo.
echo [1/3] 释放当前IP地址 / Releasing IP...
ipconfig /release
echo.
echo [2/3] 重新获取IP地址 / Renewing IP...
ipconfig /renew
echo.
echo [3/3] 刷新DNS缓存 / Flushing DNS...
ipconfig /flushdns
echo.
echo ---------- 当前IPv4详细信息 / Current IPv4 ----------
ipconfig | findstr /i "IPv4 默认网关 子网掩码 物理地址 Default Gateway Subnet Mask Physical Address"
echo ----------------------------------------
echo.
echo  判断 / Note: 169.254.x.x = 未拿到(查网线/校园网认证)   192.168.x.x / 10.x.x.x = 正常 / OK
echo.
echo  按任意键返回菜单 / Press any key to return...
pause >nul
if /i "%lang%"=="J" (goto menu_en) else (goto menu_cn)

:openadapter
echo 正在打开“网络连接”窗口 / Opening Network Connections...
start ncpa.cpl
echo 已打开，按任意键返回菜单 / Opened, press any key to return...
pause >nul
if /i "%lang%"=="J" (goto menu_en) else (goto menu_cn)
