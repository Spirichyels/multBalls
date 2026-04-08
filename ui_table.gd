extends Control


@onready var vb_cstolbec: VBoxContainer = %VBCstolbec

const HB_CSTRING = preload("uid://c1jsjugu2v1el")

var player_lines = {}

func update_score(new_score: String):
	$ScoreLabel.text = new_score



func add_player_to_table(_id: String, _name: String, _score):
	var new_string = HB_CSTRING.instantiate()
	vb_cstolbec.add_child(new_string)
	new_string.new_string(_name, str(_score))
	player_lines[_id] = {
		"name": _name,
		"score": _score,
		"node": new_string
	}

#func add_player_to_table(_id: String, _name: String, _score):
	#var new_string = HB_CSTRING.instantiate()
	#player_lines[_id] = {
		#"name": _name,
		#"score": _score
	#}
	#vb_cstolbec.add_child(new_string)
	#new_string.new_string(str(_name), str(_score))
	#print_player_lines()
	
func update_player_score(player_id: String, new_score: int):
	if player_lines.has(player_id):
		player_lines[player_id].score = new_score
		player_lines[player_id].node.update_score(str(new_score))
		
#func update_player_score(player_id: String, new_score: String):
	#print("победитель: ", player_id, "new_score: ", new_score)
	#for child in vb_cstolbec.get_children():
		#print("child: ",child)
		#if child.name == player_id:  # предполагаем, что у строки есть свойство name = id
			#child.update_score(new_score)
			#break
func print_player_lines():
	for line in player_lines:
		print(line)
