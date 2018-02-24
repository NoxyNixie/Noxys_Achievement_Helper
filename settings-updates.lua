for k,v in pairs(data.raw["bool-setting"]) do
	local _, _, t = k:find("Noxys_Achievement_Helper%-([%a-]+)")
	if t then
		v.localised_name = {"mod-setting-name.Noxys_Achievement_Helper-assist", {"achievement-name." .. t}}
	end
end
