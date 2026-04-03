extends Control

@onready var text_los_or_win: Label = $text_los_or_win


func update_loser_text(text):
	text_los_or_win.text = str(text)


func _on_button_again_pressed() -> void:
	
	pass # Replace with function body.
