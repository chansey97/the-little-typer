#lang racket

;; --- church -> real ---

(define realbool
  (lambda (b)
    (b true false)))

(define realnat
  (lambda (m)
    (m (lambda (x)
         (+ 1 x)) 0)))

;; --- church encoding ---

;; Boolean
(define tru
  (curry
   (lambda (t f)
     t)))

(define fls
  (curry
   (lambda (t f)
     f)))

;; tru and fls themselves are eliminator

;; (tru 'v 'w)
;; ((tru 'v) 'w)

;; (fls 'v 'w)
;; ((fls 'v) 'w)

;; (realbool tru)
;; (realbool fls)

;; test boolean
(define test
  (curry
   (lambda (l m n)
     (l m n))))

;; (test tru 'v 'w)
;; (test fls 'v 'w)

;; Nat
(define c0
  (curry
   (lambda (s z)
     z)))

(define c1
  (curry
   (lambda (s z)
     (s z))))

(define c2
  (curry
   (lambda (s z)
     (s (s z)))))

(define c3
  (curry
   (lambda (s z)
     (s (s (s z))))))

;; nat themselves are eliminator

;; (c0 (lambda (x)
;;       "bottom") 0)
;; (c1 (lambda (x)
;;       (+ 1 x)) 0)
;; (c2 (lambda (x)
;;       (+ 1 x)) 0)
;; (c3 (lambda (x)
;;       (+ 1 x)) 0)

;; (realnat c0)
;; (realnat c1)
;; (realnat c2)
;; (realnat c3)

;; scc
(define scc
  (curry
   (lambda (n s z)
     (s (n s z)))))

;; (realnat (scc c0))
;; (realnat (scc (scc c0)))
;; (realnat (scc (scc (scc c0))))
;; (realnat (scc (scc (scc (scc c0)))))

;; plus
(define plus
  (curry
   (lambda (m n s z)
     (m s (n s z)))))

;; (realnat (plus c2 c3))

;; times
(define times
  (curry
   (lambda (m n)
     (m (plus n) c0))))

;; (realnat (times c2 c3))

;; iszro
(define iszro
  (lambda (m)
    (m (lambda (x)
         fls)
       tru)))

;; (realbool (iszro c0))
;; (realbool (iszro c2))

;; pred
(define zz
  (cons c0 c0))

(define ss
  (lambda (p)
    (cons (cdr p) (scc (cdr p)))))

(define pred
  (lambda (m)
    (car
     (m ss zz))))

;; (realnat (pred c0))
;; (realnat (pred c1))
;; (realnat (pred c2))
;; (realnat (pred c3))

