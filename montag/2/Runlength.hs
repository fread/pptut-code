module Runlength where

-- "aaaaaaaaaeeeeeeeeekkkkkkkkcccccc" -> [('a', 9), ('e', ?), ...]

splitWhen :: (Char -> Bool) -> [Char] -> ([Char], [Char])
splitWhen p [] = ([], [])
splitWhen p (x:xs) | not (p x) = let (r1, r2) = (splitWhen p xs)
                                 in (x : r1, r2)
                   | otherwise = ([], x:xs)

group :: [Char] -> [[Char]]
group []     = []
group (x:xs) = let (firstGroup, rest) = splitWhen (/=x) (x:xs)
               in firstGroup : group rest

encode l = map (\str -> (head str, length str)) (group l)

decode :: [(Char, Int)] -> [Char]
decode = concatMap (\(c, n) -> replicate n c)
