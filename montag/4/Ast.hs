module Ast where

data Exp t = Sum (Exp t) (Exp t)
           | Var t
           | Const Integer
           | Mul (Exp t) (Exp t)
             -- condition ? then : else
           | ITE (Exp t) (Exp t) (Exp t)
           deriving (Eq)

type Env t = t -> Integer

testEnv "x" = 42
testEnv _ = undefined

eval :: Env t -> Exp t -> Integer
eval env (Const c)      = c
eval env (Var v)        = env v
eval env (Sum e1 e2)    = (eval env e1) + (eval env e2)
eval env (Mul e1 e2)    = (eval env e1) * (eval env e2)
eval env (ITE cond t e) = if (eval env cond) /= 0 then (eval env t) else (eval env e)

instance Show t => Show (Exp t) where
  show (Sum e1 e2) = "(" ++ (show e1) ++ " + " ++ show e2 ++ ")"
  show (Mul e1 e2) = "(" ++ (show e1) ++ " * " ++ show e2 ++ ")"
  show (ITE c t e) = "(" ++ (show c) ++ " ? " ++ (show t) ++ " : " ++ (show e) ++ ")"
  show (Const c)   = show c
  show (Var v)     = "var_" ++ show v
