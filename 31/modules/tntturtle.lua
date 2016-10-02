local split = dofile('/modules/split.lua')

local module = {
	axis = {
		x = false, 
		y = false,
		forward = false
	},

	init = function(self)
		rednet.open('left')
		redstone.setOutput('bottom', true)
		self:calibrate()
		return self
	end,

	listen = function(self)
		while true do
			print('* Awaiting command...')
			local senderID, msg = rednet.receive('tnt_turtle')

			local args = split(msg)

			if args[1] == 'drop' and #args == 4 then
				self:drop(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
				rednet.send(senderID, 'ok', 'tnt_turtle')
			elseif args[1] == 'move' and #args == 4 then
				self:move(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
				rednet.send(senderID, 'Turtle returned home.', 'tnt_turtle')
			end
		end
	end,

	--- Calibrate turtle position on X-Y coordinate plane
	calibrate = function(self)
		 -- get position
		originX, originY, originZ = gps.locate(5)

		if originX == nil then
			print('* Failed to reach GPS host.')
			return
		end

		 -- move forward one
		turtle.forward()

		-- get position
		local newX, newY, newZ
		while newX == nil do
			newX, newY, newZ = gps.locate(5)
		end
		sleep(.5)

		turtle.back()

		-- if x position changed, set X axis to true
		if newX ~= originX then
			self.axis.x = true
			-- if moving forward decreased X position, turn turtle around
			if newX < originX then
				turtle.turnRight()
				turtle.turnRight()
			end
		elseif newY ~= originY then
			self.axis.y = true
			-- if moving forward decreased Y position, turn turtle around
			if newY < originY then
				turtle.turnRight()
				turtle.turnRight()
			end
		end

		self.axis.forward = true
		print('* Calibrated.')
	end,

	moveTo = function(self, x, y, z)
		local currentX, currentY, currentZ = gps.locate(5)
		if currentX == nil then
			print('* Failed to reach GPS host.')
			return
		end

		-- move to Z position
		if z > currentZ then
			while currentZ < z do
				turtle.up()
				currentZ = currentZ + 1
			end
		else
			while currentZ > z do
				turtle.down()
				currentZ = currentZ - 1
			end
		end

		-- MOVE X
		if not self.axis.x then
			if self.axis.forward then
				if x > currentX then
					turtle.turnRight()
				else
					turtle.turnLeft()
					self.axis.forward = false
				end
			else
				if x > currentX then
					turtle.turnLeft()
					self.axis.forward = true
				else
					turtle.turnRight()
				end
			end

			self.axis.x = true
			self.axis.y = false
		end
		if self.axis.forward then
			while currentX <= x do
				if not self.forward() then return end
				currentX = currentX + 1
			end
		else
			while currentX >= x do
				if not self.forward() then return end
				currentX = currentX - 1
			end
		end

		-- MOVE Y
		if not self.axis.y then
			if self.axis.forward then
				if y > currentY then
					turtle.turnLeft()
				else
					turtle.turnRight()
					self.axis.forward = false
				end
			else
				if y > currentY then
					turtle.turnRight()
					self.axis.forward = true
				else
					turtle.turnLeft()
				end
			end

			self.axis.y = true
			self.axis.x = false
		end
		if self.axis.forward then
			while currentY <= y do
				if not self.forward() then return end
				currentY = currentY + 1
			end
		else
			while currentY >= y do
				if not self.forward() then return end
				currentY = currentY - 1
			end
		end

		return true
	end,

	forward = function()
		if turtle.getFuelLevel() == 0 then
			rednet.broadcast('Turtle is out of fuel.', 'tnt_turtle')
			print('* Turtle out of fuel')
			return false
		end

		if not turtle.forward() then
			rednet.broadcast('Turtle is obstructed!', 'tnt_turtle')
			print('* Turtle is obstructed')
			return false
		end

		return true
	end,

	drop = function(self, x, y, z)
		local currentX, currentY, currentZ = gps.locate(3)
		if currentX == nil then
			print('* Failed to reach GPS host.')
			return
		end

		local climb = 10

		if currentX ~= nil then 
			if self:moveTo(x, y, z+climb) then
				-- drop payload
			turtle.placeDown()
			turtle.placeDown()
			turtle.placeDown()

			rednet.broadcast('Payload delivered.', 'tnt_turtle')

			-- return to original position
			self:calibrate()
			self:moveTo(currentX, currentY, currentZ+climb)

			local i = currentZ+climb
			while i >= (currentZ-1) do
				turtle.down()
				i = i - 1
			end

			self:calibrate()
			end
		end
	end,

	move = function(self, x, y, z)
		local climb = 10
		self:moveTo(x, y, z+climb)

		local i = z+climb
		while i >= (z-1) do
			turtle.down()
			i = i - 1
		end

		self:calibrate()
	end
}

return {
	new = function()
		return module:init()
	end
}