{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neorg-overlay = {
    #   url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    nixCats,
    ...
  } @ inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
      allowUnfree = true;
    };

    dependencyOverlays = [
      (utils.standardPluginOverlay inputs)
      inputs.neovim-nightly-overlay.overlays.default
    ];

    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      name,
      ...
    } @ packageDef: {
      propagatedBuildInputs = {
        general = with pkgs; [
        ];
      };

      lspsAndRuntimeDeps = with pkgs; {
        general = [
          universal-ctags
          ripgrep
          fd
          stdenv.cc.cc
          nix-doc
          lua-language-server
          nixd
          stylua
        ];

        notes = [
          luarocks
          zk
        ];

        ai = {
          codeium = [
            codeium
          ];
          cody = [
            inputs.sg-nvim.packages.${pkgs.system}.default
          ];
        };

        debug = [
          delve
        ];

        devtools = [
          markdownlint-cli
        ];
      };

      startupPlugins = with pkgs.vimPlugins; {
      };

      optionalPlugins = with pkgs.vimPlugins; {
        general = {
          extra = [
            indent-blankline-nvim
            nvim-colorizer-lua
            nvim-notify
            pkgs.neovimPlugins.go-nvim
            pkgs.neovimPlugins.large-file
            rainbow-delimiters-nvim
            comment-nvim
            lspsaga-nvim
            dropbar-nvim
            nvim-bqf
            pkgs.neovimPlugins.volt
            pkgs.neovimPlugins.typr
          ];

          treesitter = [
            nvim-treesitter-textobjects
            nvim-ts-context-commentstring
            nvim-treesitter-context
            nvim-treesitter-refactor
          ];
        };

        elixir = [
          elixir-tools-nvim
        ];

        notes = [
          # neorg
          # neorg-telescope
        ];

        scheme = [
          conjure
          cmp-conjure
          parinfer-rust
        ];

        webdev = [
          pkgs.neovimPlugins.nvim-emmet
          emmet-vim
          tailwind-tools-nvim
          tailwindcss-colors-nvim
        ];
      };

      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
        sgdev = {
          SG_NVIM_DEV = "true";
        };
      };

      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      python3.libraries = {
        test = _: [];
      };
      extraLuaPackages = {
        ai = [
          (lp:
            with lp; [
              tiktoken_core
            ])
        ];
        notes = [
          (lp:
            with lp; [
              lua-utils-nvim
              pathlib-nvim
            ])
        ];
        test = [(_: [])];
      };
    };

    baseSettings = {pkgs, ...}: {
      wrapRc = true;
      unwrappedCfgPath = "/home/kmies/projects/nixos/boringvim";
      neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      hosts.node.enable = true;
    };
    baseCategories = {pkgs, ...}: {
      general = {
        always = true;
        extra = true;
        lsp = true;
        cmp = true;
        blink = false;
        telescope = true;
        treesitter = true;
      };
      ai = {
        copilot = true;
        copilot-cmp = true;
        codeium = false;
        cody = false;
        supermaven = false;
      };
      elixir = true;
      go = true;
      notes = true;
      debug = true;
      devtools = true;
      webdev = true;
      python = true;
      mini.extra = false;
      asm = true;

      have_nerd_font = true;

      example = {
        youCan = "add more than just booleans";
        toThisSet = [
          "and the contents of this categories set"
          "will be accessible to your lua with"
          "nixCats('path.to.value')"
          "see :help nixCats"
          "and type :NixCats to see the categories set in nvim"
        ];
      };
    };
    packageDefinitions = {
      miniNvim = args: {
        settings =
          baseSettings args
          // {
            withNodeJs = false;
          };
        categories = {
          mini.extra = true;
        };
      };

      minimalNvim = args: {
        settings =
          baseSettings args
          // {
            withNodeJs = false;
          };
        categories = {
          have_nerd_font = false;
        };
      };

      sgdevNvim = args: {
        settings =
          baseSettings args
          // {
            wrapRc = false;
            extraName = "sgvim";
          };
        categories =
          baseCategories args
          // {
            sgdev = true;
          };
      };

      testNvim = args: {
        settings =
          baseSettings args
          // {
            wrapRc = false;
            extraName = "testNvim";
          };
        categories =
          baseCategories args // {};
      };

      serverNvim = args: {
        settings = baseSettings args // {};
        categories =
          baseCategories args
          // {
            test = false;
            go = false;
            ai = {
              copilot = true;
              codeium = false;
              cody = false;
              supermaven = false;
            };
            notes = false;
            debug = false;
            extra = false;
            devtools = false;
            webdev = false;
            mini.extra = false;
            mini.optional = false;
          };
      };

      # remove ai for advent of code
      aocNvim = args: {
        settings =
          baseSettings args
          // {
            extraName = "aocNvim";
          };
        categories =
          baseCategories args
          // {
            ai = {
              copilot = true;
              copilot-cmp = false;
              codeium = false;
              cody = false;
              supermaven = false;
            };
          };
      };

      boringVim = args: {
        settings =
          baseSettings args
          // {
            aliases = ["vim" "nvim"];
            configDirName = "boringvim";
          };
        categories = baseCategories args // {};
      };
    };
    defaultPackageName = "boringVim";
  in
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = utils.mkAllWithDefault defaultPackage;

      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [
            defaultPackage
            pkgs.stylua
            pkgs.nixd
          ];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // {
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = utils.mkNixosModules {
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
      inherit utils;
      inherit (utils) templates;
    };
}
