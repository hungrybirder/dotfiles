local logger = hs.logger.new("surge", "INFO")

local function SSIDChangedCB()
	local currentSSID = hs.wifi.currentNetwork()
	if currentSSID == nil then
		return
	end

	local surge_app = hs.application.get("Surge")
	if currentSSID == "TT-Goat" then
		logger.v("currentSSID is TT-Goat")
		if surge_app ~= nil and surge_app:isRunning() then
			surge_app:kill()
			logger.v("Surge is killed")
		end
	else
		logger.v("currentSSID is TT-Goat")
		if surge_app == nil or not surge_app:isRunning() then
			hs.application.launchOrFocus("Surge")
			logger.v("Surge is launched")
		end
	end
end

local wifiWatcher = hs.wifi.watcher.new(SSIDChangedCB)
wifiWatcher:start()
