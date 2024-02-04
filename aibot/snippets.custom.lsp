(exit) ;; 防止误加载
;;; IFP
(if (${1:TEST}) 
  (progn 
    ;;你的程序
    ${2}))

;;; RES
(repeat (setq ${1:i} (sslength ${2:SS})) 
  (setq ent (ssname SS (setq i (1- i)))
        enx (entget ent)
        obj (vlax-ename->vla-object ent))
  (progn 
    ;;你的程序
    ${3}))

;;; WHP
(while 
  (progn 
    (initget (+ 2 4) "S") ;非零非负关键词
    (setq TmpPT (getpoint (strcat "\n→请指定点[设置(S)]")))
    (cond 
      (TmpPT
       ;;你的程序
       ${1}
       T ;继续循环
      )
      ((not TmpPT)
       ;;你的程序
       T ;继续循环
      )
      (T
       nil ;退出循环
      ))))


;;; DFTT
(if (null vlax-dump-object) (vl-load-com))
(defun C:TT (/ *error* CurDoc) 
  ${1}
  (setq CurDoc (vla-get-activedocument (vlax-get-acad-object)))
  (defun *error* (x)  ;出错函数
    (vla-endundomark CurDoc) ;错误时结束编组
  )

  (while (eq 8 (logand 8 (getvar 'undoctl))) 
    (vla-endundomark CurDoc)) ;关闭以前的编组
  (vla-startundomark CurDoc) ;记录编组
  ;;你的程序
  (vla-endundomark CurDoc) ;结束编组
  (princ))
