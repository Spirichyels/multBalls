extends Node



var player_name = "bot"
var IP_ADERSS: String = ""
const PORT: int = 42069

var peer: ENetMultiplayerPeer


func start_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
func start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADERSS, PORT)
	multiplayer.multiplayer_peer = peer
	print("клиент: peer создан", peer)
	
	await get_tree().process_frame  # ждем кадр
	
	var spawner = get_tree().get_first_node_in_group("spawner")
	print("spawner найден:", spawner)
	if spawner:
		spawner.request_players.rpc_id(1)
	else:
		print("спавнер не найден!")
