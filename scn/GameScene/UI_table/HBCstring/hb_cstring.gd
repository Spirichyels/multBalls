extends HBoxContainer


@onready var name_label: Label = %nameLabel
@onready var score_label: Label = %scoreLabel



func new_string(_name: String, _score: String):
	name_label.text = _name
	score_label.text = _score


func update_score(new_score: String):
	score_label.text = new_score
