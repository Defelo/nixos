{
  conf,
  pkgs,
  _pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rustup
    rust-analyzer
    bacon
    cargo-expand
    cargo-edit
    cargo-audit
    cargo-llvm-cov
    cargo-msrv
    _pkgs.sea-orm-cli
  ];
  home.file.cargo = {
    text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${pkgs.clang_14}/bin/clang"
      rustflags = ["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]

      [registries.crates-io]
      protocol = "sparse"

      [profile.dev]
      opt-level = 1
    '';
    target = ".cargo/config.toml";
  };

  home.sessionVariables = {
    CARGO_TARGET_DIR = "${conf.home}/.cargo/target";
  };
}
