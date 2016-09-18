-- v1.0
local protocol = 'modules'
local hostname = 'repository'
local modemSide = 'left'

local split = dofile('/modules/split.lua')
local json = dofile('/modules/json.lua')

local repositoryserver = {
	versions = nil,

	-- map action names (first word of a rednet message) to method names
	routes = {
		get = 'getModule',
		versions = 'getVersions'
	},

	init = function(self)
		term.clear()
		term.setCursorPos(1, 1)
		print('Started module repository server.\n')

		rednet.open(modemSide)
		self:log('Opened modem on ' .. modemSide .. ' side', 2)

		rednet.host(protocol, hostname)
		self:log('Host set to "' .. hostname .. '" on "' .. protocol .. '" protocol', 2)

		self.versions = self:getLocalVersions()
		self:log('Loaded versions', 2)

		self:log('Listening...', 2)

		-- await and respond to rednet messsages
		while true do
			-- check if message is a valid command
			local senderID, message = rednet.receive(protocol)
			
			local args = split(message)
			local action = args[1]
			
			-- execute method that is mapped to the first word of a rednet message
			if self.routes[action] ~= nil then
				self:log('Action "' .. action .. '" requested from client ' .. senderID)
				
				local response = self[self.routes[action]](self, args)

				-- if action method returned a response, send it to the client
				if response ~= nil then
					rednet.send(senderID, response, protocol)
				end
			end
		end
	end,

	log = function(self, message, level)
		level = level or 1
		local levels = {
			colors.white,
			colors.lime,
			colors.red
		}
		local originalColor = term.getTextColor()
		local colorChanged = (levels[level] ~= originalColor)

		io.write('*')
		term.setTextColor(colors.yellow)
		io.write(' [' .. textutils.formatTime(os.time(), true) .. '] ')
		term.setTextColor(originalColor)

		if levels[level] ~= nil and colorChanged then
			term.setTextColor(levels[level])
		end

		io.write(message .. '\n')

		if colorChanged then
			term.setTextColor(originalColor)
		end
	end,

	--- Retrieves module names and versions from storage
	-- @param self
	-- @returns 	Returns a table containing module names as table keys and 
	--				their version numbers as table values
	getLocalVersions = function(self)
		if not fs.exists('/modules.json') then
			return
		end

		-- open file
		local file = fs.open('/modules.json', 'r')

		-- read file contents
		-- decode JSON into table
		local data = json:decode(file:readAll())
		file:close()

		-- return table
		return data
	end,

	getModule = function(self, args)
		if #args <= 1 then 
			self:log('Error: No module name was provided', 3)
			return
		end

		local moduleName = args[2]

		-- make sure module exists in versions table
		if not self.versions[moduleName] then return end

		-- make sure module exists in /modules
		if not fs.exists('/modules/' .. moduleName .. '.lua') then 
			self:log('Error: Source file for module "' .. moduleName .. '" does not exist.', 3)
			return 
		end

		-- get source from file
		local file = fs.open('/modules/' .. moduleName .. '.lua', 'r')
		local source = file:readAll()
		file:close()

		-- return source
		return source
	end,

	getVersions = function(self, args)
		self.versions = self:getLocalVersions()
		return json:encode(self.versions)
	end
}

return function()
	repositoryserver:init()
end