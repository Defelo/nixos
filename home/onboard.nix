{pkgs, ...}: {
  home.packages = [pkgs.onboard];
  home.file = {
    onboard_theme = {
      text = ''
        <?xml version="1.0" ?>
        <theme name="Custom" format="1.3">
          <color_scheme>Charcoal</color_scheme>
          <background_gradient>0.0</background_gradient>
          <key_style>flat</key_style>
          <roundrect_radius>0.0</roundrect_radius>
          <key_size>94.0</key_size>
          <key_stroke_width>0.0</key_stroke_width>
          <key_fill_gradient>8.0</key_fill_gradient>
          <key_stroke_gradient>8.0</key_stroke_gradient>
          <key_gradient_direction>-3.0</key_gradient_direction>
          <key_label_font></key_label_font>
          <key_label_overrides>
            <key id="LWIN" label="Mod" group=""/>
            <key id="RWIN" label="Mod" group=""/>
          </key_label_overrides>
          <key_shadow_strength>0.0</key_shadow_strength>
          <key_shadow_size>0.0</key_shadow_size>
        </theme>
      '';
      target = ".local/share/onboard/themes/Custom.theme";
    };
  };
}
