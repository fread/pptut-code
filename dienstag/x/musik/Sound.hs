module Sound where

import Wave
-- data Signal = Signal [Double]
-- sampleRate :: Double
-- sampleRate = 44100.0

double2int :: Double -> Int
double2int = fromInteger . floor

constant :: Double -> Signal
constant x = Signal (iterate id x)

silence :: Signal
silence = constant 0.0

sine :: Double -> Signal
sine f = Signal (map (\x -> sin (2*pi*f*x/sampleRate)) [0.0 ..])

trim :: Signal -> Double -> Signal
trim (Signal l) t = Signal (take (double2int (sampleRate * t)) l)

--(Double -> Double -> Double)
signalOp operator (Signal x) (Signal y) = Signal (zipWith operator x y)

instance Num Signal where
  -- (+) (-) (*) abs signum fromInteger
  s1 + s2 = signalOp (+) s1 s2
  (-) = signalOp (-)
  (*) = signalOp (*)
  fromInteger i = constant (fromInteger i)

instance Fractional Signal where
  -- (/), fromRational
  (/) = signalOp (/)
  fromRational r = constant (fromRational r)

rampUp :: Double -> Signal
rampUp t = Signal (map (/samples) [0..samples])
  where
    samples = (t * sampleRate)

append :: Signal -> Signal -> Signal
append (Signal s1) (Signal s2) = Signal (s1 ++ s2)

hullCurve attack decay decayLevel release =
  ramp1 `append` ramp2 `append` ramp3
  where
    ramp1 = rampUp attack
    ramp2 = constant 1 -          (1 - constant decayLevel) * (rampUp decay)
    ramp3 = constant decayLevel - constant decayLevel       * (rampUp release)
