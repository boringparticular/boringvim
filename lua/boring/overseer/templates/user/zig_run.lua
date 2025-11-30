return {
    name = 'zig run',
    builder = function()
        return {
            cmd = { 'zig' },
            args = { 'build', 'run' },
            components = { { 'on_output_trouble', open = true }, 'default' },
        }
    end,
    condition = {
        filetype = { 'zig' },
    },
}
