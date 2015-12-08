module Rekursion where

fooF = \foo -> \n -> if n <= 100 then foo (foo (n + 11)) else n - 10

--theta = (\x -> \y -> y (x x y)) (\x -> \y -> y (x x y))
fix f = f (fix f)
