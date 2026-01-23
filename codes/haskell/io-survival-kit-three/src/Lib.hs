module Lib
    ( someFunc
    ) where

import Data.Char
import Data.List
import Data.List.Unique
import Data.Function

xs :: String
xs = "Hello, world. And may the force be with you. You and you."

ys :: String
ys = [y | x <- xs, let y = if isAlpha x then toLower x else ' ']

zs :: [String]
zs = words ys

zs' = count zs

someFunc :: IO ()
someFunc = print zs'

