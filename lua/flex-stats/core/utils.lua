---@type flex.utils
local m = {}

function m.migrate(oldName, newName)
    local database = require("flex-stats").database
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
