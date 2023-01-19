{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      eamodio.gitlens
      james-yu.latex-workshop
      kamadorueda.alejandra
      ms-python.python
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      rust-lang.rust-analyzer
      usernamehw.errorlens
      vscodevim.vim
    ];
    userSettings = {
      "editor.wordWrap" = "on";
      "workbench.startupEditor" = "newUntitledFile";
      "files.autoSave" = "afterDelay";
      "python.autoComplete.extraPaths" = [];
      "editor.lineNumbers" = "on";
      "vim.commandLineModeKeyBindings" = [];
      "rust-analyzer.checkOnSave.command" = "clippy";
      "files.associations" = {
        "*.toml" = "toml";
      };
      "vim.useSystemClipboard" = true;
      "task.quickOpen.skip" = true;
      "explorer.confirmDragAndDrop" = false;
      "jupyter.askForKernelRestart" = false;
      "notebook.output.textLineLimit" = 50;
    };
    keybindings = [
      {
        "key" = "F10";
        "command" = "workbench.action.tasks.runTask";
        "args" = "Run";
      }
      {
        "key" = "shift+f10";
        "command" = "-editor.action.showContextMenu";
        "when" = "textInputFocus";
      }
      {
        "key" = "shift+f10";
        "command" = "workbench.action.tasks.reRunTask";
      }
      {
        "key" = "ctrl+k";
        "command" = "-extension.vim_ctrl+k";
        "when" = "editorTextFocus && vim.active && vim.use<C-k> && !inDebugRepl";
      }
      {
        "key" = "shift+escape";
        "command" = "workbench.action.closePanel";
      }
      {
        "key" = "ctrl+f10";
        "command" = "workbench.action.tasks.restartTask";
      }
    ];
  };
}
