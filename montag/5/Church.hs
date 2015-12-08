module Church where

-- Normalreihenfolge  Immer der linkeste äußerste Redex wird reduziert

-- Call-by-name Reduziere linkesten äußersten Redex
-- Aber nicht falls von einem λ umgeben

-- Call-by-value Reduziere linkesten Redex
-- der nicht von einem λ umgeben
-- und dessen Argument ein Wert ist

type Church t = (t -> t) -> t -> t

--               ↓↓↓↓↓↓↓↓↓↓↓↓ n mal
-- c_n = λs. λz. s (s (... (s z)))

int2church :: Integer -> Church t
int2church 0 = \s -> \z -> z -- (= const id)
int2church n = \s -> \z -> int2church (n-1) s (s z)

church2int :: Church Integer -> Integer
church2int c = c (+1) 0

twice f x = f (f x)
