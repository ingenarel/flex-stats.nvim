local m = {}

local db = require("flex-stats.db")

function m.startInsertTime()
    local filetype = vim.opt.filetype:get()
    m.database[filetype].lastInsertEnter = os.time()
end

function m.endInsertTime()
    local filetype = vim.opt.filetype:get()
    if m.database[filetype].lastInsertEnter then
        m.database[filetype].totalTime = m.database[filetype].totalTime
            + os.time()
            - m.database[filetype].lastInsertEnter
        m.database[filetype].lastInsertEnter = nil
    end
end

function m.filetypeSetup()
    local filetype = vim.opt.filetype:get()
    if type(m.database[filetype]) ~= "table" then
        m.database[filetype] = {}
    end
    if type(m.database[filetype].totalTime) ~= "number" then
        m.database[filetype].totalTime = 0
    end
end

function m.setup()
    m.database = db.readDataBase()
    vim.api.nvim_create_autocmd("FileType", {
        callback = m.filetypeSetup,
    })
    vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
            local currentMode = vim.fn.mode()
            if string.find(currentMode, "i") then
                m.startInsertTime()
            else
                m.endInsertTime()
            end
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
