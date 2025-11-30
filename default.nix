{
  sources ? (import ./npins),
  nixpkgs ? <nixpkgs>,
  system ? (builtins.currentSystem or null),
  pkgs ? (import nixpkgs { inherit system; }),
  nixCats ? sources.nixCats,
  ...
}:
let
  lib = import "${nixpkgs}/lib";
  utils = import nixCats;
  forEachSystem = utils.eachSystem lib.platforms.all;
  luaPath = ./.;
  dependencyOverlays = [
    (utils.standardPluginOverlay sources)
    (import sources.neovim-nightly-overlay)
  ];

  extra_pkg_config = { };

  # see :help nixCats.flake.outputs.categories
  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    }@packageDef:
    {
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          ripgrep
          fd

          fzf

          prettier-d-slim
          rustfmt
          python3Packages.ruff

          vale
          spectral-language-server
          markdownlint-cli

          lua-language-server
          stylua
        ];

        extra = with pkgs; [

        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        general = with pkgs.vimPlugins; [
          pkgs.neovimPlugins.lze
          pkgs.neovimPlugins.lzextras
          plenary-nvim
          vim-sleuth
          mini-nvim
          nvim-nio
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        general = with pkgs.vimPlugins; [
          oil-nvim
          conform-nvim
          grug-far-nvim
          nvim-treesitter.withAllGrammars
        ];

        extra = with pkgs.vimPlugins; [
          nvim-lspconfig
          friendly-snippets
          conform-nvim
          nvim-treesitter-context
          nvim-treesitter-refactor
          lazydev-nvim
          nvim-lint
        ];
      };

      sharedLibraries = {
        general = with pkgs; [ ];
      };

      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      python3.libraries = {
        test = (_: [ ]);
      };

      extraLuaPackages = {
        test = [ (_: [ ]) ];
      };
    };

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions =
    let
      baseSettings = {
        suffix-path = true;
        suffix-LD = true;
        host.node.enable = true;
        host.python.enable = true;
        wrapRc = true;
        aliases = [ ];
      };
      baseCategories = {
        general = true;
        extra = true;
      };
    in
    {
      boringvim =
        {
          pkgs,
          name,
          mkPlugin,
          ...
        }:
        {
          # see :help nixCats.flake.outputs.settings
          settings = baseSettings // {
            wrapRc = false;
            unwrappedCfgPath = "/home/kmies/.config/nvim";
            # IMPORTANT:
            # your aliases may not conflict with your other packages.
            aliases = [
              "bvim"
              "nvim"
              "vim"
              "vi"
            ];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
          };
          categories = baseCategories // {
          };
          # anything else to pass and grab in lua with `nixCats.extra`
          extra = { };
        };

      boringwrapped =
        { ... }:
        {
          settings = baseSettings // {
            wrapRc = true;
            aliases = [ "bwim" ];
          };
          categories = baseCategories;
        };
    };

  # We will build the one named nvim here and export that one.
  # you can change which package from packageDefinitions is built later
  # using package.override { name = "aDifferentPackage"; }
  defaultPackageName = "boringvim";
in
forEachSystem (
  system:
  let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit
        nixpkgs
        system
        dependencyOverlays
        extra_pkg_config
        ;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages = utils.mkAllWithDefault defaultPackage;
    devShells.default = import ./shell.nix { inherit nixpkgs pkgs; };
  }
)
// (
  let
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };

    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
  in
  {
    nixosModules.default = nixosModule;

    homeModules.default = homeModule;

    overlays = utils.makeOverlays luaPath {
      inherit
        nixpkgs
        dependencyOverlays
        extra_pkg_config
        ;
    } categoryDefinitions packageDefinitions defaultPackageName;

    inherit
      sources
      utils
      nixosModule
      homeModule
      ;
  }
)
