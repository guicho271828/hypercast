(in-package :hypercast)

;; blah blah blah.

(defgeneric cast (object type)
  (:generic-function-class inlined-generic-function)
  (:argument-precedence-order type object))

(defmacro in-compile-time (&body body)
  (eval `(progn ,@body)))
