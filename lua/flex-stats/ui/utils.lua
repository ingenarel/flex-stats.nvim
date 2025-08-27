local m = {}
function m.time(seconds)
    local minutes = 0
    local hours = 0
    local returnString = ""
    if seconds >= 60 then
        local tmp = seconds % 60
        minutes = (seconds - tmp) / 60
        seconds = tmp
    end
    if minutes >= 60 then
        local tmp = minutes % 60
        hours = (minutes - tmp) / 60
        minutes = tmp
    end
    if seconds > 0 then
        returnString = returnString .. seconds .. " seconds"
    end
    if minutes > 0 then
        returnString = minutes .. " minutes " .. returnString
    end
    if hours > 0 then
        returnString = hours .. " hours " .. returnString
    end

    return returnString
end

function m.center(input, width, char)
    char = char or " "
    local indent = string.rep(char, math.floor((width - #input) / 2))
    return indent .. input .. string.rep(char, width - #indent - #input)
end

return m
