local timer = require("flex-stats.core.timer")
local database = require("flex-stats").database or {}
database.files = database.files or {}
local fileDatabase = database.files
local delete = require("flex-stats.core.lock").delete
local sharedValues = require("flex-stats").sharedValues

local function modeCheck()
    local currentMode = string.lower(vim.fn.mode())
    if string.find(currentMode, "i") or string.find(currentMode, "r") then
        timer.startEditTime(nil, fileDatabase)
    else
        timer.endEditTime(nil, fileDatabase)
        if string.find(currentMode, "n") or string.find(currentMode, "v") then
            timer.startMoveTime(nil, fileDatabase)
        else
            timer.endMoveTime(nil, fileDatabase)
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
            modeCheck()
        end,
        group = "flex-stats.nvim",
        desc = "starts the timer based on the mode",
    })

sharedValues.autocmd.BufLeaveID = sharedValues.autocmd.BufLeaveID
    or vim.api.nvim_create_autocmd("BufLeave", {
        callback = function()
            timer.endMoveTime(nil, fileDatabase)
            timer.endEditTime(nil, fileDatabase)
            timer.endIdleTime(nil, fileDatabase)
        end,
        group = "flex-stats.nvim",
        desc = "stops all timers",
    })

sharedValues.autocmd.ModeChangedID = sharedValues.autocmd.ModeChangedID
    or vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
            modeCheck()
        end,
        group = "flex-stats.nvim",
        desc = "starts the timer based on the mode",
    })

sharedValues.autocmd.CursorHoldI_ID = sharedValues.autocmd.CursorHoldI_ID
    or vim.api.nvim_create_autocmd("CursorHoldI", {
        callback = function()
            timer.endEditTime(nil, fileDatabase)
            timer.startIdleTime(nil, fileDatabase)
            ---@type [ number ]
            local id = {}
            id[1] = vim.api.nvim_create_autocmd("CursorMovedI", {
                callback = function()
                    timer.startEditTime(nil, fileDatabase)
                    timer.endIdleTime(nil, fileDatabase)
                    vim.api.nvim_del_autocmd(id[1])
                end,
            })
        end,
        group = "flex-stats.nvim",
        desc = "ends edit timer, starts idle timer",
    })

sharedValues.autocmd.CursorHold_ID = sharedValues.autocmd.CursorHold_ID
    or vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
            timer.endMoveTime(nil, fileDatabase)
            timer.startIdleTime(nil, fileDatabase)
            ---@type [ number ]
            local id = {}
            id[1] = vim.api.nvim_create_autocmd("CursorMoved", {
                callback = function()
                    timer.startMoveTime(nil, fileDatabase)
                    timer.endIdleTime(nil, fileDatabase)
                    vim.api.nvim_del_autocmd(id[1])
                end,
            })
        end,
        group = "flex-stats.nvim",
        desc = "ends move timer, starts idle timer",
    })

sharedValues.autocmd.VimLeavePreID = sharedValues.autocmd.VimLeavePreID
    or vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            require("flex-stats.core.db").writeDataBase(database)
            delete()
        end,
        group = "flex-stats.nvim",
        desc = "writes the database",
    })
