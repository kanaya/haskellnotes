module Lib
    ( someFunc
    ) where

import System.Random
import Control.Monad (replicateM)

someFunc :: IO ()
someFunc = print =<< (replicateM 10 (randomRIO (1, 6 :: Int)))
