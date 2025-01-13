local api = vim.api
local util = require("donutlify.util")
local M = {}

---smaller radii will just not work
---@type integer
local min_outer_radius = 7

---character width / character height
---@type number
local aspect_ratio = 0.5

---@param radius integer
---@return integer
local function calc_donut_area(radius)
    local inner_radius = util.round(radius / 4)
    local outer_area = math.pi * radius ^ 2
    local inner_area = math.pi * inner_radius ^ 2
    return util.round(aspect_ratio * (outer_area - inner_area))
end

---@param text_len integer
---@return integer, integer
local function determine_radius(text_len)
    local best_outer_radius, best_inner_radius = 0, 0

    for outer_radius = 60, min_outer_radius, -1 do
        -- local inner_radius = util.round(outer_radius / 4)
        local donut_area = calc_donut_area(outer_radius)

        if donut_area <= text_len then
            best_outer_radius, best_inner_radius = outer_radius + 1, util.round(outer_radius / 4)
            break
        end
    end

    return best_outer_radius, best_inner_radius
end

---@param text string
---@param outer_radius integer
---@param inner_radius integer
---@return string[]
local function make_it_donut(text, outer_radius, inner_radius)
    local height = util.round(outer_radius * 2 * aspect_ratio)
    local width = util.round(outer_radius * 2)

    local center_x = width / 2
    local center_y = height / 2

    local donut = {}
    local text_idx = 1
    local text_len = api.nvim_strwidth(text)

    for y = 0, height - 1 do
        local row = {}
        for x = 0, width - 1 do
            local dx = x - center_x
            local dy = (y - center_y) / aspect_ratio
            local distance = math.sqrt(dx ^ 2 + dy ^ 2)

            if inner_radius <= distance and distance <= outer_radius then
                local next_char = util.utf_sub(text, text_idx, text_idx)
                text_idx = text_idx + 1

                table.insert(row, next_char)

                if text_idx > text_len then
                    table.insert(donut, table.concat(row))
                    return donut
                end
            else
                table.insert(row, " ")
            end
        end
        table.insert(donut, table.concat(row))
    end

    return donut
end

---@param line_start integer
---@param line_end integer
---@param diameter integer
function M.donutlify(line_start, line_end, diameter)
    if diameter < min_outer_radius * 2 then
        util.error("Diameter is too small, minimum is " .. min_outer_radius * 2)
        return
    end

    local lines = api.nvim_buf_get_lines(0, line_start, line_end, false)
    -- trim all lines
    lines = vim.iter(lines)
        :map(function(l)
            return vim.trim(l)
        end)
        :totable()
    local text = table.concat(lines, " ")
    local text_len = api.nvim_strwidth(text)

    local radius = math.floor(diameter / 2)

    local donuts = {}
    local donut_max_chars = calc_donut_area(radius)
    local smallest_donut_max_chars = calc_donut_area(min_outer_radius)
    while text_len > donut_max_chars and text_len - donut_max_chars > smallest_donut_max_chars do
        table.insert(
            donuts,
            make_it_donut(util.utf_sub(text, 1, donut_max_chars), radius, util.round(radius / 4))
        )
        text = util.utf_sub(text, donut_max_chars + 1)
        text_len = api.nvim_strwidth(text)
    end
    local outer_radius, inner_radius = determine_radius(text_len)
    table.insert(donuts, make_it_donut(text, outer_radius, inner_radius))

    local replacement = {}
    for _, donut in ipairs(donuts) do
        for _, row in ipairs(donut) do
            table.insert(replacement, row)
        end
        table.insert(replacement, "")
    end
    api.nvim_buf_set_lines(0, line_start, line_end, false, replacement)
end

function M.setup() end

return M
