import Day1
import Day2

main = do
    day1Input <- readFile "inputs/input1.txt"
    putStrLn ("day 1 answer is " ++ (show . day1 $ day1Input))
    day2Input <- readFile "inputs/input2.txt"
    putStrLn ("day 2 answer is " ++ (show . day2 $ day2Input))
    return ()

