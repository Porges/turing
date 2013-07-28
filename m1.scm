; Turing's first published machine!
(define m1 (letrec 
  ([b (delay (list
       (make-m-cfg (list 'any) (list (P #\0) R) c)))]
   [c (delay (list
       (make-m-cfg (list 'any) (list R) e)))]
   [e (delay (list
       (make-m-cfg (list 'any) (list (P #\1) R) f)))]
   [f (delay (list
       (make-m-cfg (list 'any) (list R) b)))])
  b))
