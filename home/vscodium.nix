{
  pkgs,
  nix-vscode-extensions,
  ...
}: let
  extensions = nix-vscode-extensions.extensions.${pkgs.system};
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with extensions.vscode-marketplace; [
      angular.ng-template
      bbenoist.nix
      cyrilletuzi.angular-schematics
      dbaeumer.vscode-eslint
      eamodio.gitlens
      esbenp.prettier-vscode
      github.copilot
      github.copilot-chat
      hediet.vscode-drawio
      infinity1207.angular2-switcher
      james-yu.latex-workshop
      kamadorueda.alejandra
      ms-python.python
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-vsliveshare.vsliveshare
      orta.vscode-jest
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      streetsidesoftware.code-spell-checker
      uiua-lang.uiua-vscode
      usernamehw.errorlens
      vscodevim.vim
      vue.volar
      xabikos.javascriptsnippets
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
      "hediet.vscode-drawio.theme" = "Kennedy";
      "[uiua]"."editor.fontSize" = 18;
      "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[jsonc]"."editor.defaultFormatter" = "vscode.json-language-features";
      "[scss]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
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
