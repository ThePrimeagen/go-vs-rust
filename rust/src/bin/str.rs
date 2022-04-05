///
/// projector
/// --------------------------------------
/// dynamic environments. specify variables via file path.
///
/// string stuff
fn main() {
    // string -> usize[][]
    let can_i_get_your_digits = get_input()
        .lines()
        .map(|line| {
            return line
                .split("")
                .filter(|x| x.len() > 0)
                .map(|x| str::parse::<usize>(x))
                .map(Result::unwrap)
                .collect::<Vec<usize>>();
        })
        .collect::<Vec<Vec<usize>>>();

    let dirs: [[isize; 2]; 4] = [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
    ];

    let rows = can_i_get_your_digits.len();
    let cols = can_i_get_your_digits.get(0).unwrap().len();

    println!("THE VALUE IS {}", (0usize..rows)
        .flat_map(|row| {
            return (0usize..cols).map(move |col| {
                return (row, col);
            });
        })
        .filter_map(|(row, col)| {
            let value = can_i_get_your_digits.get(row).unwrap().get(col).unwrap();
            let mut found = true;
            for idx in 0..dirs.len() {
                let row = row.saturating_add(dirs[idx][0] as usize);
                let col = col.saturating_add(dirs[idx][1] as usize);

                let row = can_i_get_your_digits.get(row);
                if row.is_none() {
                    continue;
                }

                let row = row.unwrap();
                let col = row.get(col);
                if col.is_none() {
                    continue;
                }
                let v = col.unwrap();

                found = value < v;

                if !found {
                    break;
                }
            }

            return match found {
                true => Some(value),
                _ => None
            };
        }).
        sum::<usize>());

    return;
}

fn get_input() -> String {
    return "2199943210
3987894921
9856789892
8767896789
9899965678".to_string();
}



// My path
//
// Learning a new language
// * string processing
