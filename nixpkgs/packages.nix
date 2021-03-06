{ ...
}:

# use a pinned version of nixpkgs, bypassing nix-channel
with import ./nixpkgs.nix;

let

  inherit (stdenv.lib) optional optionals;
  inherit (stdenv) isLinux;
  myOptions = callPackage ./packageChoices.nix { };

  args = {inherit pkgs config stdenv;} // myOptions;

  gitchangelog = callPackage ./apps/gitchangelog.nix { inherit (python27Packages) buildPythonPackage d2to1; };
  devPython27 = callPackage ./devenv/python27.nix {};
  devHaskell  = with args; callPackage ./devenv/haskell.nix {};
  keepassxc = keepassx-community;
  emacsSetup = emacsWithPackages (self: with self; []);
  pnix-shell = callPackage ./apps/pnix-shell.nix {};


  play-on-linux = buildFHSUserEnv {
    name = "playonlinux";
    targetPkgs = pkgs: with pkgs; [ playonlinux freetype sudo file which binutils glxinfo wine ];
    multiPkgs  = pkgs: with pkgs; [ freetype openssl gnutls mesa mesa_noglu.osmesa libdrm libudev fontconfig libpng libjpeg libtiff fontconfig alsaLib libpulseaudio gtk3 glib ncurses ]
                   ++ (with xorg; [ libICE libSM libX11 libXi libXcursor libXrandr libXrender libXxf86vm libXcomposite libXext libXinerama ]);
    profile = ''
      export TERM=xterm
      export USER=$(whoami)
    '';
    runScript = "playonlinux";
  };

  run-in-wine =
    { name
    , cpath
    , exe
    , prefix
    , stdenv, bash, wineFull, ...
    }:
    stdenv.mkDerivation {
      name = "run-${name}";
      src = builtins.toFile "run-${name}.sh" ''
        #!/usr/bin/env bash
        cd "${prefix}/drive_c/${cpath}"
        exec wine "${exe}"
      '';
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/run-${name}
        chmod +x $out/bin/run-${name}
      '';
      buildInputs = [];
      propagatedBuildInputs = [ wineFull ];
    };


  run-pharaoh = callPackage run-in-wine {
    prefix = "~/.wine";
    name = "pharaoh";
    cpath = "SIERRA/Pharaoh";
    exe = "Pharaoh.exe";
  };

  run-torment = callPackage run-in-wine {
    name = "torment";
    prefix = "$HOME/wineprefix/planescape-torment";
    cpath = "Program Files/Planescape Torment Enhanced Edition";
    exe = "Torment.exe";
  };

  run-baldursgate = callPackage run-in-wine {
    name = "baldursgate";
    prefix = "$HOME/wineprefix/baldurs-gate-EE";
    cpath = "Program Files/Baldur's Gate - Enhanced Edition";
    exe = "Baldur.exe";
  };

in

let

  all = with args;

       [ oh-my-zsh ]

    ### cloudfs / synchronization
    ++ optional withDropbox dropbox
    ++ optional withMega    megatools
    ++ optional isLinux      unison
    ++ optional withBox     boxfs

    ### development
    ++ [ emacsSetup autoconf gnumake gcc silver-searcher colordiff direnv ]
    ++ optional withPyCharm idea.pycharm-community
    ++ [ icdiff ]
    ++ [ pnix-shell ]

    ### developtment / cloud
    ++ [ nixops aws ]

    ### development / git tools
    ++ (with gitAndTools;
       [ git hub git-extras topGit gitchangelog
         git-crypt
       ])
    ++ [ github-release ]
    ++ [ mercurialFull ]
    ++ [ vagrant ]

    # ### development / python
    ++ [ devPython27 ]
    ++ [ devHaskell  ]
    ++ [ sqlite sqlitebrowser ]

    # ### development / android
    ++ optional withAndroidDev androidsdk

    # ### finance
    ++ (with haskellPackages;
       [ hledger
         # hledger-ui
         hledger-web
         # hledger-diff # broken in 2016/12/05
       ])
    ++ [ gnuplot ]

    ### games
    ++ optionals withGames [ run-pharaoh run-torment run-baldursgate wineFull winetricks pingus ]

    ### monitoring
    ++ optionals isLinux [ iotop htop nethogs ]

    ### media
    ++ optional withSpotify spotify
    ++ [vlc smplayer mplayer mpv]

    ### nix
    ++ [ nix-repl ]

    ### office / productivity
    ++ [ mendeley ]
    ++ optional  withEvince evince
    # ++ optional  withInkscape    inkscape
    # ++ optionals withLatex       [texlive.combined.scheme-full biber ghostscript]
    # ++ optional  withLibreOffice libreoffice
    ++ optional  withPopfile     popfile
    ++ optionals withDigikam     [fdupes exiftool perlPackages.ImageExifTool]
    ++ optional  withXpdf        xpdf
    ++ optional  withSynergy     synergy
    ++ optional  withGimp        gimp-with-plugins

    ### security
    ++ [ gnupg1 gnupg gnutls pinentry keychain keepassxc ]
    ++ optional  isLinux paperkey
    ++ optionals withYubikey [ yubikey-personalization-gui
                               yubikey-personalization ]

    ### tools
    ++ [ aspell aspellDicts.en
         bc
         dos2unix
         graphviz-nox
         imagemagick
         inotify-tools
         libav
         mediainfo
         most
         pandoc
         p7zip
         pv
         rsync
         tree
         unison
         unrar
         unzipNLS
         zip
         zoom-us
       ]
    ++ optional isLinux aria

    ### web / network
    ++ [ httpie jq nmap w3m ]
    ++ optional withChrome   google-chrome
    ++ optional withChromium chromium
    ++ optional withFirefox  firefox-beta-bin
    ++ optional withVivaldi  vivaldi
    ++ optionals withUrxvt   [ rxvt_unicode_with-plugins
                               urxvt_font_size
                               urxvt_perl
                               urxvt_perls
                               urxvt_tabbedex
                               urxvt_theme_switch
                               urxvt_vtwheel
                             ]

    ### X11, window management
    ++ [ screen tmux ]                     # terminal multiplexers
    ++ [ enlightenment.terminology ]       # terminals
    ++ [ xclip xsel xdotool                # X management
         gnome3.gnome_keyring ]
    ++ [ feh rofi ]                        # X tools
    ++ (with xorg; [xev xbacklight xmodmap ])
    ++ [ networkmanagerapplet pa_applet    # applets
         parcellite ]

    ### XMonad
    ++ [ dmenu trayer compton haskellPackages.xmobar ]

    ;

in {
  badi = buildEnv {
    name = "badi-packages";
    paths =  all;
  };
  badi-recordings = buildEnv {
    name = "badi-recordings";
    paths = [blender simplescreenrecorder];
  };
}
