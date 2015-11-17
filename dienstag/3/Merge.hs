module Merge where

merge (a:as) (b:bs) | (a <= b)  = a : merge as (b:bs)
                    | otherwise = b : merge (a:as) bs
merge as bs = as ++ bs

oddPrimes (p:ps) = p : (oddPrimes [p1 | p1 <- ps, mod p1 p /= 0])
primes = 2 : oddPrimes (tail (iterate (+2) 1)) -- aus Vorlesung

-- primepowers n = sort { p^i | p Primzahl, 1 <= i <= n }
primepowers n = foldr merge [] [ primesToPower p | p <- [1..n] ]
   where
    primesToPower i = [ p^i | p <- primes ]
