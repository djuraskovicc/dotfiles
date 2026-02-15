use dirs::home_dir;
use rand::seq::SliceRandom;
use std::{
    env,
    fs::{read_dir, DirEntry},
    io::{Error, ErrorKind, Result},
    path::{Path, PathBuf},
    process::{exit, Command, Output},
    thread::sleep,
    time::Duration,
};

fn get_dir_path<P>(path: P) -> Result<PathBuf>
where
    P: AsRef<Path>,
{
    let mut file_path: PathBuf = home_dir()
        .ok_or_else(|| Error::new(ErrorKind::NotFound, "Couldn't find HOME directory"))?;

    file_path.push(path);

    if !file_path.is_dir() {
        return Err(Error::new(
            ErrorKind::NotFound,
            "Provided path is not a valid directory",
        ));
    }

    Ok(file_path)
}

fn main() {
    let args: Vec<String> = env::args().collect();

    let arg: &str = args.get(1).unwrap_or_else(|| {
        eprintln!("Provide path for images!");
        exit(1);
    });

    let dir_path: PathBuf = get_dir_path(arg)
        .map_err(|e| {
            eprintln!("Path doesn't exist\nError msg: {e}");
            exit(2);
        })
        .unwrap();

    let interval: Duration = Duration::from_secs(600);
    let images: Vec<DirEntry> = read_dir(dir_path)
        .unwrap()
        .filter_map(|entry| entry.ok())
        .filter(|entry| entry.path().is_file())
        .collect();

    if images.is_empty() {
        eprintln!("No images found in directory!");
        exit(3);
    }

    loop {
        let image: &DirEntry = images.choose(&mut rand::thread_rng()).unwrap();
        let path: PathBuf = image.path();
        let image_path: &str = path.to_str().unwrap();

        let output: Output = Command::new("xwallpaper")
            .arg("--zoom")
            .arg(image_path)
            .output()
            .unwrap();

        if !output.status.success() {
            eprintln!("Error setting wallpaper: {}", String::from_utf8_lossy(&output.stderr));
            exit(4);
        }

        sleep(interval);
    }
}
