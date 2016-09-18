local serverID = ...

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