extends Node2D



func _lose(body):
	body.visible = false
	print(body.name, " lose")


func _on_area_2d_4_body_entered(body: Node2D) -> void:
	
	_lose(body)
	pass # Replace with function body.


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	_lose(body)
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	_lose(body)
	pass # Replace with function body.


func _on_area_2d_1_body_entered(body: Node2D) -> void:
	_lose(body)
	pass # Replace with function body.
