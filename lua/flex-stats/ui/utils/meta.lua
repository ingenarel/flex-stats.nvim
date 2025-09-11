---@class flex.ui.utils
local m = {}

---@param seconds integer number of seconds
---@return string # human readable format of the number of seconds
---@nodiscard
function m.time(seconds) end

---@param input string
---@param width integer the width to center the string to
---@param char char? char to use as the indent for both sides, default is space
---centers a string to fit inside the middle of the width
function m.center(input, width, char) end

---@param db flex.database.files|flex.database.nvim
---@param nsID integer the nsid of the color namespace for flexstats
---@param opts flex.init.setupOpts.nameOverride[]? optional opts
---@return m.fileStatsMenu1stPassReturn[]
---@nodiscard
function m.fileStatsMenu1stPass(db, nsID, opts) end

---@class m.fileStatsMenu1stPassReturn
---@field [1] string file icon and name
---@field [2] string total time in human readable format
---@field [3] string move info|edit info in human readable format
---@field [4] string move info|edit info| nil
---@field [5] string empty line
---@field [6] string empty line
---@field [7] string empty line
---@field totalTime integer total time in seconds

---@param db m.fileStatsMenu1stPassReturn[]
---@param win_width integer the window width
---@param indentDriftForIcon integer
---@param gap integer
---@return string[][][]
---@nodiscard
function m.fileStatsMenu2ndPass(db, win_width, indentDriftForIcon, gap) end

---@param db string[][][]
---@return string[][][]
---@nodiscard
function m.fileStatsMenu3rdPass(db) end

---@param db string[][][]
---@param win_width integer the window width
---@param indentDriftForIcon integer indent drift for icons
---@return string[]
---@nodiscard
function m.fileStatsMenu4thPass(db, win_width, indentDriftForIcon) end

---@param db string[][][]
---@param x integer
---@param indentDriftForIcon integer
---@param win_width integer
---@param lines string[]
function m.fileStatsMenu4thPassNoEdgeGapEqualize(db, x, indentDriftForIcon, win_width, lines) end

---@param db string[][][]
---@param x integer
---@param indentDriftForIcon integer
---@param win_width integer
---@param lines string[]
function m.fileStatsMenu4thPassEdgeGapEqualize(db, x, indentDriftForIcon, win_width, lines) end

---@param regex string
---@param hexColor string
---@param nsID integer
function m.colorString(regex, hexColor, nsID) end

---@param steps number
---@param input number
---@return string hexcode
function m.getColor(steps, input) end

---@param lines string[]
---@param win_width integer
---@param currentMenu flex.ui.init.showUIOpts.page
---@return string[]
---@nodiscard
function m.addMaps(lines, win_width, currentMenu) end
