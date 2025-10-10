# CAD插件开发模板

这是一个基于AutoCAD 2026 .NET API的开发模板，使用.NET 8.0-windows框架。

## 🚀 快速开始

### 1. 修改项目配置
- **重命名项目文件**：将 `CE.csproj` 重命名为你的项目名称
- **修改命名空间**：在 `Class1.cs` 中将 `YourNamespace` 改为你的项目命名空间
- **更新类名**：将 `YourCommands` 和 `YourExtensionApplication` 改为你想要的类名

### 2. 自定义命令
在 `YourCommands` 类中添加你的CAD命令：
```csharp
[CommandMethod("你的命令名")]
public void 你的命令名()
{
    Document doc = AcApp.DocumentManager.MdiActiveDocument;
    Editor ed = doc.Editor;

    // 你的命令逻辑
    ed.WriteMessage("\n你的命令已执行！");
}
```

### 3. 构建项目
```bash
dotnet build
```

### 4. 在AutoCAD中加载插件
1. 打开AutoCAD 2026
2. 输入 `NETLOAD` 命令
3. 选择生成的DLL文件（在 `bin\Debug\net8.0-windows\` 目录）
4. 使用你的命令

## 📁 项目结构

```
项目根目录/
├── CE.csproj                 # 项目配置文件
├── Class1.cs                 # 主要代码文件（需要重命名）
├── Properties/
│   └── AssemblyInfo.cs       # 程序集信息
├── bin/                      # 输出目录（构建后生成）
├── obj/                      # 构建缓存（构建后生成）
└── TEMPLATE_README.md        # 本说明文档
```

## 🔧 环境要求

- **.NET 8.0** 或更高版本
- **AutoCAD 2026**
- **Visual Studio 2022** 或 **VS Code**

## 📚 AutoCAD API 常用类

### 基础类
- `Document` - 当前文档
- `Database` - 图形数据库
- `Editor` - 命令行编辑器
- `Transaction` - 事务处理

### 几何类
- `Point3d` - 三维点
- `Vector3d` - 三维向量
- `Line` - 直线
- `Circle` - 圆
- `Arc` - 圆弧

### 图形对象
- `BlockTableRecord` - 块表记录（图层、模型空间等）
- `Entity` - 图形实体基类

## 💡 开发提示

### 事务处理最佳实践
```csharp
using (Transaction trans = db.TransactionManager.StartTransaction())
{
    try
    {
        // 你的操作
        trans.Commit();
    }
    catch (Exception ex)
    {
        trans.Abort();
        ed.WriteMessage($"\n错误: {ex.Message}");
    }
}
```

### 获取用户输入
```csharp
// 获取点
PromptPointResult ppr = ed.GetPoint("\n选择点: ");
if (ppr.Status == PromptStatus.OK)
{
    Point3d point = ppr.Value;
}

// 获取距离
PromptDoubleResult pdr = ed.GetDistance("\n输入距离: ");
if (pdr.Status == PromptStatus.OK)
{
    double distance = pdr.Value;
}
```

### 创建图形对象
```csharp
// 创建直线
Line line = new Line(startPoint, endPoint);

// 创建圆
Circle circle = new Circle(center, Vector3d.ZAxis, radius);

// 添加到数据库
btr.AppendEntity(entity);
trans.AddNewlyCreatedDBObject(entity, true);
```

## 🎯 下一步

1. 学习更多AutoCAD API
2. 添加用户界面（如果有需要）
3. 创建更复杂的CAD操作
4. 添加错误处理和日志记录

祝开发愉快！ 🎉