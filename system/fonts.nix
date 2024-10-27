{pkgs, ...}: {
  fonts.packages = with pkgs; [
    dejavu_fonts
    # ipafont
    meslo-lgs-nf
    fantasque-sans-mono
    material-icons
    font-awesome_5
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
  # fonts.fontconfig.defaultFonts = {
  #   monospace = [
  #     "DejaVu Sans Mono"
  #     "IPAGothic"
  #   ];
  #   sansSerif = [
  #     "DejaVu Sans"
  #     "IPAPGothic"
  #   ];
  #   serif = [
  #     "DejaVu Serif"
  #     "IPAPMincho"
  #   ];
  # };
}
