use std::{fs, collections::HashSet};

fn count_points(card: &str) -> u32 {
    let (_, card_content) = card.split_once(": ").unwrap();

    let (winning_numbers, card_numbers) = card_content.split_once(" | ").unwrap();

    let mut numbers_set: HashSet<u32> = HashSet::new();

    winning_numbers.split_whitespace()
        .map(|n| n.trim().parse::<u32>().unwrap())
        .for_each(|n| { numbers_set.insert(n); });

    let something: u32 = card_numbers.split_whitespace()
        .map(|n| n.trim().parse::<u32>().unwrap())
        .map(|n| numbers_set.contains(&n))
        .map(|b| b as u32)
        .sum();

    if something > 0 {
        1 << (something - 1)
    } else {
        0
    }
}

pub fn run() -> u32 {
    //let filename = "inputs/input4_test.txt";
    let filename = "inputs/input4.txt";

    fs::read_to_string(filename).unwrap()
        .lines()
        .map(count_points)
        .sum()
}

// part two

fn count_winning_numbers(card: &str) -> u32 {
    let (_, card_content) = card.split_once(": ").unwrap();

    let (winning_numbers, card_numbers) = card_content.split_once(" | ").unwrap();

    let mut numbers_set: HashSet<u32> = HashSet::new();

    winning_numbers.split_whitespace()
        .map(|n| n.trim().parse::<u32>().unwrap())
        .for_each(|n| { numbers_set.insert(n); });

    card_numbers.split_whitespace()
        .map(|n| n.trim().parse::<u32>().unwrap())
        .map(|n| numbers_set.contains(&n))
        .map(|b| b as u32)
        .sum()
}

#[derive(Debug)]
struct Copy {
    count: u32,
    ttl: u32
}

pub fn run_part2() -> u32 {
    //let filename = "inputs/input4_test.txt";
    let filename = "inputs/input4.txt";

    let mut copies: Vec<Copy> = Vec::new();

    fs::read_to_string(filename).unwrap()
        .lines()
        .map(count_winning_numbers)
        .map(|winning_numbers| -> u32 {
            let card_copies: u32 = copies.iter_mut()
                .map(|c| {
                    c.ttl -= 1;
                    c.count
                })
                .sum();
            copies.retain(|c| c.ttl > 0);
            let card_copies = card_copies + 1;

            if winning_numbers > 0 {
                let copy = Copy { count: card_copies, ttl: winning_numbers };
                copies.push(copy);
            }

            card_copies
        })
        .sum()
}

