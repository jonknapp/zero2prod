use std::env;
use std::net::TcpListener;
use zero2prod::configuration::get_configuration;
use zero2prod::startup::run;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let configuration = get_configuration().expect("Failed to read configuration.");
    let url = format!(
        "127.0.0.1:{}",
        env::var("PORT").unwrap_or(configuration.application_port.to_string())
    );
    let listener = TcpListener::bind(url).expect("Failed to bind to address");
    let port = listener.local_addr().unwrap().port();
    println!(
        "Starting server at {}",
        format!("http://127.0.0.1:{}", port)
    );
    run(listener)?.await
}
