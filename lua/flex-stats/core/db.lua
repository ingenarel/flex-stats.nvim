---@type flex.core.db
local m = {}

local timer = require("flex-stats.core.timer")

function m.create()
    vim.fn.mkdir(vim.fn.stdpath("data") .. "/flex-stats", "p")
    local file = io.open(vim.fn.stdpath("data") .. "/flex-stats/db.json", "w")
    if file == nil then
        error("cannot create file")
    else
        file:close()
    end
end

function m.readDataBase()
    local file = io.open(vim.fn.stdpath("data") .. "/flex-stats/db.json", "r")
    local fileContent
    if file == nil then
        m.create()
        file = io.open(vim.fn.stdpath("data") .. "/flex-stats/db.json", "r")
    end
    if file ~= nil then
        fileContent = file:read("*a")
        file:close()
    end
    local success, functionOutput = pcall(vim.json.decode, fileContent)
    if success == false then
        fileContent = {}
    else
        fileContent = functionOutput
    end
    return fileContent
end

function m.writeDataBase(db)
    for lang, _ in pairs(db.files) do
        timer.endEditTime(lang, db.files)
        timer.endMoveTime(lang, db.files)
        timer.endIdleTime(lang, db.files)
    end
    local outputJson = vim.json.encode(db)
    if outputJson ~= false then
        local file = io.open(vim.fn.stdpath("data") .. "/flex-stats/db.json", "w")
        if file ~= nil then
            file:write(outputJson)
            file:close()
        end
    end
end

return m
