{ config, pkgs, ... }:

{
  home.username = "charles";
  home.homeDirectory = "/home/charles";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    tmux
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.git = {
    enable = true;
    settings = {
      core.editor = "vim";
      user.name = "Charles Ueltschey";
      user.email = "me@cueltschey.com";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      grep = "grep -I";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };
    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;
    shellOptions = [
      "histappend"
      "checkwinsize"
    ];
  };

  programs.home-manager.enable = true;
}
