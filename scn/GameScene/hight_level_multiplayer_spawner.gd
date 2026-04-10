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
	await HightLevelNetworkHandler.game_table_create_changed
	#await HightLevelNetworkHandler.game_started_changed
	
	#HightLevelNetworkHandler.add_player(player.name, player.nickname)
	for key_player in players:
		#HightLevelNetworkHandler.add_player(players[key_player].name, players[key_player].nickname)
		print("player.nickname: ",players[key_player].nickname , (" сервер" if multiplayer.is_server() else " клиент"))
		print("player.skin_id: ",players[key_player].skin_id , (" сервер" if multiplayer.is_server() else " клиент"))
		
	broadcast_players_list()

func broadcast_players_list():
	print("broadcast_players_list: ", (" сервер" if multiplayer.is_server() else " клиент"))
		
	# 1. Создаём пустой массив, куда сложим данные всех игроков
	var players_data = []
	
	# 2. Проходим по словарю players (ключ = id, значение = объект игрока)
	for id in players:
		# 3. Добавляем в массив словарь с данными одного игрока
		players_data.append({
			"id": id,                           # ID игрока
			"name": players[id].nickname,       # имя из переменной nickname
			"score": 0                          # очки (пока 0)
		})
	
	# 4. Отправляем массив на все клиенты, вызывая функцию create_table_rows
	create_table_rows.rpc(players_data)
@rpc("call_local")
func create_table_rows(data: Array):
	for player_data in data:
		HightLevelNetworkHandler.add_player(str(player_data.id), str(player_data.name))


func spawn_player(id):
	await HightLevelNetworkHandler.game_started_changed #расскоментировать на релизе
	if !multiplayer.is_server(): return
	var player = network_player.instantiate()
	player.name = str(id)
	
	
	
	get_node(spawn_path).add_child(player)
	
	
	players[id] = player

	


#пока не работает
@rpc("call_local")
func join_refused():
	print("Игра уже началась, подключение отклонено")
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
