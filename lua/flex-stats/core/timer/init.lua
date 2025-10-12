---@type flex.core.timer
local m = {}

local sharedValues = require("flex-stats").sharedValues

function m.filetypeSetup(filetype, database)
    ---WARNING: this can't be in a filetype autocmd, it breaks with when i enter telescope for some reason
    -- altho calling it in every function where stuff is modified is the SAFEST option by far, it's still unoptimized
    -- maybe some pcalls in the modify functions? idk

    if type(database[filetype]) ~= "table" then
        database[filetype] = {}
    end
    if type(database[filetype][sharedValues.date]) ~= "table" then
        database[filetype][sharedValues.date] = {}
    end
    if type(database[filetype][sharedValues.date].editTotalTime) ~= "number" then
        database[filetype][sharedValues.date].editTotalTime = 0
    end
    if type(database[filetype][sharedValues.date].moveTotalTime) ~= "number" then
        database[filetype][sharedValues.date].moveTotalTime = 0
    end
    if type(database[filetype][sharedValues.date].idleTotalTime) ~= "number" then
        database[filetype][sharedValues.date].idleTotalTime = 0
    end
end

function m.startMoveTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if not database[filetype][sharedValues.date].lastMoveEnter then
            database[filetype][sharedValues.date].lastMoveEnter = os.time()
        end
    end
end

function m.endMoveTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if database[filetype][sharedValues.date].lastMoveEnter then
            database[filetype][sharedValues.date].moveTotalTime = database[filetype][sharedValues.date].moveTotalTime
                + os.time()
                - database[filetype][sharedValues.date].lastMoveEnter
            database[filetype][sharedValues.date].lastMoveEnter = nil
        end
    end
end

function m.startEditTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if not database[filetype][sharedValues.date].lastEditEnter then
            database[filetype][sharedValues.date].lastEditEnter = os.time()
        end
    end
end

function m.endEditTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if database[filetype][sharedValues.date].lastEditEnter then
            database[filetype][sharedValues.date].editTotalTime = database[filetype][sharedValues.date].editTotalTime
                + os.time()
                - database[filetype][sharedValues.date].lastEditEnter
            database[filetype][sharedValues.date].lastEditEnter = nil
        end
    end
end

function m.startIdleTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if not database[filetype][sharedValues.date].lastIdleEnter then
            database[filetype][sharedValues.date].lastIdleEnter = os.time()
        end
    end
end

function m.endIdleTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if database[filetype][sharedValues.date].lastIdleEnter then
            database[filetype][sharedValues.date].idleTotalTime = database[filetype][sharedValues.date].idleTotalTime
                + os.time()
                - database[filetype][sharedValues.date].lastIdleEnter
            database[filetype][sharedValues.date].lastIdleEnter = nil
        end
    end
end

return m
