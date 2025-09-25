---@meta

-- vim:set textwidth=81:

---module containing the timer functions such as starting and ending moving and
---edit time in the database
---@class flex.core.timer
local m = {}

---name of the filetype. should be accessible via vim.opt.filetype
---@alias flex.filetype string
---@alias timerInput flex.database.files|flex.database.dev|flex.database.git

---@param filetype flex.filetype
---@param database timerInput
---setup necessary database options for a filetype if they're not set yet
function m.filetypeSetup(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the current time as the lastMoveEnter in the database if it hasn't been
---set yet
function m.startMoveTime(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the moveTotalTime by subtracting the current time returned by |os.time()|
---from the lastMoveEnter in the database, then set the lastMoveEnter to nil
function m.endMoveTime(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the current time as the lastEditEnter in the database if it hasn't been
---set yet
function m.startEditTime(filetype, database) end

---sets the EditTotalTime by subtracting the current time returned by |os.time()|
---from the lastEditEnter in the database, then set the lastEditEnter to nil
---@param filetype flex.filetype?
---@param database timerInput
function m.endEditTime(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the current time as the lastIdleEnter in the database if it hasn't been
---set yet
function m.startIdleTime(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the idleTotalTime by subtracting the current time returned by |os.time()|
---from the lastIdleEnter in the database, then set the lastIdleEnter to nil
function m.endIdleTime(filetype, database) end
