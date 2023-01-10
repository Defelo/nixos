{pkgs, ...}: {
  home.packages = with pkgs; [rustup];
  home.file.cargo = {
    text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${pkgs.clang_14}/bin/clang"
      rustflags = ["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]
    '';
    target = ".cargo/config.toml";
  };
}
