(in-package :hypercast)

;; coerce wraper

(defmethod cost ((x (eql 'sequence)) (type (eql 'list))) 1)
(defmethod cast ((x sequence) (type (eql 'list)))
  (declare (ignorable type))
  (coerce x type))

(defmethod cost ((x (eql 'sequence)) (type (eql 'vector))) 1)
(defmethod cast ((x sequence) (type (eql 'vector)))
  (declare (ignorable type))
  (coerce x type))

(defmethod cost ((x (eql 'real)) (type (eql 'complex))) 1)
(defmethod cast ((x real) (type (eql 'complex)))
  (declare (ignorable type))
  (coerce x type))
(defmethod cost ((x (eql 'rational)) (type (eql 'complex))) 0)
(defmethod cast ((x rational) (type (eql 'complex)))
  (declare (ignorable type))
  x)
(defmethod cost ((x (eql 'complex)) (type (eql 'complex))) 0)
(defmethod cast ((x complex) (type (eql 'complex)))
  (declare (ignorable type))
  x)

(in-compile-time
  (iter
    (for type in '(float short-float single-float double-float long-float))
    (when (first-time-p)
      (collect 'progn))
    (collect
        `(defmethod cost ((x (eql 'real)) (type (eql ',type))) 1))
    (collect
        `(defmethod cast ((x real) (type (eql ',type)))
           (declare (ignorable type))
           (coerce x ',type)))))

(defmethod cost ((x (eql 'function)) (type (eql 'function))) 0)
(defmethod cast ((x function) (type (eql 'function)))
  (declare (ignorable type))
  x)
(defmethod cost ((x (eql 'symbol)) (type (eql 'function))) 1)
(defmethod cast ((x symbol) (type (eql 'function)))
  (declare (ignorable type))
  (coerce x 'function))
(defmethod cost ((x (eql 'list)) (type (eql 'function))) 10)
(defmethod cast ((x list) (type (eql 'function)))
  (declare (ignorable type))
  (coerce x 'function))

(defmethod cost (x (type (eql 't))) 0)
(defmethod cast (x (type (eql 't)))
  (declare (ignorable type))
  x)

