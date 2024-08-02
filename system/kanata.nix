{
  services.kanata = {
    enable = true;
    keyboards.default = {
      extraDefCfg = ''
        process-unmapped-keys yes
        delegate-to-first-layer yes
      '';
      config = ''
        (defsrc
          caps
          lctl)

        (deflayermap (default)
          caps (tap-hold-press 200 200 esc lctl)
          lctl caps
          )
      '';
    };
  };
}
