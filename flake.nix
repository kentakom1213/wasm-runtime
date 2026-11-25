{
  description = "A WebAssembly runtime written in Rust";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Rust
              rustc
              cargo
              rustfmt
              clippy
              rust-analyzer

              # WebAssembly
              wabt
              wasm-tools
              wasmtime

              # Binary inspection
              xxd
            ];
          };
        }
      );
    };
}
