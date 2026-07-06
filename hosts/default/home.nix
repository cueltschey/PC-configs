{ config, pkgs, ... }:

{
  home.username = "charles";
  home.homeDirectory = "/home/charles";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
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
    grimshot
    wf-recorder
    slurp
    jq
    make
    gcc
    cmake
    binutils
  ];

  home.sessionVariables = {
    BROWSER = "librewolf";
    EDITOR = "vim";
    GOPATH = "$HOME/go";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      grep = "grep -I";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      alert = ''
        notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')"
      '';
    };
    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;
    shellOptions = [
      "histappend"
      "checkwinsize"
    ];
    initExtra = ''
      source /opt/ros/humble/setup.sh 2>/dev/null || true
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    '';
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    history = {
      save = 1000;
      size = 1000;
      path = "$HOME/.histfile";
    };
    shellAliases = {
      ls = "ls --color -F";
      ll = "ls --color -lh";
      spm = "sudo pacman";
      gr = "gvim --remote-silent";
      vr = "vim --remote-silent";
    };
    envExtra = ''
      export BROWSER="librewolf"
      export EDITOR="vim"
      export GOPATH="$HOME/go"
    '';
    initExtra = ''
      LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32;'
      export LS_COLORS

      bindkey -v
      typeset -g -A key
      bindkey '^?' backward-delete-char
      bindkey '^[[5~' up-line-or-history
      bindkey '^[[3~' delete-char
      bindkey '^[[6~' down-line-or-history
      bindkey '^[[A' up-line-or-search
      bindkey '^[[D' backward-char
      bindkey '^[[B' down-line-or-search
      bindkey '^[[C' forward-char
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line

      man() {
        env \
          LESS_TERMCAP_mb=$(printf "\e[1;31m") \
          LESS_TERMCAP_md=$(printf "\e[1;31m") \
          LESS_TERMCAP_me=$(printf "\e[0m") \
          LESS_TERMCAP_se=$(printf "\e[0m") \
          LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
          LESS_TERMCAP_ue=$(printf "\e[0m") \
          LESS_TERMCAP_us=$(printf "\e[1;32m") \
          man "$@"
      }

      zmodload zsh/complist
      autoload -Uz compinit
      compinit
      zstyle :compinstall filename '''''${HOME}/.zshrc''
      zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
      zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
      zstyle ':completion:*:pacman:*' force-list always
      zstyle ':completion:*:*:pacman:*' menu yes select
      zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*:*:kill:*' menu yes select
      zstyle ':completion:*:kill:*' force-list always
      zstyle ':completion:*:*:killall:*' menu yes select
      zstyle ':completion:*:killall:*' force-list always

      case $TERM in
        termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
          precmd () {
            vcs_info
            print -Pn "\e]0;[%n@%M][%~]%#\a"
          }
          preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }
          ;;
        screen|screen-256color)
          precmd () {
            vcs_info
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
          }
          preexec () {
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
          }
          ;;
      esac

      autoload -U colors zsh/terminfo
      colors
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git hg
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:git*' formats "%{''${fg[cyan]}%}[%{''${fg[green]}%}%s%{''${fg[cyan]}%}][%{''${fg[blue]}%}%r/%S%%{''${fg[cyan]}%}][%{''${fg[blue]}%}%b%{''${fg[yellow]}%}%m%u%c%{''${fg[cyan]}%}]%{$reset_color%}"

      setprompt() {
        setopt prompt_subst

        if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
          p_host='%F{yellow}%M%f'
        else
          p_host='%F{green}%M%f'
        fi

        PS1=''${(j::Q)''${(Z:Cn:):-$'
          %F{cyan}[%f
          %(!.%F{red}%n%f.%F{green}%n%f)
          %F{cyan}@%f
          ''${p_host}
          %F{cyan}][%f
          %F{blue}%~%f
          %F{cyan}]%f
          %(!.%F{red}%#%f.%F{green}%#%f)
          " "
        '}}

        PS2=$'%_>'
        RPROMPT=$''''${vcs_info_msg_0_}''
      }
      setprompt
    '';
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "/usr/bin/zsh";
        term = "xterm-256color";
        font = "Terminus:pixelsize=24";
      };
      mouse = {
        hide-when-typing = true;
      };
      colors = {
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
      scrollback = {
        indicator-color = "242424 5dc5f8";
      };
    };
  };

  programs.rofi = {
    enable = true;
    configuration = {
      modes = [ "combi" ];
      combi-modes = [ "window" "drun" "run" ];
      background-color = "#FF0000";
      border-color = "rgba(0,0,1, 0.5)";
      text-color = "SeaGreen";
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        theme = "gruvbox-dark";
      };
      "entry" = {
        placeholder = mkLiteral "what ya need boss?";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = rec {
      modifier = "Mod1";
      terminal = "foot";
      menu = "rofi -show run";
      fonts = {
        names = [ "Terminus" ];
        size = 12.0;
      };
      startup = [
        { command = "swaybg -c '#000000'"; }
        { command = "swayidle -w timeout 30000 'swaylock -f -c 000000' timeout 60000 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' before-sleep 'swaylock -f -c 000000'"; }
      ];
      keybindings = let
        mod = "Mod1";
      in {
        "${mod}+Shift+P" = "exec grimshot --notify save area";
        "${mod}+Shift+V" = "exec wf-recorder -g \"$(swaymsg -t get_outputs | jq -r '.[0].rect | .x,.y,.width,.height | @csv' | tr ',' ' ')\" -f ~/Videos/screen-recording-$(date +'%Y%m%d-%H%M%S').mp4";
        "${mod}+Shift+S" = "exec pkill -INT wf-recorder";
        "${mod}+Return" = "exec foot -T=\"<kitty> \\f $USER\"";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+z" = "exec foot --hold -e sudo shutdown now";
        "${mod}+d" = "exec $menu";
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
        "${mod}+m" = "exec foot --hold -e curl wttr.in/starkville";
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
          statusCommand = ''
            while true; do
              date=$(date +'%A, %b %d')
              time=$(date +'%I:%M %p')
              level=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
              status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
              [ -n "$level" ] && [ "$status" = "Charging" ] && charge="BAT $level%" || charge="BAT $level%"
              echo "$date  $time  [ $charge ]"
              sleep 1
            done
          '';
          statusEdgePadding = 3;
          statusPadding = 5;
          mode = "hide";
          hiddenState = "hide";
          modifier = "Mod1";
          colors = {
            statusline = "#ffffff";
            background = "#00000000";
          };
        }
      ];
    };
    extraConfig = ''
      include /etc/sway/config-vars.d/*
    '';
  };

  programs.home-manager.enable = true;
}
