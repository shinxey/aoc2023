use std::fs;

fn are_cubes_possible(cubes: &str) -> bool {
    let mut cubes = cubes.split(" ");
    let number_of_cubes = cubes.nth(0).unwrap().parse::<i32>().unwrap();
    let color_of_cubes = cubes.nth(0).unwrap();

    match color_of_cubes {
        "red" => number_of_cubes <= 12,
        "green" => number_of_cubes <= 13,
        "blue" => number_of_cubes <= 14,
        _ => false,
    }
}

fn is_game_possible(game: &str) -> bool {
    game.split("; ")
        .map(|set| set.split(", "))
        .flatten()
        .map(are_cubes_possible)
        .fold(true, |result, value| result && value)
}

fn game_id_if_possible(line: &str) -> Option<i32> {
    let mut game_components = line.split(": ");

    let game_id = game_components.nth(0).unwrap().split(" ").nth(1).unwrap().parse::<i32>().unwrap();
    let game_possible = is_game_possible(game_components.nth(0).unwrap());

    if game_possible {
        Some(game_id)
    } else {
        None
    }
}

pub fn run() -> i32 {
    let filename = "inputs/input2.txt";

    fs::read_to_string(filename).unwrap()
        .lines()
        .map(|line| -> i32 {
            game_id_if_possible(line)
                .unwrap_or(0)
        })
        .reduce(|acc, value| acc + value)
        .unwrap()
}

// part two

fn game_power(game: &str) -> i32 {
    let game = game.split(": ").nth(1).unwrap();

    let mut red = 0;
    let mut green = 0;
    let mut blue = 0;

    game.split("; ")
        .map(|set| set.split(", "))
        .flatten()
        .for_each(|cubes| {
            let mut iter = cubes.split(" ");
            let number = iter.nth(0).unwrap().parse::<i32>().unwrap();
            let color = iter.nth(0).unwrap();

            match color {
                "red" => red = red.max(number),
                "green" => green = green.max(number),
                "blue" => blue = blue.max(number),
                _ => {}
            }
        });

    red * green * blue
}

pub fn run_part2() -> i32 {
    let filename = "inputs/input2.txt";
    //let filename = "inputs/input2_test.txt";

    fs::read_to_string(filename).unwrap()
        .lines()
        .map(game_power)
        .reduce(|a, v| a + v)
        .unwrap()
}

