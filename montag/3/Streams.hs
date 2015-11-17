module Streams where

ones = 1 : ones

nats = 0 : map (+1) nats

facs = 1 : zipWith (*) (tail nats) facs

fibs = 0 : 1 : zipWith (+) fibs (drop 1 fibs)
