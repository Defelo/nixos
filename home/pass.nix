{...}: {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$XDG_DATA_HOME/.password-store";
      PASSWORD_STORE_CLIP_TIME = "20";
    };
  };
}
