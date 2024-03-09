local parsers = require('nvim-treesitter.parsers')
local queries = require('nvim-treesitter.query')

local m = {}

local function does_surround(a, b)
    local a_start_row, a_start_col, a_end_row, a_end_col = a[1], a[2], a[3], a[4]
    local b_start_row, b_start_col, b_end_row, b_end_col = b[1], b[2], b[3], b[4]

    if a_start_row < b_start_row and a_end_row > b_end_row then
        return true
    end

    if a_start_row == b_start_row and b_end_row == a_end_row then
        return b_start_col > a_start_col and b_end_col < a_end_col
    end

    if a_start_row == b_start_row then
        return b_start_col > a_start_col
    end

    if a_end_row == b_end_row then
        return b_end_col < a_end_col
    end

    return false
end

local function normalize_selection(sel_start, sel_end)
    local _, sel_start_row, sel_start_col = unpack(sel_start)
    local start_max_cols = #vim.fn.getline(sel_start_row)
    -- visual line mode results in getpos("'>") returning a massive number so
    -- we have to set it to the true end col
    if start_max_cols < sel_start_col then
        sel_start_col = start_max_cols
    end
    -- tree-sitter uses zero-indexed rows
    sel_start_row = sel_start_row - 1
    -- tree-sitter uses zero-indexed cols for the start
    sel_start_col = sel_start_col - 1

    local _, sel_end_row, sel_end_col = unpack(sel_end)
    local end_max_cols = #vim.fn.getline(sel_end_row)
    -- visual line mode results in getpos("'>") returning a massive number so
    -- we have to set it to the true end col
    if end_max_cols < sel_end_col then
        sel_end_col = end_max_cols
    end
    -- tree-sitter uses zero-indexed rows
    sel_end_row = sel_end_row - 1

    return { sel_start_row, sel_start_col, sel_end_row, sel_end_col }
end

function m.outer(is_start)
    local bufnr = vim.api.nvim_get_current_buf()
    local lang = parsers.get_buf_lang(bufnr)
    if not lang then return end

    local max = { 0, 0 }
    local sel = normalize_selection(vim.fn.getpos("."), vim.fn.getpos("."))
    local nodes = queries.get_capture_matches_recursively(bufnr, '@range', "treesitter-outer")
    for _, v in pairs(nodes) do
        local match_start_row, match_start_col = unpack(v.node.start_pos)
        local match_end_row, match_end_col = unpack(v.node.end_pos)
        local match = { match_start_row, match_start_col, match_end_row, match_end_col }
        if does_surround(match, sel) then
            if match[1] > max[1] or match[1] == max[1] and match[2] > max[2] then
                max = match
            end
        end
    end

    if #max > 2 then
        if is_start then
            vim.api.nvim_win_set_cursor(0, { max[1] + 1, max[2] })
        else
            vim.api.nvim_win_set_cursor(0, { max[3] + 1, max[4] })
        end
    end
end

m.config = {
    filetypes = {
        "c",
        "cpp",
        "elixir",
        "fennel",
        "foam",
        "go",
        "javascript",
        "julia",
        "lua",
        "nix",
        "php",
        "python",
        "r",
        "ruby",
        "rust",
        "scss",
        "tsx",
        "typescript",
    },
    mode = { 'n', 'v' },
    prev_outer_key = "[{",
    next_outer_key = "]}",
}

local get_default_config = function()
    return m.config
end

m.setup = function(opt)
    opt = opt or {}
    m.config = vim.tbl_deep_extend('force', get_default_config(), opt)

    local group = vim.api.nvim_create_augroup("TreesitterOuter", { clear = true })
    vim.api.nvim_create_autocmd(
        { "Filetype" },
        {
            pattern = m.config.filetypes,
            callback = function()
                vim.keymap.set(m.config.mode, m.config.prev_outer_key, function() m.outer(true) end,
                    { noremap = true, silent = true, buffer = true, desc = "Jump to start position of outer node" })
                vim.keymap.set(m.config.mode, m.config.next_outer_key, function() m.outer(false) end,
                    { noremap = true, silent = true, buffer = true, desc = "Jump to end position of outer node" })
            end,
            group = group,
        }
    )
end

return m
