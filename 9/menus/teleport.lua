local serverID, protocol = ...

return {
	{'City Entrance', function()
		rednet.send(serverID, 'tp_amita_entrance', protocol)
	end},

	{'Server Room', function()
		rednet.send(serverID, 'tp_amita_serverroom', protocol)
	end},

	{'Docks', function()
		rednet.send(serverID, 'tp_docks', protocol)
	end},

	{'Farm', function()
		rednet.send(serverID, 'tp_farm', protocol)
	end},

	{'Quartier de Lagnol', function()
		rednet.send(serverID, 'tp_quartier_de_lagnol', protocol)
	end},

	{'GPS Cluster', function()
		rednet.send(serverID, 'tp_gps_cluster', protocol)
	end},

	{'Back', function(menu)
		menu:back()
	end}
}