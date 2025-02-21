{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings =
      let
        transparency = "DD";
      in
      {
        global = {
          follow = "mouse";
          width = 300;
          height = 300;
          origin = "top-right";
          offset = "10x50";
          scale = 0;
          notification_limit = 0;

          indicate_hidden = true;
          separator_height = 2;
          padding = 6;
          horizontal_padding = 6;
          text_icon_padding = 0;
          frame_width = 3;
          frame_color = "#8EC07C${transparency}";
          sort = true;
          idle_threshold = 0;

          font = "Meslo Nerd Font 11";
          line_height = 3;
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "center";
          vertical_alignment = "top";
          show_age_threshold = 10;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;

          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 32;

          sticky_history = true;
          history_length = 10000;

          dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
          browser = "xdg-open";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = 0;

          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };

        urgency_low = {
          background = "#191311${transparency}";
          foreground = "#3B7C87${transparency}";
          frame_color = "#3B7C87${transparency}";
          timeout = 10;
        };
        urgency_normal = {
          background = "#191311${transparency}";
          foreground = "#5B8234${transparency}";
          frame_color = "#5B8234${transparency}";
          timeout = 10;
        };
        urgency_critical = {
          background = "#191311${transparency}";
          foreground = "#B7472A${transparency}";
          frame_color = "#B7472A${transparency}";
          timeout = 0;
        };
      };
  };
}
