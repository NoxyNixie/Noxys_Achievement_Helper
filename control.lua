local function read_buildable()
	global.dont_build = {}
	local s = {}
	for k,v in pairs(settings.global) do
		local _, _, t = k:find("Noxys_Achievement_Helper%-([%a-]+)")
		if t and v.value then
			s[t] = true
		end
	end

	if s["raining-bullets"] then
		global.dont_build["laser-turret"] = true
	end

	if s["logistic-network-embargo"] then
		global.dont_build["logistic-chest-active-provider"] = true
		global.dont_build["logistic-chest-requester"] = true
		global.dont_build["logistic-chest-buffer"] = true
	end

	if s["steam-all-the-way"] then
		global.dont_build["solar-panel"] = true
	end
end

local inventories = {
	defines.inventory.character_main,
	defines.inventory.character_trash,
	defines.inventory.character_vehicle,
	defines.inventory.god_main
}

script.on_init(read_buildable)
script.on_configuration_changed(read_buildable)
script.on_event(defines.events.on_runtime_mod_setting_changed, read_buildable)

script.on_event(defines.events.on_built_entity, function(e)
	if e.created_entity.type == "entity-ghost" and global.dont_build[e.created_entity.ghost_name] then
		if e.player_index then
			game.players[e.player_index].print("Achievement Helper: Blocking: " .. e.created_entity.ghost_name)
		end
		e.created_entity.destroy()
	end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(e)
	local player = game.players[e.player_index]
	if player.cursor_stack and player.cursor_stack.valid_for_read and global.dont_build[player.cursor_stack.name] then
		local i = {name = player.cursor_stack.name, count = player.cursor_stack.count}
		for _,v in pairs(inventories) do
			local inv = player.get_inventory(v)
			if inv and inv.can_insert(i) then
				player.cursor_stack.clear()
				inv.insert(i)
				player.print("Achievement Helper: Blocking: " .. i.name)
				break
			end
		end
	end
end)
