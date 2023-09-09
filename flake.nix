{
  inputs = {
  };

  outputs = { ... }: rec {
    nixosModules = rec {
      nftables = import ./default.nix;
      default = nftables;
    };
    nixosModule = nixosModules.default;

    lib = import ./lib;
  };
}