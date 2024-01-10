{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    authentication = ''
      local all all trust
      host all all all trust
    '';
  };
}
