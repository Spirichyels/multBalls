extends HBoxContainer


@onready var name_label: Label = %nameLabel
@onready var connectedLabel: Label = %connectedLabel



func new_string(_name: String, _connected: String):
	name_label.text = _name
	connectedLabel.text = _connected


func update_connected(new_connected: String):
	connectedLabel.text = new_connected
