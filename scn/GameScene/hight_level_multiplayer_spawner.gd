extends MultiplayerSpawner

@export var network_player: PackedScene
var players = {}

func _ready():
	add_to_group("spawner")
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(spawn_player)

func spawn_player(id):
	if !multiplayer.is_server(): return
	var player = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).add_child(player)
	players[id] = player
	player.set_skin.rpc(1)

@rpc("any_peer")
func request_players():
	if not multiplayer.is_server(): return
	for id in players:
		rpc_id(multiplayer.get_remote_sender_id(), "receive_player", id, players[id].skin_id)

@rpc("any_peer")
func receive_player(id, skin_id):
	print("receive_player: создаю игрока", id, "скин", skin_id)
	var player = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).add_child(player)
	players[id] = player
	player.set_skin(skin_id)  # <- ЭТО ДОЛЖНО БЫТЬ
