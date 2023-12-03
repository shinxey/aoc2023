use std::{fs, mem};

struct Number {
    value: u32,
    position_start: usize,
    position_end: usize,
}

struct Processor {
    prev_symbols: Vec<usize>,
    symbols: Vec<usize>,
    prev_numbers: Vec<Number>,
    numbers: Vec<Number>,
}

impl Processor {
    fn new() -> Self {
        Self {
            prev_symbols: Vec::new(),
            symbols: Vec::new(),
            prev_numbers: Vec::new(),
            numbers: Vec::new(),
        }
    }

    fn process(&mut self, line: &str) -> u32 {
        let mut acc_start: usize = 0;
        let mut acc: u32 = 0;

        // populating symbols and numbers

        'outer: for (i, ch) in line.chars().enumerate() {
            match ch {
                '0'..='9' => {
                    if acc == 0 {
                        acc_start = i;
                    }
                    acc = acc * 10 + ch.to_digit(10).unwrap();
                    continue 'outer;
                },
                '.' => {},
                _ => self.symbols.push(i),
            }

            if acc != 0 {
                let new_number = Number {
                    value: acc,
                    position_start: acc_start,
                    position_end: i - 1
                };

                self.numbers.push(new_number);
                acc = 0;
            }
        }

        if acc != 0 {
            let new_number = Number {
                value: acc,
                position_start: acc_start - 1,
                position_end: line.len()
            };

            self.numbers.push(new_number);
        }

        // counting numbers

        let mut result: u32 = 0;
        result += Processor::count_numbers(&mut self.numbers, &mut self.symbols);
        result += Processor::count_numbers(&mut self.numbers, &mut self.prev_symbols);
        result += Processor::count_numbers(&mut self.prev_numbers, &mut self.symbols);

        mem::swap(&mut self.numbers, &mut self.prev_numbers);
        self.numbers.clear();
        mem::swap(&mut self.symbols, &mut self.prev_symbols);
        self.symbols.clear();

        result
    }

    fn count_numbers(numbers: &mut Vec<Number>, symbols: &Vec<usize>) -> u32 {
        let mut result: u32 = 0;

        for number in numbers.iter_mut() {
            for symbol in symbols.iter() {
                let mut start = number.position_start;
                if start > 0 {
                    start -= 1;
                }
                let end = number.position_end + 1;

                if symbol <= &end && symbol >= &start {
                    result += number.value;
                    (*number).value = 0;
                }
            }
        }

        result
    }
}

pub fn run() -> u32 {
    let filename = "inputs/input3.txt";

    let mut processor = Processor::new();

    fs::read_to_string(filename).unwrap()
        .lines()
        .map(|line| -> u32 {
            processor.process(line)
        })
        .reduce(|a, v| a + v)
        .unwrap()
}

// part two

struct Processor2 {
    numbers: Vec<Vec<Number>>,
    symbols: Vec<Vec<usize>>
}

impl Processor2 {
    fn new() -> Self {
        let numbers_storage: Vec<Vec<Number>> = (1..=3).map(|_|Vec::new()).collect();
        let symbols_storage: Vec<Vec<usize>> = (1..=3).map(|_|Vec::new()).collect();

        Self {
            numbers: numbers_storage,
            symbols: symbols_storage,
        }
    }

    fn process(&mut self, line: &str) -> u32 {
        let mut acc_start: usize = 0;
        let mut acc: u32 = 0;

        'outer: for (i, ch) in line.chars().enumerate() {
            match ch {
                '0'..='9' => {
                    if acc == 0 {
                        acc_start = i;
                    }
                    acc = acc * 10 + ch.to_digit(10).unwrap();
                    continue 'outer;
                },
                '*' => self.symbols[0].push(i),
                _ => {},
            }

            if acc != 0 {
                let new_number = Number {
                    value: acc,
                    position_start: acc_start,
                    position_end: i - 1
                };

                self.numbers[0].push(new_number);
                acc = 0;
            }
        }

        if acc != 0 {
            let new_number = Number {
                value: acc,
                position_start: acc_start - 1,
                position_end: line.len()
            };

            self.numbers[0].push(new_number);
        }

        let result = self.count_gears();

        self.numbers.swap(1, 2);
        self.numbers.swap(0, 1);
        self.numbers[0].clear();

        self.symbols.swap(1, 2);
        self.symbols.swap(0, 1);
        self.symbols[0].clear();

        result
    }

    fn count_gears(&mut self) -> u32 {
        let mut result: u32 = 0;

        'outer: for gear_position in self.symbols[1].iter() {
            let mut number_count: u32 = 0;
            let mut acc: u32 = 1;

            for row in self.numbers.iter() {
                for number in row.iter() {
                    let mut start_pos = number.position_start;
                    let end_pos = number.position_end + 1;
                    if start_pos > 0 {
                        start_pos -= 1;
                    }

                    if gear_position >= &start_pos && gear_position <= &end_pos {
                        number_count += 1;
                        acc *= number.value;

                        if number_count > 2 {
                            continue 'outer;
                        }
                    }
                }
            }

            if number_count == 2 {
                result += acc;
            }
        }

        result
    }
}

pub fn run_part2() -> u32 {
    let filename = "inputs/input3.txt";

    let mut processor = Processor2::new();

    let result = fs::read_to_string(filename).unwrap()
        .lines()
        .map(|line| -> u32 {
            processor.process(line)
        })
        .reduce(|a, v| a + v)
        .unwrap();

    result + processor.process("")
}

