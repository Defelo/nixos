{
  pkgs,
  _pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (python311.withPackages (p:
      with p; [
        numpy
        requests
      ]))
    poetry
    _pkgs.poethepoet
    pyright
    ruff
  ];
}
