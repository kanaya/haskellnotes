module Lib
    ( someFunc
    ) where

import Data.Char
import Data.List
import Data.Function

xs :: String
xs = "Hello, world. And may the force be with you. You and you."

ys :: String
ys = [y | x <- xs, let y = if isAlpha x then toLower x else ' ']

zs :: [String]
zs = words ys

us = group $ sort zs

countUp :: [[String]] -> [(Int, String)]
countUp [] = []
countUp (xs:xss) = [(length xs, xs !! 0)] ++ countUp xss

vs = countUp us

compWith :: (Int, String) -> (Int, String) -> Ordering
compWith (a, _) (b, _) = compare b a

ws = sortBy compWith vs

someFunc :: IO ()
someFunc = print ws
