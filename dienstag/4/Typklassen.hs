module Typklassen where

fun6 x y = succ (toEnum (last [fromEnum x .. fromEnum y]))

foo :: Enum a => a
foo = fun6 True 't'
