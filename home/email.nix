{pkgs, ...}: let
  accounts = (import ../secrets.nix).email;
in {
  accounts.email.accounts = let
    account = {
      primary ? false,
      address,
      userName ? address,
      realName,
      gpg ? {},
      imap ? {},
      smtp ? {},
      flavor ? "plain",
      thunderbird ? true,
    }: {
      name = address;
      value = {
        inherit primary address realName userName flavor;
        gpg = pkgs.lib.mkIf (builtins.hasAttr "key" gpg) {
          inherit (gpg) key;
          encryptByDefault = true;
          signByDefault = true;
        };
        imap = pkgs.lib.mkIf (builtins.hasAttr "host" imap) {
          inherit (imap) host;
          tls.useStartTls = ({starttls = true;} // imap).starttls;
        };
        smtp = pkgs.lib.mkIf (builtins.hasAttr "host" smtp) {
          inherit (smtp) host;
          tls.useStartTls = ({starttls = true;} // smtp).starttls;
        };
        thunderbird = pkgs.lib.mkIf thunderbird {
          enable = true;
          settings = id:
            {
              "mail.identity.id_${id}.protectSubject" = false;
              "mail.identity.id_${id}.autoEncryptDrafts" = true;
              "mail.identity.id_${id}.attachPgpKey" = true;
            }
            // pkgs.lib.optionalAttrs (flavor == "gmail.com") {
              "mail.server.server_${id}.authMethod" = 10;
              "mail.smtpserver.smtp_${id}.authMethod" = 10;
            };
        };
      };
    };
  in
    pkgs.lib.attrsets.listToAttrs (map account accounts);

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
      settings = {
        "mailnews.default_news_sort_order" = 2;
        "mailnews.default_sort_order" = 2;
        "mail.accountmanager.accounts" = builtins.concatStringsSep "," (map (a: let id = builtins.hashString "sha256" a.address; in "account_${id}") accounts);
      };
    };
  };
}
