#|
  This file is a part of hypercast project.
  Copyright (c) 2016 Masataro Asai (guicho2.71828@gmail.com)
|#

(in-package :cl-user)
(defpackage :hypercast.test
  (:use :cl
        :hypercast
        :fiveam
        :iterate :alexandria :inlined-generic-function))
(in-package :hypercast.test)



(def-suite :hypercast)
(in-suite :hypercast)

;; run test with (run! test-name) 

(test integer
  (iter (for type in '(bit-vector character))
        (handler-case
            (let ((result (cast 128 type)))
              (pass "~& (cast 128 '~a) is ~a" type result))
          (error ()
            (fail "failed to (cast 128 '~a)" type)))))

(test integer.bench
  (iter (for type in '(bit-vector character))
        (for form = `(lambda () (loop repeat 10 do (loop for i below 1000000 do (cast i ',type)))))
        #+nil
        (progn
          (for fn = (compile nil form))
          (format t "~%Without inlining")
          (time (funcall fn))
          (pass))
        (for fn2 = (let ((*features* (cons :inline-generic-function *features*)))
                     (compile nil form)))
        (format t "~%With inlining")
        (time (funcall fn2))
        (pass)))
