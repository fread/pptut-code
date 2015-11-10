module Polynom where

type Polynom = [Double]
-- [1.0, 2.0, 3.0] == 1 + 2 * x + 3 * x^2

add :: Polynom -> Polynom -> Polynom
add p q = zipWith (+) pExt qExt
  where
    pExt | length p >= length q = p
         | otherwise            = p ++ [0,0..]
    qExt | length q >= length p = q
         | otherwise            = q ++ [0,0..]


eval :: Polynom -> Double -> Double
eval p x = foldr (\a b -> a + x * b) 0.0 p

deriv :: Polynom -> Polynom
deriv p = zipWith (*) (drop 1 p) [1..]
