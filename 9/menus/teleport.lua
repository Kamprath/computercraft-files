local serverID = rednet.lookup('commands', 'command_server')
if not serverID then
	term.clear()
	term.setCursorPos(1, 1)
	print('Failed to reach command server.')
	io.read()
	os.shutdown()
end
return {
	{'City Entrance', function()
		rednet.send(serverID, 'tp_amita_entrance', 'commands')
	end},

	{'Server Room', function()
		rednet.send(serverID, 'tp_amita_serverroom', 'commands')
	end},

	{'Docks', function()
		rednet.send(serverID, 'tp_docks', 'commands')
	end},

	{'Farm', function()
		rednet.send(serverID, 'tp_farm', 'commands')
	end},

	{'Quartier de Lagnol', function()
		rednet.send(serverID, 'tp_quartier_de_lagnol', 'commands')
	end},

	{'Back', function(menu)
		menu:back()
	end}
}