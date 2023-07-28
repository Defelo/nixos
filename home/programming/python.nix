{pkgs, ...}: {
  home.packages = with pkgs; [
    (python311.withPackages (p:
      with p; [
        numpy
        requests
      ]))
    poetry
    poethepoet
    pyright
    ruff
  ];
}
