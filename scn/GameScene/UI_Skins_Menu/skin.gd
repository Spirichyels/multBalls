extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var skin = 0:
	set(value):
		if value != null:
			skin = value
			$AnimationPlayer.play(str(skin))
			
			
func _ready() -> void:
	modulate = ("666666")
