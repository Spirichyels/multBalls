extends Control


@onready var vb_cstolbec: VBoxContainer = %VBCstolbec

const HB_CSTRING = preload("uid://c1jsjugu2v1el")

var player_lines = {}

#func update_score(new_score: String):
	#$scoreLabel.text = new_score



func add_player_to_table(_id: String, _name: String, _score):
	var _new_string = HB_CSTRING.instantiate()
	vb_cstolbec.add_child(_new_string)
	_new_string.new_string(_name, str(_score))
	player_lines[_id] = {
		"name": _name,
		"score": _score,
		"node": _new_string
	}


	
func update_player_score(player_id: String, new_score: int):
	if player_lines.has(player_id):
		player_lines[player_id].scoreLabel = new_score
		player_lines[player_id].node.update_score(str(new_score))

func null_player_score(player_id: String, new_score: int):
	if player_lines.has(player_id):
		player_lines[player_id].scoreLabel = new_score
		player_lines[player_id].node.update_score(str(new_score))
				

func print_player_lines():
	for line in player_lines:
		print(line)
