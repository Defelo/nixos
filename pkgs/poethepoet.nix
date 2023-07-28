{python311, ...}:
with python311.pkgs;
  buildPythonApplication rec {
    pname = "poethepoet";
    version = "0.21.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-OddU9TcUVFojz8lLEi3q81SCGLbjW0U8MJc8VZhxnp8=";
    };
    format = "pyproject";
    propagatedBuildInputs = [poetry-core tomli pastel];
    doCheck = false;
  }
