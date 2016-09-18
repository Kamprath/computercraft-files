local serverID = rednet.lookup('commands', 'command_server')
if not serverID then
	term.clear()
	term.setCursorPos(1, 1)
	print('Failed to reach command server.')
	io.read()
	os.shutdown()
end

return {
	{'Creative', function()
		rednet.broadcast('mode_creative', 'commands')
	end},

	{'Survival', function()
		rednet.broadcast('mode_survival', 'commands')
	end},

	{'Back', function(menu)
		menu:back()
	end}
}