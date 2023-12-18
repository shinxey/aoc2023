import Day1
import Day2
import Day3
import Day4

main = do
    day1Input <- readFile "inputs/input1.txt"
    putStrLn ("day 1 part 2 answer is " ++ (show . day1 $ day1Input))
    day2Input <- readFile "inputs/input2.txt"
    putStrLn ("day 2 part 2 answer is " ++ (show . day2 $ day2Input))
    day3Input <- readFile "inputs/input3.txt"
    putStrLn ("day 3 part 2 answer is " ++ (show . day3 $ day3Input))
    day4Input <- readFile "inputs/input4.txt"
    putStrLn ("day 4 answer is " ++ (show . day4 $ day4Input))
    putStrLn ("day 4 part 2 answer is " ++ (show . day4part2 $ day4Input))
    return ()

