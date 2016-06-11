#|
  This file is a part of hypercast project.
  Copyright (c) 2016 Masataro Asai (guicho2.71828@gmail.com)
|#

#|
  Fast, generic, automatic type casting (conversion) framework

  Author: Masataro Asai (guicho2.71828@gmail.com)
|#



(in-package :cl-user)
(defpackage hypercast-asd
  (:use :cl :asdf))
(in-package :hypercast-asd)


(defsystem hypercast
  :version "0.1"
  :author "Masataro Asai"
  :mailto "guicho2.71828@gmail.com"
  :bug-tracker "https://github.com/guicho271828/hypercast/issues"
  :source-control (:git "https://github.com/guicho271828/hypercast.git")
  :license "LLGPL"
  :depends-on (:iterate :alexandria :inlined-generic-function)
  :components ((:module "src"
                :components
                ((:file "0-package")
                 (:file "1-methods"))))
  :description "Fast, generic, automatic type casting (conversion) framework"
  :in-order-to ((test-op (test-op :hypercast.test))))
