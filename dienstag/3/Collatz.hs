module Collatz where

import Data.Function
import Data.List

-- a_n+1 = a_n/2 falls a_n gerade
--       = 3 * a_n + 1 sonst

collatz a0 = iterate f a0
  where
    f an | an `mod` 2 == 0 = an `div` 2
         | otherwise = 3 * an + 1

num a0 = length (takeWhile (/=1) (collatz a0))

maxNum a b = head (sortBy cmp (zip [a..b] (map num [a..b])))
  where
    cmp (_,x) (_,y) | x < y = GT
                    | x == y = EQ
                    | x > y = LT

    cmp' (_,x) (_,y) = compare y x

    cmp'' = ((flip compare) `on` snd)
