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
  (finishes
    (iter (for type in '(bit-vector character))
          (time
           (5am:for-all ((i (gen-integer :max char-code-limit :min 0)))
             (cast i type))))))
