module Hirsch where

import Data.List (sort)

atLeastElements :: [Int] -> Int -> Bool
atLeastElements l n = length (filter (>=n) l) >= n

-- all :: (a -> Bool) -> [a] -> Bool

hIndexCorrect hIndex l = all (atLeastElements l) [0..hIndex l] &&
                         not (atLeastElements l (hIndex l + 1))

hIndex l = helper (reverse (sort l)) 0
  where
    helper (l:ls) i | i < l     = helper ls (i + 1)
                    | otherwise = i

hIndex' l = length (filter (==False) (zipWith (<=) (reverse (sort l)) [0..]))
