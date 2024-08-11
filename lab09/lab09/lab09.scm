(define (over-or-under num1 num2) 'YOUR-CODE-HERE)

(define (make-adder num) 'YOUR-CODE-HERE)

(define (composed f g) 'YOUR-CODE-HERE)

(define (repeat f n) 'YOUR-CODE-HERE)

(define (max a b)
  (if (> a b)
      a
      b))

(define (min a b)
  (if (> a b)
      b
      a))

(define (gcd a b) 'YOUR-CODE-HERE)

(define (duplicate lst) 'YOUR-CODE-HERE)

(expect (duplicate '(1 2 3)) (1 1 2 2 3 3))

(expect (duplicate '(1 1)) (1 1 1 1))

(define (deep-map fn s) 'YOUR-CODE-HERE)
