local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local fx = require(ReplicatedStorage.Modules.EffectsModule)

local TweenService = game:GetService("TweenService")

local RemoteHandler = require(ReplicatedStorage.Modules.RemoteHandler)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local TS = game:GetService("TweenService")

local function newRep(part)
	task.spawn(function()
		local success, err = pcall(function()

			local values = part:GetChildren()
			local variables = {}

			for i,v in pairs(values) do
				variables[v.Name] = v.Value
			end

			fx[part.Name](variables)
		end)
		if err then
			warn(err .. " SKILL NAME: " .. part.Name )
		end
	end)
end


for _, v in pairs(workspace.Replication:GetChildren()) do
	newRep(v)
end

workspace.Replication.ChildAdded:Connect(function(v)	
	newRep(v)
end)

local currentEntity = nil

local EntityHighlight = Instance.new("Highlight")
EntityHighlight.DepthMode = Enum.HighlightDepthMode.Occluded
EntityHighlight.FillTransparency = 0.75
EntityHighlight.OutlineTransparency = 0.5
EntityHighlight.FillColor = Color3.fromRGB(240, 240, 240)
EntityHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)

local PlayerGUI = player.PlayerGui

local EntitiesModule = require(game:GetService("StarterPlayer").StarterPlayerScripts["LocalEntities"])
local entityDebounce = false

for i, Entity in pairs(workspace:WaitForChild("Interact"):GetChildren()) do
	local proximity = Entity:WaitForChild("Proximity"):FindFirstChildWhichIsA("ProximityPrompt")
	if proximity then
		
		proximity.Triggered:Connect(function()
			if entityDebounce then return end
			entityDebounce = true
			task.delay(0.5, function()
				entityDebounce = false
			end)
			local char = player.Character
			local returnedArray = {}
			if currentEntity == Entity then
				currentEntity, returnedArray = EntitiesModule[Entity.Name](player,char,{Trigger = true; Sender = Entity})
			else
				currentEntity, returnedArray = EntitiesModule[Entity.Name](player,char,{Trigger = false; Sender = Entity})
			end
			
		end)
		proximity.PromptShown:Connect(function()
			local InteractGUI = PlayerGUI:WaitForChild("InteractGUI")
			local InteractLabel = InteractGUI["Frame"]:FindFirstChild("Interact")
			
			local customText = Entity:GetAttribute("CustomText")
			if customText then
				InteractLabel.Text = "[ E - " .. customText .. " ]"
			else
				InteractLabel.Text = "[ E - Interact ]"
			end

			local tween = TS:Create(InteractLabel, TweenInfo.new(0.25), {TextStrokeTransparency = 0.5; TextTransparency = 0.15})
			tween:Play()
			EntityHighlight.Parent = Entity
			TS:Create(EntityHighlight, TweenInfo.new(0.5), {FillTransparency = 0.75; OutlineTransparency = 0.5}):Play()

		end)
		proximity.PromptHidden:Connect(function()
			local InteractGUI = PlayerGUI:WaitForChild("InteractGUI")
			local InteractLabel = InteractGUI["Frame"]:FindFirstChild("Interact")
			
			currentEntity = nil
			local tween = TS:Create(InteractLabel, TweenInfo.new(0.25), {TextStrokeTransparency = 1; TextTransparency = 1})
			tween:Play()
			TS:Create(EntityHighlight, TweenInfo.new(0.5), {FillTransparency = 1; OutlineTransparency = 1}):Play()
			task.wait(0.5)
			EntityHighlight.Parent = ReplicatedStorage.Assets

		end)
	end
	
end