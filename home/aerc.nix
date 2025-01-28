{conf, ...}: {
  programs.aerc = {
    enable = true;
    extraConfig = {
      ui = {
        fuzzy-complete = true;
        message-list-split = "h 20";
        threading-enabled = true;
        reverse-thread-order = true;
        dirlist-tree = true;
      };

      hooks.mail-received = ''dunstify "[$AERC_ACCOUNT] New mail from $AERC_FROM_NAME" "$AERC_SUBJECT"'';

      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/html" = "! html";
        ".headers" = "colorize";
      };
    };
    extraBinds = {};
  };

  sops.secrets."aerc/accounts" = {
    format = "binary";
    sopsFile = ../secrets/aerc/accounts.conf;
    path = "/home/${conf.user}/.config/aerc/accounts.conf";
  };
}
