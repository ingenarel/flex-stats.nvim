---@meta

-- vim:set textwidth=81:

---@class flex.ui.init
local m = {}

---@param db flex.database.files
---@param buf integer the buffer number
---@param win_width integer the window width
---@param nsID integer the nsid of the color namespace for flexstats
---shows the file stats menu on a buffer
function m.fileStatsMenu(db, buf, win_width, nsID) end

---@param opts flex.ui.init.showUIOpts?
---opens the ui
function m.showUI(opts) end

---@param winID integer
---@param autocmdID integer
function m.endUI(winID, autocmdID) end

---@param db flex.database.dev
---@param buf integer the buffer number
---@param win_width integer the window width
---@param nsID integer the nsid of the color namespace for flexstats
---shows the nvim stats menu on a buffer
function m.nvimDevStatsMenu(db, buf, win_width, nsID) end

---@param db flex.database.git
---@param buf integer the buffer number
---@param win_width integer the window width
---@param nsID integer the nsid of the color namespace for flexstats
---shows the git stats menu on a buffer
function m.gitStatsMenu(db, buf, win_width, nsID) end

---shows the git stats menu on a buffer
---@param nvimDb flex.database.nvim
---@param fileDb flex.database.files
---@param buf integer the buffer number
---@param win_width integer the window width
---@param nsID integer the nsid of the color namespace for flexstats
function m.nvimStatsMenu(nvimDb, fileDb, buf, win_width, nsID) end

---@class flex.ui.init.showUIOpts
---@field width integer? the window width, default is 80
---@field height integer? the window height, default is 80
---@field nsID integer
---@field page flex.ui.init.showUIOpts.page?

---@param db flex.database
---@param buf integer the buffer number
---@param win_width integer the window width
---shows the raw stats menu on a buffer
function m.rawStatsMenu(db, buf, win_width) end

---@alias flex.ui.init.showUIOpts.page "file"|"dev"|"quit"|"git"|"nvim"|"raw"
