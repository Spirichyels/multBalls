extends CanvasLayer

@onready var ui_skins_menu: Control = $UI_Skins_menu
@onready var hight_level_ui: Control = $HightLevelUI
@onready var ui_lose_window: Control = $UiLoseWindow
@onready var ui_table: Control = $UI_table

@onready var skins_button: TextureButton = $SkinsButton







enum UI{
	NullScene,
	Menu,
	Skins,
	Lose,
	Client,
	Server
}



var state_ui = UI.Menu:
	set(value):
		state_ui = value
		match(state_ui):
			UI.Menu:
				visible_false()
				hight_level_ui.visible = true
				skins_button.visible = true
			UI.Skins:
				visible_false()
				ui_skins_menu.visible = true
			UI.Lose:
				visible_false()
				ui_lose_window.visible = true
			UI.Client:
				visible_false()


func visible_false():
	ui_skins_menu.visible = false
	hight_level_ui.visible = false
	ui_lose_window.visible = false
	ui_table.visible = false
	skins_button.visible = false
	

func _ready() -> void:
	state_ui = UI.Menu

	pass

func go_menu():
	state_ui = UI.Menu
	
func go_game():
	state_ui = UI.Client




func _on_skins_button_pressed() -> void:
	state_ui = UI.Skins
	pass # Replace with function body.
