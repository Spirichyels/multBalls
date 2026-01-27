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
	
