local serverID, protocol = ...

return {
    {'Downtown Entrance', function()
        rednet.send(serverID, 'tp_amita_entrance', protocol)
    end},

    {'Server Room', function()
		rednet.send(serverID, 'tp_amita_serverroom', protocol)
	end},

    {'Docks', function()
		rednet.send(serverID, 'tp_docks', protocol)
	end},

    {'Watchtower', function()
        rednet.send(serverID, 'tp 424 83 402', protocol)
    end},
    
    {'Back', function(menu)
        menu:back()
    end}
}