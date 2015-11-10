module Polynom where

type Polynom = [Double]

add :: Polynom -> Polynom -> Polynom
add ps [] = ps
add [] qs = qs
add (p:ps) (q:qs) = p + q : add ps qs

add' p1 p2 = zipWith (+) p1 p2 ++ helper
  where helper | length p1 >= length p2 = drop (length p2) p1
               | otherwise              = drop (length p1) p2

add'' p q = zipWith (+) shorter longer
  where shorter | length p > length q = (q ++ repeat 0.0)
                | otherwise           = (p ++ repeat 0.0)
        longer  | length p > length q = p
                | otherwise           = q

eval :: Polynom -> Double -> Double
eval p x = foldr (\ a b -> a + x * b) 0.0 p

deriv :: Polynom -> Polynom
deriv [] = []
deriv p  = zipWith (*) (tail p) [1..]
