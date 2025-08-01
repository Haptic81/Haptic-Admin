G_["reset"] = function()
	local Players = game["GetService"]("Players")
	local LocalPlayer = Players["LocalPlayer"]
	local Character = LocalPlayer["Character"]
	if Character then
		Character:BreakJoints()
	end
end
