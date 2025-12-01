{
  sources ? (import ./npins),
  nixpkgs ? <nixpkgs>,
  system ? (builtins.currentSystem or null),
  pkgs ? (import nixpkgs { inherit system; }),
  nixCats ? sources.nixCats,
  ...
}:
let
  utils = import nixCats;
  luaPath = ./.;
  dependencyOverlays = [
    (utils.standardPluginOverlay sources)
    (import sources.neovim-nightly-overlay)
  ];

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
  packageDefinitions = {
    boringvim =
      {
        pkgs,
        name,
        mkPlugin,
        ...
      }:
      {
        # see :help nixCats.flake.outputs.settings
        settings = {
          suffix-path = true;
          suffix-LD = true;
          host.node.enable = true;
          host.python.enable = true;
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
        categories = {
          general = true;
          extra = true;
        };
        # anything else to pass and grab in lua with `nixCats.extra`
        extra = { };
      };
  };

  # We will build the one named nvim here and export that one.
  # you can change which package from packageDefinitions is built later
  # using package.override { name = "aDifferentPackage"; }
  defaultPackageName = "boringvim";
in
utils.baseBuilder luaPath {
  inherit pkgs dependencyOverlays;
} categoryDefinitions packageDefinitions defaultPackageName
