use std::fs;
use std::iter;

pub fn run() -> i32 {
    let filename = "inputs/input1.txt";

    fs::read_to_string(filename).unwrap()
        .lines()
        .map(|line| -> i32 {
            let mut first: i32 = -1;
            let mut second: i32 = -1;

            line.chars().for_each(|ch| {
                if let Some(value) = ch.to_digit(10) {
                    if first < 0 {
                        first = value as i32;
                    }
                    second = value as i32;
                }
            });

            first * 10 + second
        })
        .reduce(|acc, value| acc + value)
        .unwrap()
}

#[derive(Debug)]
struct Matcher<'a> {
    strs: Vec<&'a str>,
    positions: Vec<usize>
}

impl<'a> Matcher<'a> {
    fn new(strs: Vec<&'a str>) -> Self {
        let positions: Vec<usize> = iter::repeat(0).take(strs.len()).collect();

        Matcher {
            strs,
            positions
        }
    }

    fn match_char(&mut self, ch: char) -> Option<usize> {
        let mut result: Option<usize> = None;

        for (i, st) in self.strs.iter().enumerate() {
            if st.chars().nth(self.positions[i]).unwrap() == ch {
                self.positions[i] += 1;
            } else {
                self.positions[i] = 0;
                if st.chars().nth(0).unwrap() == ch {
                    self.positions[i] += 1;
                }
            }
            if st.len() == self.positions[i] {
                self.positions[i] = 0;
                result = Some(i);
            }
        }

        result
    }

    fn reset(&mut self) {
        self.positions.iter_mut().for_each(|v| *v = 0);
    }
}

pub fn run_part2() -> i32 {
    let filename = "inputs/input1.txt";

    let words = vec![
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
        "1",   "2",   "3",     "4",    "5",    "6",   "7",     "8",     "9",
    ];
    let mut matcher = Matcher::new(words);

    fs::read_to_string(filename).unwrap()
        .lines()
        .map(|line| -> i32 {
            let mut first = -1;
            let mut second = -1;

            line.chars()
                .for_each(|ch| {
                    if let Some(idx) = matcher.match_char(ch) {
                        let mut idx = idx;
                        if idx > 8 {
                            idx -= 9;
                        }
                        if first == -1 {
                            first = idx as i32 + 1;
                        }
                        second = idx as i32 + 1;
                        println!("{:?}", matcher);
                    }
                });

            matcher.reset();

            let result = first * 10 + second;

            println!("{}: {}", line, result);

            result
        })
        .reduce(|acc, value| acc + value)
        .unwrap()
}

