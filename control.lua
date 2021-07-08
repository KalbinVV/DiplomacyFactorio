script.on_event(defines.events.on_player_created,
  function(event)
    player = game.get_player(event.player_index); -- Получаем игрока
    if player.force.name == "player" then
    	player.print("Данный сервер использует мод, добавляющий возможности дипломатии в игру! Разработчик: Qurao.");
    	player.force = game.create_force(player.name);
    	player.color = {g=math.random(0,255),b=math.random(0,255),r=math.random(0,255),a=1.0};
    	player.print("Ваша команда: " .. player.force.name);
    	for key in pairs(game.forces) do
    		if game.forces[key].name ~= "enemy" and game.forces[key].name ~= "neutral" then
    			game.forces[key].set_friend(game.forces[player.name].name, true);
    			game.forces[player.name].set_friend(game.forces[key].name, true);
    		end
    	end
    end
 end)
script.on_event(defines.events.on_console_chat,
function(event)
  player = game.get_player(event.player_index);
  message = event.message;
  for key in pairs(game.players) do
  	if game.players[key].name ~= player.name then
  		if player.force.get_friend(game.forces[key].name) then
  			game.players[key].print("[Союз] " .. player.name .. ": " .. message, player.color);
  		elseif player.force.get_cease_fire(game.forces[key].name) then
  			game.players[key].print("[Нейтралитет] " .. player.name .. ": " .. message, player.color);
  		else
  			game.players[key].print("[Война] " .. player.name .. ": " .. message, player.color);
  		end
  	end
  end
end)
commands.add_command("war", nil, function(command)
	player = game.get_player(command.player_index);
	parameters = command.parameter;
	if parameters ~= "enemy" then
		check = false;
		for key in pairs(game.forces) do
			if game.forces[key].name == parameters then
				check = true;
			end
		end
		if check == true then
			game.forces[game.forces[player.name].name].set_friend(game.forces[parameters].name, false);
			game.forces[game.forces[parameters].name].set_friend(game.forces[player.name].name, false);
			game.forces[game.forces[player.name].name].set_friend(game.forces[parameters].name, false);
			game.forces[game.forces[parameters].name].set_friend(game.forces[player.name].name, false);
			player.print("Вы успешно изменили отношения!");
			for key in pairs(game.players) do
				game.players[key].print(player.name .. " объявил войну " .. parameters);
			end
		else
			player.print("Такой фракции не существует!");
		end
	else
		player.print("Вы не можете объявить войну дефолтной фракции!");
	end
end)
commands.add_command("cease", nil, function(command)
	player = game.get_player(command.player_index);
	parameters = command.parameter;
	if parameters ~= "enemy" then
		check = false;
		for key in pairs(game.forces) do
			if game.forces[key].name == parameters then
				check = true;
			end
		end
		if check == true then
			game.forces[game.forces[player.name].name].set_friend(game.forces[parameters].name, false);
			game.forces[game.forces[parameters].name].set_friend(game.forces[player.name].name, false);
			game.forces[game.forces[player.name].name].set_cease_fire(game.forces[parameters].name, true);
			game.forces[game.forces[parameters].name].set_cease_fire(game.forces[player.name].name, true);
			player.print("Вы успешно изменили отношения!");
			for key in pairs(game.players) do
				game.players[key].print(player.name .. " заключил нейтралитет с " .. parameters);
			end
		else
			player.print("Такой фракции не существует!");
		end
	else
		player.print("Вы не можете заключить нейтралитет с дефолтной фракции!");
	end
end)
commands.add_command("peace", nil, function(command)
	player = game.get_player(command.player_index);
	parameters = command.parameter;
	if parameters ~= "enemy" then
		check = false;
		for key in pairs(game.forces) do
			if game.forces[key].name == parameters then
				check = true;
			end
		end
		if check == true then
			game.forces[game.forces[player.name].name].set_cease_fire(game.forces[parameters].name, false);
			game.forces[game.forces[parameters].name].set_cease_fire(game.forces[player.name].name, false);
			game.forces[game.forces[player.name].name].set_friend(game.forces[parameters].name, true);
			game.forces[game.forces[parameters].name].set_friend(game.forces[player.name].name, true);
			for key in pairs(game.players) do
				game.players[key].print(player.name .. " заключил союз с " .. parameters);
			end
		else
			player.print("Такой фракции не существует!");
		end
	else
		player.print("Вы не можете заключить мир с дефолтной фракции!");
	end
end)
commands.add_command("diplomacy", nil, function(command)
	player = game.get_player(command.player_index);
	for key in pairs(game.forces) do
		if game.forces[key].name ~= "player" and game.forces[key].name ~= "neutral" and game.forces[key].name ~= "enemy" then
			if player.force.get_friend(game.forces[key].name) then
				player.print(key .. " статус: Союз");
			elseif player.force.get_cease_fire(game.forces[key].name) then
				player.print(key .. " статус: Нейтралитет");
			else
				player.print(key .. " статус: Война");
			end
		end
	end
end)
