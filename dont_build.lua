local dont_build = {}

local s = {}
for k,_ in pairs(settings.startup) do
	local _, _, t = k:find("Noxys_Achievement_Helper%-([%a-]+)")
	if t then
		s[t] = true
	end
end

if s["raining-bullets"] then
	dont_build["laser-turret"] = true
end

if s["logistic-network-embargo"] then
	dont_build["logistic-chest-active-provider"] = true
	dont_build["logistic-chest-requester"] = true
	dont_build["logistic-chest-buffer"] = true
end

if s["steam-all-the-way"] then
	dont_build["solar-panel"] = true
end

return dont_build