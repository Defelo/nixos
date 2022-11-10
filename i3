# This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4

# colors
set $bg-color #222d32
set $inactive-bg-color #2f343f
set $text-color #f3f4f5
set $inactive-text-color #676E7D
set $urgent-bg-color #E53935


# window colors
#                       border              background         text                 indicator
client.focused          $bg-color           $bg-color          $text-color          $bg-color
client.unfocused        $inactive-bg-color $inactive-bg-color $inactive-text-color $bg-color
client.focused_inactive $inactive-bg-color $inactive-bg-color $inactive-text-color $bg-color
client.urgent           $urgent-bg-color    $urgent-bg-color   $text-color          $bg-color



# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:monospace 10

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec {{terminal}}

# kill focused window
bindsym $mod+Shift+q kill

# start dmenu (a program launcher)
#bindsym $mod+d exec dmenu_run
#bindsym $mod+d exec "rofi -combi-modi window,drun,ssh,run -modi combi -show combi"
bindsym $mod+d exec "rofi -combi-modi drun,ssh,run -modi combi -show combi -show-icons"
#bindsym $mod+d exec rofi -modi run -show run
#bindsym $mod+Shift+d exec rofi -modi drun -show drun

# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+n split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
bindsym $mod+c focus child

# workspaces
set $workspace0 "0 "
set $workspace1 "1 "
set $workspace2 "2 "
set $workspace3 "3 "
set $workspace4 "4 "
set $workspace5 "5 "
set $workspace6 "6 "
set $workspace7 "7 "
set $workspace8 "8 "
set $workspace9 "9 "
set $workspace10 "10 "
set $workspace42 "42 "
set $workspace1337 "1337"
set $workspace_obsidian "+ "

# assign windows to workspaces
assign [class="Transmission-gtk"] $workspace0
assign [class="GitKraken"] $workspace0
assign [class="firefox"] $workspace1
assign [class="Brave-browser"] $workspace1
#assign [class="Sublime_text"] $workspace3
assign [class="jetbrains-pycharm"] $workspace3
assign [class="jetbrains-idea"] $workspace3
assign [class="jetbrains-clion"] $workspace3
assign [class="jetbrains-rubymine"] $workspace3
assign [class="jetbrains-phpstorm"] $workspace3
assign [class="jetbrains-webstorm"] $workspace3
assign [class="java-lang-Thread"] $workspace3
assign [class="VSCodium"] $workspace3
assign [class="thunderbird"] $workspace7
assign [class="discord"] $workspace8
assign [class="Element"] $workspace8
assign [class="Cinny"] $workspace8
assign [class="Slack"] $workspace8
assign [class="TelegramDesktop"] $workspace9
assign [class="vlc"] $workspace10
assign [class="minecraft-launcher"] $workspace42
assign [class="Minecraft"] $workspace42
assign [class="obsidian"] $workspace_obsidian

for_window [class="Spotify"] move to workspace $workspace10

for_window [class="Rofi"] floating enable

# assign workspaces to screens
workspace $workspace0 output VIRTUAL1
workspace $workspace1 output VIRTUAL2
workspace $workspace2 output VIRTUAL2
workspace $workspace3 output VIRTUAL2
workspace $workspace4 output VIRTUAL2
workspace $workspace5 output VIRTUAL2
workspace $workspace6 output VIRTUAL2
workspace $workspace7 output VIRTUAL2
workspace $workspace8 output VIRTUAL2
workspace $workspace9 output VIRTUAL2
workspace $workspace10 output VIRTUAL2
workspace $workspace42 output VIRTUAL2
workspace $workspace1337 output VIRTUAL2
workspace $workspace_obsidian output VIRTUAL3

# switch to workspace
bindsym $mod+asciicircum workspace $workspace0
bindsym $mod+1 workspace $workspace1
bindsym $mod+2 workspace $workspace2
bindsym $mod+3 workspace $workspace3
bindsym $mod+4 workspace $workspace4
bindsym $mod+5 workspace $workspace5
bindsym $mod+6 workspace $workspace6
bindsym $mod+7 workspace $workspace7
bindsym $mod+8 workspace $workspace8
bindsym $mod+9 workspace $workspace9
bindsym $mod+0 workspace $workspace10
bindsym $mod+ssharp workspace $workspace42
bindsym $mod+acute workspace $workspace1337
bindsym $mod+plus workspace $workspace_obsidian

# move focused container to workspace
bindsym $mod+Shift+asciicircum move container to workspace $workspace0
bindsym $mod+Shift+1 move container to workspace $workspace1
bindsym $mod+Shift+2 move container to workspace $workspace2
bindsym $mod+Shift+3 move container to workspace $workspace3
bindsym $mod+Shift+4 move container to workspace $workspace4
bindsym $mod+Shift+5 move container to workspace $workspace5
bindsym $mod+Shift+6 move container to workspace $workspace6
bindsym $mod+Shift+7 move container to workspace $workspace7
bindsym $mod+Shift+8 move container to workspace $workspace8
bindsym $mod+Shift+9 move container to workspace $workspace9
bindsym $mod+Shift+0 move container to workspace $workspace10
bindsym $mod+Shift+ssharp move container to workspace $workspace42
bindsym $mod+Shift+acute move container to workspace $workspace1337
bindsym $mod+Shift+plus move container to workspace $workspace_obsidian

# move focused workspace to monitor
bindsym $mod+Ctrl+h move workspace to output VIRTUAL1
bindsym $mod+Ctrl+j move workspace to output VIRTUAL3
bindsym $mod+Ctrl+k move workspace to output VIRTUAL2

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
{{#if dotter.packages.compton}}
bindsym $mod+Shift+r exec "pkill compton; i3-msg restart; compton &"
{{else}}
bindsym $mod+Shift+r exec "i3-msg restart"
{{/if}}
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

bindsym $mod+Shift+Return exec "~/scripts/powermenu.sh"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym h resize shrink width 10 px or 10 ppt
        bindsym j resize grow height 10 px or 10 ppt
        bindsym k resize shrink height 10 px or 10 ppt
        bindsym l resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
#bar {
#        position top
#        status_command i3blocks
#        tray_output primary
#	separator_symbol " "
#
#        colors {
#                background $bg-color
#                separator #757575
#                focused_workspace  $bg-color          $bg-color          $text-color
#                inactive_workspace $inactive-bg-color $inactive-bg-color $inactive-text-color
#                urgent_workspace   $urgent-bg-color   $urgent-bg-color   $text-color
#        }
#}

# exec --no-startup-id "xrandr --output DP1 --left-of eDP1"
# exec --no-startup-id "xrandr --output eDP1 --primary"

{{#if dotter.packages.polybar}}
#exec_always --no-startup-id "pkill -9 polybar; polybar main"
exec_always --no-startup-id "pkill -9 polybar; ~/scripts/polybar.sh"
{{/if}}
{{#if i3.clipman}}
exec_always --no-startup-id "pkill xfce4-clipman; xfce4-clipman"
{{/if}}

{{#if dotter.packages.wallpapers}}
exec --no-startup-id $HOME/scripts/wallpaper.sh
{{/if}}

hide_edge_borders both

for_window [class="^.*"] border none
#gaps inner 5
#gaps outer 1

bindsym $mod+Tab workspace back_and_forth

bindsym $mod+Shift+y exec "~/scripts/lock.sh -n -p"
#bindsym $mod+Ctrl+Shift+s exec "sudo systemctl suspend"
bindsym $mod+p exec "{{terminal}} -e python"
bindsym $mod+i exec "{{terminal}} -e irb"
#bindsym $mod+g exec "firefox ecosia.org"
#bindsym $mod+t exec thunderbird
#bindsym $mod+Shift+f exec "firefox"
bindsym $mod+Shift+f exec "brave"
#bindsym $mod+Shift+s exec "subl"
#bindsym $mod+Shift+a exec "atom"
bindsym $mod+Ctrl+e exec nemo
 
 
{{#if enc}}
bindsym $mod+Shift+w exec {{terminal}} -e ~/scripts/wtr.sh
bindsym $mod+Ctrl+w exec {{terminal}} -e ~/scripts/wtr2.sh
{{/if}}
bindsym $mod+Shift+p exec {{terminal}} -e pulsemixer


# Pulse Audio controls
#bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo +5% #increase sound volume
#bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo -5% #decrease sound volume
#bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute alsa_output.pci-0000_00_1b.0.analog-stereo toggle # mute sound
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% #increase sound volume
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% #decrease sound volume
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle # mute sound

# Sreen brightness controls
bindsym XF86MonBrightnessUp exec xbacklight -inc 5 -time 100 # increase screen brightness
bindsym XF86MonBrightnessDown exec xbacklight -dec 5 -time 100 # decrease screen brightness
bindsym Shift+XF86MonBrightnessUp exec xbacklight -inc 1 -time 20 # increase screen brightness
bindsym Shift+XF86MonBrightnessDown exec xbacklight -dec 1 -time 20 # decrease screen brightness

# Touchpad controls
bindsym XF86TouchpadToggle exec $HOME/scripts/toggletouchpad.sh # toggle touchpad

# Media player controls
bindsym XF86AudioPlay exec playerctl play-pause
bindsym Next exec playerctl play-pause
bindsym XF86AudioStop exec playerctl stop
bindsym Prior exec playerctl stop
bindsym XF86AudioNext exec playerctl next
bindsym End exec playerctl next
bindsym XF86AudioPrev exec playerctl previous
bindsym Home exec playerctl previous

# Screenshot
#bindsym Print exec gnome-screenshot -i
bindsym Print exec flameshot gui
bindsym Ctrl+Print exec ~/scripts/scan_qr.sh
bindsym Shift+Print exec ~/scripts/freeze_screen.sh

# lshr.tk
bindsym $mod+KP_Subtract exec $HOME/scripts/shorten.py

# Dunst
bindsym $mod+KP_Add exec $HOME/scripts/toggle_dunst.sh
bindsym Pause exec dunstctl close
bindsym Shift+Pause exec dunstctl close-all
bindsym Ctrl+Break exec dunstctl history-pop
bindsym Mod1+Pause exec dunstctl context

# QR
bindsym $mod+KP_Multiply exec $HOME/scripts/qr.sh

# Discord Raid Ban
bindsym $mod+KP_Divide exec bash $HOME/discord_ban.sh

# emoji menu
bindsym $mod+comma exec $HOME/scripts/emoji_menu.sh

# mic_over_mumble
bindsym $mod+Shift+M exec {{terminal}} -e $HOME/scripts/mic.sh


# Make the currently focused window a scratchpad
bindsym $mod+Shift+minus move scratchpad

# Show the first scratchpad window
bindsym $mod+minus scratchpad show


bindsym $mod+Ctrl+M exec $HOME/scripts/type_password.sh

bindsym $mod+Ctrl+B exec ~/scripts/btc.sh

bindsym $mod+T exec $HOME/scripts/termdown.sh

bindsym $mod+ctrl+P exec ~/scripts/pwgen.sh

{{#if i3.autotiling}}
exec_always --no-startup-id autotiling
{{/if}}

# disable mouse focus
#focus_follows_mouse no

# Run setup script
exec --no-startup-id ~/scripts/setup.sh

# Start some programs
#exec firefox
exec brave
exec thunderbird
exec discord-canary
exec element-desktop
#exec cinny
exec Telegram
exec obsidian
#exec vlc
exec i3-msg "workspace $workspace2; exec {{terminal}}"
