extends Control

@onready var text_los_or_win: Label = $text_los_or_win



func _ready() -> void:
	
	pass


func update_loser_text(text):
	text_los_or_win.text = str(text)
