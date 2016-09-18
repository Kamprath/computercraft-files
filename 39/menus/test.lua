return {
	{'Option 1', function(menu)
		menu:message('Option 1 selected.', 2)
	end},

	{'Option 2', function(menu)
		menu:message('Option 2 selected.', 2)
	end},

	{'Back', function(menu)
		menu:back()
	end}
}