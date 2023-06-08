{
  conf,
  pkgs,
  _pkgs,
  cargo-clif-nix,
  ...
}: {
  home.packages = with pkgs; [
    cargo-clif-nix.packages.${pkgs.system}.default
    bacon
    cargo-expand
    cargo-edit
    cargo-audit
    cargo-hack
    cargo-llvm-cov
    cargo-msrv
    cargo-release
    _pkgs.sea-orm-cli
  ];
  home.file.cargo = {
    text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${pkgs.clang_16}/bin/clang"
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
