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

	{'Lua Console', function()
		term.clear()
		term.setCursorPos(1, 1)
		shell.run('lua')
	end},

	{'Restart Server', function(menu)
		rednet.send(serverID, 'restart', 'commands')
		menu:message('Server restarted.', 2)
	end},

	{'Test Network Range', function(menu)
		while true do
			rednet.broadcast('ping')
			local senderID, msg, distance = rednet.receive(nil, 1)

			if senderID then
				menu:message('In range.')
				sleep(1)
			else
				menu:message('Out of range.')
			end
		end
	end},

	{'Shutdown', function()
		os.shutdown()
	end}
}