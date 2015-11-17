module Intersect where

intersect :: (Ord t) => [t] -> [t] -> [t]
intersect (x:xs) (y:ys) | (x < y)  = (intersect xs (y:ys))
                        | (x > y)  = (intersect (x:xs) ys)
                        | (x == y) = x : (intersect xs ys)
intersect xs ys = []

intersectAll :: (Ord t) => [[t]] -> [t]
intersectAll [] = error ""
intersectAll (x:xs) = foldr intersect x xs

commonMultiples a b c = intersectAll [[a,2*a..], [b,2*b..], [c,2*c..]]
