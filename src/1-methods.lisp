
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

;; from ironclad

(defmethod cast ((i integer) (type (eql :octet-vector)))
  (declare (ignorable type))
  (let* ((n-bytes (ceiling n-bits 8))
         (octet-vec (make-array n-bytes :element-type '(unsigned-byte 8))))
    (declare (type (simple-array (unsigned-byte 8)) octet-vec))
    (loop for i from (1- n-bytes) downto 0
          for index from 0
          do (setf (aref octet-vec index) (ldb (byte 8 (* i 8)) bignum))
          finally (return octet-vec))))



