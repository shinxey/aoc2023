module Day2 where

import Data.List
import Data.List.Split

colors :: [String]
colors = ["red", "green", "blue"]

colorIdx :: String -> Int
colorIdx string = 
    case find (\(_, x) -> x == string) (zip [0..] colors) of
        Just (idx, _) -> idx
        Nothing -> -1

setListElem :: Int -> a -> [a] -> [a]
setListElem idx newElem list = take idx list ++ [newElem] ++ drop (idx + 1) list

extractCubesRecursion :: [Int] -> [String] -> [Int]
extractCubesRecursion acc [] = acc
extractCubesRecursion acc (x:xs) = 
    let components = splitOn " " x
        colorIndex = colorIdx (components!!1)
        cubesCount = acc!!colorIndex
        newCubesCount = read (components!!0) :: Int
        newAcc = setListElem colorIndex (max cubesCount newCubesCount) acc
    in extractCubesRecursion newAcc xs

extractMaxCubes :: String -> [Int]
extractMaxCubes = extractCubesRecursion (map (\_ -> 0) colors) . concatMap (splitOn ", ") . splitOn "; "

gamePower :: String -> Int
gamePower = product . extractMaxCubes . last . splitOn ": "

day2 :: String -> Int
day2 = sum . map gamePower . lines

