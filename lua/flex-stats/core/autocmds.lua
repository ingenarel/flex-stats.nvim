local timer = require("flex-stats.core.timer")
local database = require("flex-stats").database
database.files = database.files or {}
local fileDatabase = database.files
local delete = require("flex-stats.core.lock").delete

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

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        modeCheck()
    end,
})

vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        timer.endMoveTime(nil, fileDatabase)
        timer.endEditTime(nil, fileDatabase)
    end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
        modeCheck()
    end,
})

vim.api.nvim_create_autocmd("CursorHoldI", {
    callback = function()
        timer.endEditTime(nil, fileDatabase)
        ---@type [ number ]
        local id = {}
        id[1] = vim.api.nvim_create_autocmd("CursorMovedI", {
            callback = function()
                timer.startEditTime(nil, fileDatabase)
                vim.api.nvim_del_autocmd(id[1])
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        timer.endMoveTime(nil, fileDatabase)
        ---@type [ number ]
        local id = {}
        id[1] = vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                timer.startMoveTime(nil, fileDatabase)
                vim.api.nvim_del_autocmd(id[1])
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        require("flex-stats.core.db").writeDataBase(database)
        delete()
    end,
})
