---@meta

---the module containing the database functions
---@class flex.core.db
local m = {}

---create the database file
function m.create() end

---@return flex.database
---@nodiscard
---reads the database file and returns the database
function m.readDataBase() end

---@param db flex.database
---writes the database file
function m.writeDataBase(db) end
