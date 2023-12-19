module Day7 where
import Data.List.Split (splitOn)
import Data.List (elemIndex, sortBy)
import Data.Maybe (fromJust)
import Data.Bifunctor as BF

-- common parsing

parseLine :: String -> (String, Int)
parseLine str = 
    let components = filter (not . null) . splitOn " " $ str in
    (head components, read . last $ components)

parseFile :: String -> [(String, Int)]
parseFile = map parseLine . lines

-- common calculations

count :: Eq a => a -> [a] -> Int
count target = length . filter (==target)

combinationScore :: [Int] -> Int -> Int
combinationScore frs jokers
    | (5 - jokers) `elem` frs                 = (16 ^ 5) * 8 -- five of a kind
    | (4 - jokers) `elem` frs                 = (16 ^ 5) * 7 -- four of a kind
    | (3 `elem` frs && 2 `elem` frs) 
        || (jokers == 1 && count 2 frs == 2)  = (16 ^ 5) * 6 -- full house
    | (3 - jokers) `elem` frs                 = (16 ^ 5) * 5 -- three of a kind
    | count 2 frs == 2                        = (16 ^ 5) * 4 -- two pair
    | (2 - jokers) `elem` frs                 = (16 ^ 5) * 3 -- one pair
    | otherwise                               = 0            -- no combinations

-- part 1

labels :: [Char]
labels = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']

freqs :: String -> [Int]
freqs str = filter (>0) . map (`count` str) $ labels

labelScore :: (Char, Int) -> Int
labelScore (ch, q) = (16 ^ q) * fromJust (elemIndex ch (reverse labels))

highCardScore :: String -> Int
highCardScore hand = sum . zipWith (curry labelScore) hand $ [4,3..]

handScore :: String -> Int
handScore hand = combinationScore (freqs hand) 0 + highCardScore hand

calculateTotalPoints :: [(Int, Int)] -> Int
calculateTotalPoints = sum
    . zipWith (*) [1,2..] 
    . reverse . map snd 
    . sortBy (\(s1, _) (s2, _) -> compare s2 s1)

day7 :: String -> Int
day7 = calculateTotalPoints . map (BF.first handScore) . parseFile

-- part 2

labelsJ :: [Char]
labelsJ = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']

freqsJ :: String -> [Int]
freqsJ str = map (`count` str) $ filter (/= 'J') labelsJ

labelScoreJ :: (Char, Int) -> Int
labelScoreJ (ch, q) = (16 ^ q) * fromJust (elemIndex ch (reverse labelsJ))

highCardScoreJ :: String -> Int
highCardScoreJ hand = sum . zipWith (curry labelScoreJ) hand $ [4,3..]

handScoreJ :: String -> Int
handScoreJ hand = combinationScore (freqsJ hand) (count 'J' hand) + highCardScoreJ hand

day7part2 :: String -> Int
day7part2 = calculateTotalPoints . map (BF.first handScoreJ) . parseFile

