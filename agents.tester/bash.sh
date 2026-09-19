# Enforce idiomatic Rust style guide rules
cargo fmt --check

# Run compilation safety diagnostics and treat workspace clippy warnings as hard failures
cargo clippy --workspace --all-targets -- -D warnings
