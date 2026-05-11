# CAD插件开发快速参考卡

**⚡ 5分钟快速上手**

## 🎯 最常用代码片段

### 1. 基础命令模板
```csharp
[CommandMethod("你的命令名")]
public void 你的命令名()
{
    Document doc = AcApp.DocumentManager.MdiActiveDocument;
    Editor ed = doc.Editor;

    if (doc == null) return;

    try {
        ed.WriteMessage("\n你的逻辑在这里");
        // 你的代码
    }
    catch (Exception ex) {
        ed.WriteMessage($"\n错误: {ex.Message}");
    }
}
```

### 2. 创建图形对象
```csharp
using (Transaction trans = db.TransactionManager.StartTransaction())
{
    BlockTableRecord? btr = trans.GetObject(db.CurrentSpaceId, OpenMode.ForWrite) as BlockTableRecord;
    if (btr == null) return;

    // 创建直线
    Line line = new Line(startPoint, endPoint);
    btr.AppendEntity(line);
    trans.AddNewlyCreatedDBObject(line, true);

    trans.Commit();
}
```

### 3. 获取用户输入
```csharp
// 获取点
PromptPointResult ppr = ed.GetPoint("\n选择点: ");
if (ppr.Status != PromptStatus.OK) return;
Point3d point = ppr.Value;

// 获取距离
PromptDoubleResult pdr = ed.GetDistance("\n输入距离: ");
if (pdr.Status != PromptStatus.OK) return;
double distance = pdr.Value;
```

## 🔧 项目配置要点

### 必需的引用DLL
```xml
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
```

### 必需的using语句
```csharp
using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.AutoCAD.Geometry;
using AcApp = Autodesk.AutoCAD.ApplicationServices.Application;
```

## 🚀 快速部署步骤

1. **构建项目**
   ```bash
   dotnet build
   ```

2. **加载到AutoCAD**
   ```
   NETLOAD
   选择 bin\Debug\net8.0-windows\你的项目.dll
   ```

3. **测试命令**
   ```
   你的命令名
   ```

## 🆘 常见错误解决

| 错误信息 | 解决方案 |
|----------|----------|
| `NETSDK1136` | 确保TargetFramework为`net8.0-windows` |
| `找不到DLL` | 检查AutoCAD 2026安装路径 |
| `命令无效` | 检查CommandMethod拼写和类访问修饰符 |
| `NullReferenceException` | 添加空值检查 |

## 📁 模板使用

### 快速创建项目
```bash
cd CADPluginTemplate
create_project.bat
# 按提示输入项目信息
```

### 手动使用模板
1. 复制CADPluginTemplate目录
2. 替换占位符：
   - `YourNamespace` → 你的命名空间
   - `YourCommands` → 你的类名
   - `YourCommand` → 你的命令名

## 🔍 调试技巧

### 输出调试信息
```csharp
ed.WriteMessage($"\n[DEBUG] 变量值: {变量}");
```

### 检查对象状态
```csharp
if (doc == null) {
    ed.WriteMessage("\n[ERROR] 文档为空");
    return;
}
if (btr == null) {
    ed.WriteMessage("\n[ERROR] 无法获取当前空间");
    return;
}
```

---

**💡 记住：遇到问题时，首先查看详细的SOP文档：CAD_PLUGIN_DEVELOPMENT_SOP.md**