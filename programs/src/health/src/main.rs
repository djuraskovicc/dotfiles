use rodio::{Decoder, OutputStream, Sink};
use std::{
    io::Cursor, thread::sleep, time::Duration
};

static SOUND: &[u8] = include_bytes!("../assets/sound.mp3");

fn sleep_mins(mins: u64) {
    let secs: u64 = mins * 60; 
    sleep(Duration::from_secs(secs));
}

fn play_sound() {
    let (_stream, stream_handle) = OutputStream::try_default().unwrap();

    let cursor: Cursor<&[u8]> = Cursor::new(SOUND);
    let source: Decoder<Cursor<&[u8]>> = Decoder::new(cursor).unwrap();

    let sink: Sink = Sink::try_new(&stream_handle).unwrap();
    sink.append(source);    
    sink.sleep_until_end();
}

fn main() {
    loop {
        sleep_mins(30);
        play_sound();
        sleep_mins(5);
        play_sound();
    }
}
