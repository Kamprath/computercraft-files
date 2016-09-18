local serverID = rednet.lookup('commands', 'command_server')

if not serverID then
	term.clear()
	term.setCursorPos(1, 1)
	print('Failed to reach command server.')
	io.read()
	os.shutdown()
end

return {
	-- Load gamemode menu
	{'Gamemode', function(menu)
		local title = 'Select a Gamemode' 

		menu:add(title, assert(
			loadfile('/menus/gamemode.lua')
		)(serverID))

		menu:use(title)
	end},

	-- Load the teleport menu
	{'Teleport', function(menu)
		local title = 'Teleport Menu'

		menu:add(title, assert(
			loadfile('/menus/teleport.lua')
		)(serverID))
		menu:use(title)

	end},

	-- Load the time menu
	{'Time', function(menu)
		local title = 'Set Time'

		menu:add(title, assert(
			loadfile('/menus/time.lua')
		)(serverID))

		menu:use(title)
	end},

	-- Load the weather menu
	{'Weather', function(menu)
		local title = 'Change Weather'

		menu:add(title, assert(
			loadfile('/menus/weather.lua')
		)(serverID))

		menu:use(title)
	end},

	-- Load the device menu
	{'Device', function(menu)
		local title = 'Device Menu'

		menu:add(title, assert(
			loadfile('/menus/device.lua')
		)(serverID))
		
		menu:use(title)
	end}
}