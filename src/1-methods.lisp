
(in-package :hypercast)

#+template
(defmethod cast ((i ) (type (eql )))
  (declare (ignorable type))
  )

(defmethod cast ((code fixnum) (type (eql 'character)))
  (declare (ignorable type))
  (code-char code))
(defmethod cast ((x string) (type (eql 'character)))
  (declare (ignorable type))
  (coerce x 'character))
(defmethod cast ((x symbol) (type (eql 'character)))
  ;; string designator
  (declare (ignorable type))
  (coerce x 'character))
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

;; from ironclad

(defmethod cast ((bignum integer) (type (eql :octet-vector)))
  (declare (ignorable type))
  (let* ((n-bytes (ceiling (integer-length bignum) 8))
         (octet-vec (make-array n-bytes :element-type '(unsigned-byte 8))))
    (declare (type (simple-array (unsigned-byte 8)) octet-vec))
    (loop for i from (1- n-bytes) downto 0
          for index from 0
          do (setf (aref octet-vec index) (ldb (byte 8 (* i 8)) bignum))
          finally (return octet-vec))))

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

