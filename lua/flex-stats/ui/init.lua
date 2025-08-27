local m = {}

local utils = require("flex-stats.ui.utils")

function m.statsMenu(db, buf, win_width)
    local lines = {}
    for lang, data in pairs(db) do
        local moving = data["moveTotalTime"] or 0

        local editing = data["editTotalTime"] or 0
        if moving > 0 and editing > 0 then
            table.insert(lines, (require("nvim-web-devicons").get_icon_by_filetype(lang) or "") .. " " .. lang)
            local total = moving + editing
            table.insert(lines, "total: " .. utils.time(total))
            table.insert(lines, "editing: " .. utils.time(editing))
            table.insert(lines, "moving around: " .. utils.time(moving))
            table.insert(lines, "")
        end
    end
    local maxWidth = 0
    for i = 1, #lines do
        if #lines[i] > maxWidth then
            maxWidth = #lines[i]
        end
    end
    for i = 1, #lines do
        lines[i] = utils.center(lines[i], maxWidth)
        -- lines[i] = utils.center(lines[i], win_width)
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
