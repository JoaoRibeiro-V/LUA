--// Class

local Signal = {}
Signal.__index = Signal
Signal.__type = "Signal"

function Signal.__tostring()
	return Signal.__type
end

-- Constructor / Destructor

function Signal.new()
	local self = setmetatable({
		_items = {},
	}, Signal)
	return self
end

function Signal:Destroy()
	table.clear(self)
	setmetatable(self, nil)    
end

-- Methods

function Signal:Wait(Timeout: number)
	local Thread = coroutine.running()
	if Timeout then
		task.delay(Timeout, coroutine.resume, Thread)
	end
	table.insert(self._items, Thread)
	return coroutine.yield()
end

function Signal:Fire(...)
	for Key, Item in pairs(self._items) do
		if typeof(Item) == "function" then
			coroutine.wrap(Item)(...)
		elseif typeof(Item) == "thread" then
			coroutine.resume(Item, ...)
			self._items[Key] = nil
		end
	end
	return self
end

function Signal:Connect(Callback)
	local Storage = self._items
	local Connection = {
		Connected = true
	}

	function Connection:Disconnect()
		local Key = table.find(Storage, Callback)
		if Key then
			table.remove(Storage, Key)
		end
		table.clear(Connection)
	end
	table.insert(Storage, Callback)
	return self
end

-- Return

return Signal