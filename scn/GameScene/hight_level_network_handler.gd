extends Node



var player_name = "bot"
var player_skin = 0
var IP_ADERSS: String = ""
const PORT: int = 42069

var peer: ENetMultiplayerPeer

signal game_started_changed

var game_started = false:
	set(value):
		game_started = value
		game_started_changed.emit()

func or1():
	#return 5
	return(randi()%6)
	
	#if player_skin == 0:
		#player_skin = 1
		#return 0
	#elif player_skin == 1:
		#player_skin = 0
		#return 1
	

func start_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	await get_tree().create_timer(10).timeout
	print("сервер закрылся")
	game_started = true
	
func start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADERSS, PORT)
	multiplayer.multiplayer_peer = peer
	#print("клиент: peer создан", peer)
	
