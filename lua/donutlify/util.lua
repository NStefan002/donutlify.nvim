local M = {}

---notify user of an error
---@param msg string
function M.error(msg)
    vim.notify("\n" .. msg, vim.log.levels.ERROR, { title = "Donutlify.nvim" })
end

---@param msg string
function M.info(msg)
    vim.notify("\n" .. msg, vim.log.levels.INFO, { title = "Donutlify.nvim" })
end

---Get the character at the given index in a utf-8 string
---@param str string
---@param idx integer if negative, index from the end of the string (-1 is the last character)
---@return string
function M.utf_char_at(str, idx)
    local utf_indices = vim.str_utf_pos(str)
    if idx == 0 or idx > #utf_indices then
        return ""
    end
    if idx < 0 then
        idx = #utf_indices + idx + 1
    end
    return str:sub(utf_indices[idx], idx < #utf_indices and utf_indices[idx + 1] - 1 or -1)
end

---get a substring of a utf-8 string
---@param str string
---@param start integer index of the first character of the substring (indicies are the positions of utf-8 characters, not bytes as in default lua strings)
---@param stop? integer if nil, the substring will be from `start` to the end of the string
---@return string
function M.utf_sub(str, start, stop)
    local utf_indices = vim.str_utf_pos(str)

    if start > #utf_indices then
        return ""
    end
    if start < 0 then
        start = #utf_indices + start + 1
    end
    local start_idx = utf_indices[start] or 1

    stop = stop or #utf_indices
    if stop < 0 then
        stop = #utf_indices + stop + 1
    end
    local stop_idx = (utf_indices[stop + 1] or 0) - 1

    return str:sub(start_idx, stop_idx)
end

return M
