{conf, ...}: {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${conf.home}/.password-store";
      PASSWORD_STORE_CLIP_TIME = "20";
    };
  };
}
