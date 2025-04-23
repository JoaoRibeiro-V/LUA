local Entities = {}
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AnimationsFolder = RS:WaitForChild("Animations")
local ContainerHandler = require(RS.Modules.EffectHandler)
local ConnectionManager = require(RS.Modules.ConnectionsManager)
local TS = game:GetService("TweenService")

Entities["Campfire"] = function(plr, character, ...)
	local Container = ContainerHandler:GetContainer(character)
	local Humanoid = character:FindFirstChild("Humanoid")
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	local PlayerGUI = plr.PlayerGui
	local InteractGUI = PlayerGUI.InteractGUI

	local Animation = AnimationsFolder.Resting
	InteractGUI:WaitForChild("Frame").Interact.Text = "[ E - Leave ]"
	local AnimationTrack = Humanoid:LoadAnimation(Animation)
	AnimationTrack:Play()
	local a1, object1 = Container:AddEffect("Action")
	local a2, object2 = Container:AddEffect("NoMove")
	local initialTick = tick()
	Humanoid.AutoRotate = false;
	local array = ...
	local Entity = array.Entity
	if Entity then
		task.wait()
		HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.CFrame.Position, Vector3.new(Entity.PrimaryPart.Position.X, HumanoidRootPart.CFrame.Position.Y, Entity.PrimaryPart.Position.Z))
	end
	
	local disconnectFunction = function()
		AnimationTrack:Stop()
		a1:Remove()
		a2:Remove()
		object1:Remove()
		object2:Remove()
		Humanoid.AutoRotate = true
		InteractGUI:WaitForChild("Frame").Interact.Text = "[ E - Interact ]"
	end
	-- initiating connection
	local Connection;Connection = RunService.Heartbeat:Connect(function(dTime)
		if (Entity.PrimaryPart.Position - HumanoidRootPart.Position).Magnitude >= 10 then
			ConnectionManager:RemoveConnection(plr,{ConnectionID = "Campfire"})
			disconnectFunction()
		end
		-- Heal 2.5% of max hp per second
		if tick() - initialTick >= 0.125 then
			initialTick = tick()
			Humanoid.Health += Humanoid.MaxHealth * 0.00125
		end
	end)
	

	return Connection, disconnectFunction

end

return Entities