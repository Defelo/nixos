{
  exa,
  lib,
  gitSupport ? true,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pandoc,
  pkg-config,
  zlib,
  darwin,
  Security ? darwin.apple_sdk.frameworks.Security,
  libiconv,
  installShellFiles,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "exa";
  version = "0.10.1";

  src = exa;

  # Cargo.lock is outdated
  # cargoPatches = [./update-cargo-lock.diff];

  cargoSha256 = "sha256-YpkF3+iKJj0Vh8Fir2RgD2BXUq3OoifSL6FIyOPfpPM=";

  # FIXME: LTO is broken with rustc 1.61, see https://github.com/rust-lang/rust/issues/97255
  # remove this with rustc 1.61.1+
  CARGO_PROFILE_RELEASE_LTO = "false";

  nativeBuildInputs = [cmake pkg-config installShellFiles pandoc];
  buildInputs =
    [zlib]
    ++ lib.optionals stdenv.isDarwin [libiconv Security];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional gitSupport "git";

  outputs = ["out" "man"];

  postInstall = ''
    pandoc --standalone -f markdown -t man man/exa.1.md > man/exa.1
    pandoc --standalone -f markdown -t man man/exa_colors.5.md > man/exa_colors.5
    installManPage man/exa.1 man/exa_colors.5
    installShellCompletion \
      --name exa --bash completions/bash/exa \
      --name exa.fish --fish completions/fish/exa.fish \
      --name _exa --zsh completions/zsh/_exa
  '';

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with lib; {
    description = "Replacement for 'ls' written in Rust";
    longDescription = ''
      exa is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. exa is
      written in Rust, so it’s small, fast, and portable.
    '';
    changelog = "https://github.com/ogham/exa/releases/tag/v${version}";
    homepage = "https://the.exa.website";
    license = licenses.mit;
    maintainers = with maintainers; [ehegnes lilyball globin fortuneteller2k];
  };
}
