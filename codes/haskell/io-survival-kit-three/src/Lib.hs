module Lib
    ( someFunc
    ) where

import Data.Char
import Data.List

-- s :: String
-- s = "Hello, world! Hello, once again, to you and you and you."

clean :: String -> String
clean "" = ""
clean (x:xs) = (if isAlpha x then toLower x else ' ') : clean xs

count :: [[String]] -> [(Int, String)]
count [] = []
count (xs:xss) = [(length xs, head xs)] ++ count xss

compIS :: (Int, String) -> (Int, String) -> Ordering
compIS (a, _) (b, _) = compare b a

form :: [(Int, String)] -> String
form [] = ""
form (x:xs) = (let (a, b) = x in show a ++ " " ++ b) ++ "\n" ++ form xs

doEverything :: String -> String
doEverything x = form $ (sortBy compIS) $ count $ group $ sort $ words $ clean x

doEverything' :: String -> IO String
doEverything' x = pure (doEverything x)

-- z = doEverything s
z' :: IO String
z' = doEverything' =<< getContents

someFunc :: IO ()
someFunc = putStrLn =<< z'
