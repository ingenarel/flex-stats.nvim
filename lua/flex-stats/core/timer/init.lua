---@type flex.core.timer
local m = {}

function m.filetypeSetup(filetype, database)
    ---WARNING: this can't be in a filetype autocmd, it breaks with when i enter telescope for some reason
    -- altho calling it in every function where stuff is modified is the SAFEST option by far, it's still unoptimized
    -- maybe some pcalls in the modify functions? idk

    if type(database[filetype]) ~= "table" then
        database[filetype] = {}
    end
    if type(database[filetype].editTotalTime) ~= "number" then
        database[filetype].editTotalTime = 0
    end
    if type(database[filetype].moveTotalTime) ~= "number" then
        database[filetype].moveTotalTime = 0
    end
    if type(database[filetype].idleTotalTime) ~= "number" then
        database[filetype].idleTotalTime = 0
    end
end

function m.startMoveTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if not database[filetype].lastMoveEnter then
            database[filetype].lastMoveEnter = os.time()
        end
    end
end

function m.endMoveTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if database[filetype].lastMoveEnter then
            database[filetype].moveTotalTime = database[filetype].moveTotalTime
                + os.time()
                - database[filetype].lastMoveEnter
            database[filetype].lastMoveEnter = nil
        end
    end
end

function m.startEditTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if not database[filetype].lastEditEnter then
            database[filetype].lastEditEnter = os.time()
        end
    end
end

function m.endEditTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if database[filetype].lastEditEnter then
            database[filetype].editTotalTime = database[filetype].editTotalTime
                + os.time()
                - database[filetype].lastEditEnter
            database[filetype].lastEditEnter = nil
        end
    end
end

function m.startIdleTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if not database[filetype].lastIdleEnter then
            database[filetype].lastIdleEnter = os.time()
        end
    end
end

function m.endIdleTime(filetype, database)
    ---@diagnostic disable-next-line: undefined-field
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if database[filetype].lastIdleEnter then
            database[filetype].idleTotalTime = database[filetype].idleTotalTime
                + os.time()
                - database[filetype].lastIdleEnter
            database[filetype].lastIdleEnter = nil
        end
    end
end

return m
