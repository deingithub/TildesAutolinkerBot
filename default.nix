with import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/tarball/b67bc34d4e3de1e89b8bb7cd6e375ba44f1ae8ca";
  sha256 = "1q9a64bl5afflgpa2iaw1q7z7s08c8xq9w6lndlnc5c3siajrp8v";
}) {};

crystal.buildCrystalPackage rec {
  version = "0.1.0";
  pname = "TildesAutolinkerBot";
  src = ./.;

  shardsFile = ./shards.nix;
  crystalBinaries.TildesAutolinkerBot.src = "src/TildesAutolinkerBot.cr";

  buildInputs = [ sqlite-interactive.dev ];
}
