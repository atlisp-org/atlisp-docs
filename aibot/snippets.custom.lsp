(exit)  
;;; 说明：
;;; 4个分号开头的行是每个代码片段的开始，分号后为代码片段的key，
;;; 代码片段内容为当前key到下一个key之间的内容
;;; 代码片段中的$(n:*)或$n表示光标在片段中跳转位置
;;;;IFP
;;; if + progn
(if (${1:TEST}) 
  (progn 
    ;你的程序
    $2))

;;;;RES
;;; repeat selectset
(repeat (setq ${1:i} (sslength ${2:SS})) 
  (setq en  (ssname ${2} (setq ${1} (1- ${1})))
        obj (vlax-ename->vla-object en)
        ent (entget en))
  (progn 
    ;你的程序
    $3))

;;;;WHF
;;; loop by flag
(setq ${1:Flag} T)
(while $1  ;第一次进入循环
  (if (${2:TEST})  ;如果条件成立
    (progn 
      ;你的程序
      $3
      (setq $1 Nil) ;退出循环
    )))

;;;;WHP1
(while  ;get*
  (progn 
    (initget (+ 2 4) "S") ;非零非负关键词
    (setq TmpPT (getpoint (strcat "\n→请指定点[设置(S)]")))
    (cond 
      (TmpPT ;点存在
      ;你的程序
      $1 T ;继续循环
      )
      ((and (eq (type TmpVar) 'STR) (eq (strcase TmpVar) "S")) ;字母Ss
       ;你的程序
       $2
       T ;继续循环
      )
      (T
       (princ "\n——★★★ 请输入正确的关键词或 ESC退出！ ★★★——\n")
       T ;继续循环
      ))))

;;;;WHP2
(while  ;Grread
  (progn 
    (princ (strcat "\n→请指定点[设置(S)]"))
    (while (and (setq Code (grread T (+ 1 4 8) 2)) (eq (car Code) 5)))
    (setq Key (cadr Code))
    (cond 
      ((and (eq (car Code) 3) (eq (type Key) 'LIST)) ;点选
       ;你的程序
       $1
       Nil ;退出循环
      )
      ((or (eq Key 13) (eq Key 32)) ;回车或空格
       ;你的程序
       $2
       T ;继续循环
      )
      ((or (eq Key 83) (eq Key (+ 83 32))) ;字母S
       ;你的程序
       $3
       T ;继续循环
      )
      (T
       (princ "\n——★★★ 请输入正确的关键词或 ESC退出！ ★★★——\n")
       T ;继续循环
      ))))
;;;;DFTT
(if (null vlax-dump-object) (vl-load-com));
(defun C:TT (/ *error* CurDoc) 
  (setq CurDoc (vla-get-activedocument (vlax-get-acad-object)))
  (defun *error* (x)  ;出错函数
    (vla-endundomark CurDoc) ;错误时结束编组
  )

  (while (eq 8 (logand 8 (getvar 'undoctl))) 
    (vla-endundomark CurDoc)) ;关闭以前的编组
  (vla-startundomark CurDoc) ;记录编组
  ;你的程序
  $1
  (vla-endundomark CurDoc) ;结束编组
  (command "redraw")
  (princ))


