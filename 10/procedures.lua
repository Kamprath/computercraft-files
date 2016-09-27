local username = 'ravroid'

return {
	mode_creative = function()
		commands.exec('gamemode 1 ' .. username)
	end,

	mode_survival = function()
		commands.exec('gamemode 0 ' .. username)
	end,

	time_morning = function()
		commands.exec('time set 0')
	end,

	time_noon = function()
		commands.exec('time set 6000')
	end,

	time_evening = function()
		commands.exec('time set 9000')
	end,

	time_night = function()
		commands.exec('time set 14000')
	end,

	weather_clear = function()
		commands.exec('weather clear')
	end,

	weather_rain = function()
		commands.exec('weather rain')
	end,

	weather_thunder = function()
		commands.exec('weather thunder')
	end,

	tp_amita_entrance = function()
		commands.exec('tp ' .. username .. ' 351 74 260')
	end,

	tp_amita_serverroom = function()
		commands.exec('tp ' .. username .. ' 351 85 337')
	end,

	tp_docks = function()
		commands.exec('tp ' .. username .. ' 416 64 195')
	end,

	tp_quartier_de_lagnol = function()
		commands.exec('tp ' .. username .. ' 356 71 561')
	end,

	tp_farm = function()
		commands.exec('tp ' .. username .. ' 223 67 300')
	end,

	restart = function()
		os.reboot()
	end
}