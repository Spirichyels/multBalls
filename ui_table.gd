extends Control


@onready var vb_cstolbec: VBoxContainer = $VBCstolbec
const HB_CSTRING = preload("uid://c1jsjugu2v1el")



func add_string_table(_name, _score):
	var new_string = HB_CSTRING.instantiate()
	new_string.new_string(str(_name), str(_score))
	vb_cstolbec.add(new_string)
