; Turing's third machine
(define m3 (letrec
         ([b (delay (list
                   (make-m-cfg (list 'any) (list (P #\ǝ) R (P #\ǝ) R (P #\0) R R (P #\0) L L) o)))]
          [o (delay (list
                  (make-m-cfg (list #\1) (list R (P #\x) L L L) o)
                  (make-m-cfg (list #\0) (list) q)))]
          [q (delay (list
                  (make-m-cfg (list #\0 #\1) (list R R) q)
                  (make-m-cfg (list 'empty) (list (P #\1) L) p)))]
          [p (delay (list
                  (make-m-cfg (list #\x) (list E R) q)
                  (make-m-cfg (list #\ǝ) (list R) f)
                  (make-m-cfg (list 'empty) (list L L) p)))]
          [f (delay (list
                  (make-m-cfg (list 'empty) (list (P #\0) L L) o)
                  (make-m-cfg (list 'any) (list R R) f)))])
         b))
