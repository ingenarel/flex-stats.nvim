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

function m.gitLs(root)
    local out = vim.system({ "git", "-C", root, "ls-files" }):wait()
    if out.code == 0 and out.stdout then
        local files = {}
        for file in vim.gsplit(out.stdout, "\n") do
            if file ~= "" then
                table.insert(files, vim.fs.joinpath(root, file))
            end
        end
        if #files > 0 then
            return files
        end
    end
end

function m.setFileValues(file, fileValues)
    if fileValues[file] == nil then
        local root = m.gitRoot(file)
        if root then
            local files = m.gitLs(root)
            if files then
                fileValues[files[1]] = { root }
                for i = 2, #files do
                    fileValues[files[i]] = fileValues[files[1]]
                end
            end
        else
            fileValues[file] = false
        end
    end
end

return m
