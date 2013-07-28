(define (setup-tape tape inits) 
  (let ([t (move-right (print (move-right (print tape #\ǝ)) #\ǝ))]
    [inits (append inits (list #\∷))])
   (go-far-left (fold-left (lambda (tape init)
  	       (move-right (move-right (print tape init)))) 
	     t inits))))
       
(define example (setup-tape empty-tape (list 
  		     #\; #\D #\A             #\D #\D #\C     #\R #\D #\A #\A
			     #\; #\D #\A #\A         #\D #\D         #\R #\D #\A #\A #\A
			     #\; #\D #\A #\A #\A     #\D #\D #\C #\C #\R #\D #\A #\A #\A #\A
			     #\; #\D #\A #\A #\A #\A #\D #\D         #\R #\D #\A)))
