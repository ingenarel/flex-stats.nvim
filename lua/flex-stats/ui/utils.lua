---@type flex.ui.utils
local m = {}

function m.getColor(steps, input)
    if steps / input > 2 then
        return bit.tohex(256 / ((steps / 2) / input), 2) .. "ff00"
    elseif steps / input == 2 then
        return "ffff00"
    else
        return "ff" .. bit.tohex(256 - (256 / ((steps / 2) / input)), 2) .. "00"
    end
end

function m.time(seconds)
    local minutes = 0
    local hours = 0
    local returnString = ""
    if seconds >= 60 then
        local tmp = seconds % 60
        minutes = (seconds - tmp) / 60
        seconds = tmp
    end
    if minutes >= 60 then
        local tmp = minutes % 60
        hours = (minutes - tmp) / 60
        minutes = tmp
    end
    if seconds > 0 then
        returnString = returnString .. seconds .. " seconds"
    end
    if minutes > 0 then
        returnString = minutes .. " minutes " .. returnString
    end
    if hours > 0 then
        returnString = hours .. " hours " .. returnString
    end
    return returnString
end

function m.center(input, width, char)
    char = char or " "
    local indent = string.rep(char, math.floor((width - #input) / 2))
    return indent .. input .. string.rep(char, width - #indent - #input)
end

function m.colorString(regex, hexColor, nsID)
    vim.api.nvim_set_hl(nsID, hexColor, { fg = "#" .. hexColor })
    vim.fn.matchadd(hexColor, regex)
end

function m.fileStatsMenu1stPass(db, nsID)
    local setupOpts = require("flex-stats").setupOpts
    local fp = {}
    for lang, data in pairs(db) do
        local moving = data["moveTotalTime"] or 0
        local editing = data["editTotalTime"] or 0
        local writing = moving + editing
        if writing > 0 then
            table.insert(fp, {})
            local fileName, color = require("nvim-web-devicons").get_icon_color_by_filetype(lang)
            if not fileName then
                fileName = ""
                color = "#939393"
            end

            local fileNameString = fileName .. " " .. lang
            table.insert(fp[#fp], fileNameString)
            color = string.gsub(color, "#", "")
            vim.api.nvim_set_hl(nsID, color, { fg = "#" .. color, underline = true })
            vim.fn.matchadd(color, fileNameString)

            local writingString = "Writing: " .. m.time(writing)
            table.insert(fp[#fp], writingString)
            m.colorString(writingString, m.getColor(setupOpts.fileStatsGradientMax, writing), nsID)

            if editing > 0 then
                local editString = "Editing: " .. m.time(editing)
                table.insert(fp[#fp], editString)
                m.colorString(editString, m.getColor(setupOpts.fileStatsGradientMax, editing), nsID)
            end
            if moving > 0 then
                local moveString = "Moving: " .. m.time(moving)
                table.insert(fp[#fp], moveString)
                m.colorString(moveString, m.getColor(setupOpts.fileStatsGradientMax, moving), nsID)
            end
            for _ = #fp[#fp], 5 do
                table.insert(fp[#fp], "")
            end
            fp[#fp].writingTime = writing
        end
    end
    return fp
end

function m.fileStatsMenu2ndPass(db, win_width, indentDriftForIcon, gap)
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
        table.insert(sp[#sp][#sp[#sp]], m.center(db[i][1], maxWidth + indentDriftForIcon))
        for j = 2, #db[i] do
            table.insert(sp[#sp][#sp[#sp]], m.center(db[i][j], maxWidth))
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
                    + gap
            end
            if secondPassLastConcatantedLen + nextMaxWidth < win_width then
                i = tmp
                table.insert(sp[#sp], {})
                table.insert(sp[#sp][#sp[#sp]], m.center(db[i][1], nextMaxWidth + indentDriftForIcon))
                for line = 2, #db[i] do
                    table.insert(sp[#sp][#sp[#sp]], m.center(db[i][line], nextMaxWidth))
                end
            else
                break
            end
        end
        i = i + 1
    end
    return sp
end

function m.fileStatsMenu3rdPass(db)
    local lines = {}
    for x = 1, #db do
        local tempLineNum = 1
        table.insert(lines, {})
        ---@diagnostic disable-next-line: unused-local
        for y = 1, #db[x][1] do
            table.insert(lines[#lines], {})
            for z = 1, #db[x] do
                table.insert(lines[#lines][#lines[#lines]], db[x][z][tempLineNum])
            end
            tempLineNum = tempLineNum + 1
        end
    end
    return lines
end

function m.fileStatsMenu4thPass(db, win_width, indentDriftForIcon)
    local lines = {}
    for x = 1, #db do
        for y = 1, #db[x] do
            local len = 0
            local z = 1
            while z <= #db[x][y] do
                len = len + #db[x][y][z]
                z = z + 1
            end
            if y == 1 then
                len = len - indentDriftForIcon * (z - 1)
            end
            local gap = math.floor((win_width - len) / (z - 2))
            local line = db[x][y][1] .. string.rep(" ", gap)
            z = 2
            while z < #db[x][y] do
                line = line .. db[x][y][z] .. string.rep(" ", gap)
                z = z + 1
            end
            line = line .. (db[x][y][z] or "")
            table.insert(lines, line)
        end
    end
    return lines
end

return m
