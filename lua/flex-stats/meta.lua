-- vim:set textwidth=81:
---@meta

local flex = {}

---The core files
---@class flex.core
flex.core = {}

---module containing the timer functions such as starting and ending moving and
---edit time in the database
---@class flex.core.timer
flex.core.timer = {}

---name of the filetype. should be accessible via vim.opt.filetype
---@alias flex.filetype string
---@alias timerInput flex.database.files|flex.database.nvim

---@param filetype flex.filetype
---@param database timerInput
---setup necessary database options for a filetype if they're not set yet
function flex.core.timer.filetypeSetup(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the current time as the lastMoveEnter in the database if it hasn't been
---set yet
function flex.core.timer.startMoveTime(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the moveTotalTime by subtracting the current time returned by |os.time()|
---from the lastMoveEnter in the database, then set the lastMoveEnter to nil
function flex.core.timer.endMoveTime(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the current time as the lastEditEnter in the database if it hasn't been
---set yet
function flex.core.timer.startEditTime(filetype, database) end

---sets the EditTotalTime by subtracting the current time returned by |os.time()|
---from the lastEditEnter in the database, then set the lastEditEnter to nil
---@param filetype flex.filetype?
---@param database timerInput
function flex.core.timer.endEditTime(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the current time as the lastIdleEnter in the database if it hasn't been
---set yet
function flex.core.timer.startIdleTime(filetype, database) end

---@param filetype flex.filetype?
---@param database timerInput
---sets the idleTotalTime by subtracting the current time returned by |os.time()|
---from the lastIdleEnter in the database, then set the lastIdleEnter to nil
function flex.core.timer.endIdleTime(filetype, database) end

---table with the filetypes as a string, then the value should be the filetype's
---data
---@class flex.database
---@field files flex.database.files
---@field nvim flex.database.nvim

---@alias flex.database.files table<flex.filetype, flex.database.fileData|{}>

---table containing the filetype's data
---@class flex.database.fileData
---@field editTotalTime integer total time that has been spent on editing
---@field moveTotalTime integer total time that has been spent on moving around
---@field idleTotalTime integer?
---@field lastMoveEnter integer? last time movement started to happen
---@field lastEditEnter integer? last time editing started to happen
---@field lastIdleEnter integer?

---@class flex.database.nvim
---@field configStats flex.database.fileData
---@field pluginStats flex.database.fileData

---module containing migrating functions
---@class flex.core.migrate
flex.core.migrate = {}

---@param oldName string the old key to migrate from
---@param newName string the new key to migrate to
---@param database flex.database|table|nil optional database
---a key migration function
---if the database is `{ lua = { a = 1}, ..}` and you
---want to change the name of `a` to `b`, do keys("a", "b"), then the database
---should be `{ lua = { b = 1}, ..}` if the old one's value is a number, add the
---two values, if the old one's value is a table, use |vim.tbl_deep_extend()| to
---merge the two tables
function flex.core.migrate.keys(oldName, newName, database) end

---@param keys string[]
---@param tbl table
function flex.core.migrate.createRecursiveTableKeys(keys, tbl) end

---@param keys string[]
---@param tbl table
---@nodiscard
function flex.core.migrate.popTableKey(keys, tbl) end

---@param keys string[]
---@param value any
---@param tbl table
function flex.core.migrate.setRecursiveKey(keys, value, tbl) end

---@param oldKeys string[]
---@param newKeys string[]
---@param db nil|flex.database|table
---a key migration function
---if the database is `{ x = 123 , ..}` and you want to move everything to
---`a` do moveDeeper(nil, {"a"}, nil), then the database should be `{ a = { x =
---123 } }`
function flex.core.migrate.moveDeeper(oldKeys, newKeys, db) end

---module containing the init functions
---@class flex.init
---@field setupOpts flex.init.setupOpts
---@field database flex.database|nil
---@field sharedValues flex.init.sharedValues
flex.init = {}

---@param opts flex.init.setupOpts
---the setup function
function flex.init.setup(opts) end

---@class flex.init.setupOpts
---@field noShow string[]? list of filetypes to not show in the ui
---@field indentDriftForIcon integer the indent drift for icons
---@field gap integer the minimum gap for the file UI
---@field fileStatsGradientMax integer
---@field nsID integer?
---@field saveInterval integer should be in milliseconds
---@field pluginRegexes string[]

---to show the stats
function flex.init.showStats() end

---@class flex.init.sharedValues
---@field autocmd flex.init.sharedValues.autocmd
---@field timer uv.uv_timer_t?
---@field config string the actual vim config path following symlinks
---@field data string the actual vim data path following symlinks

---@class flex.init.sharedValues.autocmd
---@field groupID integer?
---@field BufEnterID integer?
---@field BufLeaveID integer?
---@field ModeChangedID integer?
---@field CursorHoldI_ID integer?
---@field CursorHold_ID integer?
---@field CursorMovedI_ID integer?
---@field CursorMoved_ID integer?
---@field VimLeavePreID integer?

---the module containing the database functions
---@class flex.core.db
flex.core.db = {}

---create the database file
function flex.core.db.create() end

---@return flex.database
---@nodiscard
---reads the database file and returns the database
function flex.core.db.readDataBase() end

---@param db flex.database
---writes the database file
function flex.core.db.writeDataBase(db) end

flex.ui = {}
---@class flex.ui.init
flex.ui.init = {}

---@param db flex.database
---@param buf integer the buffer number
---@param win_width integer the window width
---@param nsID integer the nsid of the color namespace for flexstats
---shows the file stats menu on a buffer
function flex.ui.init.fileStatsMenu(db, buf, win_width, nsID) end

---@param opts flex.ui.init.showUIOpts?
---opens the ui
function flex.ui.init.showUI(opts) end

---@param autocmdID integer
function flex.ui.init.endUI(autocmdID) end

---@param db flex.database.nvim
---@param buf integer the buffer number
---@param win_width integer the window width
---@param nsID integer the nsid of the color namespace for flexstats
---shows the nvim stats menu on a buffer
function flex.ui.init.nvimStatsMenu(db, buf, win_width, nsID) end

---@class flex.ui.init.showUIOpts
---@field width integer? the window width, default is 80
---@field height integer? the window height, default is 80
---@field nsID integer
---@field page "file"|"nvim"|nil

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

---@param db flex.database.files|flex.database.nvim
---@param nsID integer the nsid of the color namespace for flexstats
---@param opts flex.ui.utils.fileStatsMenu1stPassOpts? optional options
---@return flex.ui.utils.fileStatsMenu1stPassReturn[]
---@nodiscard
function flex.ui.utils.fileStatsMenu1stPass(db, nsID, opts) end

---@class flex.ui.utils.fileStatsMenu1stPassOpts
---@field oldFileName string?
---@field newFileName string?
---@field icon string?
---@field color string?
---@field nameColor string?

---@class flex.ui.utils.fileStatsMenu1stPassReturn
---@field [1] string file icon and name
---@field [2] string total time in human readable format
---@field [3] string move info|edit info in human readable format
---@field [4] string move info|edit info| nil
---@field [5] string empty line
---@field [6] string empty line
---@field writingTime integer total time in seconds

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

---@param db string[][][]
---@param x integer
---@param indentDriftForIcon integer
---@param win_width integer
---@param lines string[]
function flex.ui.utils.fileStatsMenu4thPassNoEdgeGapEqualize(db, x, indentDriftForIcon, win_width, lines) end

---@param db string[][][]
---@param x integer
---@param indentDriftForIcon integer
---@param win_width integer
---@param lines string[]
function flex.ui.utils.fileStatsMenu4thPassEdgeGapEqualize(db, x, indentDriftForIcon, win_width, lines) end

---@param regex string
---@param hexColor string
---@param nsID integer
function flex.ui.utils.colorString(regex, hexColor, nsID) end

---@param steps number
---@param input number
---@return string hexcode
function flex.ui.utils.getColor(steps, input) end

---@param lines string[]
---@param win_width integer
---@param currentMenu "file"|"nvim"|"quit"
---@return string[]
---@nodiscard
function flex.ui.utils.addMaps(lines, win_width, currentMenu) end

---@class flex.core.lock
flex.core.lock = {}

---create the lockfile
function flex.core.lock.create() end

---delete the lockfile
function flex.core.lock.delete() end
