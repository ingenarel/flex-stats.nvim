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
local lock = require("flex-stats.core.lock")

function m.setup(opts)
    if not vim.uv.fs_stat(vim.fn.stdpath("data") .. "/flex-stats/LOCKFILE") then
        lock.create()
    else
        vim.notify(
            "LOCKFILE for flex-stats already exists\n"
                .. "If another neovim process is already running then it should not be deleted\n"
                .. "However if the previous nvim session crashed then the lockfile probably wasn't deleted properly\n"
                .. "Do you want to ignore the lockfile?",
            vim.log.ERROR
        )
        if string.lower(vim.fn.input("Enter y to ignore => ")) ~= "y" then
            return
        end
    end
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
