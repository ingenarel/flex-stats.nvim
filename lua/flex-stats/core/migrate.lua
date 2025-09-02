---@type flex.core.migrate
local m = {}

function m.createRecursiveTableKeys(keys, tbl)
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
