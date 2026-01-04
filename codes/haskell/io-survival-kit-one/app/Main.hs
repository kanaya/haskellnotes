module Main (main) where
f :: Double -> Double
f x = x * x
main :: IO ()
main = print . f . read =<< getLine