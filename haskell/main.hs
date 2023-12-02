import System.Environment
import Data.Char
import Data.String
import Data.Maybe
import Data.List

prefixes :: [String]
prefixes = 
    [ "1", "2", "3", "4", "5", "6", "7", "8", "9"
    , "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

matchPrefix :: String -> Maybe Int
matchPrefix string = 
    case find (\(_, v) -> v `isPrefixOf` string) (zip [0..] prefixes) of
        Just (idx, _) -> Just $ (idx `mod` 9) + 1
        Nothing -> Nothing

findDigits :: String -> [Int] -> [Int]
findDigits [] acc = acc
findDigits (x:xs) acc =
    case matchPrefix (x:xs) of
        Just value -> findDigits xs (acc ++ [value])
        Nothing -> findDigits xs acc

calibrationValue :: String -> Int
calibrationValue string =
    let digits = findDigits string []
    in
        head digits * 10 + last digits

sumOfCalibrationValues :: [String] -> Int
sumOfCalibrationValues = sum . map calibrationValue

main = do
    content <- readFile "inputs/input1.txt"
    let linesOfFile = lines content
    let answer = sumOfCalibrationValues linesOfFile
    print answer
    return ()

