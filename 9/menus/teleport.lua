local serverID, protocol = ...

local menuinterface = dofile('/modules/menuinterface.lua')

return {
	{'Amida...', function(menu)
		local title = 'Amida Locations' 
		menu:add(title, menuinterface.load('teleport_amida', serverID, protocol))
		menu:use(title)
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

	{'Enter Coordinates...', function(menu)
		term.clear()
		term.setCursorPos(1, 1)
		
		io.write('X: ')
		local x = io.read()

		io.write('Y: ')
		local y = io.read()

		io.write('Z: ')
		local z = io.read()

		if x and y and z then
			rednet.send(serverID, 'tp ' .. x .. ' ' .. y .. ' ' .. z, protocol)
		end

		menu:message('Teleported.', 2)
	end},

	{'Back', function(menu)
		menu:back()
	end}
}