(in-package :hypercast)

;; blah blah blah.

(defgeneric cast (object type)
  (:generic-function-class inlined-generic-function)
  (:argument-precedence-order type object))

(defgeneric cost (type-from type-to)
  (:documentation "estimated cost of conversion operation"))

(defmethod cost (type-from type-to)
  (if (subtypep type-from type-to)
      0
      (no-applicable-method #'cost type-from type-to)))

(defmacro in-compile-time (&body body)
  (eval `(progn ,@body)))
