{pkgs, ...}: {
  home.packages = with pkgs; [
    (python310.withPackages (p:
      with p; [
        numpy
        pandas
        matplotlib
        scipy
        jupyterlab
      ]))
  ];
}
