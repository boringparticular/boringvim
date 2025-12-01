return {
    {
        'blink.pairs',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        after = function(_)
            require('blink-pairs').setup({
                mappings = {
                    -- you can call require("blink.pairs.mappings").enable() and require("blink.pairs.mappings").disable() to enable/disable mappings at runtime
                    enabled = false,
                    -- see the defaults: https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L10
                    pairs = {},
                },
                highlights = {
                    enabled = true,
                    groups = {
                        'BlinkPairsRed',
                        'BlinkPairsYellow',
                        'BlinkPairsBlue',
                        'BlinkPairsOrange',
                        'BlinkPairsGreen',
                        'BlinkPairsViolet',
                        'BlinkPairsCyan',
                    },
                    matchparen = {
                        enabled = true,
                        group = 'MatchParen',
                    },
                },
                debug = false,
            })
        end,
    },
}
