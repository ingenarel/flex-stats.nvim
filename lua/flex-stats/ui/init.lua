---@type flex.ui.init
local m = {}

local utils = require("flex-stats.ui.utils")

function m.statsMenu(db, buf, win_width, opts)
    opts = opts or {}
    opts.indentDriftForIcon = opts.indentDriftForIcon or 2
    opts.gap = opts.gap or 5
    local lines = {}
    local firstPass = {}
    local secondPass = {}
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
            table.insert(firstPass, {})
            table.insert(
                firstPass[#firstPass],
                (require("nvim-web-devicons").get_icon_by_filetype(lang) or "") .. " " .. lang
            )
            table.insert(firstPass[#firstPass], "total: " .. utils.time(total))
            if editing > 0 then
                table.insert(firstPass[#firstPass], "editing: " .. utils.time(editing))
            end
            if moving > 0 then
                table.insert(firstPass[#firstPass], "moving: " .. utils.time(moving))
            end
            for _ = #firstPass[#firstPass], 4 do
                table.insert(firstPass[#firstPass], "")
            end
            firstPass[#firstPass].totalTime = total
        end
    end
    table.sort(firstPass, function(element1, element2)
        return (element1.totalTime > element2.totalTime)
    end)
    local i = 1
    while i <= #firstPass do
        local maxWidth = 0
        for j = 1, #firstPass[i] do
            if #firstPass[i][j] > maxWidth then
                maxWidth = #firstPass[i][j]
            end
        end
        table.insert(secondPass, {})
        table.insert(secondPass[#secondPass], {})
        table.insert(
            secondPass[#secondPass][#secondPass[#secondPass]],
            utils.center(firstPass[i][1], maxWidth + opts.indentDriftForIcon)
        )
        for j = 2, #firstPass[i] do
            table.insert(secondPass[#secondPass][#secondPass[#secondPass]], utils.center(firstPass[i][j], maxWidth))
        end
        while i + 1 <= #firstPass do
            local tmp = i + 1
            local nextMaxWidth = 0
            for j = 1, #firstPass[tmp] do
                if #firstPass[tmp][j] > nextMaxWidth then
                    nextMaxWidth = #firstPass[tmp][j]
                end
            end
            local secondPassLastConcatantedLen = 0
            for p = 1, #secondPass[#secondPass] do
                secondPassLastConcatantedLen = secondPassLastConcatantedLen + #secondPass[#secondPass][p][1] + opts.gap
            end
            if secondPassLastConcatantedLen + nextMaxWidth < win_width then
                i = tmp
                table.insert(secondPass[#secondPass], {})
                table.insert(
                    secondPass[#secondPass][#secondPass[#secondPass]],
                    utils.center(firstPass[i][1], nextMaxWidth + opts.indentDriftForIcon)
                )
                for line = 2, #firstPass[i] do
                    table.insert(
                        secondPass[#secondPass][#secondPass[#secondPass]],
                        utils.center(firstPass[i][line], nextMaxWidth)
                    )
                end
                i = i + 1
            else
                break
            end
        end
    end
    firstPass = nil
    for x = 1, #secondPass do
        local tempLineNum = 1
        ---@diagnostic disable-next-line: unused-local
        for y = 1, #secondPass[x][1] do
            local line = ""
            for z = 1, #secondPass[x] do
                line = line .. string.rep(" ", opts.gap) .. (secondPass[x][z][tempLineNum] or "")
            end
            table.insert(lines, line)
            tempLineNum = tempLineNum + 1
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
