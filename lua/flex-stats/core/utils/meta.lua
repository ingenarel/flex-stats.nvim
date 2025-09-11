---@meta

---@class flex.core.utils
local m = {}

---@param file string the full file path
---@return string|nil git_root returns the git root dir if it exists,
---@nodiscard
function m.gitRoot(file) end

---@param root string
---@return string[]|nil git_files returns the git files returned by system
---command `git ls-files`
---@nodiscard
function m.gitLs(root) end

---@param file string
---@param fileValues flex.init.sharedValues.fileValues
function m.setFileValues(file, fileValues) end
