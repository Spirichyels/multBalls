extends Control

@onready var name_label: Label = %NameLabel

@onready var name_input: LineEdit = %nameInput



func _ready() -> void:
	#рандомное имя
	name_input.text = str("bot",randi()%100+1) 
	HightLevelNetworkHandler.player_name = name_input.text
	
	name_label.text = str("Твоё имя: "+ HightLevelNetworkHandler.player_name)


func _on_server_pressed() -> void:
	HightLevelNetworkHandler.start_server()
	visible = false
	pass # Replace with function body.


func _on_client_pressed() -> void:
	HightLevelNetworkHandler.start_client()
	visible = false
	pass # Replace with function body.

	
	


func _on_name_input_text_submitted(new_text: String) -> void:
	HightLevelNetworkHandler.player_name = new_text
	name_label.text = str("Твоё имя: "+ HightLevelNetworkHandler.player_name)
	pass # Replace with function body.
func _on_name_input_text_changed(new_text: String) -> void:
	HightLevelNetworkHandler.player_name = new_text
	name_label.text = str("Твоё имя: "+ HightLevelNetworkHandler.player_name)
	pass # Replace with function body.

func _on_ipadres_input_text_submitted(new_text: String) -> void:
	HightLevelNetworkHandler.IP_ADERSS = new_text
	pass # Replace with function body.	

func _on_ipadres_input_text_changed(new_text: String) -> void:
	HightLevelNetworkHandler.IP_ADERSS = new_text
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
