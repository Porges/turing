(import (rnrs)
    (rnrs r5rs (6)) ; provides 'delay' & 'force'
    (streams))
    
; type for a configuration
(define-record-type m-cfg
            (fields symbols operations next))
            
            
; type for a tape (modeled as two stacks)
(define-record-type tape
            (fields left right min max index))
            
; the operations available
(define-enumeration op
  (right left erase print halt)
  op-set)
  
; these need to be lists, because print takes an argument
(define L (list (op left)))
(define R (list (op right)))
(define P (lambda (c) (list (op print) c)))
(define E (list (op erase)))
(define H (list (op halt)))

(define empty-tape
  (make-tape (stream-constant 'empty) (stream-constant 'empty) 0 0 0))
  
; Tape manipulation:
(define (current-symbol tape)
  (stream-car (tape-right tape)))
 
(define (move-item from to)
  (values (stream-cdr from)
      (stream-cons (stream-car from) to)))
 
(define (move-right tape)
  (let-values (
      [(right left) (move-item (tape-right tape) (tape-left tape))]
      [(min max) (update-min-max (tape-min tape) (tape-max tape) (+ 1 (tape-index tape)))])
    (make-tape left right min max (+ 1 (tape-index tape)))))
 
(define (move-left tape)
  (let-values (
      [(left right) (move-item (tape-left tape) (tape-right tape))]
      [(min max) (update-min-max (tape-min tape) (tape-max tape) (- (tape-index tape) 1))])
    (make-tape left right min max (- (tape-index tape) 1))))
 
(define (print tape symbol)
  (make-tape
    (tape-left tape)
    (stream-cons symbol (stream-cdr (tape-right tape)))
    (tape-min tape)
    (tape-max tape)
    (tape-index tape)))
 
(define (erase tape)
  (print tape 'empty))
 
(define (update-min-max min max i)
  (cond 
    [(< i min) (values i max)]
    [(> i max) (values min i)]
    [else      (values min max)]))
    
; performs an operation on a tape, returns new tape
(define (perform-op tape oper)
  (case (car oper)
    [(op left) (move-left tape)]
    [(op right) (move-right tape)]
    [(op print) (print tape (cadr oper))]
    [(op erase) (erase tape)]
    [(op halt) #f])) ; ungraceful halt!
    
; finds the correct rule to follow for this symbol
(define (find-cfg machine symbol)
  (find (lambda (cfg) (or
                (find [lambda (s) (eqv? symbol s)]
                  (m-cfg-symbols cfg))
                (find [lambda (s) (eqv? 'any s)]
                  (m-cfg-symbols cfg))))
        machine))
        
; runs a machine forward one step
(define (run-machine tape machine)
  (let ([cfg (find-cfg (force machine) (current-symbol tape))])
    (list (fold-left perform-op tape (m-cfg-operations cfg))
          (m-cfg-next cfg))))
          
(define (print-tape tape)
  ; move as far left as possible
  (let ([leftTape (go-far-left tape)])
    ; now go right
    (do ([t leftTape])
      ((> (tape-index t) (tape-max tape)) t)
      (when (eqv? (tape-index tape) (tape-index t))
              (display "["))
      (cond
          [(eqv? (current-symbol t) 'empty) (display ".")]
          [else (display (current-symbol t))])
      (when (eqv? (tape-index tape) (tape-index t))
              (display "]"))
      (set! t (move-right t)))))
 
; moves to the far left of the tape (as far as has been travelled)
(define (go-far-left tape)
  (do ([t tape])
    ((= (tape-index t) (tape-min tape)) t)
     (set! t (move-left t))))

(define (go t m)
 (do ([tm (list t m)])
  ((eqv? tm #f) (car tm))
  (print-tape (car tm))
  (newline)
  (set! tm (run-machine (car tm) (cadr tm)))))
