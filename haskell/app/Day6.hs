module Day6 where

import Data.List.Split

-- part 1 

parseLine :: String -> [Int]
parseLine = map read . filter (not . null) . splitOn " " . last . splitOn ":"

parseFile :: String -> ([Int], [Int])
parseFile content = 
    let lines = filter (not . null) . splitOn "\n" $ content in
    (parseLine $ head lines, parseLine $ last lines)

solveRace :: (Int, Int) -> Int
solveRace (time, distance) = length . filter (> distance) . map (\x -> (time - x) * x) $ [1..time]

solveAllRaces :: ([Int], [Int]) -> Int
solveAllRaces (times, distances) = product (map solveRace (zip times distances))

day6 :: String -> Int
day6 = solveAllRaces . parseFile

-- part 2

parseLine2 :: String -> Int
parseLine2 = read . filter (/= ' ') . last . splitOn ":"

parseFile2 :: String -> (Int, Int)
parseFile2 content =
    let lines = filter (not . null) . splitOn "\n" $ content in
    (parseLine2 $ head lines, parseLine2 $ last lines)

day6Part2 :: String -> Int
day6Part2 = solveRace . parseFile2
