-----------------------------------------------------------------------------
--  Sends RPC commands to a turtle when a valid string is written to the file
--  being watched.
--
--  Valid strings are mapped to remote procedures in the 'map' table of this
--  module.
--
--	Version: 0.1
--	Dependencies: log
-----------------------------------------------------------------------------

local log = dofile('/modules/log.lua')

local config = {
    hostname = 'xbox-turtle',
    path = '/input',
    protocol = 'rpc'
}

local map = {
    ['left:up'] = 'forward',
    ['left:down'] = 'back',
    ['left:left'] = 'left',
    ['left:right'] = 'right',
    ['right:up'] = 'up',
    ['right:down'] = 'down',
    ['a'] = 'attack',
    ['y'] = 'place down'
}

local module = {
    turtleID = nil,

    init = function(self, path, hostname)
        if path then
            config.path = path
        end
        if hostname then
            config.hostname = hostname
        end

        term.clear()
        term.setCursorPos(1, 1)
        print('Watching for controller input...\n')

        self.turtleID = rednet.lookup(config.protocol, config.hostname)
        
        if not self.turtleID then
            log('"' .. config.hostname .. '" not found on protocol "' .. config.protocol .. '"', 3)
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

        rednet.send(self.turtleID, map[input], config.protocol)
        log(input .. ': ' .. map[input])
    end
}

return function(path, hostname)
    module:init(path, hostname)
end