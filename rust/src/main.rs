mod day1;
mod day2;

fn main() {
    let day1_answer = day1::run();
    let day1_part2_answer = day1::run_part2();

    println!("day1 aoc answer is {}", day1_answer);
    println!("day1 part 2answer is {}", day1_part2_answer);

    let day2_answer = day2::run();
    println!("[day 2]: {}", day2_answer);

    let day2_part2_answer = day2::run_part2();
    println!("[day 2 part 2]: {}", day2_part2_answer);
}

