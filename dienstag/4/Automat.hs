module Automat where

type Map k v = [(k, v)]
-- lookup :: k -> Map k v -> Maybe v

-- data Maybe t = Nothing | Just t

data State r = S (Maybe r) (Map Char (State r))

accepts :: String -> State r -> Maybe r
accepts [] (S result map) = result
accepts (x:xs) (S result nextStateMap) = case lookup x nextStateMap of
  Nothing -> Nothing
  Just nextState -> accepts xs nextState

data Result = Zero | Bin | Oct | Dec deriving Show

automaton = start where
  start = S Nothing     (('0', s0) : [ (d, s10) | d <- ['1'..'9'] ])
  s0    = S (Just Zero) (('b', s2) : zip ['0'..'7'] (repeat s8))
  s2    = S (Just Bin)  [('0', s2), ('1', s2)]
  s8    = S (Just Oct)  (map (\x -> (x, s8)) ['0'..'7'])
  s10   = S (Just Dec)  [ (d, s10) | d <- ['0'..'9'] ]
