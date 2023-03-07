{
  pkgs,
  _pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (python311.withPackages (p:
      with p; [
        numpy
      ]))
    poetry
    _pkgs.poethepoet
    pyright
    ruff
  ];
}
