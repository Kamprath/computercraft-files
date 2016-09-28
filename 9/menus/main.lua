local menuinterface = dofile('/modules/menuinterface.lua')
local tntturtleremote = dofile('/modules/tntturtleremote.lua')
local serverID, protocol = ...

return {
	-- Load gamemode menu
	{'Gamemode', function(menu)
		local title = 'Select a Gamemode' 
		menu:add(title, menuinterface.load('gamemode', serverID, protocol))
		menu:use(title)
	end},

	-- Load the teleport menu
	{'Teleport', function(menu)
		local title = 'Teleport Menu'
		menu:add(title, menuinterface.load('teleport', serverID, protocol))
		menu:use(title)
	end},

	-- Load the time menu
	{'Time', function(menu)
		local title = 'Set Time'
		menu:add(title, menuinterface.load('time', serverID, protocol))
		menu:use(title)
	end},

	-- Load the weather menu
	{'Weather', function(menu)
		local title = 'Change Weather'
		menu:add(title, menuinterface.load('weather', serverID, protocol))
		menu:use(title)
	end},

	{'TNT Turtle', function(menu)
		tntturtleremote(menu)
	end},

	-- Load the device menu
	{'Device', function(menu)
		local title = 'Device Menu'
		menu:add(title, menuinterface.load('device', serverID, protocol))
		menu:use(title)
	end}
}