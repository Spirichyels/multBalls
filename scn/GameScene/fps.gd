extends CanvasLayer

@onready var fps_label: Label = %fpsLabel
@onready var ping_label: Label = %pingLabel


func _physics_process(delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"
	
	if multiplayer.is_server():
		ping_label.text = "Server"
		return
	
	var peer = multiplayer.multiplayer_peer
	if peer is ENetMultiplayerPeer:
		var enet_peer = peer.get_peer(1)  # 1 = ID сервера
		if enet_peer:
			var rtt = enet_peer.get_statistic(ENetPacketPeer.PeerStatistic.PEER_LAST_ROUND_TRIP_TIME)
			ping_label.text = str(rtt) + " ms"
		else:
			ping_label.text = "No peer"
	else:
		ping_label.text = "No ENet"
