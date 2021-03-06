{ pkgs, config
, ... }:

let

  inherit (builtins) elem;
  inherit (pkgs.stdenv) isLinux;

  isNixOS = builtins.pathExists /etc/NIXOS;
  hostname = builtins.getEnv "HOSTNAME";

  isHomeMachine = elem hostname ["fangorn"];
  isWorkMachine = elem hostname ["tolu"];

in
{
  withAndroidDev  = isHomeMachine;
  withBox         = false;
  withChrome      = isLinux;
  withChromium    = false;
  withDigikam     = true;
  withDropbox     = false;
  withEvince      = isLinux;
  withFirefox     = false;
  withGames       = isHomeMachine;
  withGimp        = isHomeMachine;
  withInkscape    = isLinux;
  withLatex       = isLinux;
  withLibreOffice = isLinux;
  withMega        = false;
  withPopfile     = isHomeMachine;
  withPyCharm     = false;
  withSpotify     = true;
  withSynergy     = hostname == "fangorn";
  withUrxvt       = true;
  withVivaldi     = false;
  withX11         = isNixOS;
  withXmonad      = isNixOS;
  withYubikey     = isLinux;
  withXpdf        = isLinux;
}
