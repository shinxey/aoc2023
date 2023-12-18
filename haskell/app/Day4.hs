module Day4 where

import Data.List.Split
import Data.Char (isSpace)
import Data.List (dropWhileEnd)

-- Card

data Card = Card { winningNumbers :: [Int], cardNumbers :: [Int] }

parseNumbers :: String -> [Int]
parseNumbers = map read . filter (not . null) . splitOn " "

parseCard :: String -> Card
parseCard str = 
    let components = splitOn "|" . last . splitOn ": " $ str in
    Card (parseNumbers $ head components) (parseNumbers $ components!!1)

numberOfWinningNumbers :: Card -> Int
numberOfWinningNumbers (Card wn cn) = length (filter (`elem` wn) cn)

-- Solution part 1

points :: Int -> Int
points p = if p > 0 then 2 ^ (p - 1) else 0

day4 :: String -> Int
day4 = sum . map (points . numberOfWinningNumbers . parseCard) . lines

-- Solution part 2

data Copy = Copy { copyCount :: Int, copyTtl :: Int }

reduceCopiesTtl :: [Copy] -> [Copy]
reduceCopiesTtl [] = []
reduceCopiesTtl ((Copy cnt ttl):copies)
    | ttl > 0 = Copy cnt (ttl - 1):reduceCopiesTtl copies
    | otherwise = reduceCopiesTtl copies

totalSctratchCards :: [Copy] -> [Card] -> Int
totalSctratchCards _ [] = 0
totalSctratchCards copies (card:cards) = 
    let wnc = numberOfWinningNumbers card
        cardCopies = (sum . map copyCount $ copies) + 1
        newCopy = Copy cardCopies wnc
    in
    cardCopies + totalSctratchCards (reduceCopiesTtl (newCopy:copies)) cards

day4part2 :: String -> Int
day4part2 = totalSctratchCards [] . map parseCard . lines

