module Lib
    ( someFunc
    ) where

import System.Random
import Control.Monad (replicateM)

someFunc :: IO ()
someFunc = print =<< (5 `replicateM` (randomIO :: IO Float))
