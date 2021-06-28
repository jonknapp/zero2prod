{
  description = "zero2prod";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, flake-utils, nixpkgs, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit overlays system; };
      in {
        devShell = pkgs.mkShell {
          name = "zero2prod";

          buildInputs = [
            pkgs.libgit2 # needed for cargo-tarpaulin
            pkgs.nixfmt
            pkgs.openssl
            pkgs.pkgconfig
            (pkgs.rust-bin.selectLatestNightlyWith (toolchain:
              toolchain.default.override {
                extensions = [ "rust-src" ]; # needed for rust-analyzer
              }))
          ] ++ (if system == "x86_64-darwin" then [
            pkgs.darwin.apple_sdk.frameworks.CoreFoundation # needed for sqlx-cli
            pkgs.darwin.apple_sdk.frameworks.SystemConfiguration # needed for sqlx-cli
            pkgs.darwin.apple_sdk.frameworks.Security # needed for cargo-edit
          ] else
            [ ]);
        };
      });
}
