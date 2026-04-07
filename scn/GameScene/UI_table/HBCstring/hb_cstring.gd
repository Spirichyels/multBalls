extends HBoxContainer

@onready var name_label: Label = $nameLabel
@onready var score_label: Label = $scoreLabel




func new_string(_name, _score):
	name_label.text = _name
	score_label.text = _score
