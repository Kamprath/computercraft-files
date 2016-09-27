-- v0.3

-- todo: move logging functionality from module repository server into its own module and use it in this module
-- local log = dofile('/modules/log.lua')

--- This application acts as an RPC server over rednet.
local rednetrpc = {
	
	-- rednet host info
	protocol = 'rpc',
	hostname = 'rpc_server',
	
	-- procedures table
	procedures = {},

	-- indicates if the application is listening for procedure calls over rednet
	listening = false,

	init = function(self, procedures, hostname)
		if hostname ~= nil then 
			self.hostname = hostname 
		end

		-- open rednet
		if not self:open() then
			return
		end

		-- register procedures, if provided
		if procedures ~= nil then 
			self:registerProcedures(procedures)
		end

		return self
	end,

	registerProcedures = function(self, procedures)
		for name, func in pairs(procedures) do
			self.procedures[name] = func
			print('Registered procedure ' .. name)
		end
	end,

	open = function(self)
		local sides = {'left', 'right', 'front', 'back', 'top', 'bottom'}
		for key, val in ipairs(sides) do
			if peripheral.getType(sides[key]) == 'modem' then
				rednet.open(sides[key])
				rednet.host(self.protocol, self.hostname)

				return true
			end
		end

		print('Error: No modem attached to this computer.')
		return false
	end,

	listen = function(self)
		self.listening = true

		while self.listening do
			local senderID, procedureName, protocol = rednet.receive()

			-- if a protocol has been specified, ignore procedureName if it isn't on the correct protocol
			if self.protocol == nil or (self.protocol ~= nil and protocol == self.protocol) then
				if self.procedures[procedureName] ~= nil then
					self.procedures[procedureName]()
				end
			end
		end
	end

}

return {
	new = function(procedures, hostname)
		return rednetrpc:init(procedures, hostname)
	end
}