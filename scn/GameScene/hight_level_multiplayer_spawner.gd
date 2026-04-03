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
	player.set_skin.rpc(1)
	players[id] = player
	
