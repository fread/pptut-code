module Hirsch where

import Data.List (sort)

atLeastElements :: [Int] -> Int -> Bool
atLeastElements l n = length (filter (>=n) l) >= n

atLeastElements' l n = n <= foldr (\x acc -> if x >= n then acc+1 else acc) 0 l


hIndexCorrect hIndex l = all (atLeastElements l) [1..hIndex l] &&
                         not (atLeastElements l (hIndex l + 1))


hIndex l = length (filter id (zipWith (<=) [1..] (reverse (sort l))))
