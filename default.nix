{
  pkgs ? import (import ./lon.nix).nixpkgs { },
}:
{
  bot = pkgs.callPackage ./src/Bot/package.nix { };
  webhook = pkgs.callPackage ./src/Webhook/package.nix { };
}
