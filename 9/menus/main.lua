local serverID = rednet.lookup('commands', 'command_server')
if not serverID then
	term.clear()
	term.setCursorPos(1, 1)
	print('Failed to reach command server.')
	io.read()
	os.shutdown()
end

return {
	-- Display gamemode menu
	{'Gamemode', function(menu)
		local title = 'Select a Gamemode' 
		menu:add(title, dofile('/menus/gamemode.lua'))
		menu:use(title)
	end},

	{'Teleport', function(menu)
		local title = 'Teleport Menu'
		menu:add(title, dofile('/menus/teleport.lua'))
		menu:use(title)
	end},

	{'Time', function(menu)
		local title = 'Set Time'
		menu:add(title, dofile('/menus/time.lua'))
		menu:use(title)
	end},

	{'Weather', function(menu)
		local title = 'Change Weather'
		menu:add(title, dofile('/menus/weather.lua'))
		menu:use(title)
	end},

	{'Device', function(menu)
		local title = 'Device Menu'
		menu:add(title, dofile('/menus/device.lua'))
		menu:use(title)
	end}
}