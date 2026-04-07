extends MultiplayerSpawner

@export var network_player: PackedScene
var players = {}

func _ready():
	
	add_to_group("spawner")
	if multiplayer.is_server():
		if not HightLevelNetworkHandler.game_started: #!!!!!!!на клиенте проверяет, исправить
			multiplayer.peer_connected.connect(spawn_player)
		else:
			join_refused()

func spawn_player(id):
	#await HightLevelNetworkHandler.game_started_changed
	if !multiplayer.is_server(): return
	var player = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).add_child(player)
	player.skin_id = HightLevelNetworkHandler.or1()
	print(player.skin_id)
	player.set_skin.rpc(player.skin_id)
	
	HightLevelNetworkHandler.add_player(player.name)
	print("spawn_player это " + (" сервер" if multiplayer.is_server() else " клиент"))
	
	print(HightLevelNetworkHandler.players)
	players[id] = player
	
	
@rpc("call_local")
func join_refused():
	print("Игра уже началась, подключение отклонено")
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
