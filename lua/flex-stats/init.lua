---@type flex.init
local m = {}

local db = require("flex-stats.core.db")

function m.setup()
    m.database = db.readDataBase()
    require("flex-stats.core.autocmds")
    vim.api.nvim_create_user_command("Flex", function()
        m.showStats()
    end, {})
end

function m.showStats()
    db.writeDataBase(m.database)
    require("flex-stats.ui").showUI()
end

return m
