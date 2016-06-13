#|
  This file is a part of hypercast project.
  Copyright (c) 2016 Masataro Asai (guicho2.71828@gmail.com)
|#


(in-package :cl-user)
(defpackage hypercast.test-asd
  (:use :cl :asdf))
(in-package :hypercast.test-asd)


(defsystem hypercast.test
  :author "Masataro Asai"
  :mailto "guicho2.71828@gmail.com"
  :description "Test system of hypercast"
  :license "LLGPL"
  :depends-on (:hypercast
               :fiveam)
  :components ((:module "t"
                :components
                ((:file "package"))))
  :perform (test-op :after (op c)
(eval
 (read-from-string
  "(let ((res (5am:run :hypercast)))
     (5am:explain! res)
     (every #'5am::TEST-PASSED-P res))"))))
