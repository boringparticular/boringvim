return {

    {
        'parinfer-rust',
        for_cat = 'languages.lisp',
        dep_of = { 'conjure' },
    },
    {
        'conjure',
        ft = { 'lisp', 'clojure', 'fennel', 'hy', 'scheme', 'yuck' },
        on_require = 'conjure',
        for_cat = 'languages.lisp',
        after = function(_)
            vim.g['conjure#debug'] = true
        end,
    },
    {
        'cmp-conjure',
        for_cat = 'languages.lisp',
        dep_of = { 'blink.cmp' },
    },
}
