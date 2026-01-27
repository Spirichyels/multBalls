extends MultiplayerSpawner

@export var network_player: PackedScene
@onready var spawners: Node2D = $"../Spawners"

var array_spawners = []




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	
	var player: Node = network_player.instantiate()
	player.name = str(id)

	
	pass
	get_node(spawn_path).call_deferred("add_child", player)
	
