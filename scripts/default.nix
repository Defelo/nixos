pkgs: let
  mkScripts = builtins.mapAttrs (name: deps:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = deps;
      text = builtins.readFile ./${name}.sh;
    });

  scripts = mkScripts {
    easyroam-setup = with pkgs; [
      coreutils
      openssl
      gnused
      util-linux # uuidgen
      pwgen
    ];
  };
in
  scripts
