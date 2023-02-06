{
  pkgs,
  hyprland,
  ...
}: {
  imports = [hyprland.homeManagerModules.default];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      exec-once=xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2
      monitor=eDP-1,1920x1080@60,0x0,1

      input {
        kb_layout=de
        kb_variant=
        kb_model=
        kb_options=
        kb_rules=

        follow_mouse=1

        touchpad {
          natural_scroll=1
        }
      }

      bind=SUPER+SHIFT,Q,killactive,
      bind=SUPER+SHIFT,E,exit,
      bind=SUPER+SHIFT,Space,togglefloating,

      bind=SUPER,h,movefocus,l
      bind=SUPER,l,movefocus,r
      bind=SUPER,k,movefocus,u
      bind=SUPER,j,movefocus,d

      bind=SUPER+SHIFT,H,movewindow,l
      bind=SUPER+SHIFT,L,movewindow,r
      bind=SUPER+SHIFT,K,movewindow,u
      bind=SUPER+SHIFT,J,movewindow,d

      bind=SUPER,f,fullscreen,0

      bind=SUPER,Tab,workspace,previous

      bind=SUPER,1,workspace,1
      bind=SUPER,2,workspace,2
      bind=SUPER,3,workspace,3
      bind=SUPER,4,workspace,4
      bind=SUPER,5,workspace,5
      bind=SUPER,6,workspace,6
      bind=SUPER,7,workspace,7
      bind=SUPER,8,workspace,8
      bind=SUPER,9,workspace,9
      bind=SUPER,0,workspace,10

      bind=SUPER+SHIFT,exclam,movetoworkspace,1
      bind=SUPER+SHIFT,quotedbl,movetoworkspace,2
      bind=SUPER+SHIFT,section,movetoworkspace,3
      bind=SUPER+SHIFT,dollar,movetoworkspace,4
      bind=SUPER+SHIFT,percent,movetoworkspace,5
      bind=SUPER+SHIFT,ampersand,movetoworkspace,6
      bind=SUPER+SHIFT,slash,movetoworkspace,7
      bind=SUPER+SHIFT,parenleft,movetoworkspace,8
      bind=SUPER+SHIFT,parenright,movetoworkspace,9
      bind=SUPER+SHIFT,equal,movetoworkspace,10

      bind=SUPER,Return,exec,alacritty
      bind=SUPER,d,exec,${pkgs.rofi-wayland}/bin/rofi -combi-modi drun,ssh,run -modi combi -show combi -show-icons
    '';
  };
}
