module Hamming where

hamming = [ (i, j, k, 2^i * 3^j * 5^k) | sum <- [0..],
            i <- [0..sum], j <- [0..sum-i], k <- [sum-i-j] ]

pairs = [ (x, y) | sum <- [0..], x <- [0..sum], y <- [sum - x] ]
