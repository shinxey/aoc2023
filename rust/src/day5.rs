use std::fmt::Debug;
use std::fs;
use std::mem::swap;

#[derive(Clone)]
struct MapEntry {
    destination_start: i64,
    source_start: i64,
    count: i64
}

impl Debug for MapEntry {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "M: {{ d:{}, s: {}, c: {} }}\n", self.destination_start, self.source_start, self.count)
    }
}

impl MapEntry {
    fn from(s: &str) -> Self {
        let mut fields = s.split(" ").map(|f| f.parse::<i64>().unwrap());

        let destination_start = fields.next().unwrap();
        let source_start = fields.next().unwrap();
        let count = fields.next().unwrap();

        Self {
            destination_start,
            source_start,
            count
        }
    }
}

pub fn run() -> i64 {
    let file_content = fs::read_to_string("inputs/input5.txt").unwrap();

    let (seeds_str, remaining_content) = file_content.trim()
        .split_once("\n\n").unwrap();

    let seeds: Vec<_> = seeds_str.split_once(": ").unwrap().1
        .split(" ")
        .map(|s| s.parse::<i64>().unwrap())
        .collect();

    let mut result_map: Vec<Vec<MapEntry>> = Vec::new();

    remaining_content.split("\n\n")
        .for_each(|map| {
            let mut entry_map: Vec<_> = map.split("\n")
                .skip(1)
                .map(|e| MapEntry::from(e))
                .collect();
            entry_map.sort_by(|a, b| a.source_start.cmp(&b.source_start));

            result_map.push(entry_map);
        });

    let mut result: i64 = i64::MAX;

    for seed in seeds {
        let mut location: i64 = seed;

        for i in 0 .. result_map.len() {
            for map_entry in &result_map[i] {
                let relative_position = location - map_entry.source_start;
                if relative_position >= 0 && relative_position < map_entry.count {
                    location = map_entry.destination_start + relative_position;
                    break;
                }
            }
        }

        result = result.min(location);
    }

    result
}

// part two

pub fn run_part2() -> i64 {
    let file_content = fs::read_to_string("inputs/input5.txt").unwrap();

    let (seeds_str, remaining_content) = file_content.trim()
        .split_once("\n\n").unwrap();

    let seed_ranges: Vec<(i64, i64)> = seeds_str.split_once(": ").unwrap().1
        .split(" ")
        .map(|v| v.parse::<i64>().unwrap())
        .collect::<Vec<_>>()
        .chunks(2)
        .map(|c| (c[0], c[1]))
        .collect();

    let maps: Vec<Vec<(i64, i64, i64)>> = remaining_content.split("\n\n")
        .map(|map| {
            let entry_map: Vec<(i64, i64, i64)> = map.split("\n")
                .skip(1)
                .map(|e| {
                    let mut iter = e.split(" ").map(|i| i.parse::<i64>().unwrap());
                    let dest: i64 = iter.next().unwrap();
                    let source = iter.next().unwrap();
                    let length = iter.next().unwrap();
                    (dest, source, length)
                })
                .collect();

            entry_map
        })
        .collect();

    let mut queue: Vec<(i64, i64)> = seed_ranges.clone();
    let mut next_queue: Vec<(i64, i64)> = Vec::new();

    for i in 0 .. maps.len() {
        'queue: while let Some(range) = queue.pop() {
            for map in &maps[i] {
                let offset = range.0 - map.1;
                if offset >= 0 && offset < map.2 {
                    if range.1 + offset <= map.2 {
                        next_queue.push((map.0 + offset, range.1));
                        continue 'queue;
                    } else {
                        queue.push((range.0, map.2 - offset));
                        queue.push((map.1 + map.2, range.1 - map.2 + offset));
                        continue 'queue;
                    }
                }
            }

            next_queue.push(range);
        }

        swap(&mut queue, &mut next_queue);
        next_queue.clear();
    }

    queue.iter()
        .map(|v| v.0)
        .min()
        .unwrap()
}

