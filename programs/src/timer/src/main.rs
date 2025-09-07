use rodio::{Decoder, OutputStream, Sink};
use std::{
    env,
    fs::File, 
    io::{self, Write, BufReader}, 
    num::ParseIntError,
    process::exit,
    thread::sleep,
    time::Duration,
};

static ERR_MESSAGE: &str = "Type `timer --help` for more info";

struct Clock {
    time: u64,
    path: String,
}

impl Clock {
    fn new(time: u64, path: String) -> Self {
        Self { time, path }
    }

    fn timer(&self) {
        for remaining in (0..=self.time).rev() {
            let hours: u64 = remaining / 3600;
            let minutes: u64 = (remaining % 3600) / 60;
            let seconds: u64 = remaining % 60;

            print!("\rTime remaining: {:02}:{:02}:{:02}", hours, minutes, seconds);
            io::stdout().flush().unwrap();
            sleep(Duration::from_secs(1));
        }
    }
}

fn parse_time(time_str: &str) -> Result<u64, ParseIntError> {
    time_str.parse::<u64>()
}

fn check_exists(path: &str) -> File {
    match File::open(path) {
        Ok(file_path) => file_path,
        Err(_) => {
            eprintln!("\nFile not found!\n{ERR_MESSAGE}");
            exit(3);
        }
    }
}

fn play_alarm(clock: Clock) {
    let (_stream, stream_handle) = OutputStream::try_default().unwrap();
    let sink = Sink::try_new(&stream_handle).unwrap();
    let file: File = check_exists(&clock.path);
    let source = Decoder::new(BufReader::new(file)).unwrap();

    println!("\nPlaying {}", clock.path);
    sink.append(source);
    sink.sleep_until_end();
}

fn check_out_of_bounds(index: usize, vec: &Vec<String>) {
    if index + 1 >= vec.len() {
        eprintln!("Missing argument for: {}", vec[index]);
        exit(5);
    }
}

fn print_help() {
    println!("Timer version 0.1 usage:
                -s  |  run timer for specific amound of seconds
                -m  |  run timer for specific amount of minutes
                -p  |  path of timeout sound or song");
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut time_in_sec: u64 = 0;
    let mut path: String = String::new();

    if args.len() == 1 {
        print_help();
        exit(0);
    }

    for i in 0..args.len() {
        match args[i].as_str() {
            "--help" => {
                print_help();
                exit(0);
            },
            "-s" => {
                check_out_of_bounds(i, &args);
                time_in_sec += parse_time(&args[i + 1]).unwrap_or_else(|_| {
                    eprintln!("{ERR_MESSAGE}");
                    exit(2);
                });
            }
            "-m" => {
                check_out_of_bounds(i, &args);
                let mins: u64 = parse_time(&args[i + 1]).unwrap_or_else(|_| {
                    eprintln!("{ERR_MESSAGE}");
                    exit(2);
                });
                time_in_sec += mins * 60;
            },
            "-h" => {
                check_out_of_bounds(i, &args);
                let hour: u64 = parse_time(&args[i + 1]).unwrap_or_else(|_| {
                    eprintln!("{ERR_MESSAGE}");
                    exit(2);
                });
                time_in_sec += hour * 3600;
            },
            "-p" => {
                check_out_of_bounds(i, &args);
                path = args[i + 1].to_owned();
            },
            _ => {},
        }
    }

    check_exists(&path);
    let clock = Clock::new(time_in_sec, path);
    Clock::timer(&clock);
    play_alarm(clock);
    println!("Bye! :)");
}
