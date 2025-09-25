---@meta

-- vim:set textwidth=81:

---module containing migrating functions
---@class flex.core.migrate
local m = {}

---@param oldName string the old key to migrate from
---@param newName string the new key to migrate to
---@param database table<string, any>|nil optional database
---a key migration function
---if the database is `{ lua = { a = 1}, ..}` and you
---want to change the name of `a` to `b`, do keys("a", "b"), then the database
---should be `{ lua = { b = 1}, ..}` if the old one's value is a number, add the
---two values, if the old one's value is a table, use |vim.tbl_deep_extend()| to
---merge the two tables
function m.keys(oldName, newName, database) end

---@param keys string[]
---@param tbl table
function m.createRecursiveTableKeys(keys, tbl) end

---@param keys string[]
---@param tbl table
---@nodiscard
function m.popTableKey(keys, tbl) end

---@param keys string[]
---@param value any
---@param tbl table
function m.setRecursiveKey(keys, value, tbl) end

---@param oldKeys string[]
---@param newKeys string[]
---@param db table<string, any>|nil optional database
---a key migration function
---if the database is `{ x = 123 , ..}` and you want to move everything to
---`a` do moveDeeper(nil, {"a"}, nil), then the database should be `{ a = { x =
---123 } }`
function m.moveDeeper(oldKeys, newKeys, db) end
