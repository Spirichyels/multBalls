extends CharacterBody2D

const SPEED = 500.0
const PUSH_IMPULSE = 1000.0

var pending_impulse = Vector2.ZERO

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	# 1. Берем и СРАЗУ обнуляем
	var impulse_this_frame = pending_impulse
	pending_impulse = Vector2.ZERO  # ⬅️ ОБНУЛИЛИ ЗДЕСЬ
	
	# 1. Применяем ввод
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	
	# 2. Добавляем накопленный импульс (если есть)
	velocity += impulse_this_frame
	if impulse_this_frame:
		print("Меня оттлкнули с таким импульсом: ",impulse_this_frame)	
	move_and_slide()
	
	# 3. При столкновении
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		
		if other is CharacterBody2D:
			var push_dir = (position - other.position).normalized()
			
			# Отталкиваем себя СРАЗУ
			velocity += push_dir * PUSH_IMPULSE
			
			# Другому отправляем импульс (он применит в этом же кадре если RPC успеет)
			print("Отправляю RPC игроку:", other.name)
			other.apply_impulse_immediate.rpc_id(other.get_multiplayer_authority(), -push_dir * PUSH_IMPULSE)

@rpc("any_peer", "call_local", "unreliable")
func apply_impulse_immediate(impulse: Vector2):
	# Применяем СРАЗУ, не ждём следующего кадра
	print("Получил импульс:", impulse, " Текущий pending:", pending_impulse)
	pending_impulse += impulse
	print("Стал:", pending_impulse)
