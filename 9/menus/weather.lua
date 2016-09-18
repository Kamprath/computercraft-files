local serverID = rednet.lookup('commands', 'command_server')
if not serverID then
	term.clear()
	term.setCursorPos(1, 1)
	print('Failed to reach command server.')
	io.read()
	os.shutdown()
end

return {
	{'Clear', function()
		rednet.send(serverID, 'weather_clear', 'commands')
	end},

	{'Rain', function()
		rednet.send(serverID, 'weather_rain', 'commands')
	end},

	{'Thunder', function()
		rednet.send(serverID, 'weather_thunder', 'commands')
	end},

	{'Back', function(menu)
		menu:back()
	end}
}