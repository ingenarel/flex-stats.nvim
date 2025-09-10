---@type flex.core.utils
local m = {}

function m.gitRoot(file)
    for dir in vim.fs.parents(file) do
        if vim.uv.fs_stat(vim.fs.joinpath(dir, ".git")) then
            local path, _, _ = vim.uv.fs_realpath(dir)
            if path then
                return path
            end
        end
    end
end

return m
