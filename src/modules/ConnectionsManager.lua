-- ConnectionManager ModuleScript
local ConnectionManager = {}

-- Table to hold player connections
ConnectionManager.PlayerConnections = {}

function ConnectionManager:AddConnection(player, connectionInfo)
	if not self.PlayerConnections[player] then
		print("CREATING PLAYER CONNECTIONS")
		self.PlayerConnections[player] = {}
	end
	if not self.PlayerConnections[player][connectionInfo.ConnectionID] then
		print("ADDING CONNECTION: " .. connectionInfo.ConnectionID)
		self.PlayerConnections[player][connectionInfo.ConnectionID] = connectionInfo
	end
end

function ConnectionManager:RemoveConnection(player, connectionInfo)
	if self.PlayerConnections[player] then
		print("REMOVING CONNECTION")
		local ConnectionID = connectionInfo.ConnectionID
		print(ConnectionID)
		if self.PlayerConnections[player][ConnectionID] then
			print("FOUND CONNECTION TO DESTROY")
			self.PlayerConnections[player][ConnectionID].Connection:Disconnect()
			if self.PlayerConnections[player][ConnectionID].OnDisconnect then
				self.PlayerConnections[player][ConnectionID].OnDisconnect()
			end
			self.PlayerConnections[player][ConnectionID] = nil
		end
	end
end
function ConnectionManager:RemoveAllConnections(player)
	if self.PlayerConnections[player] then
		for i, conn in ipairs(self.PlayerConnections[player]) do
			if conn then
				conn:Disconnect()
				if self.PlayerConnections[player][i].OnDisconnect then
					self.PlayerConnections[player][i].OnDisconnect()
				end
				self.PlayerConnections[player][i] = nil
				
				break
			end
		end
	end
end

return ConnectionManager