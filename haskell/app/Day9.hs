module Day9 where

import Data.List.Split

diffSequence :: [Int] -> [Int]
diffSequence [_] = []
diffSequence [x, x2] = [x2 - x]
diffSequence (x:x2:xs) = (x2 - x):diffSequence (x2:xs)

allDiffSequences :: [Int] -> [[Int]]
allDiffSequences sequence
    | all (==0) sequence = []
    | otherwise = newDiffSequence:allDiffSequences newDiffSequence
    where newDiffSequence = diffSequence sequence

extrapolatedValue :: [Int] -> Int
excrapolatedValue [] = 0
extrapolatedValue values = sum . map last $ sequences
    where sequences = values:allDiffSequences values

parseFile :: String -> [[Int]]
parseFile = map (map read . splitOn " ") . lines

day9 :: String -> Int
day9 = sum . map extrapolatedValue . parseFile

backtrapolatedValue :: [Int] -> Int
backtrapolatedValue values = foldr ((-) . head) 0 sequences
    where sequences = values:allDiffSequences values

day9Part2 :: String -> Int
day9Part2 = sum . map backtrapolatedValue . parseFile

