# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example repository https://github.com/BirdeeHub/nixCats-nvim
# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.
# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.
{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim?dir=nix";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    sg-nvim = {
      url = "github:sourcegraph/sg.nvim";
    };

    plugins-render-markdown = {
      url = "github:MeanderingProgrammer/markdown.nvim";
      flake = false;
    };

    plugins-large-file = {
      url = "github:mireq/large_file";
      flake = false;
    };

    plugins-go-nvim = {
      url = "github:ray-x/go.nvim";
      flake = false;
    };

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples
  };

  # see :help nixCats.flake.outputs
  outputs = {
    self,
    nixpkgs,
    nixCats,
    ...
  } @ inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      allowUnfree = true;
    };
    # sometimes our overlays require a ${system} to access the overlay.
    # management of this variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.

    # First, we will define just our overlays per system.
    # later we will pass them into the builder, and the resulting pkgs set
    # will get passed to the categoryDefinitions and packageDefinitions
    # which follow this section.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.
    inherit
      (forEachSystem (system: let
        # see :help nixCats.flake.outputs.overlays
        dependencyOverlays =
          /*
          (import ./overlays inputs) ++
          */
          [
            # This overlay grabs all the inputs named in the format
            # `plugins-<pluginName>`
            # Once we add this overlay to our nixpkgs, we are able to
            # use `pkgs.neovimPlugins`, which is a set of our plugins.
            (utils.standardPluginOverlay inputs)

            inputs.neovim-nightly-overlay.overlays.default
            inputs.neorg-overlay.overlays.default
            # add any flake overlays here.
          ];
        # these overlays will be wrapped with ${system}
        # and we will call the same utils.eachSystem function
        # later on to access them.
      in {inherit dependencyOverlays;}))
      dependencyOverlays
      ;
    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      name,
      ...
    } @ packageDef: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # propagatedBuildInputs:
      # this section is for dependencies that should be available
      # at BUILD TIME for plugins. WILL NOT be available to PATH
      # However, they WILL be available to the shell
      # and neovim path when using nix develop
      propagatedBuildInputs = {
        general = with pkgs; [
        ];
      };

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
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
          luarocks
        ];

        notes = [
        ];

        ai = [
          inputs.sg-nvim.packages.${pkgs.system}.default
        ];

        debug = [
          delve
        ];

        devtools = [
          markdownlint-cli
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = with pkgs.vimPlugins; {
        general = [
          lazy-nvim
          plenary-nvim
          vim-sleuth
          fidget-nvim
          telescope-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim
          conform-nvim
          oil-nvim
          which-key-nvim
          mini-nvim
          catppuccin-nvim
          comment-nvim
          luasnip
          nvim-cmp
          cmp_luasnip
          cmp-path
          cmp-cmdline
          cmp-buffer
          cmp-treesitter
          lspkind-nvim
          nvim-web-devicons
          nvim-treesitter.withAllGrammars
          # This is for if you only want some of the grammars
          # (nvim-treesitter.withPlugins (
          #   plugins: with plugins; [
          #     nix
          #     lua
          #   ]
          # ))
        ];

        mini = {
          extra = [
            mini-nvim
          ];
          optional = [
            mini-nvim
          ];
        };

        go = [
          pkgs.neovimPlugins.go-nvim
        ];

        ai = [
          supermaven-nvim
          # sg-nvim # breaks with rust 1.80
          inputs.sg-nvim.packages.${pkgs.system}.sg-nvim
        ];

        notes = [
          neorg
          neorg-telescope
          pkgs.neovimPlugins.render-markdown
          markdown-preview-nvim
          obsidian-nvim
        ];

        treesitter-optional = [
          nvim-treesitter-textobjects
          nvim-ts-context-commentstring
          nvim-treesitter-context
          nvim-treesitter-refactor
        ];

        devtools = [
          nvim-lspconfig
          cmp-nvim-lsp
          cmp-nvim-lsp-signature-help
          cmp-nvim-lsp-document-symbol
          cmp-nvim-lua
          lsp_signature-nvim
          nvim-lint
          fidget-nvim
        ];

        extra = [
          pkgs.neovimPlugins.large-file
          gitsigns-nvim
          lazydev-nvim
          todo-comments-nvim
          undotree
          direnv-vim
          nvim-notify
          harpoon2
          indent-blankline-nvim
          nvim-colorizer-lua
          trouble-nvim
          rainbow-delimiters-nvim
          noice-nvim
        ];

        debug = [
          nvim-dap
          nvim-dap-ui
          nvim-dap-go
          nvim-nio
        ];

        webdev = [
          emmet-vim
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
      # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
      # I just put them all in startupPlugins. I could have put them all in here instead.
      optionalPlugins = {};

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      extraPython3Packages = {
        test = _: [];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
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

    # And then build a package with specific categories from above here:
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.

    # see :help nixCats.flake.outputs.packageDefinitions
    # they contain a settings set defined above
    # see :help nixCats.flake.outputs.settings
    baseSettings = {pkgs, ...}: {
      wrapRc = true;
      unwrappedCfgPath = "/home/kmies/projects/nixos/nixCats";
      neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      withNodeJs = true;
    };
    # and a set of categories that you want
    # (and other information to pass to lua)
    baseCategories = {pkgs, ...}: {
      general = true;
      ai = true;
      go = true;
      notes = true;
      treesitter-optional = true;
      debug = true;
      extra = true;
      devtools = true;
      webdev = true;
      mini.extra = true;
      mini.optional = false;

      # we can pass whatever we want actually.
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
      # These are the names of your packages
      # you can include as many as you wish.
      miniNvim = args: {
        settings =
          baseSettings args
          // {
            withNodeJs = false;
          };
        categories = {
          mini.extra = true;
          mini.optional = true;
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

      testNvim = args: {
        settings =
          baseSettings args
          // {
            wrapRc = false;
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
            ai = false;
            notes = false;
            debug = false;
            extra = false;
            devtools = false;
            webdev = false;
            mini.extra = false;
            mini.optional = false;
          };
      };

      nvim = args: {
        settings =
          baseSettings args
          // {
            aliases = ["vim"];
          };
        categories = baseCategories args // {};
      };
    };
    # In this section, the main thing you will need to do is change the default package name
    # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "nvim";
  in
    # see :help nixCats.flake.outputs.exports
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      # this is just for using utils such as pkgs.mkShell
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
      pkgs = import nixpkgs {inherit system;};
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one passed in here.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [
            defaultPackage
            pkgs.stylua
          ];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // {
      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      # we also export a nixos module to allow reconfiguration from configuration.nix
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
      # and the same for home manager
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
