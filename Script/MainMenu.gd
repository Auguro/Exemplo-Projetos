extends MarginContainer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.
	
func load_game():
	var save_game = File.new()
	if save_game.file_exists("res://Saves/savegame.save"):
		save_game.open("res://Saves/savegame.save", File.READ)
		var current_line = parse_json(save_game.get_line())
		global.provasCompletas = current_line["provasCompletas"]
		global.falhas = current_line["falhas"]
		save_game.close()
		get_tree().change_scene("res://scenes/Mundo.tscn")
	else:
		return false

func _on_NewGame_pressed():
	global.reset()
	get_tree().change_scene("res://scenes/Mundo.tscn")


func _on_Continue_pressed():
	if(not load_game()):
		$HBoxContainer/VBoxContainer/VBoxContainer/Notification.notify()
