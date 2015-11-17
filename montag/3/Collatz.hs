module Collatz where

import Data.List

-- a[n+1] = a[n]/2, wenn a[n] gerade
--        = 3*a[n] + 1, wenn a[n] ungerade

-- iterate :: (a -> a) -> a -> [a]

collatz = iterate (\x -> if even x then x `div` 2 else 3 * x + 1)

num a0 = snd (head (filter (\(v, i) -> v == 1) list))
  where
    list = collatz a0 `zip` [0..]


maxNum a b = maximumBy cmp ([a..b] `zip` map num [a..b])
  where
    cmp = (\(i1, v1) (i2, v2) -> compare v1 v2)
    cmp' = (compare `on` snd)
