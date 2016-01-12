import Wave

{------------------------------------------------------------------------------
 - Bitte kopieren Sie ihre Funktionen an diese Stelle und kommentieren Sie    -
 - dann die folgende Zeile aus!                                               -
 ------------------------------------------------------------------------------}
import Sound

-- Notes C4..B4
notes4 = [
  ("c4",  261.63),
  ("c#4", 277.18),
  ("d4",  293.66),
  ("d#4", 311.13),
  ("e4",  329.63),
  ("f4",  349.23),
  ("f#4", 369.99),
  ("g4",  392.00),
  ("g#4", 415.00),
  ("a4",  440.00),
  ("a#4", 466.16),
  ("b4",  493.88)
  ]
-- We can generate the other octaves by doubling/halving the frequencies
notes5 = map (\(name, freq) -> ((init name)++"5", freq*2.0)) notes4
notes3 = map (\(name, freq) -> ((init name)++"3", freq/2.0)) notes4
notes2 = map (\(name, freq) -> ((init name)++"2", freq/2.0)) notes3
notes = notes2 ++ notes3 ++ notes4 ++ notes5 ++ [ ("", 0) ]

note2Freq :: String -> Double
note2Freq name = case lookup name notes of
  (Just x)  -> x
  (Nothing) -> error ("note2Freq: Invalid note name " ++ name)

leadPattern0 = [
  ("g4", 2),
  ("f4", 2),
  ("g4", 2),
  ("d4", 2),
  ("a#3", 1),
  ("d4", 2),
  ("g3", 2),
  ("", 3)
  ]
leadPattern1 = [
  ("g4", 2),
  ("a4", 2),
  ("a#4", 2),
  ("a4", 1),
  ("a#4", 2),
  ("a#4", 2),
  ("g4", 1),
  ("a4", 2),
  ("g4", 1),
  ("a4", 2),
  ("a4", 2),
  ("f4", 1),
  ("g4", 2),
  ("f4", 1),
  ("g4", 2),
  ("g4", 2),
  ("f4", 1),
  ("g4", 4)
  ]

bassPattern = [
  ("g2", 2),
  ("g2", 2),
  ("d2", 2),
  ("f2", 1),
  ("g2", 2),
  ("g2", 2),
  ("g2", 1),
  ("d2", 2),
  ("f2", 2)
  ]

pattern2Notes :: Double -> [(String, Double)] -> [(Double, Double)]
pattern2Notes speed = map (\(noteName, l) -> (note2Freq noteName, l*speed))

completeBass = bassPattern ++ bassPattern ++ bassPattern ++ bassPattern ++ bassPattern ++ bassPattern
completeLead = [("", 12)] ++ leadPattern0 ++ leadPattern0 ++ leadPattern1

bass :: Instrument
bass freq = base * hull
  where
    base = sine (2*freq)
    hull = hullCurve 0.01 0.05 0.3 0.5

leadSynth :: Instrument
leadSynth freq = base * hull
  where
    base = abs (sine freq)
    hull = hullCurve 0.01 0.1 0 0.0001

speed = 6/50
song = 0.4*(play bass (pattern2Notes speed completeBass)) + 0.6*(play leadSynth (pattern2Notes speed completeLead))
