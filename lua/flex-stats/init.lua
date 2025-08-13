local m = {}

m.fileTimes = {}

function m.startInsertTime()
    local filetype = vim.opt.filetype:get()
    m.fileTimes[filetype].lastInsertEnter = os.time()
end

function m.endInsertTime()
    local filetype = vim.opt.filetype:get()
    m.fileTimes[filetype].totalTime = m.fileTimes[filetype].totalTime
        + os.time()
        - m.fileTimes[filetype].lastInsertEnter
    m.fileTimes[filetype].lastInsertEnter = nil
end

function m.filetypeSetup()
    local filetype = vim.opt.filetype:get()
    if type(m.fileTimes[filetype]) ~= "table" then
        m.fileTimes[filetype] = {}
    end
    if type(m.fileTimes[filetype].totalTime) ~= "number" then
        m.fileTimes[filetype].totalTime = 0
    end
end

function m.setup()
    vim.api.nvim_create_autocmd("FileType", {
        callback = m.filetypeSetup,
    })
    vim.api.nvim_create_autocmd("InsertEnter", {
        callback = m.startInsertTime,
    })
    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = m.endInsertTime,
    })
end

return m
