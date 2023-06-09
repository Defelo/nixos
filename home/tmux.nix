{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    keyMode = "vi";
    prefix = "M-Space";
    resizeAmount = 5;
    secureSocket = true;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      tmux-fzf
      onedark-theme
    ];
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"

      set-option -g detach-on-destroy off

      # open new panes in same directory
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # switch panes using Alt+vimarrow without prefix
      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D

      # switch windows using Alt+Number without prefix
      bind -n M-1 select-window -t1
      bind -n M-2 select-window -t2
      bind -n M-3 select-window -t3
      bind -n M-4 select-window -t4
      bind -n M-5 select-window -t5
      bind -n M-6 select-window -t6
      bind -n M-7 select-window -t7
      bind -n M-8 select-window -t8
      bind -n M-9 select-window -t9
      bind -n M-0 select-window -t10
    '';
  };
}
