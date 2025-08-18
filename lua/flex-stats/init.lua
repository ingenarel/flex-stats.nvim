local m = {}

local db = require("flex-stats.core.db")

function m.setup()
    m.database = db.readDataBase()
    require("flex-stats.core.autocmds")
end

function m.showStats()
    db.writeDataBase(m.database)
    vim.print(m.database)
end

return m
