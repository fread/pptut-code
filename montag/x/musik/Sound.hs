module Sound where

import Wave

-- data Signal = Signal [Double]
-- sampleRate = 44100

double2Int :: Double -> Int
double2Int = fromInteger . floor

constant :: Double -> Signal
constant level = Signal (infiniteLevel)
  where
    infiniteLevel = level : infiniteLevel

silence :: Signal
silence = constant 0.0

sine :: Double -> Signal
sine freq = Signal (map (\x -> sin (2*pi*freq*x/sampleRate)) [0..])

trim :: Signal -> Double -> Signal
trim (Signal l) t = Signal (take samples l)
  where
    samples = double2Int (t * sampleRate)

instance (Num Signal) where
  (Signal s1) + (Signal s2) = (Signal (zipWith (+) s1 s2))
  (Signal s1) - (Signal s2) = (Signal (zipWith (-) s1 s2))
  (Signal s1) * (Signal s2) = (Signal (zipWith (*) s1 s2))
  fromInteger i = constant (fromInteger i)

instance (Fractional Signal) where
  (Signal s1) / (Signal s2) = (Signal (zipWith (/) s1 s2))
  fromRational r = constant (fromRational r)
