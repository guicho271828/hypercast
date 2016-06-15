#|
  This file is a part of hypercast project.
  Copyright (c) 2016 Masataro Asai (guicho2.71828@gmail.com)
|#

(in-package :cl-user)
(defpackage hypercast
  (:use :cl :iterate :alexandria :inlined-generic-function)
  (:export
   #:cast))
(in-package :hypercast)

;; blah blah blah.

(defgeneric cast (object type)
  (:generic-function-class inlined-generic-function)
  (:argument-precedence-order type object))




