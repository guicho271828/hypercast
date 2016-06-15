(in-package :hypercast)

;; coerce wraper

(defmethod cast ((x sequence) (type (eql 'list)))
  (declare (ignorable type))
  (coerce x type))

(defmethod cast ((x sequence) (type (eql 'vector)))
  (declare (ignorable type))
  (coerce x type))

(defmethod cast ((x real) (type (eql 'complex)))
  (declare (ignorable type))
  (coerce x type))
(defmethod cast ((x rational) (type (eql 'complex)))
  (declare (ignorable type))
  x)
(defmethod cast ((x complex) (type (eql 'complex)))
  (declare (ignorable type))
  x)

(in-compile-time
  (iter
    (for type in '(float short-float single-float double-float long-float))
    (when (first-time-p)
      (collect 'progn))
    (collect
        `(defmethod cast ((x real) (type (eql ',type)))
           (declare (ignorable type))
           (coerce x ',type)))))

(defmethod cast ((x function) (type (eql 'function)))
  (declare (ignorable type))
  x)
(defmethod cast ((x symbol) (type (eql 'function)))
  (declare (ignorable type))
  (coerce x 'function))
(defmethod cast ((x list) (type (eql 'function)))
  (declare (ignorable type))
  (coerce x 'function))

(defmethod cast (x (type (eql 't)))
  (declare (ignorable type))
  x)

