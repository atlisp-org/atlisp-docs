
# Table of Contents

1.  [如何开发@lisp应用包](#orgbb10470)
    1.  [创建应用](#orgb524ce8)
    2.  [编译应用](#org0ce3c63)
    3.  [上传和发布应用](#org0967693)
2.  [应用包的架构组成](#orgefbd424)
3.  [包定义及开发主要函数](#org8406566)
4.  [界面：菜单及命令面板相关函数](#orgb31e5d9)
5.  [参数配置项的定义与使用](#orgc630e6e)
    1.  [变量定义](#orgf3b1e12)
    2.  [变量设置及修改值](#orgd0d36e7)
    3.  [变量读值](#org9d2d794)
    4.  [列所有的变量](#orgc7c7fff)
6.  [国际化与本地化支持](#org479cb60)
7.  [帮助及提示系统](#org70090b3)
8.  [Hello world 示例](#org41a97fe)
9.  [布署](#org87ec960)



<a id="orgbb10470"></a>

# 如何开发@lisp应用包

安装 **[@lisp开发工具](file:///package-info?name=dev-tools)** 并输入个人信息就可以使用本网开发的 **开发工具** 创建应用、编译应用、上传和发布你的应用了。

然后 点击菜单 开发工具(DevelopTools) -> 获取开发令牌 ，过程中根据提示输入用户信息及密码。如果你的 Email 和 手机号 没有被注册过的话，就可以注册新用户进行应用的创建和发布了。


<a id="orgb524ce8"></a>

## 创建应用

该功能可创建一个初始的空应用包，注意应用包的标识名(name)为全网唯一，不能与已有的应用名重复（英文标识）。

中文显示的名称(full name) 可以重复，但显示的作者不同。

**应用包的标识名(name)** 与安装的文件夹 （目录）应完全一致。创建后它们是一致的，不得更改。

英文标识名(pkg.lsp 文件中的 :name) 尽量采用有意义的单词，命令行安装时易于识别。

中文名称(pkg.lsp 文件中的 :full-name)尽量能表明功能。这个可以更改为自己中意的名称。

简介(pkg.lsp 文件中的 :description)对应用包的功能进行简述。

请记住   **应用包的标识名** 在编译和发布时需要输入。


<a id="org0ce3c63"></a>

## 编译应用

当你创建了一个应用包，并完成功能代码的编写工作之后。就可以 **编译应用** 了， **编译应用** 可以将你的开发包定义中的 :files 中的可执行文件（不含扩展名的文件） 进行编译 生成 .fas 文件。


<a id="org0967693"></a>

## 上传和发布应用

上传应用 是 将你编写的应用包上传到 **@lisp服务器** 的 **先行版数据池** 中，用于测试及公众测试 。

发布应用 是 将你编写的应用包上传到 **@lisp服务器** 的 **稳定版数据池** 中，供一般用户使用 。


<a id="orgefbd424"></a>

# 应用包的架构组成

@lisp 采用应用包的方式管理相对独立的程序。

每个包有自己的目录结构。

包目录文件结构： 

-   pkg.lsp :包定义文件
-   readme 包功能及用法说明文档。
-   包定义中指定的文件。

首先需要对自己的程序进行包定义。用于定义包的名称，作者，下载网址及组成文件等。

包定义文件命名方式为  pkg.lsp 。

如 vitaltools 包 ，其定义文件名为 pkg.lsp 

其内容示例如下:

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; @lisp 工程管理
    ;;; Author: VitalGG<vitalgg@gmail.com>
    ;;; Description: 基于 AutoLisp/VisualLisp 开发的绘图工具集
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    (@:def-pkg '((:name . "at-pm")        
    	     (:full-name . "工程管理")
    	     (:author . "vitalGG")    
    	     (:email  . "vitalgg@gmail.com")
    	     (:version . "1.0.0")    
    	     (:locale  . "CHS")       
    	     (:description . "CAD 常用工具,图层、文本、基本数学运算、批量打印、业务逻辑化管理。") 
    	     (:category . "通用") 
    	     (:tags . ("批量打印"))
    	     (:url . "http://atlisp.cn")
    	     (:files . ("tools-anti-virus"
    		       "virus.lib"
    		       "tools-contents"
    		       "tools-layer"
    		       "tools-math"
    		       "tools-text"
    		       "tukuang.dwg" ))))

在 files 点对中对应的文件列表，不带扩展名的文件均为 lsp 文件，编译上传后为 fas 文件。其它文件则需要带有扩展名，如病毒库文件 virus.lib,图框的dwg 文件等。 

如果需要安装这个包，需在 CAD 命令行 输入

    @I at-pm

或

    (@:package-install "at-pm")

即可完成下载及安装配置工作，并重新生成菜单。

CAD 在启动加载的时候会按这个文件列表加载各个 fas 文件(用户)。


<a id="org8406566"></a>

# 包定义及开发主要函数

@:def-pkg    定义包 

@:add-menu  菜单生成函数(用于在加载时生成菜单)

@:help      命令提示函数(用于运行前的功能用法提示)

@:define-config 定义包中可供使用者修改的参数。

@:set-config  使用者修改包中定义的变量。

@:get-config  取包中定义的变量的值。


<a id="orgb31e5d9"></a>

# 界面：菜单及命令面板相关函数

@lisp 可以在安装时生成相应的菜单。目前 所有的功能菜单均集中于 @lisp(A) 中。

@:add-menu 函数用于生成菜单。 

格式如下：

    (@:add-menu "子菜单" "功能名称" "(功能函数)")
    (defun 功能函数 ()
       ...
     )

示例(无参数)：

    (@:add-menu "大绘图" "附着签名" "(@:attach-sign)")
    (defun @:attach-sign ( )
       ... 
    )

示例(有参数)：

    (@:add-menu "大绘图" "插入图框" "(@:insert-tukuang \"tukuang.dwg\" @:*tukuang*)")
    (@:add-menu "变更及工程处理" "变更" "(@:insert-tukuang \"bg-tukuang.dwg\" @:*bg-tukuang*)")
    (@:add-menu "变更及工程处理" "处理方案" "(@:insert-tukuang \"fa-tukuang.dwg\" @:*fa-tukuang*)")
    
    (defun @:insert-tukuang (tk-file tk-dwg)
    ...)


<a id="orgc630e6e"></a>

# 参数配置项的定义与使用

    (@:define-config 'vitaltools:projects-output "D:\\Output" "本地PDF输出目录")
    (@:set-config 'vitaltools:projects-output "D:\\PDF")
    (@:get-config 'vitaltools:projects-output)
    (@:list-config)

说明：


<a id="orgf3b1e12"></a>

## 变量定义

(@:define-config 可供用户修改的变量名(符号)  默认值  变量说明)


<a id="orgd0d36e7"></a>

## 变量设置及修改值

(@:set-config 可供用户修改的变量名(符号)  用户设定值)


<a id="org9d2d794"></a>

## 变量读值

(@:get-config 可供用户修改的变量名(符号)  )


<a id="orgc7c7fff"></a>

## 列所有的变量

(@:list-config)


<a id="org479cb60"></a>

# 国际化与本地化支持

@lisp 支持应用包的多国语言，不同语种的CAD环境，可以加载不同的语言包，显示用户使用的语言。

在代码中使用 (\_"string") 就可以将string 作为翻译标记，生成可翻译的文件。

    (_"语言字符串")

开发者可以自行制作翻译文件，文件名为 pkgname-locale.lang 将该文件放在 @lisp/locale/ 目录下就可以实现翻译了。

**TODO** : 共享翻译 ，系统会收集未翻译的字符串，将未翻译的字符串，共享到 @lisp 网站，有翻译能力的 **使用者** 可以翻译这些内容让其他 **使用者** 使用。


<a id="org70090b3"></a>

# 帮助及提示系统

在函数定义体后跟提示内容. 在配置文件 @config.lsp 中设置提示方式。
目前有两种提示方式, 1 是命令行提示方式， 2 是 alert 提示方式。

    (defun foobar  ()
     (@:help "运行时提示该 foobar 函数的使用方法等。 ")
    ...)


<a id="org41a97fe"></a>

# Hello world 示例

包定义：
pkg.lsp :

    
    (@:def-pkg '((:name . "helloworld")
    	     (:full-name . "hello world 示例")
    	     (:author . "vitalGG")
    	     (:email  . "vitalgg@gmail.com")
    	     (:version . "1.0.0")
    	     (:description . "第一个示例。")
    	     (:url . "http://atlisp.cn")
    	     (:files . ("helloworld"))))

helloworld.lsp :

    (@:add-menu "Hello" "helloworld" "(helloworld)")
    (defun helloworld ()
      (@:help "输出hello world 到命令行及对话框提示。")
      (princ "hello world.\n")
      (alert "hello world.")
      (princ)
    )

安装 helloworld 包

    (@:package-install "helloworld")

完成后会在 菜单中出现相应的 helloworld 项。点击会执行相应的代码功能.


<a id="org87ec960"></a>

# 布署

如果你有自己的服务器， 可将 包定义的的 url 改成你自己的网址，确保 files 中的文件能从你的网址中下载。
下载地址为 **url/stable/** 下的文件。

然后把 包定义文件 pkg.lsp 分享到包数据库中即可。

