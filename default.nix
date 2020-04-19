with import <nixpkgs> {};
crystal.buildCrystalPackage rec {
  version = "0.1.0";
  pname = "TildesAutolinkerBot";
  src = ./.;

  shardsFile = ./shards.nix;
  crystalBinaries.TildesAutolinkerBot.src = "src/TildesAutolinkerBot.cr";

  buildInputs = [ sqlite-interactive.dev ];
}
