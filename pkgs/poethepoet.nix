{python311, ...}:
with python311.pkgs;
  buildPythonApplication rec {
    pname = "poethepoet";
    version = "0.18.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-XzVmsUwvXczfvDuybwCWAGs43AucdL1PjdHrp7Din2o=";
    };
    propagatedBuildInputs = [tomli pastel];
    doCheck = false;
  }
