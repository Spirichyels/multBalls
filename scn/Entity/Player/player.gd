extends CharacterBody2D




const SPEED = 1000.0
const PUSH_FORCE = 140
const FRICTION = 0.99  # Трение (0.9 = 10% замедления за кадр)


var input_dir = Vector2.ZERO

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D




@onready var player_name_label: Label = %player_name_label
@onready var player_speed_label: Label = %player_speed_label

@export var nickname = "bot_no_name":
	set(value):
		if value != "server":
			nickname = value
			player_name_label.text = nickname
			#print("nickname: ",nickname , (" сервер" if multiplayer.is_server() else " клиент"))
			#print("skin_id: ", skin_id , (" сервер" if multiplayer.is_server() else " клиент"))
		
@export var spawn_count = 1
@export var skin_id = -2:
	set(value):
		skin_id = value
		$AnimationPlayer.play(str(skin_id))
		#print("skin_id: ", skin_id , (" сервер" if multiplayer.is_server() else " клиент"))
		
		
@export var is_ready = false
@export var orDead = false:
	set(value):
		orDead = value
		if orDead == true:
			visible = false
			velocity = Vector2.ZERO
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, false)
		elif orDead == false:
			set_collision_layer_value(1, true)
			set_collision_mask_value(1, true)
			set_collision_mask_value(2, true)
			visible = true

func _reborn():
	position.x = randi() % 1000 + 100
	position.y = randi() % 520 + 100
	await get_tree().create_timer(1.0).timeout
	
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	orDead = false
	

	

func _ready() -> void:
	player_name_label.position.x = player_name_label.size.x / 4 * -1
	_reborn()
	if not multiplayer.is_server(): return
	player_speed_label.visible = true


func _enter_tree() -> void:
	set_multiplayer_authority(1)  # сервер управляет всем
		

func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	player_speed_label.text = str(velocity)
	
	if not orDead:
		velocity += input_dir * SPEED * _delta
	
	velocity *= FRICTION
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		
		if other is CharacterBody2D:
			var push_dir = (position - other.position).normalized()
			velocity += push_dir * PUSH_FORCE
			
			other.apply_push_force.rpc_id(other.get_multiplayer_authority(), -push_dir * PUSH_FORCE)

@rpc("any_peer", "call_local", "unreliable")
func apply_push_force(force: Vector2):
	velocity += force

@rpc("any_peer", )
func reborn():
	_reborn()

@rpc("any_peer", "unreliable")
func update_input(id: int, dir: Vector2):
	if int(name) == id:
		input_dir = dir


@rpc("any_peer","call_local")
func set_player_name_and_skin(_name: String, _id: String):
	print("set_player_name_and_skin: ", (" сервер" if multiplayer.is_server() else " клиент"))
	print("_id: ", _id , (" сервер" if multiplayer.is_server() else " клиент"))
	var sender_id = multiplayer.get_remote_sender_id()
	if int(name) == sender_id:
		nickname = _name
		skin_id = _id
		player_name_label.text = _name
