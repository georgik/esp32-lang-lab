use clap::Parser;
use std::{fs::{self, File, create_dir_all}, io::{Write, BufRead, BufReader}};
use std::path::Path;
use std::process::Command;
use tera::{Tera, Context};

/// ESP32 Code Generator
#[derive(Parser, Debug)]
#[clap(author, version, about, long_about = None)]
struct Args {
    /// Sets the input directory for base templates
    #[clap(short, long, value_parser, default_value = "templates/base")]
    input: String,

    /// Sets the output directory for generated code
    #[clap(short, long, value_parser, default_value = "out")]
    output: String,

    /// Technology type (e.g., esp-idf, rust)
    #[clap(short, long, value_parser, default_value = "esp-idf")]
    tech: String,
}

fn process_directory(tera: &mut Tera, input_path: &Path, output_path: &Path) {
    for entry in fs::read_dir(input_path).expect("Failed to read input directory") {
        let entry = entry.expect("Failed to read entry");
        let path = entry.path();
        if path.is_dir() {
            let new_output_path = output_path.join(path.file_name().unwrap());
            create_dir_all(&new_output_path).expect("Failed to create nested output directory");
            process_directory(tera, &path, &new_output_path);
        } else {
            let mut context = Context::new();
            context.insert("base_code", "printf(\"Hello World!\\n\");");
            context.insert("feature_code", "");

            let content = fs::read_to_string(&path).expect("Failed to read file");
            let template_name = path.to_str().unwrap();
            tera.add_raw_template(template_name, &content).unwrap();

            let rendered = tera.render(template_name, &context).unwrap();

            let output_file_path = output_path.join(path.file_name().unwrap());
            let mut file = File::create(output_file_path).expect("Failed to create output file");
            writeln!(file, "{}", rendered).expect("Failed to write to file");
        }
    }
}

fn main() {
    let args = Args::parse();

    let mut tera = Tera::default();
    create_dir_all(&args.output).expect("Failed to create output directory");

    let input_path = Path::new(&args.input);
    let output_path = Path::new(&args.output);
    process_directory(&mut tera, input_path, output_path);


    match args.tech.as_str() {
        "esp-idf" => {
            Command::new("sh")
                .arg("-c")
                .arg("source ~/projects/esp-idf/export.sh && cd out && idf.py build")
                .status()
                .expect("Failed to execute ESP-IDF build commands");
        },
        "rust" => {
            Command::new("sh")
                .arg("-c")
                .arg("cd out && cargo build --release")
                .status()
                .expect("Failed to execute Rust build commands");
        },
        _ => eprintln!("Unsupported technology: {}", args.tech),
    }


    // Run Wokwi CLI Simulator
    Command::new("sh")
        .arg("-c")
        .arg("cd out && wokwi-cli --timeout 5000 --expect-text \"starting in\" --serial-log-file log.txt")
        .status()
        .expect("Failed to execute Wokwi CLI Simulator");

    // Parse log.txt
    let log_file = File::open("log.txt").expect("Failed to open log.txt");
    let reader = BufReader::new(log_file);

    for line in reader.lines() {
        let line = line.expect("Failed to read line");
        if line.contains("Minimum free heap size:") {
            let parts: Vec<&str> = line.split_whitespace().collect();
            if let Some(size_str) = parts.iter().find(|&&s| s.ends_with("bytes")) {
                let size = size_str.trim_end_matches("bytes");
                println!("Minimum free heap size: {} bytes", size);
                break;
            }
        }
    }
}
