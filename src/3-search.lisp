
(in-package :hypercast)

#|

implements a breadth-first search

|#

(defun edges ()
  (ematch #'cast
    ((generic-function methods)
     (iter (for m in methods)
           (collect
               (match m
                 ((method :specializers (list (class class name)
                                              (eql-specializer object)))
                  (list name object))))))))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass node ()
       ((name :initarg :name)
        (parent :initarg :parent)
        (priority :initarg :priority))))

(defmethod print-object ((o node) s)
  (print-unreadable-object (o s :type t)
    (match o
      ((node name priority)
       (pprint-linear s (list name priority))))))

(defmethod cost ((n1 node) (n2 node))
  (ematch* (n1 n2)
    (((node :name name1) (node :name name2))
     (cost name1 name2))))

(defmacro ptrace (form)
  form
  #+nil
  (ematch form
    ((list* head args)
     (with-gensyms (result)
       (let ((args-vars (make-gensym-list (length args))))
         `(let (,result)
            (fresh-line *standard-output*)
            (pprint-logical-block (*standard-output* nil :per-line-prefix "; ")
              (let (,@(mapcar #'list args-vars args))
                (format *standard-output* "~a" (list ',head ,@args-vars))
                (pprint-indent :block 2 *standard-output*)
                (setf ,result (,head ,@args-vars))
                (format *standard-output* "~&---> ~a" ,result)
                (clear-output *standard-output*)))
            (fresh-line *standard-output*)
            ,result))))))

(defun dijkstra (start goal)
  (let ((open (make-array 20 :initial-element nil :adjustable t))
        (db (make-hash-table)))
    (progn ;step
     (labels ((pop-min ()
                (or (iter (for set in-vector open with-index i)
                          (when set
                            (return (pop (aref open i)))))
                    (error "OPEN list exhausted: no way to convert ~a to ~a"
                           start goal)))
              (applicable-edges (node)
                (ematch node
                  ((node name)
                   (remove-if-not
                    (lambda (x)
                      (subtypep name x))
                    (ptrace (edges)) :key #'car))))
              (insert (node)
                (ematch node
                  ((node priority)
                   (unless (array-in-bounds-p open priority)
                     (adjust-array open (1+ priority) :initial-element nil))
                   (pushnew node (aref open priority)))))
              (update (curr super succ)
                (match* (curr succ)
                  (((node :priority c-g)
                    (node :priority (place s-g) :parent (place parent)))
                   (let ((new-g (+ (cost super succ) c-g)))
                     (when (< new-g s-g)
                       (setf s-g new-g
                             parent curr)
                       (insert succ))))))
              (fetch-node (name &optional (priority most-positive-fixnum))
                (ensure-gethash
                 name db
                 (make-instance 'node
                    :name name
                    :priority priority)))
              (goal-p (node)
                (ematch node
                  ((node name)
                   (eq name goal))))
              (expand ()
                (iter (with curr = (ptrace (pop-min)))
                      (when (goal-p curr)
                        (return-from dijkstra (path curr)))
                      (for (real-curr succ) in (ptrace (applicable-edges curr)))
                      (ptrace
                       (update curr
                               (fetch-node real-curr)
                               (fetch-node succ)))))
              (path (node)
                (nreverse (%path node)))
              (%path (node)
                (ematch node
                  ((node name :parent parent)
                   (cons name (handler-case (%path parent)
                                (unbound-slot () nil)))))))
       (ptrace (insert (fetch-node start 0)))
       (iter (expand))))))

(defmethod cast (object type)
  (reduce #'cast (dijkstra (type-of object) type) :initial-value object))

;; I want to compile this part of the dynamic execution away... how to do this?

