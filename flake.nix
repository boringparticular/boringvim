{
  description = "My Neovim configuration using nixCats";

  inputs = { };

  outputs =
    {
      self ? (builtins.toString ./.),
      ...
    }@flakeArgs:
    let
      sources = flakeArgs.sources or (import "${self}/npins");
      nixpkgs = flakeArgs.nixpkgs or sources.nixpkgs;
      nixCats = flakeArgs.nixCats or sources.nixCats;
      defaultNix = import ./default.nix { inherit sources nixpkgs nixCats; };
    in
    {
      inherit (defaultNix)
        packages
        devShells
        nixosModule
        nixosModules
        homeModule
        homeModules
        ;
    };
}
