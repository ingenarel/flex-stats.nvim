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
            "typr",
        },
        indentDriftForIcon = 2,
        gap = 5,
        fileStatsGradientMax = 360000,
    },
}

local db = require("flex-stats.core.db")

function m.setup(opts)
    opts = vim.tbl_deep_extend("force", m.setupOpts, opts)
    m.setupOpts = opts
    m.database = db.readDataBase()
    opts.nsID = opts.nsID or vim.api.nvim_create_namespace("FlexStats")
    require("flex-stats.core.autocmds")
    vim.api.nvim_create_user_command("Flex", function()
        m.showStats()
    end, {})
end

function m.showStats()
    db.writeDataBase(m.database)
    require("flex-stats.ui").showUI { nsID = m.setupOpts.nsID }
end

return m
