{
  pkgs,
  pkgs-fork,
  ...
}: {
  home.packages = with pkgs; [
    (python310.withPackages (p:
      with p; [
        numpy
        pandas
        matplotlib
        scipy
        scikit-learn
        jupyterlab
      ]))
    pkgs-fork.poetry
    (with python310.pkgs;
      buildPythonApplication rec {
        pname = "poethepoet";
        version = "0.18.1";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-XzVmsUwvXczfvDuybwCWAGs43AucdL1PjdHrp7Din2o=";
        };
        propagatedBuildInputs = [tomli pastel];
        doCheck = false;
      })
    pandoc
  ];
}
