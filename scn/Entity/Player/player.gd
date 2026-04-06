extends CharacterBody2D




const SPEED = 1000.0
const PUSH_FORCE = 2000.0
const FRICTION = 0.99  # Трение (0.9 = 10% замедления за кадр)




@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@onready var player_name_label: Label = %player_name_label

@export var spawn_count = 1
@export var skin_id = -2
@export var is_ready = false
@export var orDead = false:
	set(value):
		orDead = value
		if orDead == true:
			#visible = false
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
	
	player_name_label.text = HightLevelNetworkHandler.player_name
	player_name_label.position.x = player_name_label.size.x / 4 * -1
	
	
	_reborn()
	#position.x = randi() % 1000 + 100
	#position.y = randi() % 520 + 100
	


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	# 1. Получаем ввод
	
	var input = 0
	if not orDead:
		input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Добавляем ускорение от ввода
	if not orDead:
		velocity += input * SPEED * _delta
	
	# 3. Применяем трение (замедление)
	velocity *= FRICTION
	
	# 4. Двигаемся
	
	move_and_slide()
	
	# 5. При столкновении
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		
		if other is CharacterBody2D:
			var push_dir = (position - other.position).normalized()
			
			# Добавляем плавную силу отталкивания
			velocity += push_dir * PUSH_FORCE * _delta
			
			# Отправляем другому
			other.apply_push_force.rpc_id(other.get_multiplayer_authority(), -push_dir * PUSH_FORCE * _delta)
		

@rpc("any_peer", "call_local", "unreliable")
func apply_push_force(force: Vector2):
	velocity += force

@rpc("any_peer")
func reborn():
	_reborn()
	
@rpc("any_peer")
func set_skin(id):
	$AnimationPlayer.play(str(id))
	
