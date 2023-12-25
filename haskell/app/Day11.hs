module Day11 where

import Data.List
import Data.Maybe

data Pos = Pos Int Int
    deriving (Eq, Ord, Show)

emptyLines :: [String] -> [Int]
emptyLines lines = map fst $ filter snd $ zip [0..] $ map (all (=='.')) lines

between :: Int -> Int -> Int -> Bool
between l r val = min l r < val && val < max l r

distance :: Pos -> Pos -> [Int] -> [Int] -> Int -> Int
distance (Pos x1 y1) (Pos x2 y2) er ec c = abs (x1 - x2) + abs(y1 - y2) - er' - ec' + er' * c + ec' * c
    where
      er' = length $ filter id $ map (between y1 y2) er
      ec' = length $ filter id $ map (between x1 x2) ec

distances :: [Pos] -> [Int] -> [Int] -> Int -> [Int]
distances ps er ec c = [ distance p1 p2 er ec c | p1 <- ps, p2 <- ps, p1 /= p2 ]

galaxies :: [String] -> [Pos]
galaxies lines = concatMap (catMaybes . mapLine) (zip lines [0..])
    where
        mapLine (line, y) = map (\(ch, x) -> mapChar ch x y) (zip line [0..])
        mapChar ch x y = if ch == '#' then Just $ Pos x y else Nothing

solve :: Int -> String -> Int
solve coef content = sum ds `div` 2
    where
      contentLines = lines content
      allGalaxies = galaxies . lines $ content
      emptyRows = emptyLines contentLines
      emptyCols = emptyLines $ transpose contentLines
      ds = distances allGalaxies emptyRows emptyCols coef

day11 :: String -> Int
day11 = solve 2

day11Part2 :: String -> Int
day11Part2 = solve 1000000

