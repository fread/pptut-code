pow2 b 0 = 1
pow2 b e | (e < 0)  = error "negative exponent"
         | (odd e)  = b * pow2 (b*b) (e `div` 2)
         | (even e) = pow2 (b*b) (e `div` 2)


pow3 b e | (e < 0) = error "negative exponent"
         | otherwise = helper b e 1
  where
    helper b 0 acc = acc
    helper b e acc | (even e) = helper (b*b) (e `div` 2) (acc)
                   | otherwise = helper (b*b) (e `div` 2) (acc*b)


-- e-te Wurzel aus r
root 0 r = error "zero root not allowed."
root e r | (e < 0) = error "negative exponent"
         | (r < 0) = error "imaginary numbers not supported"
         | otherwise = interval 0 (r + 1)
  where
    interval a b | ((b-a) <= 1) = a
                 | m `pow3` e <= r = interval m b
                 | m `pow3` e  > r = interval a m
      where

            m = (a+b) `div` 2



-- pow1 b e = b * b * b * ... (e mal) ... * b
-- [b, b, b, b, b, b, b] (Länge e)
pow1Fold b e = product (replicate e b)

insert x [] = [x]
insert x (l:rest) | (x < l) = (x:l:rest)
                  | otherwise = l:(insert x rest)

insertSort = foldr insert []


merge (x:xs) (y:ys) | (x <= y) = x : (merge xs (y:ys))
                    | (x  > y) = y : (merge (x:xs) ys)
merge xs ys = xs ++ ys


mergesort [] = []
mergesort [x] = [x]
mergesort l = merge (mergesort (take half l)) (mergesort (drop half l))
  where
    half = length l `div` 2
