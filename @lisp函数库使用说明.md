# @lisp 函数库

### 介绍
@lisp 函数库是一个开源、共享、可云端加载的 autolisp 函数库。由像您一样热爱开源共享的爱好者所构筑并维护。可依据开放许可协议自由使用。

@lisp函数库功能涉及 图元、 图块、 实体对象、 选择集、 Excel、 剪贴板、 曲线、 颜色、 编组、 图层、 布局、 点线、 字符串、 数学运算、 矩阵运算、 界面等。更多内容持续迭代中 …

### 安装

将以下代码复制到 CAD 命令行内，回车即可开始安装 @lisp kernel。@lisp kernel（内核）包含 @lisp函数库 及 @lisp应用云 的基本管理功能。

(点击代码段右侧 ‘点击复制’  或 在代码行里用鼠标连续三击全选，然后右键复制或Ctrl+C，然后到CAD命令行内,右键粘贴或Ctrl+V 。)

```lisp
(progn(vl-load-com)(setq o"http://atlisp.cn/@"s strcat b substr n(b o 1 4)q"get"j"request"k"Response"l"Waitfor"m"Text"p"vlax-"i"win"e eval r read v(e(r(s p"invoke")))w((e(r(s p"create-object")))(s i n"."i n j".5.1")))(v w'open q o :vlax-true)(v w'send)(v w(r(s l k))1000)(e(r((e(r(s p q)))w(r(s k m))))))
```


### 快速上手：

以下命令在 CAD 命令行中执行。

```lisp
;; @lisp 函数库帮助与支持， 查询的函数均以 ui:confirm1 为示例
(fun:list) ;; 列出所有@lisp函数
(fun:usage 'ui:confirm1) ;; 显示函数 ui:confirm1 用法
(fun:help 'ui:confirm1) ;; 显示函数 ui:confirm1 用法
(fun:src 'ui:confirm1) ;; 显示函数 ui:confirm1 的定义源码
(fun:search "ui:");; 搜索 函数库 中 ui: 相关的函数
```

在 lsp 文件中的调用示例
```lisp
(require 'ui:confirm1) ;; 加载 用户确认对话框函数
(ui:confirm1 '("你家门口有两双鞋。" "一双是你的。" "另一双也是你的。" ) "是-否")
```

