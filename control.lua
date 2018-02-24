local dont_build = require("dont_build")

script.on_event(defines.events.on_built_entity, function(e)
	if e.created_entity.type == "entity-ghost" and dont_build[e.created_entity.ghost_name] then
		if e.player_index then
			game.players[e.player_index].print("Achievement Helper: Blocking: " .. e.created_entity.ghost_name)
		end
		e.created_entity.destroy()
	end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(e)
	local player = game.players[e.player_index]
	if player.cursor_stack and player.cursor_stack.valid_for_read and dont_build[player.cursor_stack.name] then
		local i = {name = player.cursor_stack.name, count = player.cursor_stack.count}
		for _,v in pairs{
			defines.inventory.player_quickbar,
			defines.inventory.player_main,
			defines.inventory.player_trash,
			defines.inventory.player_vehicle,
			defines.inventory.god_quickbar,
			defines.inventory.god_main
		} do
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
