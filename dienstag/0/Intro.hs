x = 23

double x = 2 * x

max2if x y = if x > y then x else y

f =
  let x = 1
      y = 2
      z = 3 in
  x + y + z

max3if x y z = if x > y && x > z
                 then x
                 else if y > z
                      then y
                      else z

max3guard x y z | x > y && x > z = x
                | y > z          = y
                | otherwise      = z

max3max x y z = max x (max y z)

myHead (a:b) | a == 0 = a

data Dings = Dings Int Int

-- f 0 = "null"
-- f 1 = "eins"

g "null" = 0
g "eins" = 1

myLast [] = error "leer"
myLast [x] = x
myLast (x:xs) = myLast xs
