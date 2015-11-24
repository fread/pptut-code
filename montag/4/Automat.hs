module Automat where

type Map k v = [(k, v)]
-- lookup :: (Eq k) => k -> Map k v -> Maybe v
data State r = S (Maybe r) (Map Char (State r))

-- data Maybe a = Nothing | Just a

accepts :: [Char] -> State r -> Maybe r
accepts [] (S result _) = result
accepts (x:xs) (S result map) = case lookup x map of
  Nothing -> Nothing
  Just nextState -> accepts xs nextState

data Result = Dec | Bin | Oct | Zero
            deriving Show

automaton = start where
  start = S Nothing     (('0', s0) : [ (d, s10) | d <- ['1'..'9'] ])
  s0    = S (Just Zero) (('b', s2) : zip ['0'..'7'] (repeat s8))
  s2    = S (Just Bin)  [('0', s2), ('1', s2)]
  s8    = S (Just Oct)  (map (\x -> (x, s8)) ['0'..'7'])
  s10   = S (Just Dec)  [ (d, s10) | d <- ['0'..'9'] ]
