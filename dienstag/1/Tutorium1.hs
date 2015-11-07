-- pow2 b e = b hoch e
pow2 b 0 = 1
pow2 b e | (even e) = pow2 (b*b) (div e 2)
         | otherwise = b * (pow2 (b*b) (div e 2))

pow3 b e = helper b e 1
  where
    helper b e acc | e < 0 = error "No negative exponents"
                   | e == 0 = acc
                   | (even e)  = helper (b*b) (div e 2) acc
                   | otherwise = helper (b*b) (div e 2) (b*acc)


-- root e r = e-te Wurzel aus r
root e r | r < 0 = error "r < 0"
         | e <= 0 = error "e <= 0"
         | otherwise = interval 0 (r + 1)
  where
    interval a b | b - a == 1 = a
                 | a >= b = error "Invalid interval"
                 | pow3 guess e <= r = interval guess b
                 | otherwise = interval a guess
                 where guess = div (a+b) 2

-- pow1 b e = b * b * ... (e mal) ... * b
pow1 b e = product (replicate e b)

pow4 b e = last (take (e + 1) (iterate (*b) 1))


-- insert y liste
insert y []     = [y]
insert y (x:xs) | y > x = x : insert y xs
                | otherwise = y:x:xs

insertSort [] = []
insertSort xs = foldr insert [] xs


merge (a:as) (b:bs) | (a <= b)  = a : merge as (b:bs)
                    | otherwise = b : merge (a:as) bs
merge as bs = as ++ bs

mergeSort []  = []
mergeSort [x] = [x]
mergeSort xs = merge (mergeSort ys) (mergeSort zs)
  where (ys,zs) = splitAt (div (length xs) 2) xs
