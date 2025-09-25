-- vim:set textwidth=81:
---@meta

local flex = {}

---the main database containing times
---@class flex.database
---@field files flex.database.files table with the filetypes as a string, then
---the value should be the filetype's data
---@field nvim flex.database.nvim
---@field git flex.database.git

---@alias flex.database.files table<flex.filetype, flex.database.fileData|{}>
---@alias flex.database.git table<flex.filetype, flex.database.fileData|{}>

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
---@field nameOverrides flex.init.setupOpts.nameOverride[]

---@class flex.init.setupOpts.nameOverride
---@field oldFileName string
---@field newFileName string?
---@field icon string?
---@field iconColor string?
---@field nameColor string?

---to show the stats
function flex.init.showStats() end

---@class flex.init.sharedValues
---@field autocmd flex.init.sharedValues.autocmd
---@field timer uv.uv_timer_t?
---@field config string the actual vim config path following symlinks
---@field data string the actual vim data path following symlinks
---@field fileValues flex.init.sharedValues.fileValues

---@alias flex.init.sharedValues.fileValues table<string, ({[1]: string}|false|nil)>

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
