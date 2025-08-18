local timer = require("flex-stats.core.timer")
local database = require("flex-stats").database
vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
        local currentMode = string.lower(vim.fn.mode())
        if string.find(currentMode, "i") or string.find(currentMode, "r") then
            timer.startEditTime(nil, database)
        else
            timer.endEditTime(nil, database)
            if string.find(currentMode, "n") or string.find(currentMode, "v") then
                timer.startMoveTime(nil, database)
            else
                timer.endMoveTime(nil, database)
            end
        end
    end,
})

vim.api.nvim_create_autocmd("CursorHoldI", {
    callback = function()
        timer.endEditTime(nil, database)
        local id = {}
        id[1] = vim.api.nvim_create_autocmd("CursorMovedI", {
            callback = function()
                timer.startEditTime(nil, database)
                vim.api.nvim_del_autocmd(id[1])
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        timer.endMoveTime(nil, database)
        local id = {}
        id[1] = vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                timer.startMoveTime(nil, database)
                vim.api.nvim_del_autocmd(id[1])
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        require("flex-stats.core.db").writeDataBase(database)
    end,
})
