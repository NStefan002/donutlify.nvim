local function cmd(data)
    local line_start, line_end
    if data.range == 0 then
        line_start, line_end = 0, -1
    else
        line_start, line_end = data.line1 - 1, data.line2
    end
    local diameter = 80
    if #data.fargs > 0 then
        diameter = tonumber(data.fargs[1]) or diameter
    elseif vim.bo.textwidth > 0 then
        diameter = vim.bo.textwidth
    end
    require("donutlify").donutlify(line_start, line_end, diameter)
end

vim.api.nvim_create_user_command("Donutlify", cmd, {
    desc = "Turn the buffer text into donuts",
    nargs = "*",
    range = true,
})
