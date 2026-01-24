module Lib
    ( someFunc
    ) where

import Data.Char
import Data.List

-- s :: String
-- s = "Hello, world! Hello, once again, to you and you and you."

cleanUp :: String -> String
cleanUp "" = ""
cleanUp (x:xs) = (if isAlpha x then toLower x else ' ') : cleanUp xs

countUp :: [[String]] -> [(Int, String)]
countUp [] = []
countUp (xs:xss) = [(length xs, head xs)] ++ countUp xss

compWith :: (Int, String) -> (Int, String) -> Ordering
compWith (a, _) (b, _) = compare b a

form :: [(Int, String)] -> String
form [] = ""
form (x:xs) = (let (a, b) = x in show a ++ " " ++ b) ++ "\n" ++ form xs

doEverything :: String -> String
doEverything x = form $ (sortBy compWith) $ countUp $ group $ sort $ words $ cleanUp x

doEverything' :: String -> IO String
doEverything' x = pure (doEverything x)

-- z = doEverything s
z' :: IO String
z' = doEverything' =<< getContents

someFunc :: IO ()
someFunc = putStrLn =<< z'
