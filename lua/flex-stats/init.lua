local m = {}
m.fileTimes = {}
function m.setup()
    vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
            local filetype = vim.opt.filetype:get()
            if type(m.fileTimes[filetype]) ~= "table" then
                m.fileTimes[filetype] = { totalTime = 0 }
            end
            m.fileTimes[filetype].lastInsertEnter = os.time()
        end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
            local filetype = vim.opt.filetype:get()
            m.fileTimes[filetype].totalTime = m.fileTimes[filetype].totalTime
                + os.time()
                - m.fileTimes[filetype].lastInsertEnter
            m.fileTimes[filetype].lastInsertEnter = nil
        end,
    })
end
return m
