extends Node2D

func _ready() -> void:
	get_parent().set_player_name.rpc_id(1, HightLevelNetworkHandler.player_name)
	print("HightLevelNetworkHandler.player_skin: ", HightLevelNetworkHandler.player_skin , (" сервер" if multiplayer.is_server() else " клиент"))
	get_parent().set_player_skin.rpc_id(1, HightLevelNetworkHandler.player_skin)

func _process(_delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if multiplayer.get_unique_id() != 1:
		get_parent().update_input.rpc_id(1, multiplayer.get_unique_id(), dir)
