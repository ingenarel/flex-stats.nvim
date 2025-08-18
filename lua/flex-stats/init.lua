local m = {}

local db = require("flex-stats.core.db")
local timer = require("flex-stats.core.timer")

function m.setup()
    m.database = db.readDataBase()
    vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
            local currentMode = string.lower(vim.fn.mode())
            if string.find(currentMode, "i") or string.find(currentMode, "r") then
                timer.startEditTime(nil, m.database)
            else
                timer.endEditTime(nil, m.database)
                if string.find(currentMode, "n") or string.find(currentMode, "v") then
                    timer.startMoveTime(nil, m.database)
                else
                    timer.endMoveTime(nil, m.database)
                end
            end
        end,
    })

    vim.api.nvim_create_autocmd("CursorHoldI", {
        callback = function()
            timer.endEditTime(nil, m.database)
            local id = {}
            id[1] = vim.api.nvim_create_autocmd("CursorMovedI", {
                callback = function()
                    timer.startEditTime(nil, m.database)
                    vim.api.nvim_del_autocmd(id[1])
                end,
            })
        end,
    })

    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
            timer.endMoveTime(nil, m.database)
            local id = {}
            id[1] = vim.api.nvim_create_autocmd("CursorMoved", {
                callback = function()
                    timer.startMoveTime(nil, m.database)
                    vim.api.nvim_del_autocmd(id[1])
                end,
            })
        end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            db.writeDataBase(m.database)
        end,
    })
end

function m.showStats()
    db.writeDataBase(m.database)
    vim.print(m.database)
end

return m
