-- vim:set textwidth=78:
---@meta

local flex = {}

---@class flex.timer
flex.timer = {}

---flex.filetype: the name of the filetype. should be accessible via
---vim.opt.filetype
---@alias flex.filetype string

---flex.filetype or nil
---@alias flex.filetypeOrNil flex.filetype|nil

---@param filetype flex.filetype
---@param database flex.database
function flex.timer.filetypeSetup(filetype, database) end

---@param filetype flex.filetypeOrNil
---@param database flex.database
function flex.timer.startMoveTime(filetype, database) end

---@param filetype flex.filetypeOrNil
---@param database flex.database
function flex.timer.endMoveTime(filetype, database) end

---@param filetype flex.filetypeOrNil
---@param database flex.database
function flex.timer.startEditTime(filetype, database) end

---@param filetype flex.filetypeOrNil
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

---the database is a table with the filetypes as a string, then the value
---should be the filetypes
---@alias flex.database table<flex.filetype, flex.database.data|{}>

---@class flex.database.data
---@field editTotalTime integer
---@field moveTotalTime integer
---@field lastMoveEnter integer?
---@field lastEditEnter integer?

---@class flex.utils
flex.utils = {}

---@param oldName string
---@param newName string
function flex.utils.migrate(oldName, newName) end

--
--
--
--
--
--
--
--

---@class flex.init
flex.init = {}

---@type flex.database
flex.init.database = {}

function flex.init.setup() end

function flex.init.showStats() end

--
--
--
--
--
--
--
--

---@class flex.db
flex.db = {}

function flex.db.create() end

---@return flex.database
function flex.db.readDataBase() end

---@param db flex.database
function flex.db.writeDataBase(db) end
