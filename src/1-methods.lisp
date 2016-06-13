
(in-package :hypercast)

(defmethod cast ((code fixnum) (type (eql 'character)))
  (declare (ignorable type))
  (code-char code))

(defconstant +fixnum-size/16+ (* 16 (ceiling (integer-length most-positive-fixnum) 16)))

(defmethod cast ((i fixnum) (type (eql 'bit-vector)))
  (declare (ignorable type))
  (declare (optimize (speed 3) (safety 0)))
  (iter (declare (iterate:declare-variables))
        (with a = (make-array +fixnum-size/16+ :element-type 'bit))
        (for j below +fixnum-size/16+)
        (setf (aref a j) (ldb (byte 1 j) i))
        (finally (return a))))

