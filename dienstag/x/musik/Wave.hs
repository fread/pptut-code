{- Simple module to write (audio-) wave Signals to ".wav"-files -}
module Wave where

import Data.Word
import Data.Binary.Put
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Char8 as B
import qualified Data.Binary.Builder as BB

-- Represents a wave signal.
-- For audio signals the values should be in the interval [-1.0, 1.0]
data Signal = Signal [Double] deriving(Show, Eq)

-- samples per second
sampleRate :: Double
sampleRate = 44100

-- Converts a time in seconds into a sample-position
time2Samples :: Double -> Double
time2Samples secs = secs * sampleRate

-- Create ".wav"-file
createWave :: Signal -> BL.ByteString
createWave (Signal signal) = runPut bytes
  where
    samples = toInteger (length signal)
    sampleSize = 2 -- sample size in bytes
    fmtChunkSize = 36
    sampleRate' = floor sampleRate
    dataLength = sampleSize * samples
    bytes :: Put
    bytes = do
      putByteString (B.pack "RIFF")                         -- file-magic
      putWord32le (fromInteger (dataLength + fmtChunkSize)) -- file length
      putByteString (B.pack "WAVE")                         -- filetype
      putByteString (B.pack "fmt ")                         -- chunk "fmt " begins
      putWord32le 16                                        -- chunk length
      putWord16le 1                                         -- format: pcm
      putWord16le 1                                         -- channels
      putWord32le (fromInteger sampleRate')                 -- samplerate
      putWord32le (fromInteger (sampleRate'*sampleSize))    -- bytes per second
      putWord16le (fromInteger sampleSize)                  -- bytes per sample
      putWord16le (fromInteger (sampleSize*8))              -- bits per sample
      putByteString (B.pack "data")                         -- chunk "data" begins
      putWord32le (fromInteger dataLength)                  -- chunk length
      sequence_ (map putWord16le signal16)
    signal16 :: [Word16]
    signal16 = map double2Word16 signal
    max16 :: Double
    max16 = fromIntegral ((maxBound::Word16) `div` 2)
    double2Word16 :: Double -> Word16
    double2Word16 x = fromIntegral (round (x*max16))

-- It seems some people produce signals outside the [-1,1] range, try to warn
-- them...
validSignal :: Signal -> Bool
validSignal (Signal values) = all validValue values
  where
    validValue x = (-1-epsilon) <= x && x <= (1+epsilon)
    epsilon      = 1e-10

-- Writes a .wav file to disk
-- writeWave filename signal
writeWave :: FilePath -> Signal -> IO ()
writeWave filename signal = do
  BL.writeFile filename (createWave signal)
  if not (validSignal signal) then
    putStr "Warning: Your signal is not in the [-1,1] range everywhere"
    else return ()
