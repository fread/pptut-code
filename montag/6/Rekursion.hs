fib 0 = 1
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

foo n | n <= 100 = (foo (foo (n + 11)))
      | otherwise = n - 10


result = let k x y = x in k 12 (k True 'a')

result' :: (forall a b . a -> b -> a) -> Int
result' = \k -> k (12 :: Int) (k True 'a')
