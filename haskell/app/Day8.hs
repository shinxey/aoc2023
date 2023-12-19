module Day8 where

import Data.Maybe
import Data.List.Split
import Data.Map (Map)
import qualified Data.Map as Map

solve :: Int -> String -> String -> Map String (String, String) -> Int
solve count pos (dir:dirs) m
    | pos == "ZZZ" = count
    | otherwise       = solve (count + 1) newPos dirs m
    where
        mapValue = fromJust $ Map.lookup pos m
        newPos = if dir == 'L' then fst mapValue else snd mapValue

parseMapLine :: String -> (String, (String, String))
parseMapLine line = (key, (left, right))
    where
      components = splitOn " = " line
      key = head components
      valueComponents = splitOn ", " $ last components
      left = drop 1 $ head valueComponents
      right = take 3 $ last valueComponents

parseFile :: String -> (String, Map String (String, String))
parseFile content = (directions, kvMap)
    where 
      contentLines = lines content
      directions = head contentLines
      kvMap = Map.fromList $ map parseMapLine (drop 2 contentLines)

day8 :: String -> Int
day8 content = solve 0 "AAA" (cycle directions) kvMap
    where (directions, kvMap) = parseFile content

-- part 2

isEnd :: String -> Bool
isEnd pos = last pos == 'Z'

solve' :: Int -> String -> String -> Map String (String, String) -> Int
solve' count pos (dir:dirs) m
    | isEnd pos = count
    | otherwise = solve' (count + 1) newPos dirs m
    where
        mapValue = fromJust $ Map.lookup pos m
        newPos = if dir == 'L' then fst mapValue else snd mapValue

lcmFromList :: [Int] -> Int
lcmFromList [] = 1
lcmFromList [x] = x
lcmFromList (x:xs) = let next = lcmFromList xs in (next * x) `div` gcd next x

day8part2 :: String -> Int
day8part2 content = lcmFromList $ map (\x -> solve' 0 x (cycle directions) kvMap) startPositions
    where
      contentLines = lines content
      directions = head contentLines
      kvMap = Map.fromList $ map parseMapLine (drop 2 contentLines)
      startPositions = filter (\x -> last x == 'A') $ Map.keys kvMap
