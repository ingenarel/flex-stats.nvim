-- vim:set textwidth=81:
---@meta

local flex = {}

---module containing the timer functions such as starting and ending moving and
---edit time in the database
---@class flex.timer
flex.timer = {}

---name of the filetype. should be accessible via vim.opt.filetype
---@alias flex.filetype string

---@param filetype flex.filetype
---@param database flex.database
---setup necessary database options for a filetype if they're not set yet
function flex.timer.filetypeSetup(filetype, database) end

---@param filetype flex.filetype?
---@param database flex.database
---sets the current time as the lastMoveEnter in the database if it hasn't been
---set yet
function flex.timer.startMoveTime(filetype, database) end

---@param filetype flex.filetype?
---@param database flex.database
---sets the moveTotalTime by subtracting the current time returned by |os.time()|
---from the lastMoveEnter in the database, then set the lastMoveEnter to nil
function flex.timer.endMoveTime(filetype, database) end

---@param filetype flex.filetype?
---@param database flex.database
---sets the current time as the lastEditEnter in the database if it hasn't been
---set yet
function flex.timer.startEditTime(filetype, database) end

---sets the EditTotalTime by subtracting the current time returned by |os.time()|
---from the lastEditEnter in the database, then set the lastEditEnter to nil
---@param filetype flex.filetype?
---@param database flex.database
function flex.timer.endEditTime(filetype, database) end

--
--
--
--
--
--
--
--

---table with the filetypes as a string, then the value should be the filetype's
---data
---@alias flex.database table<flex.filetype, flex.database.data|{}>

---table containing the filetype's data
---@class flex.database.data
---total time that has been spent on editing
---@field editTotalTime integer
---total time that has been spent on moving around
---@field moveTotalTime integer
---last time movement started to happen
---@field lastMoveEnter integer?
---last time editing started to happen
---@field lastEditEnter integer?

---module containing some utility functions
---@class flex.utils
flex.utils = {}

---@param oldName string the old key to migrate from
---@param newName string the new key to migrate to
---a key migration function
---if the database is `{ lua = { a = 1}, ..}` and you
---want to change the name of `a` to `b`, do migrate("a", "b"), then the database
---should be `{ lua = { b = 1}, ..}` if the old one's value is a number, add the
---two values, if the old one's value is a table, use |vim.tbl_deep_extend()| to
---merge the two tables
function flex.utils.migrate(oldName, newName) end

--
--
--
--
--
--
--
--

---module containing the init functions
---@class flex.init
flex.init = {}

---@type flex.database
flex.init.database = {}

---the setup function
function flex.init.setup() end

---to show the stats
function flex.init.showStats() end

--
--
--
--
--
--
--
--

---the module containing the database functions
---@class flex.db
flex.db = {}

---create the database file
function flex.db.create() end

---@return flex.database
---@nodiscard
---reads the database file and returns the database
function flex.db.readDataBase() end

---@param db flex.database
---writes the database file
function flex.db.writeDataBase(db) end
