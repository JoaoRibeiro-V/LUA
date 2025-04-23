local Entities = {}
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AnimationsFolder = RS:WaitForChild("Animations")
local ContainerHandler = require(RS.Modules.EffectHandler)
local TS = game:GetService("TweenService")

Entities["Campfire"] = function(plr, character, ...)
	local Container = ContainerHandler:GetContainer(character)
	local Humanoid = character:FindFirstChild("Humanoid")
	local array = ...
	local trigger = array["Trigger"]
	local sender = array["Sender"]
	local depthoffield = game.Lighting:FindFirstChildWhichIsA("DepthOfFieldEffect")
	if trigger == false then
		
		TS:Create(depthoffield, TweenInfo.new(0.5), {
			FarIntensity = 0.25;
			FocusDistance = 1;
			InFocusRadius = 50;
			NearIntensity = 1;
		})
		RS.Remotes.Entity:FireServer(character, true,"Campfire", {Entity = sender})
	else
		TS:Create(depthoffield, TweenInfo.new(0.5), {
			FarIntensity = 0.215;
			FocusDistance = 1;
			InFocusRadius = 200;
			NearIntensity = 1;
		}):Play()
		RS.Remotes.Entity:FireServer(character, false,"Campfire", {Entity = sender})
		return nil, array
	end
	return sender, array
end

return Entities
