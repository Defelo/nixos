{
  conf,
  pkgs,
  fenix,
  ...
}: {
  home.packages = with pkgs; [
    (
      with fenix.packages.${pkgs.system};
        combine [
          complete.toolchain
          targets.x86_64-unknown-linux-musl.latest.rust-std
          targets.wasm32-unknown-unknown.latest.rust-std
        ]
    )
    bacon
    cargo-expand
    cargo-edit
    cargo-audit
    cargo-hack
    cargo-llvm-cov
    cargo-release
    sea-orm-cli
    sqlx-cli
    trunk
    cargo-leptos
    cargo-shuttle
  ];
  home.file.cargo = {
    text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${pkgs.clang_16}/bin/clang"
      rustflags = ["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]

      [registries.crates-io]
      protocol = "sparse"

      [build]
      target-dir = "${conf.home}/.cargo/target"

      [profile.dev]
      opt-level = 1
      codegen-backend = "cranelift"

      [profile.dev.package."httparse"]
      codegen-backend = "llvm"

      [unstable]
      codegen-backend = true
    '';
    target = ".cargo/config.toml";
  };
  home.file.rustfmt = {
    text = ''
      format_code_in_doc_comments = true
      format_macro_bodies = true
      # format_macro_matchers = true
      format_strings = true
      group_imports = "StdExternalCrate"
      imports_granularity = "Crate"
      unstable_features = true
      wrap_comments = true
    '';
    target = ".config/rustfmt/rustfmt.toml";
  };

  sops.secrets."shuttle/config" = {
    sopsFile = ../../secrets/shuttle;
    format = "binary";
    path = "${conf.home}/.config/shuttle/config.toml";
  };
}
