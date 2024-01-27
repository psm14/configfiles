{ pkgs, lib, ... }:
{
  config = {
    programs.vscode-brew = {
      extensions = [
        "eamodio.gitlens"
        "esbenp.prettier-vscode"
        "GitHub.vscode-pull-request-github"
        "jnoortheen.nix-ide"
        "ms-azuretools.vscode-docker"
        "ms-vscode-remote.remote-containers"
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-ssh-edit"
        "ms-vsliveshare.vsliveshare"
        "redhat.vscode-yaml"
        "rust-lang.rust-analyzer"
        "vscodevim.vim"
        "mkhl.direnv"
      ];
      settings = {
        "[markdown]" = {
          "editor.quickSuggestions" = {
            "comments" = "off";
            "other" = "off";
            "strings" = "off";
          };
          "editor.unicodeHighlight.ambiguousCharacters" = false;
          "editor.unicodeHighlight.invisibleCharacters" = false;
          "editor.wordWrap" = "on";
          "editor.wordWrapColumn" = 120;
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "breadcrumbs.enabled" = false;
        "editor.acceptSuggestionOnCommitCharacter" = false;
        "editor.cursorBlinking" = "phase";
        "editor.cursorStyle" = "line-thin";
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.folding" = false;
        "editor.formatOnSave" = true;
        "editor.fontFamily" = "Hack, Menlo, Monaco, 'Courier New', monospace";
        "editor.guides.indentation" = false;
        "editor.inlayHints.enabled" = "off";
        "editor.minimap.enabled" = false;
        "editor.padding.bottom" = 12;
        "editor.padding.top" = 16;
        "editor.renderLineHighlight" = "gutter";
        "editor.rulers" = [ ];
        "editor.tabSize" = 2;
        "extensions.ignoreRecommendations" = true;
        "git.autofetch" = false;
        "githubIssues.assignWhenWorking" = false;
        "githubPullRequests.pullBranch" = "never";
        "gitlens.codeLens.enabled" = false;
        "gitlens.menus" = {
          "editor" = {
            "blame" = false;
            "clipboard" = false;
            "compare" = false;
            "history" = false;
            "remote" = false;
          };
          "editorGroup" = {
            "blame" = false;
            "compare" = false;
          };
          "editorTab" = {
            "clipboard" = false;
            "compare" = false;
            "history" = false;
            "remote" = false;
          };
          "explorer" = {
            "clipboard" = false;
            "compare" = false;
            "history" = false;
            "remote" = false;
          };
          "scm" = {
            "authors" = false;
          };
          "scmGroup" = {
            "compare" = false;
            "openClose" = false;
            "stash" = false;
          };
          "scmGroupInline" = {
            "stash" = false;
          };
          "scmItem" = {
            "clipboard" = false;
            "compare" = false;
            "history" = false;
            "remote" = false;
            "stash" = false;
          };
        };
        "gitlens.statusBar.enabled" = false;
        "gitlens.statusBar.pullRequests.enabled" = false;
        "liveshare.showInStatusBar" = "whileCollaborating";
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "/nix/store/25xpcw4nc7wnb4fmd15fxai6wazccny3-nixpkgs-fmt-1.3.0/bin/nixpkgs-fmt";
        "nix.serverPath" = "/nix/store/qczidp2nmcvc1j78dh1wjj1dk8q0b444-rnix-lsp-unstable-2022-11-27/bin/rnix-lsp";
        "redhat.telemetry.enabled" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "telemetry.telemetryLevel" = "off";
        "terminal.external.osxExec" = "iTerm.app";
        "terminal.integrated.cursorStyle" = "underline";
        "terminal.integrated.shellIntegration.decorationsEnabled" = "never";
        "vim.easymotion" = true;
        "vs-kubernetes" = {
          "vs-kubernetes.crd-code-completion" = "disabled";
        };
        "window.autoDetectColorScheme" = true;
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "City Lights";
        "workbench.fontAliasing" = "auto";
        "workbench.preferredDarkColorTheme" = "City Lights";
        "workbench.preferredLightColorTheme" = "Gruvbox Light Medium";
        "workbench.sideBar.location" = "right";
        "workbench.startupEditor" = "readme";
        "workbench.statusBar.visible" = false;
        "window.commandCenter" = false;
        "workbench.layoutControl.enabled" = false;
        "workbench.activityBar.location" = "top";
      };
    };
  };
}
