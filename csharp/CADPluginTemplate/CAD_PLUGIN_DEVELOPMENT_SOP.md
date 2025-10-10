# CAD插件开发详细SOP操作手册

**适用人员**: 任何AI助手或开发人员
**版本**: 1.0
**更新日期**: 2025-10-09
**目标环境**: AutoCAD 2026 + .NET 8.0-windows

---

## 📋 目录
1. [环境准备](#环境准备)
2. [创建新项目](#创建新项目)
3. [项目配置](#项目配置)
4. [代码开发](#代码开发)
5. [构建和测试](#构建和测试)
6. [部署到AutoCAD](#部署到autocad)
7. [常见问题排查](#常见问题排查)
8. [项目模板使用](#项目模板使用)

---

## 🛠️ 环境准备

### 1.1 系统要求检查
```bash
# 检查Windows版本（必须是Windows）
winver

# 检查.NET SDK版本
dotnet --version
# 应该显示8.0或更高版本
```

### 1.2 安装.NET 8.0 SDK
**如果尚未安装.NET 8.0：**
1. 访问 https://dotnet.microsoft.com/download/dotnet/8.0
2. 下载并安装".NET 8.0 SDK"
3. 重新打开命令行验证安装：
```bash
dotnet --version
```

### 1.3 验证AutoCAD 2026安装
**确认以下文件存在：**
```
C:\Program Files\Autodesk\AutoCAD 2026\AcCoreMgd.dll
C:\Program Files\Autodesk\AutoCAD 2026\AcDbMgd.dll
C:\Program Files\Autodesk\AutoCAD 2026\AcMgd.dll
```

### 1.4 开发工具安装
**推荐使用：**
- Visual Studio 2022（推荐）
- Visual Studio Code（备选）

---

## 🚀 创建新项目

### 2.1 方法一：使用模板脚本（推荐）

#### 步骤1：定位到模板目录
```bash
cd C:\Users\TIAN\Documents\2025\September\Lib\CADPluginTemplate
```

#### 步骤2：运行创建脚本
```bash
create_project.bat
```

#### 步骤3：按提示输入信息
```
请输入项目名称: MyCADPlugin
请输入命名空间 (默认: MyCADPlugin): MyCADPlugin
请输入作者名称: YourName
```

#### 步骤4：验证项目创建
```bash
# 进入新创建的项目目录
cd MyCADPlugin

# 查看项目文件
dir
# 应该看到：
# MyCADPlugin.csproj
# MyCADPluginCommands.cs
# Properties/
# README.md
```

### 2.2 方法二：手动创建项目

#### 步骤1：创建项目目录
```bash
mkdir MyNewCADPlugin
cd MyNewCADPlugin
```

#### 步骤2：创建项目配置文件
创建文件 `MyNewCADPlugin.csproj`：
```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0-windows</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <UseWindowsForms>true</UseWindowsForms>
    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>
    <PlatformTarget>x64</PlatformTarget>
    <OutputType>Library</OutputType>
    <EnableWindowsTargeting>true</EnableWindowsTargeting>
  </PropertyGroup>

  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">
    <DebugType>full</DebugType>
    <DebugSymbols>true</DebugSymbols>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
  </PropertyGroup>

  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|x64'">
    <DebugType>pdbonly</DebugType>
    <Optimize>true</Optimize>
    <DefineConstants>TRACE</DefineConstants>
  </PropertyGroup>

  <ItemGroup>
    <Reference Include="AcCoreMgd">
      <HintPath>C:\Program Files\Autodesk\AutoCAD 2026\AcCoreMgd.dll</HintPath>
      <Private>False</Private>
    </Reference>
    <Reference Include="AcDbMgd">
      <HintPath>C:\Program Files\Autodesk\AutoCAD 2026\AcDbMgd.dll</HintPath>
      <Private>False</Private>
    </Reference>
    <Reference Include="AcMgd">
      <HintPath>C:\Program Files\Autodesk\AutoCAD 2026\AcMgd.dll</HintPath>
      <Private>False</Private>
    </Reference>
  </ItemGroup>

</Project>
```

#### 步骤3：创建Properties目录和AssemblyInfo.cs
```bash
mkdir Properties
```

创建文件 `Properties\AssemblyInfo.cs`：
```csharp
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

[assembly: AssemblyTitle("CAD Extension Plugin")]
[assembly: AssemblyDescription("AutoCAD .NET API Extension Plugin")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("")]
[assembly: AssemblyProduct("MyNewCADPlugin")]
[assembly: AssemblyCopyright("Copyright ©  2025")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

[assembly: ComVisible(false)]
[assembly: Guid("12345678-1234-1234-1234-123456789012")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
```

#### 步骤4：创建主代码文件
创建文件 `MyNewCADPluginCommands.cs`：
```csharp
using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.AutoCAD.Geometry;
using AcApp = Autodesk.AutoCAD.ApplicationServices.Application;

namespace MyNewCADPlugin
{
    public class MyNewCADPluginCommands
    {
        [CommandMethod("HelloPlugin")]
        public void HelloPlugin()
        {
            Document doc = AcApp.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;

            ed.WriteMessage("\nHello from My CAD Plugin!");
        }
    }

    public class MyNewCADPluginExtension : IExtensionApplication
    {
        public void Initialize()
        {
            Editor ed = AcApp.DocumentManager.MdiActiveDocument.Editor;
            ed.WriteMessage("\nCAD插件已加载！");
            ed.WriteMessage("\n可用命令: HelloPlugin");
        }

        public void Terminate()
        {
            // 插件卸载时执行
        }
    }
}
```

---

## ⚙️ 项目配置

### 3.1 验证项目配置
```bash
# 确保项目配置正确
dotnet build
```

**预期输出：**
```
MSBuild version 17.x.x.x
  确定项目...
  所有项目均是最新的，无法还原。
  MyNewCADPlugin -> C:\path\to\MyNewCADPlugin\bin\Debug\net8.0-windows\MyNewCADPlugin.dll

已成功生成。
```

### 3.2 检查AutoCAD DLL引用
```bash
# 检查AutoCAD DLL是否存在
dir "C:\Program Files\Autodesk\AutoCAD 2026\Ac*.dll"
```

**必须找到以下文件：**
- AcCoreMgd.dll
- AcDbMgd.dll
- AcMgd.dll

---

## 💻 代码开发

### 4.1 基础命令结构
每个CAD命令都遵循以下结构：

```csharp
[CommandMethod("命令名")]
public void 命令名()
{
    // 1. 获取文档和编辑器
    Document doc = AcApp.DocumentManager.MdiActiveDocument;
    Editor ed = doc.Editor;

    // 2. 验证文档状态
    if (doc == null || ed == null)
    {
        ed.WriteMessage("\n无法获取当前文档！");
        return;
    }

    try
    {
        // 3. 执行命令逻辑
        ed.WriteMessage("\n命令执行中...");

        // 4. 你的具体代码
        // ...

        ed.WriteMessage("\n命令执行完成！");
    }
    catch (Exception ex)
    {
        ed.WriteMessage($"\n错误: {ex.Message}");
    }
}
```

### 4.2 用户输入处理
```csharp
// 获取点输入
PromptPointResult ppr = ed.GetPoint("\n请选择一个点: ");
if (ppr.Status != PromptStatus.OK) return;
Point3d selectedPoint = ppr.Value;

// 获取距离输入
PromptDistanceOptions pdo = new PromptDistanceOptions("\n请输入距离: ");
pdo.UseBasePoint = true;
pdo.BasePoint = selectedPoint;
PromptDoubleResult pdr = ed.GetDistance(pdo);
if (pdr.Status != PromptStatus.OK) return;
double distance = pdr.Value;

// 获取字符串输入
PromptStringOptions pso = new PromptStringOptions("\n请输入文字: ");
PromptResult pr = ed.GetString(pso);
if (pr.Status != PromptStatus.OK) return;
string text = pr.StringResult;
```

### 4.3 图形对象创建
```csharp
// 获取数据库和事务
Database db = doc.Database;
using (Transaction trans = db.TransactionManager.StartTransaction())
{
    try
    {
        // 打开当前空间（模型空间或图纸空间）
        BlockTableRecord? btr = trans.GetObject(db.CurrentSpaceId, OpenMode.ForWrite) as BlockTableRecord;
        if (btr == null)
        {
            ed.WriteMessage("\n无法获取当前空间！");
            return;
        }

        // 创建直线
        Line line = new Line(new Point3d(0, 0, 0), new Point3d(10, 10, 0));
        btr.AppendEntity(line);
        trans.AddNewlyCreatedDBObject(line, true);

        // 创建圆
        Circle circle = new Circle(new Point3d(0, 0, 0), Vector3d.ZAxis, 5.0);
        btr.AppendEntity(circle);
        trans.AddNewlyCreatedDBObject(circle, true);

        // 创建文字
        DBText text = new DBText();
        text.Position = new Point3d(0, 15, 0);
        text.Height = 2.5;
        text.TextString = "示例文字";
        btr.AppendEntity(text);
        trans.AddNewlyCreatedDBObject(text, true);

        // 提交事务
        trans.Commit();
        ed.WriteMessage("\n图形对象创建成功！");
    }
    catch (Exception ex)
    {
        trans.Abort();
        ed.WriteMessage($"\n创建失败: {ex.Message}");
    }
}
```

### 4.4 图层操作
```csharp
public void CreateLayer()
{
    Document doc = AcApp.DocumentManager.MdiActiveDocument;
    Database db = doc.Database;
    Editor ed = doc.Editor;

    using (Transaction trans = db.TransactionManager.StartTransaction())
    {
        // 打开图层表
        LayerTable lt = trans.GetObject(db.LayerTableId, OpenMode.ForRead) as LayerTable;

        // 检查图层是否已存在
        if (!lt.Has("我的图层"))
        {
            // 升级为写入模式
            lt.UpgradeOpen();

            // 创建新图层
            LayerTableRecord ltr = new LayerTableRecord();
            ltr.Name = "我的图层";
            ltr.Color = Color.FromColorIndex(ColorMethod.ByAci, 1); // 红色

            // 添加到图层表
            lt.Add(ltr);
            trans.AddNewlyCreatedDBObject(ltr, true);

            ed.WriteMessage("\n图层'我的图层'创建成功！");
        }
        else
        {
            ed.WriteMessage("\n图层'我的图层'已存在！");
        }

        trans.Commit();
    }
}
```

---

## 🔨 构建和测试

### 5.1 构建项目
```bash
# 清理项目
dotnet clean

# 构建 Debug 版本
dotnet build --configuration Debug

# 构建 Release 版本
dotnet build --configuration Release
```

### 5.2 检查输出文件
```bash
# 检查生成的文件
dir "bin\Debug\net8.0-windows"
```

**应该看到以下文件：**
- 项目名称.dll（主程序集）
- 项目名称.pdb（调试信息）
- 项目名称.deps.json（依赖信息）

### 5.3 验证DLL是否有效
```bash
# 使用.NET工具检查DLL
dotnet "bin\Debug\net8.0-windows\项目名称.dll" --version
# 如果DLL有效，不会报错
```

---

## 📦 部署到AutoCAD

### 6.1 方法一：使用NETLOAD命令

#### 步骤1：启动AutoCAD 2026
双击桌面上的AutoCAD 2026图标

#### 步骤2：打开命令行
在AutoCAD底部的命令行中输入：
```
NETLOAD
```

#### 步骤3：选择DLL文件
1. 在弹出的文件选择对话框中，导航到项目目录
2. 进入 `bin\Debug\net8.0-windows` 文件夹
3. 选择你的项目DLL文件
4. 点击"打开"

#### 步骤4：验证加载成功
如果加载成功，命令行会显示：
```
CAD插件已加载！
可用命令: 你的命令名
```

### 6.2 方法二：自动加载配置

#### 创建加载配置文件
在AutoCAD支持路径下创建 `你的项目名.lsp` 文件：

```lisp
;; 自动加载CAD插件
(if (findfile "你的项目名.dll")
    (command "NETLOAD" (findfile "你的项目名.dll"))
    (princ "\n无法找到插件文件: 你的项目名.dll")
)
(princ)
```

### 6.3 测试插件功能
在AutoCAD命令行中输入你的命令名，例如：
```
HelloPlugin
```

**预期输出：**
```
Hello from My CAD Plugin!
```

---

## 🔧 常见问题排查

### 7.1 构建问题

#### 问题1：找不到AutoCAD DLL
**错误信息：**
```
error MSB0001: 内部编译器错误
```

**解决方案：**
1. 确认AutoCAD 2026已正确安装
2. 检查路径 `C:\Program Files\Autodesk\AutoCAD 2026\` 是否存在
3. 确认以下文件存在：
   - AcCoreMgd.dll
   - AcDbMgd.dll
   - AcMgd.dll

#### 问题2：WindowsBase版本冲突
**错误信息：**
```
warning MSB3277: 发现无法解析的"WindowsBase"的不同版本之间存在冲突
```

**解决方案：**
这是正常警告，不会影响功能。可以忽略或添加到项目文件：
```xml
<PropertyGroup>
    <AutoGenerateBindingRedirects>true</AutoGenerateBindingRedirects>
</PropertyGroup>
```

#### 问题3：目标框架错误
**错误信息：**
```
error NETSDK1136: 如果使用 Windows 窗体或 WPF，则必须将目标平台设置为 Windows
```

**解决方案：**
确保项目文件中的TargetFramework为：
```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

### 7.2 运行时问题

#### 问题1：插件无法加载
**现象：**
- NETLOAD命令执行后无反应
- 命令行显示错误信息

**解决方案：**
1. 检查DLL是否在正确路径
2. 确认.NET 8.0运行时已安装
3. 检查AutoCAD版本是否为2026
4. 尝试以管理员身份运行AutoCAD

#### 问题2：命令无法执行
**现象：**
- 插件加载成功，但命令无效
- 命令行显示"未知命令"

**解决方案：**
1. 检查CommandMethod属性的拼写
2. 确认类和方法的访问修饰符为public
3. 检查是否有编译错误
4. 重新编译并加载插件

#### 问题3：空引用异常
**现象：**
- 命令执行时崩溃
- 错误信息包含"NullReferenceException"

**解决方案：**
1. 添加空值检查：
```csharp
Document doc = AcApp.DocumentManager.MdiActiveDocument;
if (doc == null) return;
```

2. 检查事务处理：
```csharp
BlockTableRecord? btr = trans.GetObject(db.CurrentSpaceId, OpenMode.ForWrite) as BlockTableRecord;
if (btr == null) return;
```

### 7.3 调试技巧

#### 方法1：使用消息输出调试
```csharp
ed.WriteMessage($"\n调试信息: 变量值 = {变量值}");
```

#### 方法2：使用日志文件
```csharp
public void LogToFile(string message)
{
    string logPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "cad_plugin_log.txt");
    File.AppendAllText(logPath, $"{DateTime.Now}: {message}\n");
}
```

#### 方法3：使用Visual Studio调试
1. 在Visual Studio中打开项目
2. 设置AutoCAD为启动程序
3. 在代码中设置断点
4. 按F5开始调试

---

## 📋 项目模板使用

### 8.1 模板目录说明
```
CADPluginTemplate/
├── CE.csproj                    # 项目配置模板
├── Class1.cs                    # 代码模板（包含占位符）
├── Properties/
│   └── AssemblyInfo.cs          # 程序集信息模板
├── TEMPLATE_README.md           # 技术文档
├── create_project.bat           # 自动创建脚本
├── README.md                    # 基础说明
└── CAD_PLUGIN_DEVELOPMENT_SOP.md # 本SOP文档
```

### 8.2 占位符说明
在模板代码中，以下占位符需要替换：

| 占位符 | 说明 | 示例 |
|--------|------|------|
| `YourNamespace` | 命名空间 | `MyCADPlugin` |
| `YourCommands` | 命令类名 | `MyCADPluginCommands` |
| `YourExtensionApplication` | 扩展应用类名 | `MyCADPluginExtension` |
| `YourCommand` | 示例命令名 | `HelloPlugin` |

### 8.3 自动脚本使用
```bash
# 运行自动创建脚本
create_project.bat

# 按提示输入：
# 项目名称: MyPlugin
# 命名空间: MyPlugin
# 作者名称: YourName

# 脚本会自动：
# 1. 创建项目目录
# 2. 复制模板文件
# 3. 重命名文件
# 4. 替换所有占位符
# 5. 生成README.md
```

### 8.4 手动使用模板
1. 复制整个 `CADPluginTemplate` 目录
2. 重命名为你的项目名
3. 手动替换所有文件中的占位符
4. 重命名文件：
   - `CE.csproj` → `你的项目名.csproj`
   - `Class1.cs` → `你的项目名Commands.cs`

---

## ✅ 检查清单

### 开发前检查
- [ ] .NET 8.0 SDK已安装
- [ ] AutoCAD 2026已安装
- [ ] 开发工具已安装
- [ ] 已创建项目目录

### 项目配置检查
- [ ] TargetFramework为net8.0-windows
- [ ] AutoCAD DLL引用路径正确
- [ ] 项目能成功构建
- [ ] 生成DLL文件无错误

### 代码质量检查
- [ ] 使用了正确的命名空间
- [ ] 命令方法有CommandMethod特性
- [ ] 添加了空值检查
- [ ] 使用了事务处理
- [ ] 包含错误处理

### 部署前检查
- [ ] 项目成功构建
- [ ] DLL文件存在
- [ ] 在AutoCAD中能成功加载
- [ ] 命令能正常执行
- [ ] 功能符合预期

---

## 📞 技术支持

### 常用资源
- [AutoCAD .NET API 文档](https://help.autodesk.com/view/OARX/2024/ENU/)
- [Microsoft .NET 文档](https://docs.microsoft.com/dotnet/)
- [C# 编程指南](https://docs.microsoft.com/dotnet/csharp/)

### 故障排除步骤
1. 查看错误信息
2. 对照本SOP排查
3. 检查环境和配置
4. 查阅相关文档
5. 尝试最小示例测试

---

**版本历史**
- v1.0 (2025-10-09): 初始版本，包含完整的开发流程

**注意事项**
- 本SOP专门针对AutoCAD 2026开发
- 使用前请确保环境配置正确
- 遇到问题请仔细阅读故障排除部分