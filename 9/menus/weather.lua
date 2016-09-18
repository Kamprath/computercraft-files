local serverID = ...

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