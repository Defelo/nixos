{
  pkgs,
  _pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (python311.withPackages (p:
      with p; [
        numpy
        pandas
        matplotlib
        scipy
        scikit-learn
        jupyterlab
      ]))
    poetry
    _pkgs.poethepoet
    pandoc
    pyright
  ];
}
