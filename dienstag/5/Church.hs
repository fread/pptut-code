module Church where

-- Normalreihenfolge  Immer der linkeste äußerste Redex wird reduziert

-- Call-by-name Reduziere linkesten äußersten Redex
-- Aber nicht falls von einem λ umgeben

-- Call-by-value Reduziere linkesten Redex
-- der nicht von einem λ umgeben
-- und dessen Argument ein Wert ist

--               ↓↓↓↓↓↓↓↓↓↓↓↓↓↓ n mal
-- c_n = λs. λz. s (s (s ... (s z)))

type Church t = (t -> t) -> t -> t

int2church 0 = \s -> \z -> z
int2church n = \s -> \z -> s (int2church (n-1) s z)

church2int c_n =  c_n (+1) 0
