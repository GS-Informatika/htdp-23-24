;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 13-interpreter2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define T 'T)
(define F 'F)

; BooleanLiteral je jedno z
; - T
; - F

; Expression rozšíříme o další strukturu - variable

(define-struct variable [name])
(define-struct literal [value])
(define-struct op-not [value])
(define-struct op-or [left right])
(define-struct op-and [left right])
; Expression je jedno z
#; (make-variable Symbol)
#; (make-literal BooleanLiteral)
#; (make-op-not Expression)
#; (make-op-or Expression Expression)
#; (make-op-and Expression Expression)

; BooleanLiteral -> Boolean
(define (literal-true? lit)
  (symbol=? 'T lit))

; Dále si zavedeme binding variable -> value
(define-struct binding [name value])
; Binding je strkutura
#; (make-binding Symbol Expression)

(define-struct environment [bindings])
; Environment je struktura
#; (make-environment [List-of Binding])

;; Dále potřebujeme funkci která nalezne hodnotu proměnné v daném
;; prostředí

; Environment Symbol -> Expression
(define (get-value env var-name)
  (local (; [List-of Binding] -> Expression
          (define (find-binding lob)
            (cond [(empty? lob) (error (string-append "Variable " (symbol->string var-name) " not bound"))]
                  [(symbol=? var-name (binding-name (first lob))) (binding-value (first lob))]
                  [else (find-binding (rest lob))])))
    (find-binding (environment-bindings env))))


;; Do funkce eval musíme zapracovat možnost variable

; Environment Expression -> BooleanLiteral
(define (eval env expr)
  (cond [(literal? expr) (literal-value expr)]
        [(variable? expr) (eval env (get-value env (variable-name expr)))]
        [(op-not? expr) (local ((define evaluated
                                  (eval env (op-not-value expr))))
                          (if (literal-true? evaluated) F T))]
        
        [(op-or? expr) (local ((define left-evaluated
                                 (eval env (op-or-left expr))))
                         (if (literal-true? left-evaluated)
                             T (eval env (op-or-right expr))))]
        
        [(op-and? expr) (local ((define left-evaluated
                                  (eval env (op-and-left expr))))
                          (if (literal-true? left-evaluated)
                              (eval env (op-and-left expr)) F))]))

(define env1
  (make-environment (list (make-binding 'x (make-literal T)) ; T
                          (make-binding 'y (make-op-or (make-literal T) ; T
                                                       (make-literal F)))
                          (make-binding 'z (make-op-and (make-literal F) ; F
                                                        (make-variable 'x))))))

; (T or (T and F)) = T
#; (eval env1 (make-op-or (make-variable 'x)
                       (make-op-and (make-variable 'y)
                                    (make-variable 'z))))


;; Dále můžeme rozšířit definici Environment a Expression o funkce.
;; Funkce mají kromě "těla" které se musí evaluovat také vlastní variable binding,
;; který rozšiřuje (a zastiňuje) širší variable binding.

(define-struct func-call [name args])
; Expression.v2 je jedno z
; - Expression
#; (make-func-call Symbol [List-of Expression])

(define-struct function-def [name var-names body])
; FunctionDef je struktura
#; (make-function-def Symbol [List-of Symbol] Expression)

(define-struct env-with-fns [variables functions])
; Environment.v2 je struktura
#; (make-env-with-fns [List-of Binding] [List-of FunctionDef])


; Environment.v2 Symbol -> Expression
(define (get-variable env var-name)
  (local (; [List-of Binding] -> Expression
          (define (find-binding lob)
            (cond [(empty? lob)
                   (error (string-append "Variable " (symbol->string var-name) " not bound"))]
                  [(symbol=? var-name (binding-name (first lob))) (binding-value (first lob))]
                  [else (find-binding (rest lob))])))
    (find-binding (env-with-fns-variables env))))


; Environment.v2 Symbol -> FunctionDef
(define (get-function-def env fn-name)
  (local (; [List-of FunctionDef] -> FunctionDef
          (define (find-def lod)
            (cond [(empty? lod)
                   (error (string-append "Definition for function " (symbol->string fn-name) " not found"))]
                  [(symbol=? fn-name (function-def-name (first lod))) (first lod)]
                  [else (find-def (rest lod))])))
    (find-def (env-with-fns-functions env))))


; Environment.v2 Symbol [List-of Symbol] [List-of Expression] -> Environment.v2
; Vytovří environment s bindingy fn-vars k fn-args
(define (bind-fn-vars env fn-name fn-vars fn-args)
  (local (; [List-of Symbol] [List-of Expression] -> [List-of Binding]
          (define (new-bindings fn-vars fn-args)
            (cond [(and (empty? fn-vars) (empty? fn-args)) '()]
                  [(or (empty? fn-vars) (empty? fn-args))
                   (error (string-append "Arity mismatch when executing " (symbol->string fn-name) "."))]
                  [else (cons (make-binding (first fn-vars) (first fn-args))
                              (new-bindings (rest fn-vars) (rest fn-args)))])))
    (make-env-with-fns (append (new-bindings fn-vars fn-args)
                               (env-with-fns-variables env))
                       (env-with-fns-functions env))))


; Environment.v2 Expression.v2 -> BooleanLiteral
(define (eval.v2 env expr)
  (cond [(literal? expr) (literal-value expr)]
        
        [(variable? expr) (eval.v2 env (get-variable env (variable-name expr)))]
        
        [(func-call? expr) (local (; FunctionDef
                                   (define fn-def (get-function-def env (func-call-name expr)))
                                   ; Environment.v2
                                   (define fn-env (bind-fn-vars env
                                                                (func-call-name expr)
                                                                (function-def-var-names fn-def)
                                                                ; Vytvoření literálů z argumentů
                                                                ; (eager evaluation)
                                                                (map make-literal
                                                                     (map (lambda (expr) (eval.v2 env expr))
                                                                          (func-call-args expr))))))
                             (eval.v2 fn-env (function-def-body fn-def)))]
                                                   
        [(op-not? expr) (local ((define evaluated
                                  (eval.v2 env (op-not-value expr))))
                          (if (literal-true? evaluated) F T))]
        
        [(op-or? expr) (local ((define left-evaluated
                                 (eval.v2 env (op-or-left expr))))
                         (if (literal-true? left-evaluated)
                             T (eval.v2 env (op-or-right expr))))]
        
        [(op-and? expr) (local ((define left-evaluated
                                  (eval.v2 env (op-and-left expr))))
                          (if (literal-true? left-evaluated)
                              (eval.v2 env (op-and-right expr)) F))]))

; Environment kde máme proměnné i funkce
(define env2 (make-env-with-fns (list (make-binding 'x (make-literal T))
                                      (make-binding 'y (make-op-or (make-variable 'x)
                                                                   (make-literal F))))
                                
                                (list (make-function-def 'or-3 '(x y z)
                                                         (make-op-or (make-variable 'x)
                                                                  (make-op-or (make-variable 'y)
                                                                              (make-variable 'z))))
                                      (make-function-def 'and-4 '(a b c d)
                                                         (make-op-and (make-op-and (make-variable 'a)
                                                                                   (make-variable 'b))
                                                                   (make-op-and (make-variable 'c)
                                                                                (make-variable 'd)))))))

; (or-3 T F F) and (and-4 F T F F) = F
(eval.v2 env2 (make-op-and (make-func-call 'or-3 (list (make-literal T)
                                                       (make-literal F)
                                                       (make-literal F)))
                           (make-func-call 'and-4 (list (make-literal F)
                                                        (make-literal T)
                                                        (make-literal F)
                                                        (make-literal F)))))


;; Další doporučená četba - https://craftinginterpreters.com/
