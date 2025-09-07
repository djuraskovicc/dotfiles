use std::{
    env,
    process::{exit, Command, Output},
};

fn get_current_kb() -> String {
    let output: Output = Command::new("setxkbmap")
        .arg("-query")
        .output()
        .expect("Couldn't get keyboard layout info!");

    let layout: String = String::from_utf8(output.stdout).expect("Invalid UTF-8");

    layout.lines()
        .find(|line| line.contains("layout"))
        .map(|line| line.split(":").nth(1).unwrap().trim().to_string())
        .expect("Couldn't find layout line")
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 3 {
        eprintln!("Provide kb layouts that you want to switch!");
        println!("Example: kblayout us de");
        exit(1);
    }

    let layout: &str = if get_current_kb().eq(&args[1]) {
        &args[2]
    } else {
        &args[1]
    };

    Command::new("setxkbmap").arg(layout).output().unwrap();
}
