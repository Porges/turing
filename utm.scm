; need this to generate a couple of cfgs
(define u-symbols (list
  	   #\A #\C #\D #\0 #\1
		   #\u #\v #\w #\x #\y #\z
		   #\; #\L #\R #\N
		   #\∷ #\:
		   ))
 
; yo dawg
(define u (letrec
        (
         [f (lambda (C B a) (delay (list
                (make-m-cfg (list #\ǝ) (list L) (f1 C B a))
                (make-m-cfg (list 'any) (list L) (f C B a)))))]
         [f1 (lambda (C B a) (delay (list
                (make-m-cfg (list a) (list) C)
                (make-m-cfg (list 'empty) (list R) (f2 C B a))
                (make-m-cfg (list 'any) (list R) (f1 C B a)))))]
         [f2 (lambda (C B a) (delay (list
                (make-m-cfg (list a) (list) C)
                (make-m-cfg (list 'empty) (list R) B)
                (make-m-cfg (list 'any) (list R) (f1 C B a)))))]
         [fdash (lambda (C B a) (delay (list
                (make-m-cfg (list 'any) (list) (f (l C) B a)))))]
         [fdashdash (lambda (C B a) (delay (list
                (make-m-cfg (list 'any) (list) (f (r C) B a)))))]
         [r (lambda (C) (delay (list
                (make-m-cfg (list 'any) (list R) C))))]
         [l (lambda (C) (delay (list
                (make-m-cfg (list 'any) (list L) C))))]
         [q (case-lambda
              [(C) (delay (list
                (make-m-cfg (list 'empty) (list R) (q1 C))
                (make-m-cfg (list 'any) (list R) (q C))))]
         [(C a) (delay (list
                (make-m-cfg (list 'any) (list) (q (q1 C a)))))])]
         [q1 (case-lambda
               [(C) (delay (list
                (make-m-cfg (list 'empty) (list) C)
                (make-m-cfg (list 'any) (list R) (q C))))]
               [(C a) (delay (list
                (make-m-cfg (list a) (list) C)
                (make-m-cfg (list 'any) (list L) (q1 C a))))])]
         [pe (lambda (C b) (delay (list
                (make-m-cfg (list 'any) (list) (f (pe1 C b) c #\ǝ)))))]
         [pe1 (lambda (C b) (delay (list
                (make-m-cfg (list 'empty) (list (P b)) C)
                (make-m-cfg (list 'any) (list R R) (pe1 C b)))))]
         [pe2 (lambda (C a b) (delay (list
                (make-m-cfg (list 'any) (list) (pe (pe C b) a)))))]
         [c (lambda (C B a) (delay (list
                (make-m-cfg (list 'any) (list) (fdash (c1 C) B a)))))]
         [c1 (lambda (C) (delay (map
                    (lambda (b) (make-m-cfg (list b) (list) (pe C b)))
                      u-symbols)))]
         [ce (case-lambda
               [(C B a) (delay (list
                (make-m-cfg (list 'any) (list) (c (e C B a) B a))))]
               [(B a) (delay (list
                (make-m-cfg (list 'any) (list) (ce (ce B a) B a))))])]
         [ce2 (lambda (B a b) (delay (list
                (make-m-cfg (list 'any) (list) (ce (ce B b) a)))))]
         [ce3 (lambda (B a b g) (delay (list
                (make-m-cfg (list 'any) (list) (ce (ce2 B b g) a)))))]
         [ce5 (lambda (B a b g d e) (delay (list
                (make-m-cfg (list 'any) (list) (ce3 (ce2 B d e) a b g)))))] ; added
         [cp (lambda (C U F a b) (delay (list
                (make-m-cfg (list 'any) (list) (fdash (cp1 C U b) (f U F b) a)))))]
         [cp1 (lambda (C U b) (delay (map
                   (lambda (g) (make-m-cfg (list g) (list) (fdash (cp2 C U g) U b)))
                     u-symbols)))]
         [cp2 (lambda (C U g) (delay (list
                (make-m-cfg (list g) (list) C)
                (make-m-cfg (list 'any) (list) U))))]
         [cpe (case-lambda 
                [(C U F a b) (delay (list
                 (make-m-cfg (list 'any) (list) (cp (e (e C C b) C a) U F a b))))]
                [(U F a b) (delay (list
                 (make-m-cfg (list 'any) (list) (cpe (cpe U F a b) U F a b))))])]
         [e (case-lambda
               [(C) (delay (list
                (make-m-cfg (list #\ǝ) (list R) (e1 C))
                (make-m-cfg (list 'any) (list L) (e C))))]
               [(B a) (delay (list 
                (make-m-cfg (list 'any) (list) (e (e B a) B a))))]
               [(C B a) (delay (list 
                (make-m-cfg (list 'any) (list) (f (e1 C B a) B a))))])]
         [e1 (case-lambda
               [(C) (delay (list
                (make-m-cfg (list 'empty) (list) C) 
                (make-m-cfg (list 'any) (list R E R) (e1 C))))]
               [(C B a) (delay (list
                (make-m-cfg (list 'any) (list E) C)))])]
         [con (lambda (C a) (delay (list
                (make-m-cfg (list #\A) (list L (P a) R) (con1 C a))
                (make-m-cfg (list 'any) (list R R) (con C a)))))]
         [con1 (lambda (C a) (delay (list
                (make-m-cfg (list #\A) (list R (P a) R) (con1 C a))
                (make-m-cfg (list #\D) (list R (P a) R) (con2 C a)))))]
         [con2 (lambda (C a) (delay (list
                (make-m-cfg (list #\C) (list R (P a) R) (con2 C a))
                (make-m-cfg (list 'any) (list R R) C))))]
         [b (delay (list
                (make-m-cfg (list 'any) (list) (f b1 b1 #\∷))))]
         [b1 (delay (list
                (make-m-cfg (list 'any) (list R R (P #\:) R R (P #\D) R R (P #\A) R R (P #\D)) anf)))] ; added "R R PD"
         [anf (delay (list
                (make-m-cfg (list 'any) (list) (q anf1 #\:))))] ; corrected from "(g ..."
         [anf1 (delay (list
                (make-m-cfg (list 'any) (list) (con fom #\y))))]
         [fom (lambda () (list
                (make-m-cfg (list #\;) (list R (P #\z) L) (con fmp #\x))
                (make-m-cfg (list #\z) (list L L) fom)
                (make-m-cfg (list #\ǝ) (list H) fom)
                (make-m-cfg (list 'any) (list L) fom)))]
         [fmp (delay (list
                (make-m-cfg (list 'any) (list) (cpe (e (e anf #\x) #\y) sim #\x #\y))))] ; corrected
         [sim (delay (list
                (make-m-cfg (list 'any) (list) (fdash sim1 sim1 #\z))))]
         [sim1 (delay (list
                (make-m-cfg (list 'any) (list) (con sim2 'empty))))]
         [sim2 (delay (list
                (make-m-cfg (list #\A) (list) sim3)
                (make-m-cfg (list 'any) (list L (P #\u) R R R) sim2)))] ; corrected from "R ..."
         [sim3 (delay (list
                (make-m-cfg (list #\A) (list L (P #\y) R R R) sim3)
                (make-m-cfg (list 'any) (list L (P #\y)) (e mf #\z))))]
         [mf (delay (list
                (make-m-cfg (list 'any) (list) (q mf1 #\:))))] ; corrected from "(g mf ..."
         [mf1 (delay (list
                (make-m-cfg (list #\A) (list L L L L) mf2)
                (make-m-cfg (list 'any) (list R R) mf1)))]
         [mf2 (delay (list
                (make-m-cfg (list #\C) (list R (P #\x) L L L) mf2)
                (make-m-cfg (list #\:) (list) mf4)
                (make-m-cfg (list #\D) (list R (P #\x) L L L) mf3)))]
         [mf3 (delay (list
                (make-m-cfg (list #\:) (list) mf4)
                (make-m-cfg (list 'any) (list R (P #\v) L L L) mf3)))]
         [mf4 (delay (list
                (make-m-cfg (list 'any) (list) (con (l (l mf5)) 'empty))))]
         [mf5 (delay (list
                (make-m-cfg (list 'empty) (list (P #\:)) sh)
                (make-m-cfg (list 'any) (list R (P #\w) R) mf5)))]
         [sh (delay (list
                (make-m-cfg (list 'any) (list) (f sh1 inst #\u))))]
         [sh1 (delay (list
                (make-m-cfg (list 'any) (list L L L) sh2)))]
         [sh2 (delay (list
                (make-m-cfg (list #\D) (list R R R R) sh3) ; corrected from "sh2"
                (make-m-cfg (list 'any) (list) inst)))]
         [sh3 (delay (list
                (make-m-cfg (list #\C) (list R R) sh4)
                (make-m-cfg (list 'any) (list) inst)))]
         [sh4 (delay (list
                (make-m-cfg (list #\C) (list R R) sh5)
                (make-m-cfg (list 'any) (list) (pe2 inst #\0 #\:))))]
         [sh5 (delay (list
                (make-m-cfg (list #\C) (list) inst)
                (make-m-cfg (list 'any) (list) (pe2 inst #\1 #\:))))]
         [inst (delay (list                                 ; note that inst1 is forced here!
                                                            ; this is because it is a zero-arity varargs
                (make-m-cfg (list 'any) (list) (q (l (inst1)) #\u))))] ; corrected from "(g ..." 
         [inst1 (case-lambda
                 [() (delay (map
                       (lambda (a) (make-m-cfg (list a) (list R E) (inst1 a)))
                       u-symbols))]
                 [(x) (case x
                      [(#\L) (delay (list (make-m-cfg (list 'any) (list) (ce5 ov #\v #\y #\x #\u #\w))))]
                      [(#\R) (delay (list (make-m-cfg (list 'any) (list) (ce5 ov #\v #\x #\u #\y #\w))))]
                      [(#\N) (delay (list (make-m-cfg (list 'any) (list) (ce5 ov #\v #\x #\y #\u #\w))))])])]
         [ov (delay (list
               (make-m-cfg (list 'any) (list) (q (r (r ov1)) #\A))))] ; changed from original
         [ov1 (delay (list
               (make-m-cfg (list #\D) (list) (e anf))
               (make-m-cfg (list 'empty) (list (P #\D)) (e anf))))]
         ) b)) ;; start in state 'b'
