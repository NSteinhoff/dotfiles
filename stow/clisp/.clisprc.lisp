(setq CUSTOM:*BROWSER* :FIREFOX)
; (setq CUSTOM:*CLHS-ROOT-DEFAULT* "/home/niko/Documents/HyperSpec/")

;;; The following lines added by ql:add-to-init-file:
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

