local tntturtle = dofile('/modules/tntturtle.lua')
tntturtle:init()

return {
	test = function()
		return "Procedure loaded from procedures.lua"
	end,

	move = function(args)
		local x = tonumber(args[2])
		local y = tonumber(args[3])
		local z = tonumber(args[4])

		if x == nil or y == nil or z == nil then
			return "GPS coordinates required"
		end

		tntturtle:move(x, y, z)
		
		return 'Turtle returned to home'
	end,

	bomb = function(args)
		tntturtle:drop(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
		return 'ok'
	end,
}