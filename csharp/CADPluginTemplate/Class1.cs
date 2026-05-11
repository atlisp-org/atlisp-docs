using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.AutoCAD.Geometry;
using AcApp = Autodesk.AutoCAD.ApplicationServices.Application;

namespace YourNamespace
{
    public class YourCommands
    {
        [CommandMethod("YourCommand")]
        public void YourCommand()
        {
            Document doc = AcApp.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;

            // 在这里添加你的命令逻辑
            ed.WriteMessage("\nHello from your CAD Plugin!");
        }

        // 添加更多命令方法...
    }

    public class YourExtensionApplication : IExtensionApplication
    {
        public void Initialize()
        {
            Editor ed = AcApp.DocumentManager.MdiActiveDocument.Editor;
            ed.WriteMessage("\nCAD插件已加载！");
            ed.WriteMessage("\n可用命令: YourCommand");
        }

        public void Terminate()
        {
            // 插件卸载时执行
        }
    }
}
