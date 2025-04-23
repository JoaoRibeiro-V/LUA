local module = {}
module.__index = module

function module.ResizeCharacter(givenModel,scale)
	local Humanoid = givenModel:FindFirstChild("Humanoid")

	local Humanoid = givenModel:WaitForChild("Humanoid")
	local HumanoidRootPart = givenModel:WaitForChild("HumanoidRootPart")
	local Torso = givenModel:WaitForChild("Torso")

	local RootJoint = HumanoidRootPart:WaitForChild("RootJoint")
	local Neck = Torso:WaitForChild("Neck")
	local RightShoulder = Torso:WaitForChild("Right Shoulder")
	local LeftShoulder = Torso:WaitForChild("Left Shoulder")
	local RightHip = Torso:WaitForChild("Right Hip")
	local LeftHip = Torso:WaitForChild("Left Hip")

	local RootJointC0 = RootJoint.C0
	local NeckC0 = Neck.C0
	local RightShoulderC0 = RightShoulder.C0
	local LeftShoulderC0 = LeftShoulder.C0
	local RightHipC0 = RightHip.C0
	local LeftHipC0 = LeftHip.C0

	if Humanoid then

		local halfHMRSize = (givenModel.HumanoidRootPart.Size.Y / 2)
		for _, i in pairs(givenModel:GetDescendants()) do
			if i:IsA("BasePart") and i.Name ~= "HumanoidRootPart" then
				local wasCanCollide = i.CanCollide
				i.CanCollide = false
				i.Size = i.Size * scale
				i.CanCollide = wasCanCollide

			elseif i:IsA("FileMesh") and (not i:IsA("SpecialMesh") or i.MeshType == Enum.MeshType.FileMesh) then
				i.Scale = i.Scale * scale
			elseif (i:IsA("JointInstance") or i:IsA("Motor6D")) and not i.Parent.Parent:IsA("Accessory") then
				local wasAnchored = i.Part1.Anchored
				i.Part1.Anchored = false
				i.C0 = i.C0 - (i.C0.Position * (1 - scale))
				i.C1 = i.C1 - (i.C1.Position * (1 - scale))
			elseif (i:IsA("JointInstance") or i:IsA("Motor6D")) and i.Parent.Parent:IsA("Accessory") then
				local wasAnchored = i.Part1.Anchored
				i.Part1.Anchored = false
				i.C0 = i.C0 - (i.C0.Position * (0.9675 - scale))
				i.C1 = i.C1 - (i.C1.Position * (0.9675 - scale))

			elseif i:IsA("Attachment") then
				i.Position = i.Position * scale
			elseif i:IsA("Pose") then
				i.CFrame = i.CFrame - (i.CFrame.p * (1 - scale))
			elseif i:IsA("Humanoid") then
				i.HipHeight = (i.HipHeight + halfHMRSize) * scale - halfHMRSize
			elseif i:IsA("SpecialMesh") then
				i.Scale *= (scale * 1.025)
			end
		end
	end
end

return module
