---@meta

-- vim:set textwidth=0:

local flex = {}

---the main database containing times
---@class flex.database
---@field files flex.database.files
---@field dev flex.database.dev
---@field git flex.database.git
---@field nvim flex.database.nvim

---@alias flex.database.files table<flex.filetype, flex.database.fileData|{}> table with the filetypes as a string, then the value should be the filetype's data
---@alias flex.database.git table<string, flex.database.fileData|{}> table with git repo paths as string, value should be fileData

---table containing the filetype's data
---@class flex.database.fileData
---@field editTotalTime integer? total time that has been spent on editing
---@field moveTotalTime integer? total time that has been spent on moving around
---@field idleTotalTime integer? total time that has been spent idle
---@field lastMoveEnter integer? last time movement started to happen
---@field lastEditEnter integer? last time editing started to happen
---@field lastIdleEnter integer? last time idle time started to happen

---@class flex.database.dev dev work: time spent on neovim config and writing neovim plugins
---@field configStats flex.database.fileData time spent on neovim config
---@field pluginStats flex.database.fileData time spent on writing neovim plugins

---@class flex.database.nvim time spent on specific neovim tasks
---@field cmdTotalTime integer? time spent on the cmdline
---@field lastCmdEnter integer? last time the cmdline was entered
---@field useTotalTime integer? total time neovim has been used
---@field lastUseCheck integer? time the last use check was done

---module containing the init functions
---@class flex.init
---@field setupOpts flex.init.setupOpts
---@field database flex.database|nil
---@field sharedValues flex.init.sharedValues
flex.init = {}

---@param opts flex.init.actualSetupOpts
---the setup function
---just call it like this:
---```lua
--- require("flex-stats").setups({opts})
---```
function flex.init.setup(opts) end

---@class flex.init.setupOpts containing the opts for the setup
---@field noShow                flex.init.setupOpts.noShow
---@field indentDriftForIcon    flex.init.setupOpts.indentDriftForIcon
---@field gap                   flex.init.setupOpts.gap
---@field fileStatsGradientMax  flex.init.setupOpts.fileStatsGradientMax
---@field nsID                  flex.init.setupOpts.nsID
---@field saveInterval          flex.init.setupOpts.saveInterval
---@field pluginRegexes         flex.init.setupOpts.pluginRegexes
---@field nameOverrides         flex.init.setupOpts.nameOverrides

---@class flex.init.actualSetupOpts the values you pass in in the setup function
---@field noShow                flex.init.setupOpts.noShow?
---@field indentDriftForIcon    flex.init.setupOpts.indentDriftForIcon?
---@field gap                   flex.init.setupOpts.gap?
---@field fileStatsGradientMax  flex.init.setupOpts.fileStatsGradientMax?
---@field nsID                  flex.init.setupOpts.nsID?
---@field saveInterval          flex.init.setupOpts.saveInterval?
---@field pluginRegexes         flex.init.setupOpts.pluginRegexes?
---@field nameOverrides         flex.init.setupOpts.nameOverrides?

---@alias flex.init.setupOpts.noShow string[] list of filetypes to not show in the ui, see the default in ./lua/flex-stats/init.lua
---@alias flex.init.setupOpts.indentDriftForIcon integer the indent drift for icons, see the default in ./lua/flex-stats/init.lua
---@alias flex.init.setupOpts.gap integer the minimum gap for the file UI, see the default in ./lua/flex-stats/init.lua
---@alias flex.init.setupOpts.fileStatsGradientMax integer, see the default in ./lua/flex-stats/init.lua
---@alias flex.init.setupOpts.nsID integer namespace id for the plugin
---@alias flex.init.setupOpts.saveInterval integer should be in milliseconds, see the default in ./lua/flex-stats/init.lua
---@alias flex.init.setupOpts.pluginRegexes string[] list of regexes to detect nvim plugins, see the default in ./lua/flex-stats/init.lua
---@alias flex.init.setupOpts.nameOverrides flex.init.setupOpts.nameOverride[] override for filenames, see the default in ./lua/flex-stats/init.lua

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
---@field date string

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
---@field CmdlineEnterID integer?
---@field CmdlineLeaveID integer?
