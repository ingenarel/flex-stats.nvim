local m = {}

function m.migrate(database, oldName, newName)
    for lang, _ in pairs(database) do
        local oldNameType = type(database[lang][oldName])
        if oldNameType == "number" then
            if type(database[lang][newName]) ~= "number" then
                database[lang][newName] = 0
            end
            database[lang][newName] = database[lang][newName] + database[lang][oldName]
        elseif oldNameType == "table" then
            if type(database[lang][newName]) ~= "table" then
                database[lang][newName] = {}
            end
            database[lang][newName] = database[lang][newName] + database[lang][oldName]
        end
        database[lang][oldName] = nil
    end
end

return m
