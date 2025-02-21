{ conf, ... }:
{
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "/home/${conf.user}/.password-store";
      PASSWORD_STORE_CLIP_TIME = "20";
    };
  };
}
