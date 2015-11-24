module Ast where

-- alles Integer
-- Konstanten, Variablen, Addition, Multiplikation
data Exp t = Const Integer
           | Var t
           | Add (Exp t) (Exp t)
           | Mul (Exp t) (Exp t)
           -- cond ? then : else
           | IfThenElse (Exp t) (Exp t) (Exp t)

testEnv "x" = 7
testEnv "y" = 3

eval :: (t -> Integer) -> Exp t -> Integer
eval f (Const x) = x
eval f (Var v)   = f v
eval f (Add x y) = (eval f x) + (eval f y)
eval f (Mul x y) = (eval f x) * (eval f y)
eval f (IfThenElse c t e) = if (eval f c) /= 0 then (eval f t) else (eval f e)


instance Show t => Show (Exp t) where
  show (Const x) = show x
  show (Var v)   = show v
  show (Add x y) = "(" ++ show x ++ " + " ++ show y ++ ")"
  show (Mul x y) = "(" ++ show x ++ " * " ++ show y ++ ")"
  show (IfThenElse c t e) = "if (" ++ show c ++ ") then (" ++ show t ++ ") else (" ++ show e ++ ")"
