(in-package :hypercast)

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

