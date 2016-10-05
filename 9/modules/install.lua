-- v0.2.2
local update = dofile('/modules/update.lua')
local json = dofile('/modules/json.lua')

local path = '/modules.json'

local module = {
	versions = nil,

	init = function(self, args)
		local modules = {}

		-- add missing modules to a table
		for key, moduleName in ipairs(args) do
			if not fs.exists('/modules/' .. moduleName .. '.lua') then
				modules[moduleName] = ""
			end
		end

		-- update modules.json and run update
		if #modules > 0 then
			self.versions = self:getLocalVersions()

			-- add modules to versions table
			for key, val in pairs(modules) do
				self.versions[key] = val
			end

			-- save modules.json
			self:saveVersions()

			-- run update
			update()
		end
	end,

	--- Writes the versions table to the modules.json file
	-- @param self
	saveVersions = function(self)
		-- make sure file exists
		if not fs.exists(path) then return end

		-- open file for reaching
		local file = fs.open(path, 'w')
		file.write(json:encode(self.versions))
		file.close()
	end,

	--- Retrieves module names and versions from storage
	-- @param self
	-- @returns 	Returns a table containing module names as table keys and 
	--				their version numbers as table values
	getLocalVersions = function(self)
		if not fs.exists(path) then
			return
		end

		-- open file
		local file = fs.open(path, 'r')

		-- read file contents
		-- decode JSON into table
		local data = json:decode(file:readAll())
		file:close()

		-- return table
		return data
	end,
}

return function(...)
	module:init(arg)
end