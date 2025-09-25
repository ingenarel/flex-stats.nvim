local timer = require("flex-stats.core.timer")
local database = require("flex-stats").database or {}
database.files = database.files or {}
database.dev = database.dev or {}
database.git = database.git or {}
database.dev.configStats = database.dev.configStats or {}
database.dev.pluginStats = database.dev.pluginStats or {}
database.nvim = database.nvim or {}
database.nvim.cmdTotalTime = database.nvim.cmdTotalTime or 0
local delete = require("flex-stats.core.lock").delete
local write = require("flex-stats.core.db").writeDataBase
local sharedValues = require("flex-stats").sharedValues
local setupOpts = require("flex-stats").setupOpts
local utils = require("flex-stats.core.utils")

---@param filetype flex.filetype?
---@param db timerInput
local function modeCheck(filetype, db)
    local currentMode = string.lower(vim.fn.mode())
    if string.find(currentMode, "i") or string.find(currentMode, "r") then
        timer.startEditTime(filetype, db)
    else
        timer.endEditTime(filetype, db)
        if string.find(currentMode, "n") or string.find(currentMode, "v") then
            timer.startMoveTime(filetype, db)
        else
            timer.endMoveTime(filetype, db)
        end
    end
end

---@param func function
---@param file string
local function configCheck(func, file)
    if string.find(file, sharedValues.config, 1, true) then
        func()
    end
end

---@param file string
local function pluginCheck(func, file)
    if not (string.find(file, sharedValues.data, 1, true) and string.find(file, vim.env.VIMRUNTIME, 1, true)) then
        for i = 1, #setupOpts.pluginRegexes do
            if string.find(file, setupOpts.pluginRegexes[i]) then
                func()
                return
            end
        end
    end
end

local function gitCheck(file)
    if file and file ~= "" then
        utils.setFileValues(file, sharedValues.fileValues)
        if sharedValues.fileValues[file] then
            return sharedValues.fileValues[file][1]
        end
    end
end

sharedValues.autocmd.groupID = sharedValues.autocmd.groupID
    or vim.api.nvim_create_augroup("flex-stats.nvim", {
        clear = false,
    })

sharedValues.autocmd.BufEnterID = sharedValues.autocmd.BufEnterID
    or vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            modeCheck(nil, database.files)
            local file = vim.fn.expand("%:p")
            configCheck(function()
                modeCheck("configStats", database.dev)
            end, file)
            pluginCheck(function()
                modeCheck("pluginStats", database.dev)
            end, file)
            local repo = gitCheck(file)
            if repo then
                modeCheck(repo, database.git)
            end
        end,
        group = "flex-stats.nvim",
        desc = "starts the timer based on the mode",
    })

sharedValues.autocmd.BufLeaveID = sharedValues.autocmd.BufLeaveID
    or vim.api.nvim_create_autocmd("BufLeave", {
        callback = function()
            timer.endMoveTime(nil, database.files)
            timer.endEditTime(nil, database.files)
            timer.endIdleTime(nil, database.files)
            local file = vim.fn.expand("%:p")
            configCheck(function()
                timer.endMoveTime("configStats", database.dev)
                timer.endEditTime("configStats", database.dev)
                timer.endIdleTime("configStats", database.dev)
            end, file)
            pluginCheck(function()
                timer.endMoveTime("pluginStats", database.dev)
                timer.endEditTime("pluginStats", database.dev)
                timer.endIdleTime("pluginStats", database.dev)
            end, file)
            local repo = gitCheck(file)
            if repo then
                timer.endMoveTime(repo, database.git)
                timer.endEditTime(repo, database.git)
                timer.endIdleTime(repo, database.git)
            end
        end,
        group = "flex-stats.nvim",
        desc = "stops all timers",
    })

sharedValues.autocmd.ModeChangedID = sharedValues.autocmd.ModeChangedID
    or vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
            modeCheck(nil, database.files)
            local file = vim.fn.expand("%:p")
            configCheck(function()
                modeCheck("configStats", database.dev)
            end, file)
            pluginCheck(function()
                modeCheck("pluginStats", database.dev)
            end, file)
            local repo = gitCheck(file)
            if repo then
                modeCheck(repo, database.git)
            end
        end,
        group = "flex-stats.nvim",
        desc = "starts the timer based on the mode",
    })

sharedValues.autocmd.CursorHoldI_ID = sharedValues.autocmd.CursorHoldI_ID
    or vim.api.nvim_create_autocmd("CursorHoldI", {
        callback = function()
            timer.endEditTime(nil, database.files)
            timer.startIdleTime(nil, database.files)
            local file = vim.fn.expand("%:p")
            configCheck(function()
                timer.endEditTime("configStats", database.dev)
                timer.startIdleTime("configStats", database.dev)
            end, file)
            pluginCheck(function()
                timer.endEditTime("pluginStats", database.dev)
                timer.startIdleTime("pluginStats", database.dev)
            end, file)
            local repo = gitCheck(file)
            if repo then
                timer.endEditTime(repo, database.git)
                timer.startIdleTime(repo, database.git)
            end
            sharedValues.autocmd.CursorMovedI_ID = sharedValues.autocmd.CursorMovedI_ID
                or vim.api.nvim_create_autocmd("CursorMovedI", {
                    callback = function()
                        timer.startEditTime(nil, database.files)
                        timer.endIdleTime(nil, database.files)
                        configCheck(function()
                            timer.startEditTime("configStats", database.dev)
                            timer.endIdleTime("configStats", database.dev)
                        end, file)
                        pluginCheck(function()
                            timer.startEditTime("pluginStats", database.dev)
                            timer.endIdleTime("pluginStats", database.dev)
                        end, file)
                        if repo then
                            timer.startEditTime(repo, database.git)
                            timer.endIdleTime(repo, database.git)
                        end
                        vim.api.nvim_del_autocmd(sharedValues.autocmd.CursorMovedI_ID)
                        sharedValues.autocmd.CursorMovedI_ID = nil
                    end,
                    group = "flex-stats.nvim",
                    desc = "ends idle timer, starts edit timer",
                })
        end,
        group = "flex-stats.nvim",
        desc = "ends edit timer, starts idle timer",
    })

sharedValues.autocmd.CursorHold_ID = sharedValues.autocmd.CursorHold_ID
    or vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
            timer.endMoveTime(nil, database.files)
            timer.startIdleTime(nil, database.files)
            local file = vim.fn.expand("%:p")
            configCheck(function()
                timer.endMoveTime("configStats", database.dev)
                timer.startIdleTime("configStats", database.dev)
            end, file)
            pluginCheck(function()
                timer.endMoveTime("pluginStats", database.dev)
                timer.startIdleTime("pluginStats", database.dev)
            end, file)
            local repo = gitCheck(file)
            if repo then
                timer.endMoveTime(repo, database.git)
                timer.startIdleTime(repo, database.git)
            end
            sharedValues.autocmd.CursorMoved_ID = sharedValues.autocmd.CursorMoved_ID
                or vim.api.nvim_create_autocmd("CursorMoved", {
                    callback = function()
                        timer.startMoveTime(nil, database.files)
                        timer.endIdleTime(nil, database.files)
                        configCheck(function()
                            timer.startMoveTime("configStats", database.dev)
                            timer.endIdleTime("configStats", database.dev)
                        end, file)
                        pluginCheck(function()
                            timer.startMoveTime("pluginStats", database.dev)
                            timer.endIdleTime("pluginStats", database.dev)
                        end, file)
                        if repo then
                            timer.startMoveTime(repo, database.git)
                            timer.endIdleTime(repo, database.git)
                        end
                        vim.api.nvim_del_autocmd(sharedValues.autocmd.CursorMoved_ID)
                        sharedValues.autocmd.CursorMoved_ID = nil
                    end,
                    group = "flex-stats.nvim",
                    desc = "ends idle timer, starts move timer",
                })
        end,
        group = "flex-stats.nvim",
        desc = "ends move timer, starts idle timer",
    })

sharedValues.autocmd.VimLeavePreID = sharedValues.autocmd.VimLeavePreID
    or vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            write(database)
            delete()
        end,
        group = "flex-stats.nvim",
        desc = "writes the database",
    })

sharedValues.autocmd.CmdlineEnterID = sharedValues.autocmd.CmdlineEnterID
    or vim.api.nvim_create_autocmd("CmdlineEnter", {
        callback = function()
            database.nvim.lastCmdEnter = os.time()
        end,
        group = "flex-stats.nvim",
        desc = "starts cmdline timer",
    })

sharedValues.autocmd.CmdlineLeaveID = sharedValues.autocmd.CmdlineLeaveID
    or vim.api.nvim_create_autocmd("CmdlineLeave", {
        callback = function()
            database.nvim.cmdTotalTime = database.nvim.cmdTotalTime + os.time() - database.nvim.lastCmdEnter
            database.nvim.lastCmdEnter = nil
        end,
        group = "flex-stats.nvim",
        desc = "ends cmdline timer",
    })

sharedValues.timer = sharedValues.timer or vim.uv.new_timer()
_ = sharedValues.timer:is_active()
    or sharedValues.timer:start(setupOpts.saveInterval, setupOpts.saveInterval, function()
        write(database)
        vim.schedule(function()
            modeCheck(nil, database.files)
            local file = vim.fn.expand("%:p")
            configCheck(function()
                modeCheck("configStats", database.dev)
            end, file)
            pluginCheck(function()
                modeCheck("pluginStats", database.dev)
            end, file)
            local repo = gitCheck(file)
            if repo then
                modeCheck(repo, database.git)
            end
        end)
    end)
