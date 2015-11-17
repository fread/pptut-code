module Hamming where

hamming = [2^i * 3^j * 5^k | i <- [0..], j <- [0..], k <- [0..] ]

tuples = [ (sum - j, j) | sum <- [0..], j <- [0..sum] ]
