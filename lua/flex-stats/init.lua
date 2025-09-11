local actualConfig = vim.fn.stdpath("config")
actualConfig = vim.uv.fs_realpath(actualConfig) or actualConfig
local actualData = vim.fn.stdpath("data")
actualData = vim.uv.fs_realpath(actualData) or actualData
---@type flex.init
local m = {
    setupOpts = {
        noShow = {
            "checkhealth",
            "dap-repl",
            "dapui_breakpoints",
            "dapui_console",
            "dapui_scopes",
            "dapui_stacks",
            "dapui_watches",
            "dashboard",
            "flexstats",
            "lazy",
            "mason",
            "metapack",
            "netrw",
            "noice",
            "notify",
            "qf",
            "TelescopePrompt",
            "TelescopeResults",
            "typr",
            "typrstats",
        },
        pluginRegexes = {
            "[%-.]nvim/",
            "/nvim[%-.]",
        },
        nameOverrides = {
            {
                oldFileName = "configStats",
                newFileName = "Config",
                icon = "",
                iconColor = "#00CF00",
                nameColor = "#ff0000",
            },
            {
                oldFileName = "pluginStats",
                newFileName = "Plugin",
                icon = "",
                iconColor = "#00CF00",
                nameColor = "#ff0000",
            },
        },
        indentDriftForIcon = 2,
        gap = 5,
        fileStatsGradientMax = 360000,
        saveInterval = 600000,
    },
    sharedValues = {
        autocmd = {},
        config = actualConfig,
        data = actualData,
        fileValues = {},
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
    vim.api.nvim_set_hl(0, "FlexStatsMenuItem", { link = "Pmenu", default = true })
    vim.api.nvim_set_hl(0, "FlexStatsCurrentMenu", { link = "PmenuSel", default = true })
end

function m.showStats()
    db.writeDataBase(m.database)
    require("flex-stats.ui").showUI { nsID = m.setupOpts.nsID }
end

return m
