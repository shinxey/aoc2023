import Day1

main = do
    day1Input <- readFile "inputs/input1.txt"
    putStrLn ("day 1 answer is " ++ (show . day1 $ day1Input))
    return ()

