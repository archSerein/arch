(define (over-or-under num1 num2) 
  (if (< num1 num2)
    -1
      (if (= num1 num2)
        0
          1))
)

(define (make-adder num) 
  (lambda (inc)
    (+ num inc)))

(define (composed f g) 
  (lambda (x)
    (f (g x))))

(define (repeat f n)
  (define (compose-n f n)
    (if (= n 1)
        f
        (composed f (compose-n f (- n 1)))))
  (lambda (x)
    ((compose-n f n) x)))

(define (max a b)
  (if (> a b)
      a
      b))

(define (min a b)
  (if (> a b)
      b
      a))

(define gcd
  (lambda (a b)
    (if (= b 0)
        a
        (gcd b (remainder a b)))))

(define (duplicate lst)
  (if (null? lst)
      '()
      (cons (car lst) 
            (cons (car lst) 
                  (duplicate (cdr lst))))))

(expect (duplicate '(1 2 3)) (1 1 2 2 3 3))

(expect (duplicate '(1 1)) (1 1 1 1))

(define (deep-map fn s)
  (map (lambda (x)
         (if (list? x)
             (deep-map fn x)
             (fn x)))
       s))
