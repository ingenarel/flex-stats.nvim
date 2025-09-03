---@type flex.core.migrate
local m = {}

function m.popTableKey(keys, tbl)
    keys = vim.deepcopy(keys)
    if type(keys) == "table" then
        if #keys > 1 then
            tbl = tbl[keys[1]]
            table.remove(keys, 1)
            return m.popTableKey(keys, tbl)
        elseif #keys == 1 then
            local returnTable = vim.deepcopy(tbl[keys[1]])
            tbl[keys[1]] = nil
            return returnTable
        end
    elseif keys == nil then
        local returnTable = vim.deepcopy(tbl)
        for i = 1, #tbl do
            tbl[i] = nil
        end
        for key, _ in pairs(tbl) do
            tbl[key] = nil
        end
        return returnTable
    end
end

function m.createRecursiveTableKeys(keys, tbl)
    keys = vim.deepcopy(keys)
    if #keys > 0 then
        local key = keys[1]
        if type(tbl[key]) ~= "table" then
            tbl[key] = {}
        end
        table.remove(keys, 1)
        if #keys > 0 then
            local secondKey = keys[1]
            table.remove(keys, 1)
            if type(tbl[key][secondKey]) ~= "table" then
                tbl[key][secondKey] = {}
            end
            m.createRecursiveTableKeys(keys, tbl[key][secondKey])
        end
    end
end

function m.keys(oldName, newName, database)
    database = database or require("flex-stats").database
    for lang, _ in pairs(database) do
        local oldNameType = type(database[lang][oldName])
        if oldNameType == "nil" then
            goto continue
        elseif oldNameType == "number" then
            if type(database[lang][newName]) ~= "number" then
                database[lang][newName] = 0
            end
            database[lang][newName] = database[lang][newName] + database[lang][oldName]
        elseif oldNameType == "table" then
            if type(database[lang][newName]) ~= "table" then
                database[lang][newName] = {}
            end
            vim.tbl_deep_extend("force", database[lang][newName], database[lang][oldName])
        end
        database[lang][oldName] = nil
        ::continue::
    end
end

return m
