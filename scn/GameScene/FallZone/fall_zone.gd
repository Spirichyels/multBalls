extends Node2D

var players_in_game = []
var maxPlayers 
var deadPlayers = 0


func _lose(body):
	#body.visible = false
	#print(body.name, " lose")
	maxPlayers = get_tree().get_nodes_in_group("players")
	
	if body.is_multiplayer_authority():
		report_fall.rpc_id(1, body.name)  # отправляем серверу
	deadPlayers +=1
	print("deadPlayers: ", deadPlayers)

			
	if deadPlayers + 1 == maxPlayers.size():
		for i in maxPlayers.size():
			if maxPlayers[i].visible == true:
				report_win.rpc_id(1, str(maxPlayers[i].player_name_label.text))
				maxPlayers[i].queue_free()

@rpc("any_peer")
func report_fall(player_name: String):
	if not multiplayer.is_server(): return
	# Сервер обрабатывает
	handle_player_fall.rpc(player_name)
	
@rpc("any_peer")
func report_win(player_name):
	if not multiplayer.is_server(): return
	# Сервер обрабатывает
	show_game_over.rpc(player_name)

@rpc("call_local")
func handle_player_fall(player_name: String):
	var player = get_node("../" + player_name)
	if player:
		player.queue_free()
		print(player.name, " lose")
		
		
@rpc("call_local")
func show_game_over(winner):
	#var ui = get_node("/root/Main/CanvasLayer/UiLoseWindow")
	#ui.visible = true
	#ui.get_node("WinnerLabel").text = winner + " победил!"
	
	var ui_lose_window = get_tree().get_first_node_in_group("lose_window")
	ui_lose_window.update_loser_text( str(winner, " победил"))
	ui_lose_window.visible = true
		
	



func _on_area_2d_4_body_entered(body: Node2D) -> void:
	
	_lose(body)
	pass # Replace with function body.


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	_lose(body)
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	_lose(body)
	pass # Replace with function body.


func _on_area_2d_1_body_entered(body: Node2D) -> void:
	_lose(body)
	pass # Replace with function body.
	
