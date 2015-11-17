module Merge where

merge (x:xs) (y:ys) | (x <= y) = x : (merge xs (y:ys))
                    | (x  > y) = y : (merge (x:xs) ys)
merge xs ys = xs ++ ys

oddPrimes (p:ps) = p : (oddPrimes [p1 | p1 <- ps, mod p1 p /= 0])
primes = 2 : oddPrimes (tail (iterate (+2) 1)) -- aus Vorlesung

-- { p^i | p Primzahl, 1 <= i <= n }
primepowers :: Integer -> [Integer]
primepowers n = foldl merge [] lists
  where
    lists = [ map (^x) primes | x <- [1..n] ]
