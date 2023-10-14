{
  services.postgresql = {
    enable = true;
    authentication = ''
      local all all trust
      host all all all trust
    '';
  };
}
