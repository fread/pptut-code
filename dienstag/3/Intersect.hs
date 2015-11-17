module Intersect where

import Merge

intersect :: (Ord a) => [a] -> [a] -> [a]
intersect (x:xs) (y:ys) | x == y = x : intersect xs ys
                        | x <  y = intersect xs (y:ys)
                        | x >  y = intersect (x:xs) ys
intersect xs ys = []


intersectAll []        = error ""
intersectAll (l:lists) = foldr intersect l lists


commonMultiples a b c d e = intersectAll [[ a * i | i <- [1..] ],
                                          map (*b) [1..],
                                          [c, 2*c..],
                                          iterate (+d) d,
                                          let es = e : map (+e) es in es]
