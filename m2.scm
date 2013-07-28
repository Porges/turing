; the same machine, only smaller
(define m2 (letrec
         ([b (delay (list
           (make-m-cfg (list 'empty) (list (P #\0)) b)
           (make-m-cfg (list #\0) (list R R (P #\1)) b)
           (make-m-cfg (list #\1) (list R R (P #\0)) b)))])
         b))
