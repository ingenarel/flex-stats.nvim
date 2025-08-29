---@type flex.ui.init
local m = {}

local utils = require("flex-stats.ui.utils")

function m.fileStatsMenu(db, buf, win_width, opts)
    opts = opts or {}
    opts.indentDriftForIcon = opts.indentDriftForIcon or 2
    opts.gap = opts.gap or 5
    db = vim.deepcopy(db)
    local setupOpts = require("flex-stats").setupOpts
    for i = 1, #setupOpts.noShow do
        db[setupOpts.noShow[i]] = nil
    end
    db = utils.fileStatsMenu1stPass(db)
    table.sort(db, function(element1, element2)
        return (element1.totalTime > element2.totalTime)
    end)
    db = utils.fileStatsMenu2ndPass(db, win_width, opts)
    db = utils.fileStatsMenu3rdPass(db)
    db = utils.fileStatsMenu4thPass(db, win_width, opts.indentDriftForIcon)
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, db)
    vim.bo[buf].modifiable = false
end

function m.showUI(opts)
    opts = opts or {}
    opts.width = opts.width or 80
    opts.height = opts.height or 80

    ---@type integer
    local win_width = math.floor(vim.o.columns / 100 * opts.width)
    ---@type integer
    local win_height = math.floor(vim.o.lines / 100 * opts.height)
    ---@type integer
    local bufID = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(bufID, true, {
        relative = "editor",
        width = win_width,
        height = win_height,
        col = math.floor((vim.o.columns - win_width - 2) / 2),
        row = math.floor((vim.o.lines - win_height - 2) / 2),
        border = "rounded",
        style = "minimal",
    })
    vim.bo[bufID].filetype = "flexstats"
    local db = require("flex-stats").database
    db[""] = nil
    vim.keymap.set("n", "<ESC>", "<CMD>q<CR>", { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "q", "<CMD>q<CR>", { noremap = true, silent = true, buffer = true })
    m.fileStatsMenu(db, bufID, win_width)
end

return m
