extends Node

@onready var ui_table




var player_name = "bot"
var player_skin = 0
var IP_ADERSS: String = ""
const PORT: int = 42069

var players = {}



var peer: ENetMultiplayerPeer

signal game_started_changed


func _ready() -> void:
	ui_table  = get_tree().get_first_node_in_group("ui_table")

var game_started = false:
	set(value):
		game_started = value
		game_started_changed.emit()

func add_player(_id:String , _name: String):
	players[str(_id)] = {"score": 0}
	print(ui_table)
	ui_table.add_player_to_table(_id, _name, 0)
	
	
func up_score_player(_id: String, _name: String, new_score: int):
	players[str(_id)].score += new_score
	# После обновления счёта рассылаем новую таблицу
	broadcast_score_update.rpc(_id, players[_id].score)

@rpc("call_local")
func broadcast_score_update(player_id: String, new_score: int):
	ui_table.update_player_score(player_id, new_score)

	
#@rpc("call_local")
#func broadcast_score_update(player_id, new_score):
	## На всех клиентах обновляем строку таблицы
	#ui_table.update_player_score(str(player_id), str(new_score))

func or1():
	#return 5
	return player_skin
	#return(randi()%6)
	
	#if player_skin == 0:
		#player_skin = 1
		#return 0
	#elif player_skin == 1:
		#player_skin = 0
		#return 1
	

func start_server():
	player_name = "server"
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
	# Отправляем имя на сервер
	#print("клиент: peer создан", peer)
	
