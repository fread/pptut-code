module Runlength where

test = "aaaaaaaaaaaaaaaabbbbbbbbbbbbbaaaaaaaccccccceeeeeelllllllllllll"
-- [('a', 16), ('b', ?), ...]

splitWhen :: (a -> Bool) -> [a] -> ([a], [a])
splitWhen p l = helper l []
  where
    helper []     acc = (acc, [])
    helper (l:ls) acc | p l = (acc, l:ls)
                      | otherwise = helper ls (acc++[l])

group :: Eq a => [a] -> [[a]]
group [] = []
group xs@(x:_) = ys : group zs
  where
    (ys, zs) = splitWhen (/=x) xs

encode :: Eq a => [a] -> [(a, Int)]
encode xs = map (\xs -> (head xs, length xs)) (group xs)

decode :: [(a, Int)] -> [a]
decode xs = concat (map step xs)
  where
    step x = replicate (snd x) (fst x)
