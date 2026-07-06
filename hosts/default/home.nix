{ config, pkgs, ... }:

{
  home.username = "charles";
  home.homeDirectory = "/home/charles";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    bash
    curl
    git
    gh
    tldr
    neovim
    foot
    rofi
    chromium
    swaybg
    swayidle
    swaylock
    waybar
    pkgs.sway-contrib.grimshot
    wf-recorder
    slurp
    jq
    gnumake
    gcc
    cmake
    binutils
    terminus_font
  ];

  home.sessionVariables = {
    BROWSER = "librewolf";
    EDITOR = "vim";
    GOPATH = "$HOME/go";
  };

  home.file.".config/sway/statusCommand.sh" = {
    source = ../../config/sway/statusCommand.sh;
    executable = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      ${builtins.readFile ../../config/bash/initExtra.sh}
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
    shellAliases = {
      grep = "grep -I";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      alert = builtins.readFile ../../config/bash/alert.sh;
    };
    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;
    shellOptions = [
      "histappend"
      "checkwinsize"
    ];
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Terminus:size=10";
        term = "foot";
        shell = "${pkgs.bash}/bin/bash";
        colors = "dark";
      };
      colors-dark = {
        alpha = 1;
        background = "000000";
        foreground = "ffffff";
        regular0 = "242424";
        regular1 = "f62b5a";
        regular2 = "47b413";
        regular3 = "e3c401";
        regular4 = "24acd4";
        regular5 = "f2affd";
        regular6 = "13c299";
        regular7 = "e6e6e6";
        bright0 = "616161";
        bright1 = "ff4d51";
        bright2 = "35d450";
        bright3 = "e9e836";
        bright4 = "5dc5f8";
        bright5 = "feabf2";
        bright6 = "24dfc4";
        bright7 = "ffffff";
      };
    };
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      modes = [ "combi" ];
      combi-modes = [ "window" "drun" "run" ];
    };
    theme = {
      "*" = {
        background-color = "#FF0000";
        border-color = "rgba(0,0,1, 0.5)";
        text-color = "SeaGreen";
      };
      "entry" = {
        placeholder = "what ya need boss?";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod1";
      terminal = "${pkgs.foot}/bin/foot";
      menu = "${pkgs.rofi}/bin/rofi -show run";
      fonts = {
        names = [ "Terminus" ];
        size = 10.0;
      };
      startup = [
        { command = "swaybg -c '#000000'"; }
        { command = "swayidle -w timeout 30000 'swaylock -f -c 000000' timeout 60000 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' before-sleep 'swaylock -f -c 000000'"; }
      ];
      keybindings = let
        mod = modifier;
      in {
        "${mod}+Shift+P" = "exec grimshot --notify save area";
        "${mod}+Shift+V" = "exec wf-recorder -g \"$(swaymsg -t get_outputs | jq -r '.[0].rect | .x,.y,.width,.height | @csv' | tr ',' ' ')\" -f ~/Videos/screen-recording-$(date +'%Y%m%d-%H%M%S').mp4";
        "${mod}+Shift+S" = "exec pkill -INT wf-recorder";
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+z" = "exec ${pkgs.foot}/bin/foot --hold -e sudo shutdown now";
        "${mod}+d" = "exec ${menu}";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaymsg exit";
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+a" = "focus parent";
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";
        "${mod}+r" = "mode resize";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "${mod}+m" = "exec ${pkgs.foot}/bin/foot --hold -e curl wttr.in/starkville";
      };
      colors = {
        focused = {
          border = "#002323";
          background = "#002323";
          text = "#d9d8d8";
          indicator = "#000000";
          childBorder = "#002323";
        };
        focusedInactive = {
          border = "#000000";
          background = "#000000";
          text = "#d9d8d8";
          indicator = "#000000";
          childBorder = "#000000";
        };
        unfocused = {
          border = "#000000";
          background = "#000000";
          text = "#d9d8d8";
          indicator = "#000000";
          childBorder = "#000000";
        };
        urgent = {
          border = "#ee2e24";
          background = "#ee2e24";
          text = "#d9d8d8";
          indicator = "#ee2e24";
          childBorder = "#ee2e24";
        };
      };
      bars = [
        {
          position = "top";
          fonts = {
            names = [ "Terminus" ];
            size = 14.0;
          };
          statusCommand = "~/.config/sway/statusCommand.sh";
          mode = "hide";
          hiddenState = "hide";
          extraConfig = ''
            modifier Mod1
            status_edge_padding 3
            status_padding 5
          '';
          colors = {
            statusline = "#ffffff";
            background = "#00000000";
          };
        }
      ];
    };
    extraConfig = builtins.readFile ../../config/sway/extraConfig;
  };

  programs.home-manager.enable = true;
}
