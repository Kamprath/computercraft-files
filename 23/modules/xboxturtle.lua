local log = dofile('/modules/log.lua')

local protocol = 'rpc'
local hostname = 'xbox-turtle'
local path = '/turtlecommand'

local map = {
    ['left:up'] = 'forward',
    ['left:down'] = 'back',
    ['left:left'] = 'left',
    ['left:right'] = 'right',
    ['right:up'] = 'up',
    ['right:down'] = 'down',
    ['a'] = 'attack'
}

local module = {
    turtleID = nil,

    init = function(self)
        term.clear()
        term.setCursorPos(1, 1)
        print('Watching for Xbox controller input...\n')

        self.turtleID = rednet.lookup(protocol, hostname)
        
        if not self.turtleID then
            log('"' .. hostname .. '" not found on protocol "' .. protocol .. '"', 3)
            return
        end

        log('Connected to turtle ' .. self.turtleID)

        while true do
            local file = fs.open(path, 'r')
            local input = file.readLine()
            file.close()

            if input ~= nil and input ~= '' then
                self:handleInput(input)
                file = fs.open(path, 'w')
                file.write('')
                file.close()
            end

            sleep(.2)
        end
    end,

    handleInput = function(self, input)
        if not map[input] then return end

        rednet.send(self.turtleID, map[input], protocol)
        log(input .. ': ' .. map[input])
    end
}

return function()
    module:init()
end