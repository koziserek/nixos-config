{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # Security and authentication
  keepassxc

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager

  # Media and design tools
  gimp
  vlc
  mpv
  wineWowPackages.stable
  fontconfig
  font-manager

  # Calculators
  bc # old school calculator
  galculator

  # Audio tools
  cava # Terminal audio visualizer
  pavucontrol # Pulse audio controls

  # Messaging and chat applications
  discord
  fractal # Matrix.org messaging app

  # Testing and development tools
  beekeeper-studio
  chromedriver
  direnv
  rofi
  rofi-calc
  qmk
  postgresql
  libusb1 # for Xbox controller
  libtool # for Emacs vterm

  # Screenshot and recording tools
  flameshot
  simplescreenrecorder

  # Text and terminal utilities
  emote # Emoji picker
  feh # Manage wallpapers
  screenkey
  tree
  unixtools.ifconfig
  unixtools.netstat
  xclip # For the org-download package in Emacs
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  i3lock-fancy-rapid
  libnotify
  ledger-live-desktop
  playerctl # Control media players from command line
  pcmanfm # Our file browser
  sqlite
  xdg-utils

  # Other utilities
  yad # I use yad-calendar with polybar
  xdotool
firefox
google-chrome-stable
  # PDF viewer
  zathura

  # Music and entertainment
  spotify

]
