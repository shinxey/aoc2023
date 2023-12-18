module Day3 where

import Data.Char (isDigit)
import qualified Data.Char as Char

-- context

data Part = Part { position :: Int, len :: Int, value :: Int }
data Context = Context { parts :: [[Part]], gears :: [[Int]] }

instance Show Part where
    show (Part pos len val) = "{ pos: " ++ show pos ++ ", len: " ++ show len ++ ", value: " ++ show val ++ "}"

emptyContext :: Context
emptyContext = Context [[], [], []] [[], [], []]

-- parsing

parseParts :: String -> Int -> [Part]
parseParts [] _ = []
parseParts str pos =
    let chars = takeWhile Char.isDigit str in
    case chars of
        [] -> parseParts (dropWhile (not . Char.isDigit) str) (pos + length (takeWhile (not . Char.isDigit) str))
        _ -> Part pos (length chars) (read chars :: Int):parseParts (dropWhile Char.isDigit str) (pos + length chars)

parseGears :: String -> Int -> [Int]
parseGears [] _ = []
parseGears (x:xs) pos
    | x == '*' =
        pos:parseGears xs (pos + 1)
    | otherwise = parseGears xs (pos + 1)

-- solving

shiftContext :: Context -> String -> Context
shiftContext (Context parts gears) line =
    let newParts = parseParts line 0
        newGears = parseGears line 0
    in
    Context (drop 1 parts ++ [newParts]) (drop 1 gears ++ [newGears])

gearMatchesPart :: Int -> Part -> Bool
gearMatchesPart gearPos part =
    let partStart = position part - 1
        partEnd = partStart + len part + 1
    in
    gearPos >= partStart && gearPos <= partEnd

countGearRatios :: [[Part]] -> Int -> Int
countGearRatios parts gear =
    let matchingParts = filter (gearMatchesPart gear) . concat $ parts
    in
    if length matchingParts /= 2 then 0 else product . map value $ matchingParts

countRatios :: Context -> Int
countRatios (Context parts gears) = sum . map (countGearRatios parts) $ gears!!1

day3Solve :: Context -> [String] -> Int
day3Solve _ [] = 0
day3Solve context (line:lines) =
    let newContext = shiftContext context line
    in
    countRatios newContext + day3Solve newContext lines

day3 :: String -> Int
day3 content = day3Solve emptyContext (lines content)

