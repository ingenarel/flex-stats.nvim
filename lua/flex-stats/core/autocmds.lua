local timer = require("flex-stats.core.timer")
local database = require("flex-stats").database or {}
database.files = database.files or {}
database.nvim = database.nvim or {}
database.nvim.configStats = database.nvim.configStats or {}
local delete = require("flex-stats.core.lock").delete
local write = require("flex-stats.core.db").writeDataBase
local sharedValues = require("flex-stats").sharedValues
local setupOpts = require("flex-stats").setupOpts

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

local function configCheck(func)
    ---@diagnostic disable-next-line: param-type-mismatch
    if string.find(vim.fn.expand("%:p"), vim.uv.fs_realpath(vim.fn.stdpath("config"))) then
        func()
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
            configCheck(function()
                modeCheck("configStats", database.nvim)
            end)
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
            configCheck(function()
                timer.endMoveTime("configStats", database.nvim)
                timer.endEditTime("configStats", database.nvim)
                timer.endIdleTime("configStats", database.nvim)
            end)
        end,
        group = "flex-stats.nvim",
        desc = "stops all timers",
    })

sharedValues.autocmd.ModeChangedID = sharedValues.autocmd.ModeChangedID
    or vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
            modeCheck(nil, database.files)
            configCheck(function()
                modeCheck("configStats", database.nvim)
            end)
        end,
        group = "flex-stats.nvim",
        desc = "starts the timer based on the mode",
    })

sharedValues.autocmd.CursorHoldI_ID = sharedValues.autocmd.CursorHoldI_ID
    or vim.api.nvim_create_autocmd("CursorHoldI", {
        callback = function()
            timer.endEditTime(nil, database.files)
            timer.startIdleTime(nil, database.files)
            configCheck(function()
                timer.endEditTime("configStats", database.nvim)
                timer.startIdleTime("configStats", database.nvim)
            end)
            sharedValues.autocmd.CursorMovedI_ID = sharedValues.autocmd.CursorMovedI_ID
                or vim.api.nvim_create_autocmd("CursorMovedI", {
                    callback = function()
                        timer.startEditTime(nil, database.files)
                        timer.endIdleTime(nil, database.files)
                        configCheck(function()
                            timer.startEditTime("configStats", database.nvim)
                            timer.endIdleTime("configStats", database.nvim)
                        end)
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
            configCheck(function()
                timer.endMoveTime("configStats", database.nvim)
                timer.startIdleTime("configStats", database.nvim)
            end)
            sharedValues.autocmd.CursorMoved_ID = sharedValues.autocmd.CursorMoved_ID
                or vim.api.nvim_create_autocmd("CursorMoved", {
                    callback = function()
                        timer.startMoveTime(nil, database.files)
                        timer.endIdleTime(nil, database.files)
                        configCheck(function()
                            timer.startMoveTime("configStats", database.nvim)
                            timer.endIdleTime("configStats", database.nvim)
                        end)
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

sharedValues.timer = sharedValues.timer or vim.uv.new_timer()
_ = sharedValues.timer:is_active()
    or sharedValues.timer:start(setupOpts.saveInterval, setupOpts.saveInterval, function()
        write(database)
        vim.schedule(function()
            modeCheck(nil, database.files)
            configCheck(function()
                modeCheck("configStats", database.nvim)
            end)
        end)
    end)
