return {
    name = 'zig build',
    builder = function()
        return {
            cmd = { 'zig' },
            args = { 'build' },
            components = {
                { 'on_output_quickfix', open = true, set_diagnostics = true },
                -- { 'on_result_diagnostics_trouble', close = false },
                'default',
            },
        }
    end,
    condition = {
        filetype = { 'zig' },
    },
}
