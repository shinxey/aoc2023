{-# LANGUAGE TupleSections #-}

module Day5 where
import Data.List
import Data.List.Split (splitOn, chunksOf)

-- parsing

data MapEntry = MapEntry { destination :: Int, source :: Int, length :: Int }

instance Show MapEntry where
    show (MapEntry d s l) = "{ d: " ++ show d ++ ", s: " ++ show s ++ ", l: " ++ show l ++ " }"

entryContains :: Int -> MapEntry -> Bool
entryContains elem (MapEntry _ src len) =
    let offset = elem - src in
    offset >= 0 && offset < len

-- returns tuple (rangeStart, length)
parseSeeds :: String -> [(Int, Int)]
parseSeeds = map ((, 1) . read) . filter (not . null) . splitOn " " . last . splitOn "seeds: "

parseSeedsRanges :: String -> [(Int, Int)]
parseSeedsRanges = map (\x -> (head x, last x)) . chunksOf 2 . map read . filter (not . null) . splitOn " " . last . splitOn "seeds: "

parseMapEntry :: String -> MapEntry
parseMapEntry = (\x -> MapEntry (head x) (x!!1) (x!!2)) . map (read :: String -> Int) . splitOn " "

parseMap :: String -> [MapEntry]
parseMap = map parseMapEntry . filter (not . null) . drop 1 . splitOn "\n"

parseFile :: (String -> [(Int, Int)]) -> String -> ([(Int, Int)], [[MapEntry]])
parseFile seedsParse content = 
    let components = splitOn "\n\n" content in
    (seedsParse . head $ components, map parseMap . drop 1 $ components)

-- applying maps

applyMap :: [(Int, Int)] -> [MapEntry] -> [(Int, Int)]
applyMap [] _ = []
applyMap ((rstart, rlen):ranges) map =
    case find (entryContains rstart) map of
        Nothing                     -> (rstart, rlen):applyMap ranges map
        Just (MapEntry dst src len) ->
            let offset = rstart - src in
            if offset + rlen > len
                then applyMap ((rstart, len - offset):(src + len, rlen - len + offset):ranges) map
                else (dst + offset, rlen):applyMap ranges map

applyMaps :: [(Int, Int)] -> [[MapEntry]] -> [(Int, Int)]
applyMaps = foldl applyMap

-- solutions

day5 :: String -> Int
day5 content = 
   let (ranges, maps) = parseFile parseSeeds content in
   foldr (min . fst) maxBound . applyMaps ranges $ maps

day5part2 :: String -> Int
day5part2 content = 
    let (ranges, maps) = parseFile parseSeedsRanges content in
    foldr (min . fst) maxBound . applyMaps ranges $ maps

