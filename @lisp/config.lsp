#+title: 
* 参数配置项的定义与使用

#+BEGIN_SRC lisp 
(@:define-config 'vitaltools:projects-output "D:\\Output" "本地PDF输出目录")
(@:set-config 'vitaltools:projects-output "D:\\PDF")
(@:get-config 'vitaltools:projects-output)
(@:list-config)
#+END_SRC
说明：
** 变量定义
   (@:define-config 可供用户修改的变量名(符号)  默认值  变量说明)
** 变量设置及修改值
   (@:set-config 可供用户修改的变量名(符号)  用户设定值)
** 变量读值
   (@:get-config 可供用户修改的变量名(符号)  )
  
** 列所有的变量
   (@:list-config)
