---@type flex.ui.init
local m = {}

local utils = require("flex-stats.ui.utils")

function m.fileStatsMenu(db, buf, win_width, nsID)
    local setupOpts = require("flex-stats").setupOpts
    db = vim.deepcopy(db)
    for i = 1, #setupOpts.noShow do
        db[setupOpts.noShow[i]] = nil
    end
    db = utils.fileStatsMenu1stPass(db, nsID)
    table.sort(db, function(element1, element2)
        return (element1.totalTime > element2.totalTime)
    end)
    db = utils.fileStatsMenu2ndPass(db, win_width, setupOpts.indentDriftForIcon, setupOpts.gap)
    db = utils.fileStatsMenu3rdPass(db)
    db = utils.fileStatsMenu4thPass(db, win_width, setupOpts.indentDriftForIcon)
    db = utils.addMaps(db, win_width, "file")
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, db)
    vim.bo[buf].modifiable = false
end

function m.nvimDevStatsMenu(db, buf, win_width, nsID)
    local setupOpts = require("flex-stats").setupOpts
    db = vim.deepcopy(db)
    db = utils.fileStatsMenu1stPass(db, nsID, setupOpts.nameOverrides)
    table.sort(db, function(element1, element2)
        return (element1.totalTime > element2.totalTime)
    end)
    db = utils.fileStatsMenu2ndPass(db, win_width, setupOpts.indentDriftForIcon, setupOpts.gap)
    db = utils.fileStatsMenu3rdPass(db)
    db = utils.fileStatsMenu4thPass(db, win_width, setupOpts.indentDriftForIcon)
    db = utils.addMaps(db, win_width, "dev")
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, db)
    vim.bo[buf].modifiable = false
end

function m.endUI(winID, autocmdID)
    vim.api.nvim_win_close(winID, false)
    vim.api.nvim_del_autocmd(autocmdID)
end

function m.showUI(opts)
    opts = opts or {}
    opts.width = opts.width or 80
    opts.height = opts.height or 80
    opts.page = opts.page or "file"

    ---@type integer
    local win_width = math.floor(vim.o.columns / 100 * opts.width)
    ---@type integer
    local win_height = math.floor(vim.o.lines / 100 * opts.height)
    ---@type integer
    local bufID = vim.api.nvim_create_buf(false, true)
    local winID = vim.api.nvim_open_win(bufID, true, {
        relative = "editor",
        width = win_width,
        height = win_height,
        col = math.floor((vim.o.columns - win_width - 2) / 2),
        row = math.floor((vim.o.lines - win_height - 2) / 2),
        border = "rounded",
        style = "minimal",
    })
    vim.bo[bufID].filetype = "flexstats"
    ---@type flex.database
    local db = require("flex-stats").database
    db[""] = nil
    vim.api.nvim_win_set_hl_ns(winID, opts.nsID)
    local pages = {
        file = function()
            vim.schedule(function()
                m.fileStatsMenu(db.files, bufID, win_width, opts.nsID)
            end)
        end,
        dev = function()
            vim.schedule(function()
                m.nvimDevStatsMenu(db.nvim, bufID, win_width, opts.nsID)
            end)
        end,
    }
    pages[opts.page]()
    local autocmdID
    autocmdID = vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
            vim.schedule(function()
                m.showUI(opts)
            end)
            m.endUI(winID, autocmdID)
        end,
        group = "flex-stats.nvim",
        desc = "redraw the window",
    })
    vim.keymap.set("n", "<ESC>", function()
        m.endUI(winID, autocmdID)
    end, { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "q", function()
        m.endUI(winID, autocmdID)
    end, { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "f", function()
        opts.page = "file"
        pages[opts.page]()
    end, { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "d", function()
        opts.page = "dev"
        pages[opts.page]()
    end, { noremap = true, silent = true, buffer = true })
end

return m
