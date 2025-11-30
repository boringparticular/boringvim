return {
    {
        'parinfer-rust',
        for_cat = 'off',
        dep_of = { 'conjure' },
    },
    {
        'conjure',
        ft = { 'lisp', 'clojure', 'fennel', 'hy', 'scheme', 'yuck' },
        on_require = 'conjure',
        for_cat = 'off',
        after = function(_)
            vim.g['conjure#debug'] = true
        end,
    },
}
