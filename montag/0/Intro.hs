max3if x y z = if x > y
               then if x > z
                    then x
                    else z
               else if y > z
                    then y
                    else z


sign x | x < 0     = -1
       | x > 0     = 1
       | otherwise = 0

isPositive x | x >= 0 = True
             | x == 0 = False
             | x < 0  = False

max3guard x y z | (x >= y) && (x >= z) = x
                | (y >= z) = y
                | otherwise = z

max3max x y z = max x (max y z)


second []           = error "Leere Liste"
second [x]          = error "zu kurz"
second (x:(y:rest)) = y


splitNumber x = (fromIntegral (floor x), x - fromIntegral (floor x))


myLast [] = error "Leer"
myLast (x:[]) = x
myLast (x:xs) = myLast xs
