import Day1
import Day2
import Day3

main = do
    day1Input <- readFile "inputs/input1.txt"
    putStrLn ("day 1 answer is " ++ (show . day1 $ day1Input))
    day2Input <- readFile "inputs/input2.txt"
    putStrLn ("day 2 answer is " ++ (show . day2 $ day2Input))
    day3Input <- readFile "inputs/input3.txt"
    putStrLn ("day 3 answer is " ++ (show . day3 $ day3Input))
    return ()

