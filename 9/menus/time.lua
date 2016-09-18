local serverID = rednet.lookup('commands', 'command_server')
if not serverID then
	term.clear()
	term.setCursorPos(1, 1)
	print('Failed to reach command server.')
	io.read()
	os.shutdown()
end
return {
	{'Morning', function()
		rednet.send(serverID, 'time_morning', 'commands')
	end},

	{'Noon', function()
		rednet.send(serverID, 'time_noon', 'commands')
	end},

	{'Evening', function()
		rednet.send(serverID, 'time_evening', 'commands')
	end},

	{'Night', function()
		rednet.send(serverID, 'time_night', 'commands')
	end},

	{'Back', function(menu)
		menu:back()
	end}
}