local serverID = ...

return {
	{'Lua Console', function()
		term.clear()
		term.setCursorPos(1, 1)
		shell.run('lua')
	end},

	{'Restart Command Server', function(menu)
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
	end},

	{'Back', function(menu)
		menu:back()
	end}

}