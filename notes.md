# Notes

## Keymaps

### mini.operators

`g=` evaluate text and replace with output
`gx` exchange text regions
`gm` multiply (duplicate) text
`gr` replace text with register
`gs` sort text

### mini.bracketed


`[` + upper-suffix : go first.
`[` + lower-suffix : go backward.
`]` + lower-suffix : go forward.
`]` + upper-suffix : go last.

`b` / `B` buffer
`c` / `C` comment block
`x` / `X` conflict marker
`d` / `D` diagnostics
`f` / `F` file on disk
`i` / `I` indent change
`j` / `J` jump from jumplist inside current buffer
`l` / `L` location from location list
`o` / `O` old files
`q` / `Q` quickfix entry from quickfix list
`t` / `T` treesitter node and parents
`u` / `U` undo states from specially tracked linear history
`w` / `W` window in current tab
`y` / `Y` yank selection replacing latest put region


### mini.splitjoin

`gS` toggle

### mini.surround

`sa` add
`sd` delete
`sr` replace
`sf` `sF` find surrounding
`sh` highlight surrounding

### mini.ai

`a` around
`i` inside
`an` around next
`in` inside next
`al` around last
`il` inside last
`g[` goto left
`g]` goto right

### mini.sessions

### mini.move

`<M-k>` up
`<M-j>` down
`<M-h>` left
`<M-l>` right

### mini.files

`j` navigate down
`k` navigate up
`l` expand entry under cursor
`h` go to parent directory
`m<char>` set directory path of focused window as bookmark `<char>`
`'<char>` jump to bookmark
`g?` help


### trouble
### lspsaga
### fzf-lua
### navic
### treesitter
### glance
### aerial
### navbuddy
### dropbar
### navigator
### outline
### flash


### kind icons blink

```lua
kind_icons = {
  Copilot = '',
  Text = '󰉿',
  Method = '󰊕',
  Function = '󰊕',
  Constructor = '󰒓',

  Field = '󰜢',
  Variable = '󰆦',
  Property = '󰖷',

  Class = '󱡠',
  Interface = '󱡠',
  Struct = '󱡠',
  Module = '󰅩',

  Unit = '󰪚',
  Value = '󰦨',
  Enum = '󰦨',
  EnumMember = '󰦨',

  Keyword = '󰻾',
  Constant = '󰏿',

  Snippet = '󱄽',
  Color = '󰏘',
  File = '󰈔',
  Reference = '󰬲',
  Folder = '󰉋',
  Event = '󱐋',
  Operator = '󰪚',
  TypeParameter = '󰬛',
},
```

### luasnip

```lua
local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require('luasnip.util.events')
local ai = require('luasnip.nodes.absolute_indexer')
local extras = require('luasnip.extras')
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require('luasnip.extras.expand_conditions')
local postfix = require('luasnip.extras.postfix').postfix
local types = require('luasnip.util.types')
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet
local k = require('luasnip.nodes.key_indexer').new_key
```

## Plugins

- nvim-colorizer-lua
- brenoprata10/nvim-highlight-colors
- indent-blankline-nvim
- rainbow-delimiters-nvim
- otter-nvim

*instead of mini.sessions*
- folke/persistence.nvim
- rmagatti/auto-session

- inc-rename

- RRethy/nvim-treesitter-textsubjects/
- tpope/vim-dadbod
- szw/vim-maximizer
- stevearc/overseer.nvim
- milisims/nvim-luaref

- milanglacier/minuet-ai.nvim
- olimorris/codecompanion.nvim

*instead of mini.splitjoin*
- Wansmer/treesj

- al1-ce/just.nvim


## Category Default Values


There are 2 ways of creating default values in nixCats.

#1 Implicit: when value is in another section of `categoryDefinitions`

If in your `categoryDefinitions` you had the following:

```nix
environmentVariables = {
  test = {
    subtest1 = {
      CATTESTVAR = "It worked!";
    };
    subtest2 = {
      CATTESTVAR3 = "It didn't work!";
    };
  };
};
extraWrapperArgs = {
  test = [
    '' --set CATTESTVAR2 "It worked again!"''
  ];
};
```

And in your `packageDefinitions` set, under categories, you had the following:

```nix
test = {
  subtest1 = true;
};
```

you could echo `$CATTESTVAR` and `$CATTESTVAR2` in your terminal to see them.
However you could not echo `$CATTESTVAR3`.

All items that are not attributes of the parent set will be included
when you enable a subcategory. This includes lists, strings, functions, etc...

However, attributes will not and you must explicitly enable all attributes of
a subcategory if you set even 1 explicitly.

Thus to include `CATTESTVAR3`, you would have to enable it like so:

```nix
test = {
  subtest1 = true;
  subtest2 = true;
};
```

However, those are all the items in the test category.
So instead we can do this to enable all the subcategories in test.

```nix
test = true;
```

This applies in many situations. Take this one for example.

```nix
lspsAndRuntimeDeps = {
  neonixdev = {
    inherit (pkgs)
    nix-doc nil lua-language-server nixd;
  };
};
```

```nix
startupPlugins = {
  neonixdev = with pkgs.vimPlugins; [
    neodev-nvim
    neoconf-nvim
  ];
};
```

If you were to put the following in your `packageDefinitions`: 

```nix
neonixdev.nix-doc = true;
```

`neodev-nvim` and `neoconf-nvim` would still be included.
However, nil, `lua-language-server`, and `nixd` would not be!
You would need to pick which of those you wanted separately.
Sometimes this is the desired behavior.
Sometimes it is not and a list of packages would be better suited.

This leads us to our second way to make a default value:

#2 Explicit: using `extraCats` section of `categoryDefinitions`.

The `extraCats` section of `categoryDefinitions` contains categories of attribute
paths. If that category is defined, the categories specified by the attribute
paths will also be enabled. This means you could make it so that if you
included the go category, it could then enable `debug.go` and `lsp.go` for you.
But in addition to that, it can be combined with the implicit form of creating
default values above in an interesting way.

```nix
categoryDefinitions = { pkgs, settings, categories, extra, name, ... }@packageDef: {
  lspsAndRuntimeDeps = {
    debug = with pkgs; {
      go = [ delve ];
    };
    go = with pkgs; [
      gopls
      gotools
      go-tools
      gccgo
    ];
  };
  startupPlugins = {
    debug = with pkgs.vimPlugins; {
      default = [
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
      ];
      go = [ nvim-dap-go ];
    };
  };
  # WARNING: use of categories argument in this set will cause infinite recursion
  # The categories argument of this function is the FINAL value.
  # You may use it in any of the other sets.
  extraCats = {
    # due to the implicit form of default values in different sections,
    # this will enable debug.default
    # if any subcategory of debug is enabled
    # thus, enabling debug.go would also enable debug.default
    debug = [
      [ "debug" "default" ]
    ];
    # and if go is enabled, it enables debug.go
    # which then enables debug.default
    go = [ # <- must be in a list
      [ "debug" "go" ]
    ];
  };
};
```

If you wish to only enable a value via extraCats if multiple other categories
are enabled, the categories in extraCats also accept a set form!

```nix
extraCats = {
  # if target.cat is enabled, the list of extra cats is active!
  target.cat = [ # <- must be a list of (sets or list of strings)
    # list representing attribute path of category to enable.
    [ "to" "enable" ]
    # or as a set
    {
      cat = [ "other" "toenable" ]; #<- required if providing the set form
      # all below conditions, if provided, must be true for the `cat` to be included

      # true if any containing category of the listed cats are enabled
      when = [ # <- `when` conditions must be a list of list of strings
        [ "another" "cat" ]
      ];
      # true if any containing OR sub category of the listed cats are enabled
      cond = [ # <- `cond`-itions must be a list of list of strings
        [ "other" "category" ]
      ];
    }
  ];
};
```

```nix
baseCategories = {
  pkgs,
    name,
    ...
}: {
  general = true;
  gitPlugins = true;
  debug = true;
  lsp = true;
  treesitter = true;
  markdown = true;
  notes = true;
  go = true;
  elixir = true;
  blink = true;
  typr = true;
  ai = true;
  customPlugins = true;
  test = true;

  example = {
    youCan = "add more than just booleans";
    toThisSet = [
      "and the contents of this categories set"
      "will be accessible to your lua with"
      "nixCats('path.to.value')"
      "see :help nixCats"
    ];
  };
};
```

```lua
    { 'Olical/conjure' },
    { 'PaterJason/cmp-conjure' },
    { 'eraserhd/parinfer-rust', build = require('nixCatsUtils').lazyAdd('cargo build --release') },
```

Trouble

```lua
{
  "[q",
  function()
    if require("trouble").is_open() then
      require("trouble").prev({ skip_groups = true, jump = true })
    else
      local ok, err = pcall(vim.cmd.cprev)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end
  end,
  desc = "Previous Trouble/Quickfix Item",
},
{
  "]q",
  function()
    if require("trouble").is_open() then
      require("trouble").next({ skip_groups = true, jump = true })
    else
      local ok, err = pcall(vim.cmd.cnext)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end
  end,
  desc = "Next Trouble/Quickfix Item",
},
```

todo-comments.nvim

```lua
{
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "LazyFile",
  opts = {},
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
}
```

