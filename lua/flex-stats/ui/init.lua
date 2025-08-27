---@type flex.ui.init
local m = {}

local utils = require("flex-stats.ui.utils")

function m.statsMenu(db, buf, win_width)
    local lines = {}
    local fileData = {}
    db = vim.deepcopy(db)
    db.noice = nil
    db.TelescopePrompt = nil
    db.notify = nil
    db.lazy = nil
    db.flexstats = nil
    db.mason = nil
    db.metapack = nil
    for lang, data in pairs(db) do
        local moving = data["moveTotalTime"] or 0
        local editing = data["editTotalTime"] or 0
        local total = moving + editing
        if total > 0 then
            table.insert(fileData, {})
            table.insert(
                fileData[#fileData],
                (require("nvim-web-devicons").get_icon_by_filetype(lang) or "") .. " " .. lang
            )
            table.insert(fileData[#fileData], "total: " .. utils.time(total))
            table.insert(fileData[#fileData], "editing: " .. utils.time(editing))
            table.insert(fileData[#fileData], "moving around: " .. utils.time(moving))
            table.insert(fileData[#fileData], "")
            fileData[#fileData].totalTime = total
        end
    end
    table.sort(fileData, function(element1, element2)
        return (element1.totalTime > element2.totalTime)
    end)
    for i = 1, #fileData do
        local maxWidth = 0
        for j = 1, #fileData[i] do
            if #fileData[i][j] > maxWidth then
                maxWidth = #fileData[i][j]
            end
        end
        table.insert(lines, utils.center(fileData[i][1], maxWidth + 2))
        for j = 2, #fileData[i] do
            table.insert(lines, utils.center(fileData[i][j], maxWidth))
        end
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
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
    m.statsMenu(db, bufID, win_width)
end

return m
