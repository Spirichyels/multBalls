extends Node2D

var maxPlayers 
var deadPlayers = 0
var round_ended = false

var processing = []

var ui_lose_window

func _ready() -> void:
	ui_lose_window = get_tree().get_first_node_in_group("lose_window")
	await get_tree().process_frame  # ждём кадр
	maxPlayers = get_tree().get_nodes_in_group("players")
	
	

func _restart_game():
	
	
	if not multiplayer.is_server(): return
	print("_restart_game это " + (" сервер" if multiplayer.is_server() else " клиент"))

	round_ended = false
	# Сбрасываем счётчики на сервере
	maxPlayers = get_tree().get_nodes_in_group("players")
	deadPlayers = 0
	
	#print("round_ended: ", round_ended, "maxPlayers.size(): ",maxPlayers.size(), " deadPlayers: ", deadPlayers)
	
	restart_clients.rpc()
	
	
	
@rpc("call_local")
func restart_clients():
	print("restart_clients это " + (" сервер" if multiplayer.is_server() else " клиент"))
	#if multiplayer.is_server(): 
		#return
	# Сбрасываем всё на клиентах
	
	
	deadPlayers = 0
	maxPlayers = get_tree().get_nodes_in_group("players")
	#
	print("round_ended: ", round_ended, "maxPlayers.size(): ",maxPlayers.size(), " deadPlayers: ", deadPlayers)
	for player in maxPlayers:
		player.reborn.rpc()
	#
	# Скрываем UI
	await get_tree().create_timer(1.0).timeout
	ui_lose_window.visible = false

@rpc("call_local")
func kill_player(_id: String):
	
	for player in maxPlayers:
		if player.name == _id:
			player.orDead = true
			#print("player_name: ", name, " player.id: ", player.id, "body.orDead: ", player.orDead)	
			break

	
func _lose(body):
	maxPlayers = get_tree().get_nodes_in_group("players")
	
	#проверка только на сервере	
	if not multiplayer.is_server(): return
	if round_ended: return
	if body.orDead: return
	if body.has_meta("processing"): return  # проверка метки
	
	body.set_meta("processing", true)  # ставим метку
	print("_lose это " + (" сервер" if multiplayer.is_server() else " клиент"))
	
	#убиваем лузера
	body.orDead = true
	
	
	# Рассылаем клиентам, чтобы они тоже убили этого игрока
	kill_player.rpc(body.name)
	#print("player_name: ", body.name, "orDead: ", body.orDead)
	
	
	if multiplayer.is_server():
		#print("maxPlayers ", maxPlayers.size() , (" сервер" if multiplayer.is_server() else " клиент"))
		pass
	
	deadPlayers +=1
	if multiplayer.is_server():
		#print("deadPlayers: ", deadPlayers)
		pass

	# Проверяем на сервере
	if deadPlayers + 1 == maxPlayers.size():
		round_ended = true
		for player in maxPlayers:
			if not player.orDead:
				HightLevelNetworkHandler.up_score_player(str(player.name),player.nickname, 1)
				var _score = int(HightLevelNetworkHandler.get_result(str(player.name)))
				print(HightLevelNetworkHandler.players)
				player.orDead = true
				kill_player.rpc(player.name)
				if _score >= HightLevelNetworkHandler.max_score_to_win:
					show_game_over_clients.rpc(str(player.player_name_label.text), " окончательно победил")
					await HightLevelNetworkHandler.game_again_restart
					next_round()
					pass
				
				else:
					show_game_over_clients.rpc(str(player.player_name_label.text)," выиграл раунд")
					#HightLevelNetworkHandler.up_score_player(player.id, player.player_name_label.text, 1)
					next_round()
				break
	
	
	await get_tree().create_timer(0.9).timeout
	body.remove_meta("processing")  # убираем метку
	

func next_round():
	if not multiplayer.is_server(): return
	if not round_ended: return
	#print("next_round это " + (" сервер" if multiplayer.is_server() else " клиент"))
	
	await get_tree().create_timer(1.0).timeout
	processing.clear()
	print("игра закончилась, запускаю рестарт игры")
	_restart_game()
	
	
	


@rpc("call_local")
func show_game_over_clients(winner, text):
	if multiplayer.is_server(): return
	print("show_game_over_clients это " + ("сервер" if multiplayer.is_server() else "клиент"))
	var xren= winner + text
	ui_lose_window.update_loser_text(str(xren))
	ui_lose_window.visible = true

	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		if not body.orDead and round_ended == false:
			#print("_on_area_2d_body_entered это " + ("сервер" if multiplayer.is_server() else "клиент"))
			_lose(body)
		pass # Replace with function body.
