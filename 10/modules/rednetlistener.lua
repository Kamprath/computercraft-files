local RednetListener = {
	
	routeTable = {},

	listening = false,

	init = function(self, protocol, routes)
		-- open rednet
		if not self:open() then
			return
		end

		if routes ~= nil then 
			self:routes(routes)
		end

		return self
	end,

	routes = function(self, routesTbl)
		for name, func in pairs(routesTbl) do
			self.routeTable[name] = func
			print('Registered route ' .. name)
		end
	end,

	open = function(self)
		local sides = {'left', 'right', 'front', 'back', 'top', 'bottom'}
		for key, val in ipairs(sides) do
			if peripheral.getType(sides[key]) == 'modem' then
				rednet.open(sides[key])
				return true
			end
		end

		print('Error: No modem attached to this computer.')
		return false
	end,

	listen = function(self)
		self.listening = true

		while self.listening do
			local senderID, message, protocol = rednet.receive()

			-- if a protocol has been specified, ignore message if it isn't on the correct protocol
			if self.protocol == nil or (self.protocol ~= nil and protocol == self.protocol) then
				if self.routeTable[message] ~= nil then
					self.routeTable[message]()
				end
			end
		end
	end

}

return {
	new = function(protocol, routes)
		return RednetListener:init(protocol, routes)
	end
}