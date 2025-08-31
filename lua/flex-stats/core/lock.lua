---@type flex.lock
local m = {}

function m.create()
    vim.fn.mkdir(vim.fn.stdpath("data") .. "/flex-stats", "p")
    local file = io.open(vim.fn.stdpath("data") .. "/flex-stats/LOCKFILE", "w")
    if file == nil then
        error("cannot create file")
    else
        file:write("DO NOT DELETE THIS IF A NEOVIM PROCESS IS ALREADY RUNNING!!!")
        file:close()
    end
end

function m.delete()
    vim.fs.rm(vim.fn.stdpath("data") .. "/flex-stats/LOCKFILE", { recursive = false, force = true })
end

return m
