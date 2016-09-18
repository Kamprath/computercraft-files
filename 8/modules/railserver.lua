--[[

Functions
=========
* Tracks rail station computers and their sequence
* Responds to requests to send carts to stations
* Tracks cart 
* Determines stations and sets their modes to route the cart to destination
* Stores station information such as computer ID, sequence, and title
* Allows new stations to be added to the system by querying all available station computers and prompting to register any unknown stations
* Provides a menu for reordering stations
* Provides an API for instructing the application to do things such as deploy the minecart or check its status.

Station Tracking
=============
The application stores information for each registered rail station. To register a new rail system, the application broadcasts a message across rednet that causes all rail station computers to return identifying information. The application determines which stations it has not stored information for and stores their information. The user is then prompted to update the order of stations using the Route Menu.
When the application starts, it broadcasts a message to determine which stations are online and loads information for system that responds, or registers any systems that the application has not stored data for.

Route Menu
==========
The route menu is a GUI that allows a user to modify the sequence of rail stations using a menu. Stations that the system has stored are displayed in a menu, in order of their position on the rail. When a menu item is selected, a second menu item is then selected to swap their positions.

Communicating with Rail Station Computers
=========================================
The application communicates over rednet with rail stations. The application can send commnands and await messages from rail station computers. The application is typically awaiting command from rednet messages.

API
===
The application also provides an API that is interfaced with using rednet messages. The API can be used to check cart status, query for the cart's location, and send carts to stations. Other applications can utilize this API to control the rail system.

Sending the Cart
================
The application deploys the cart to a specific rail station using this process:
1. Determine each station's mode 'either pass, park, or listen'
2. Send each station a message indicating the station's mode
3. Await messages from all stations confirming that they are in their required modes
4. Await message from each pass-thru station indicating that the cart has arrived
5. Await message from final station indicating that the cart has arrived

]]--

-- load required modules
return {

	stations = nil,

	apiRoutes = {
		check_cart_status
	},
	
	--- Initialize the application
	init = function(self)
		-- get online rail stations
		self:loadStations()

		-- start event-response loop
		self:listen()
	end,

	loadStations = function(self)
		-- load station data from storage
		self.stations = self:getStationData()

		-- get IDs of all online stations over rednet
		local onlineStations = self:getOnlineStations()

		-- store data for any new stations
		self.stations = self:addNewStations(onlineStations)

	end,

	listen = function(self)
		-- wait for rednet message


		-- interpret rednet message and perform action accordingly
		self:handleRednetMessage()
	end,

	handleRedNetMessage = function(self)
		-- determine if message contains API method and execute it if so
	end

}