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

---module containing the init functions
---@class flex.init
---@field setupOpts flex.init.setupOpts
flex.init = {}

---@type flex.database
flex.init.database = {}

---@param opts flex.init.setupOpts
---the setup function
function flex.init.setup(opts) end

---@class flex.init.setupOpts
---@field noShow string[]? list of filetypes to not show in the ui
---@field indentDriftForIcon integer the indent drift for icons
---@field gap integer the minimum gap for the file UI

---to show the stats
function flex.init.showStats() end

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

flex.ui = {}
---@class flex.ui.init
flex.ui.init = {}

---@param db flex.database
---@param buf integer the buffer number
---@param win_width integer the window width
---@param nsID integer the nsid of the color namespace for flexstats
---shows the stats menu on a buffer
function flex.ui.init.fileStatsMenu(db, buf, win_width, nsID) end

---@param opts flex.ui.init.showUIOpts?
---opens the ui
function flex.ui.init.showUI(opts) end

---@class flex.ui.init.showUIOpts
---@field width integer? the window width, default is 80
---@field height integer? the window height, default is 80

---@class flex.ui.utils
flex.ui.utils = {}

---@param seconds integer number of seconds
---@return string # human readable format of the number of seconds
---@nodiscard
function flex.ui.utils.time(seconds) end

---@param input string
---@param width integer the width to center the string to
---@param char char? char to use as the indent for both sides, default is space
---centers a string to fit inside the middle of the width
function flex.ui.utils.center(input, width, char) end

---@param db flex.database
---@return flex.ui.utils.fileStatsMenu1stPassReturn[]
---@param nsID integer the nsid of the color namespace for flexstats
---@nodiscard
function flex.ui.utils.fileStatsMenu1stPass(db, nsID) end

---@class flex.ui.utils.fileStatsMenu1stPassReturn
---@field [1] string file icon and name
---@field [2] string total time in human readable format
---@field [3] string move info|edit info in human readable format
---@field [4] string move info|edit info| nil
---@field [5] string empty line
---@field [6] string empty line
---@field totalTime integer total time in seconds

---@param db flex.ui.utils.fileStatsMenu1stPassReturn[]
---@param win_width integer the window width
---@param indentDriftForIcon integer
---@param gap integer
---@return string[][][]
---@nodiscard
function flex.ui.utils.fileStatsMenu2ndPass(db, win_width, indentDriftForIcon, gap) end

---@param db string[][][]
---@return string[][][]
---@nodiscard
function flex.ui.utils.fileStatsMenu3rdPass(db) end

---@param db string[][][]
---@param win_width integer the window width
---@param indentDriftForIcon integer indent drift for icons
---@return string[]
---@nodiscard
function flex.ui.utils.fileStatsMenu4thPass(db, win_width, indentDriftForIcon) end
