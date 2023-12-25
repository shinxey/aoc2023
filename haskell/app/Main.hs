import Day1
import Day2
import Day3
import Day4
import Day5
import Day6
import Day7
import Day8
import Day9
import Day10
import Day11

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

    day5Input <- readFile "inputs/input5.txt"
    putStrLn ("day 5 answer is " ++ (show . day5 $ day5Input))
    putStrLn ("day 5 part 2 answer is " ++ (show . day5part2 $ day5Input))

    day6Input <- readFile "inputs/input6.txt"
    putStrLn ("day 6 answer is " ++ (show . day6 $ day6Input))
    putStrLn ("day 6 part 2 answer is " ++ (show . day6Part2 $ day6Input))

    day7Input <- readFile "inputs/input7.txt"
    putStrLn ("day 7 answer is " ++ (show . day7 $ day7Input))
    putStrLn ("day 7 part 2 answer is " ++ (show . day7part2 $ day7Input))

    day8Input <- readFile "inputs/input8.txt"
    putStrLn ("day 8 answer is " ++ (show . day8 $ day8Input))
    putStrLn ("day 8 part 2 answer is " ++ (show . day8part2 $ day8Input))

    day9Input <- readFile "inputs/input9.txt"
    putStrLn ("day 9 answer is " ++ (show . day9 $ day9Input))
    putStrLn ("day 9 part 2 answer is " ++ (show . day9Part2 $ day9Input))

    day10Input <- readFile "inputs/input10.txt"
    putStrLn ("day 10 answer is " ++ (show . day10 $ day10Input))
    putStrLn ("day 10 part 2 answer is " ++ (show . day10Part2 $ day10Input))

    day11Input <- readFile "inputs/input11.txt"
    putStrLn ("day 11 answer is " ++ (show . day11 $ day11Input))
    putStrLn ("day 11 part 2 answer is " ++ (show . day11Part2 $ day11Input))

    return ()

