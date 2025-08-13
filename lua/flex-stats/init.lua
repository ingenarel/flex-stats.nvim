local m = {}

local db = require("flex-stats.db")

function m.startMoveTime()
    local filetype = vim.opt.filetype:get()
    if filetype then
        m.filetypeSetup(filetype)
        if not m.database[filetype].lastMoveEnter then
            m.database[filetype].lastMoveEnter = os.time()
        end
    end
end

function m.endMoveTime()
    local filetype = vim.opt.filetype:get()
    if filetype then
        m.filetypeSetup(filetype)
        if m.database[filetype].lastMoveEnter then
            m.database[filetype].moveTotalTime = m.database[filetype].moveTotalTime
                + os.time()
                - m.database[filetype].lastMoveEnter
            m.database[filetype].lastMoveEnter = nil
        end
    end
end

function m.startInsertTime()
    local filetype = vim.opt.filetype:get()
    if filetype then
        m.filetypeSetup(filetype)
        if not m.database[filetype].lastInsertEnter then
            m.database[filetype].lastInsertEnter = os.time()
        end
    end
end

function m.endInsertTime()
    local filetype = vim.opt.filetype:get()
    if filetype then
        m.filetypeSetup(filetype)
        if m.database[filetype].lastInsertEnter then
            m.database[filetype].insertTotalTime = m.database[filetype].insertTotalTime
                + os.time()
                - m.database[filetype].lastInsertEnter
            m.database[filetype].lastInsertEnter = nil
        end
    end
end

function m.filetypeSetup(filetype)
    ---WARNING: this can't be in a filetype autocmd, it breaks with when i enter telescope for some reason
    -- altho calling it in every function where stuff is modified is the SAFEST option by far, it's still unoptimized
    -- maybe some pcalls in the modify functions? idk
    if type(m.database[filetype]) ~= "table" then
        m.database[filetype] = {}
    end
    if type(m.database[filetype].insertTotalTime) ~= "number" then
        m.database[filetype].insertTotalTime = 0
    end
    if type(m.database[filetype].moveTotalTime) ~= "number" then
        m.database[filetype].moveTotalTime = 0
    end
end

function m.setup()
    m.database = db.readDataBase()
    vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
            local currentMode = string.lower(vim.fn.mode())
            if string.find(currentMode, "i") or string.find(currentMode, "r") then
                m.startInsertTime()
            else
                m.endInsertTime()
                if string.find(currentMode, "n") or string.find(currentMode, "v") then
                    m.startMoveTime()
                else
                    m.endMoveTime()
                end
            end
        end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            for lang, data in pairs(m.database) do
                pcall(function()
                    if data.lastMoveEnter then
                        m.database[lang].lastMoveEnter = nil
                    end
                end)
                pcall(function()
                    if data.lastInsertEnter then
                        m.database[lang].lastInsertEnter = nil
                    end
                end)
            end
            db.writeDataBase(m.database)
        end,
    })
end

function m.showStats()
    db.writeDataBase(m.database)
    vim.print(m.database)
end

return m
