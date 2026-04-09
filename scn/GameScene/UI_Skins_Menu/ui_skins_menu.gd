extends Control




@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const SKIN = preload("uid://cim0m11hl1oth")

@onready var UI_global

var skins = {
	0: "Говно мяч",
	1: "Футбольный мяч",
	2: "Волейбольный мяч Курильщика",
	3: "Волейбольный мяч Мужчины",
	4: "Баскетбольный мяч",
	5: "Красный спинер",
	
}

var new_skin = 0

var center = Vector2(0, 0)  # центр твоей окружности
var radius = 450
var ball_count = 6

var target_rotation = deg_to_rad(90)
var rotate_speed = 3.0
var is_rotating = false

func get_radius():
	if collision_shape_2d and collision_shape_2d.shape:
		return collision_shape_2d.shape.radius
	return 0.0

func rotate_to_bottom(rght):
	# target_angle: PI*1.5 = 270 градусов (снизу)
	if rght:
		target_rotation += deg_to_rad(60)
	else:
		target_rotation += deg_to_rad(-60)

func _ready():
	UI_global = get_tree().get_first_node_in_group("UI_global")
	radius = get_radius()
	for i in ball_count:
		var angle = -i * (TAU / ball_count)  # TAU = 2*PI
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		var ball = SKIN.instantiate()
		
		ball.position = pos
		collision_shape_2d.add_child(ball)
		ball.skin = i

func _process(delta):
	if is_rotating:
		var step = rotate_speed * delta
		var new_rot = move_toward(collision_shape_2d.rotation, target_rotation, step)
		collision_shape_2d.rotation = new_rot
		if abs(collision_shape_2d.rotation - target_rotation) <= step:
			collision_shape_2d.rotation = target_rotation
			is_rotating = false
	
func _on_button_right_pressed() -> void:
	if is_rotating:
		return
	rotate_to_bottom(true)
	is_rotating = true
	pass # Replace with function body.


func _on_button_left_pressed() -> void:
	if is_rotating:
		return
	rotate_to_bottom(false)
	is_rotating = true
	pass # Replace with function body.


func _on_name_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("skin_in_menu_skins"):
		body.modulate = ("ffffff")
		new_skin = body.skin
		%nameSkinLabel.text = skins[new_skin]
		pass # Replace with function body.


func _on_name_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("skin_in_menu_skins"):
		body.modulate = ("666666")
		pass # Replace with function body.


func _on_ok_button_pressed() -> void:
	HightLevelNetworkHandler.player_skin = str(new_skin)
	#UiGlobal.state_ui = UiGlobal.UI.Menu
	UI_global.go_menu()
	
	pass # Replace with function body.
