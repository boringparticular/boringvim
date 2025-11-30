{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    {
      packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ ];
            config = { };
          };
        in
        nixCats.utils.mkAllWithDefault (import ./. (inputs // { inherit pkgs; }))
      );
      homeModule = self.packages.x86_64-linux.default.homeModule; # <- it will get the system from the importing configuration
      nixosModule = self.packages.x86_64-linux.default.nixosModule; # <- module namespace defaults to defaultPackageName.{ enable, packageNames, etc... }
    };
}
