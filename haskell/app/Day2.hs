module Day2 where

import Data.Maybe
import Data.List
import Data.List.Split

colors :: [String]
colors = ["red", "green", "blue"]

colorIdx :: String -> Int
colorIdx string = fromJust $ elemIndex string colors

setListElem :: Int -> a -> [a] -> [a]
setListElem idx newElem list = take idx list ++ [newElem] ++ drop (idx + 1) list

extractCubes :: [Int] -> [String] -> [Int]
extractCubes acc [] = acc
extractCubes acc (x:xs) = 
    let components = splitOn " " x
        colorIndex = colorIdx (components!!1)
        cubesCount = acc!!colorIndex
        newCubesCount = read (head components) :: Int
        newAcc = setListElem colorIndex (max cubesCount newCubesCount) acc
    in extractCubes newAcc xs

extractMaxCubes :: String -> [Int]
extractMaxCubes = extractCubes (map (const 0) colors) . concatMap (splitOn ", ") . splitOn "; "

gamePower :: String -> Int
gamePower = product . extractMaxCubes . last . splitOn ": "

day2 :: String -> Int
day2 = sum . map gamePower . lines

