local function cmd(data)
    local line_start, line_end
    if data.range == 0 then
        line_start, line_end = 0, -1
    else
        line_start, line_end = data.line1 - 1, data.line2
    end
    require("donutlify").donutlify(line_start, line_end)
end

vim.api.nvim_create_user_command("Donutlify", cmd, {
    desc = "Turn the buffer text into donuts",
    nargs = "*",
    range = true,
})
