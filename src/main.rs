use std::env;
use std::net::TcpListener;
use zero2prod::run;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let url = format!(
        "127.0.0.1:{}",
        env::var("PORT").unwrap_or(String::from("8000"))
    );
    let listener = TcpListener::bind(url).expect("Failed to bind to address");
    let port = listener.local_addr().unwrap().port();
    println!(
        "Starting server at {}",
        format!("http://127.0.0.1:{}", port)
    );
    run(listener)?.await
}
