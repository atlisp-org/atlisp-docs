@echo off
setlocal enabledelayedexpansion

echo ========================================
echo AutoCAD 插件项目创建向导
echo ========================================
echo.

set /p project_name="请输入项目名称: "
if "%project_name%"=="" (
    echo 错误: 项目名称不能为空
    pause
    exit /b 1
)

set /p namespace="请输入命名空间 (默认: %project_name%): "
if "%namespace%"=="" set namespace=%project_name%

set /p author="请输入作者名称: "

echo.
echo 正在创建项目...
echo 项目名称: %project_name%
echo 命名空间: %namespace%
echo 作者: %author%
echo.

REM 创建新项目目录
if exist "%project_name%" (
    echo 错误: 目录 "%project_name%" 已存在
    pause
    exit /b 1
)

mkdir "%project_name%"

REM 复制模板文件
xcopy "..\CADPluginTemplate" "%project_name%\" /E /I > nul

REM 修改文件名
if exist "%project_name%\CE.csproj" ren "%project_name%\CE.csproj" "%project_name%.csproj"
if exist "%project_name%\Class1.cs" ren "%project_name%\Class1.cs" "%project_name%Commands.cs"

REM 替换配置文件中的占位符
powershell -Command "(Get-Content '%project_name%\%project_name%.csproj') -replace 'CE', '%project_name%' | Set-Content '%project_name%\%project_name%.csproj'"
powershell -Command "(Get-Content '%project_name%\%project_name%Commands.cs') -replace 'YourNamespace', '%namespace%' | Set-Content '%project_name%\%project_name%Commands.cs'"
powershell -Command "(Get-Content '%project_name%\%project_name%Commands.cs') -replace 'YourCommands', '%project_name%Commands' | Set-Content '%project_name%\%project_name%Commands.cs'"
powershell -Command "(Get-Content '%project_name%\%project_name%Commands.cs') -replace 'YourCommand', 'Hello%project_name%' | Set-Content '%project_name%\%project_name%Commands.cs'"
powershell -Command "(Get-Content '%project_name%\%project_name%Commands.cs') -replace 'YourExtensionApplication', '%project_name%ExtensionApplication' | Set-Content '%project_name%\%project_name%Commands.cs'"

REM 更新AssemblyInfo.cs中的作者信息
if not "%author%"=="" (
    powershell -Command "(Get-Content '%project_name%\Properties\AssemblyInfo.cs') -replace '\"\"', '\"%author%\"' | Set-Content '%project_name%\Properties\AssemblyInfo.cs'"
)

REM 创建项目说明文件
echo # %project_name% > "%project_name%\README.md"
echo. >> "%project_name%\README.md"
echo 这是基于CAD插件模板创建的项目: %project_name% >> "%project_name%\README.md"
echo. >> "%project_name%\README.md"
echo ## 快速开始 >> "%project_name%\README.md"
echo 1. 在Visual Studio中打开 `%project_name%.csproj` >> "%project_name%\README.md"
echo 2. 修改 `%project_name%Commands.cs` 中的命令逻辑 >> "%project_name%\README.md"
echo 3. 运行 `dotnet build` 构建项目 >> "%project_name%\README.md"
echo 4. 在AutoCAD中使用 `NETLOAD` 加载生成的DLL >> "%project_name%\README.md"
echo. >> "%project_name%\README.md"
echo ## 可用命令 >> "%project_name%\README.md"
echo - `Hello%project_name%` - 示例命令 >> "%project_name%\README.md"

echo.
echo ========================================
echo 项目创建完成！
echo ========================================
echo.
echo 项目位置: %cd%\%project_name%
echo.
echo 下一步操作:
echo 1. 在Visual Studio中打开 %project_name%.csproj
echo 2. 修改 %project_name%Commands.cs 中的命令逻辑
echo 3. 运行 dotnet build 构建项目
echo 4. 在AutoCAD中使用 NETLOAD 加载生成的DLL
echo.

pause