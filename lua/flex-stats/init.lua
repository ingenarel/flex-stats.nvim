---@type flex.init
local m = {
    setupOpts = {
        noShow = {
            "noice",
            "TelescopePrompt",
            "notify",
            "lazy",
            "flexstats",
            "mason",
            "metapack",
            "checkhealth",
        },
    },
}

local db = require("flex-stats.core.db")

function m.setup(opts)
    opts = vim.tbl_deep_extend("force", m.setupOpts, opts)
    m.setupOpts = opts
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
