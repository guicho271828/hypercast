
(in-package :hypercast)

#+template
(defmethod cast ((i ) (type (eql )))
  (declare (ignorable type))
  )

(defmethod cost ((code (eql 'fixnum)) (type (eql 'character))) 1)
(defmethod cast ((code fixnum) (type (eql 'character)))
  (declare (ignorable type))
  (code-char code))

(defmethod cost ((char (eql 'character)) (type (eql 'fixnum))) 1)
(defmethod cast ((char character) (type (eql 'fixnum)))
  (declare (ignorable type))
  (char-code char))

(defmethod cost ((x (eql 'null)) (type (eql 'fixnum))) 0)
(defmethod cast ((x null) (type (eql 'fixnum)))
  (declare (ignorable type))
  0)
(defmethod cost ((sym (eql 'symbol)) (type (eql 'fixnum))) 0)
(defmethod cast ((sym symbol) (type (eql 'fixnum)))
  (declare (ignorable type))
  1)

(defmethod cost ((x (eql 'string)) (type (eql 'character))) 1)
(defmethod cast ((x string) (type (eql 'character)))
  (declare (ignorable type))
  (coerce x 'character))
(defmethod cost ((x (eql 'symbol)) (type (eql 'character))) 1)
(defmethod cast ((x symbol) (type (eql 'character)))
  ;; string designator
  (declare (ignorable type))
  (coerce x 'character))
(defmethod cost ((x (eql 'character)) (type (eql 'character))) 0)
(defmethod cast ((x character) (type (eql 'character)))
  (declare (ignorable type))
  x)

(declaim (type fixnum +fixnum-size/16+))
(defconstant +fixnum-size/16+ (* 16 (ceiling (integer-length most-positive-fixnum) 16)))

(declaim (type (simple-bit-vector #.(* 256 8)) +static-8bit-vectors+))
(define-constant +static-8bit-vectors+
    #.(iter (with a1 = (make-array (* 256 8) :element-type 'bit))
            (for i below 256)
            (iter (for j below 8)
                  (setf (aref a1 (+ (* 8 i) j)) (ldb (byte 1 j) i)))
            (finally (return a1)))
    :test 'equalp
    :documentation "an 8-bit cache for converting bitvec and integer")

(defmethod cost ((i (eql 'fixnum)) (type (eql 'bit-vector))) 10)
(defmethod cast ((i fixnum) (type (eql 'bit-vector)))
  (declare (fixnum i))
  (declare (ignorable type))
  (declare (optimize (speed 3) (safety 0)))
  (let ((a (make-array +fixnum-size/16+ :element-type 'bit)))
    (declare (type simple-bit-vector +static-8bit-vectors+))
    (in-compile-time
      (iter (for j below +fixnum-size/16+ by 8)
            ;; (for i-masked = (ash (mask-field (byte 8 j) i) (- j)))
            ;; (for offset = (* i-masked 8))
            (when (first-time-p)
              (collect 'progn))
            (collect
                `(let* ((i-masked (ldb (byte 8 ,j) i))
                        (offset (* i-masked 8)))
                   (replace a +static-8bit-vectors+
                            :start1 ,j :end1 ,(+ 8 j)
                            :start2 offset :end2 (+ offset 8))))))
    a))


(defmethod cost (thing (type (eql 'string))) 10)
(defmethod cast (thing (type (eql 'string)))
  (declare (ignorable type))
  (princ-to-string thing))

