---@type flex.ui.utils
local m = {}
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

function m.statsMenu1stPass(db)
    local fp = {}
    for lang, data in pairs(db) do
        local moving = data["moveTotalTime"] or 0
        local editing = data["editTotalTime"] or 0
        local total = moving + editing
        if total > 0 then
            table.insert(fp, {})
            table.insert(fp[#fp], (require("nvim-web-devicons").get_icon_by_filetype(lang) or "") .. " " .. lang)
            table.insert(fp[#fp], "total: " .. m.time(total))
            if editing > 0 then
                table.insert(fp[#fp], "editing: " .. m.time(editing))
            end
            if moving > 0 then
                table.insert(fp[#fp], "moving: " .. m.time(moving))
            end
            for _ = #fp[#fp], 5 do
                table.insert(fp[#fp], "")
            end
            fp[#fp].totalTime = total
        end
    end
    return fp
end

function m.statsMenu2ndPass(db, win_width, opts)
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
        table.insert(sp[#sp][#sp[#sp]], m.center(db[i][1], maxWidth + opts.indentDriftForIcon))
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
                    + opts.gap
            end
            if secondPassLastConcatantedLen + nextMaxWidth < win_width then
                i = tmp
                table.insert(sp[#sp], {})
                table.insert(sp[#sp][#sp[#sp]], m.center(db[i][1], nextMaxWidth + opts.indentDriftForIcon))
                for line = 2, #db[i] do
                    table.insert(sp[#sp][#sp[#sp]], m.center(db[i][line], nextMaxWidth))
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

function m.statsMenu3rdPass(db)
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

function m.statsMenu4thPass(db, win_width, opts)
    local lines = {}
    for x = 1, #db do
        for y = 1, #db[x] do
            local gap = 0
            local z = 1
            while z <= #db[x][y] do
                gap = gap + #db[x][y][z]
                z = z + 1
            end
            if y == 1 then
                gap = gap - opts.indentDriftForIcon * (z - 1)
            end
            gap = math.floor((win_width - gap) / z + 1)
            local line = ""
            ---@diagnostic disable-next-line: redefined-local
            for z = 1, #db[x][y] do
                line = line .. string.rep(" ", gap) .. db[x][y][z]
                z = z + 1
            end
            table.insert(lines, line)
        end
    end
    return lines
end

return m
