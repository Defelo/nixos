pkgs: let
  mkScripts = builtins.mapAttrs (name: deps:
    pkgs.stdenvNoCC.mkDerivation {
      inherit name;
      nativeBuildInputs = [pkgs.makeWrapper];
      unpackPhase = "true";
      installPhase = ''
        mkdir -p $out/bin
        cp ${./${name}.sh} $out/bin/${name}
        chmod +x $out/bin/${name}
      '';
      postFixup = ''
        wrapProgram $out/bin/${name} --set PATH ${pkgs.lib.makeBinPath deps}
      '';
    });
  scripts = mkScripts {
    update-hardware-configuration = with pkgs; [
      coreutils
      nixos-install-tools # nixos-generate-config
    ];
    new-host = with pkgs; [
      coreutils
      scripts.update-hardware-configuration
      nix # nix-instantiate
      util-linux # findmnt, lsblk
      age # age-keygen
      sops
      pwgen
      mkpasswd
      openssh # ssh-keygen
      gnused # sed
    ];
  };
in
  scripts
