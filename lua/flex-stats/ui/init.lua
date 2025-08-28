---@type flex.ui.init
local m = {}

local utils = require("flex-stats.ui.utils")

local function statsMenufirstPass(db)
    local fp = {}
    for lang, data in pairs(db) do
        local moving = data["moveTotalTime"] or 0
        local editing = data["editTotalTime"] or 0
        local total = moving + editing
        if total > 0 then
            table.insert(fp, {})
            table.insert(fp[#fp], (require("nvim-web-devicons").get_icon_by_filetype(lang) or "") .. " " .. lang)
            table.insert(fp[#fp], "total: " .. utils.time(total))
            if editing > 0 then
                table.insert(fp[#fp], "editing: " .. utils.time(editing))
            end
            if moving > 0 then
                table.insert(fp[#fp], "moving: " .. utils.time(moving))
            end
            for _ = #fp[#fp], 4 do
                table.insert(fp[#fp], "")
            end
            fp[#fp].totalTime = total
        end
    end
    return fp
end

local function statsMenuSecondPass(db, win_width, opts)
    local sp = {}
    local i = 1
    while i <= #db do
        local maxWidth = 0
        for j = 1, #db[i] do
            if #db[i][j] > maxWidth then
                maxWidth = #db[i][j]
            end
        end
        table.insert(sp, {})
        table.insert(sp[#sp], {})
        table.insert(sp[#sp][#sp[#sp]], utils.center(db[i][1], maxWidth + opts.indentDriftForIcon))
        for j = 2, #db[i] do
            table.insert(sp[#sp][#sp[#sp]], utils.center(db[i][j], maxWidth))
        end
        while i + 1 <= #db do
            local tmp = i + 1
            local nextMaxWidth = 0
            for nextMaxWidthLoopJ = 1, #db[tmp] do
                if #db[tmp][nextMaxWidthLoopJ] > nextMaxWidth then
                    nextMaxWidth = #db[tmp][nextMaxWidthLoopJ]
                end
            end
            local secondPassLastConcatantedLen = 0
            for secondPassLastConcatantedLenLoopJ = 1, #sp[#sp] do
                secondPassLastConcatantedLen = secondPassLastConcatantedLen
                    + #sp[#sp][secondPassLastConcatantedLenLoopJ][1]
                    + opts.gap
            end
            if secondPassLastConcatantedLen + nextMaxWidth < win_width then
                i = tmp
                table.insert(sp[#sp], {})
                table.insert(sp[#sp][#sp[#sp]], utils.center(db[i][1], nextMaxWidth + opts.indentDriftForIcon))
                for line = 2, #db[i] do
                    table.insert(sp[#sp][#sp[#sp]], utils.center(db[i][line], nextMaxWidth))
                end
            else
                break
            end
            i = i + 1
        end
        i = i + 1
    end
    return sp
end

local function statsMenuThirdPass(db, opts)
    local lines = {}
    for x = 1, #db do
        local tempLineNum = 1
        ---@diagnostic disable-next-line: unused-local
        for y = 1, #db[x][1] do
            local line = ""
            for z = 1, #db[x] do
                line = line .. string.rep(" ", opts.gap) .. (db[x][z][tempLineNum] or "")
            end
            table.insert(lines, line)
            tempLineNum = tempLineNum + 1
        end
    end
    return lines
end

function m.statsMenu(db, buf, win_width, opts)
    opts = opts or {}
    opts.indentDriftForIcon = opts.indentDriftForIcon or 2
    opts.gap = opts.gap or 5
    db = vim.deepcopy(db)
    db.noice = nil
    db.TelescopePrompt = nil
    db.notify = nil
    db.lazy = nil
    db.flexstats = nil
    db.mason = nil
    db.metapack = nil
    db.checkhealth = nil
    db = statsMenufirstPass(db)
    table.sort(db, function(element1, element2)
        return (element1.totalTime > element2.totalTime)
    end)
    db = statsMenuSecondPass(db, win_width, opts)
    db = statsMenuThirdPass(db, opts)
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
    m.statsMenu(db, bufID, win_width)
end

return m
