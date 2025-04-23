local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local RS = game:GetService("ReplicatedStorage")
local Cache = {}
local Signal = require(RS.Modules.Signal)

--// Function(s)

function Create(ClassName: string, Properties: {any})
	local Object = Instance.new(ClassName) do
		for Property, Value in pairs(Properties) do
			if typeof(Value) == "Instance" and Property ~= "Parent" then
				Value.Parent = Object
			elseif Property ~= "Parent" then
				Object[Property] = Value
			end
		end
		local Parent = Properties.Parent
		if Parent then
			Object.Parent = Parent
		end
	end
	return Object
end

--// Replicator

local Replicator = {}

local ValueList = {
	"Accessory";
	"NumberValue";
	"IntValue";
	"StringValue";
	"ObjectValue"
}

function Replicator:GetContainer(Character)
	local Container = Cache[Character]
	
	Character:WaitForChild("Humanoid", 9e9).Died:Connect(function()
		if script:FindFirstChild(Character.Name) then
			script:FindFirstChild(Character.Name):Destroy()
		end
	end)
	
	if not Container then
		local Storage = Character:WaitForChild("Effects")
		local Temp = {}

		local New = {}

		function New:AddEffect(Name: string, ClassName,Value)
			if not ClassName then
				ClassName = "Accessory"
			end
			local Object = Instance.new(ClassName)
			if ClassName ~= "Accessory" and Value then
				Object.Value = Value
			end
			Object.Name = Name
			Object.Parent = Storage
			local Effect = {}

			function Effect:Debris(Lifetime: number)			
				task.spawn(function()
					task.wait(Lifetime)
					
					Object:Destroy()
					Temp[Object] = nil
					table.clear(Effect)
				end)

				return Effect
			end

			function Effect:Remove()
				Object:Destroy()
				Temp[Object] = nil
				table.clear(Effect)
			end
			
			function Effect:InstanceTag(name)
				if Object then
					local Tag = Instance.new("Accessory")
					Tag.Name = name
					Tag.Parent = Object
				end
				
				return Effect
			end
			
			
			
			return Effect, Object
		end
		
		function New:MindfulRemove(Name: string, All: boolean | nil)
			if All then
				for _, Tag in pairs(Storage:GetChildren()) do
					if Tag.Name == Name and not Tag:FindFirstChild("NoDelete") then
						Tag:Destroy()
						local Table = Temp[Tag]
						if Table then
							table.clear(Table)
							Temp[Tag] = nil
						end
					end
				end
			else
				local Tag = Storage:FindFirstChild(Name)
				if Tag and not Tag:FindFirstChild("NoDelete") then
					Tag:Destroy()
					local Table = Temp[Tag]
					if Table then
						table.clear(Table)
						Temp[Tag] = nil
					end
				end
			end
		end

		function New:RemoveEffect(Name: string, All: boolean | nil)
			if All then
				for _, Tag in pairs(Storage:GetChildren()) do
					if Tag.Name == Name then
						Tag:Destroy()
						local Table = Temp[Tag]
						if Table then
							table.clear(Table)
							Temp[Tag] = nil
						end
					end
				end
			else
				local Tag = Storage:FindFirstChild(Name)
				if Tag then
					Tag:Destroy()
					local Table = Temp[Tag]
					if Table then
						table.clear(Table)
						Temp[Tag] = nil
					end
				end
			end
		end

		function New:HasEffect(Name)
			if typeof(Name) ~= "string" then
				for _,v in pairs(Name) do
					local yurr = Storage:FindFirstChild(v)
					if yurr then
						return yurr
					end
				end
				
				return false
			end
			
			if Storage:FindFirstChild(Name) then
				return Storage:FindFirstChild(Name)
			else
				return nil
			end
		end
		
		function New:HasEffects(Names: {string})
			for _,v in pairs(Names) do
				if Storage:FindFirstChild(v) then
					return Storage:FindFirstChild(v)
				end
			end
			return false
		end
		
		function New:WaitForEffect(Name: string, Timeout: number)
			local Thread = coroutine.running()
			if Timeout then
				task.delay(Timeout, coroutine.resume, Thread)
			end
			table.insert(Temp, Thread)
			return coroutine.yield()
		end
		function New:DestroyAllEffects()
			table.clear(Temp)
			for _,v in pairs(Storage:GetChildren()) do
				v:Destroy()
			end
		end

		function New:Destroy()
			for Key, Item in pairs(Temp) do
				if typeof(Item) == "RBXScriptConnection" then
					Item:Disconnect()
				elseif typeof(Item) == "table" then
					Item:Remove()
				end
				Temp[Key] = nil
			end
			Storage:Destroy()
			Cache[Character] = nil
			table.clear(New)
		end

		Container,Cache[Character] = New,Container
	end
	return Container
end

return Replicator