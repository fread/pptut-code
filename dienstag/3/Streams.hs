module Streams where

ones = 1 : ones

nats = 0 : map (+1) nats

odds = 1 : map (+2) odds

facs = 1 : zipWith (*) (tail nats) facs

fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
