local m = {}

function m.filetypeSetup(filetype, database)
    ---WARNING: this can't be in a filetype autocmd, it breaks with when i enter telescope for some reason
    -- altho calling it in every function where stuff is modified is the SAFEST option by far, it's still unoptimized
    -- maybe some pcalls in the modify functions? idk
    if type(database[filetype]) ~= "table" then
        database[filetype] = {}
    end
    if type(database[filetype].insertTotalTime) ~= "number" then
        database[filetype].insertTotalTime = 0
    end
    if type(database[filetype].moveTotalTime) ~= "number" then
        database[filetype].moveTotalTime = 0
    end
end

function m.startMoveTime(filetype, database)
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if not database[filetype].lastMoveEnter then
            database[filetype].lastMoveEnter = os.time()
        end
    end
end

function m.endMoveTime(filetype, database)
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

function m.startInsertTime(filetype, database)
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if not database[filetype].lastInsertEnter then
            database[filetype].lastInsertEnter = os.time()
        end
    end
end

function m.endInsertTime(filetype, database)
    filetype = filetype or vim.opt.filetype:get()
    if filetype ~= "" then
        m.filetypeSetup(filetype, database)
        if database[filetype].lastInsertEnter then
            database[filetype].insertTotalTime = database[filetype].insertTotalTime
                + os.time()
                - database[filetype].lastInsertEnter
            database[filetype].lastInsertEnter = nil
        end
    end
end

return m
