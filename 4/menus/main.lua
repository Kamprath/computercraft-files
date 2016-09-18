local testMenu = dofile('/menus/test.lua')

return {
	{'Shutdown Computer', function()
		os.shutdown()
	end},

	{'Test Menu', function(menu)
		menu:add('Test Menu', testMenu)
		menu:use('Test Menu')
	end},

	{'Close', function(menu)
		menu:back()
	end}
}