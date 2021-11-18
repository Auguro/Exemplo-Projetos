extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		if(!get_tree().paused):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			show()
			get_tree().paused = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			hide()
			get_tree().paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	hide()
	get_tree().paused = false
	



func _on_Quit_pressed():
	save_game()
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func save_game():
	var save_game = File.new()
	save_game.open("res://Saves/savegame.save", File.WRITE)
	var save_dict = {
		"provasCompletas" : global.provasCompletas,
		"falhas" : global.falhas
	}
	save_game.store_line(to_json(save_dict))
	save_game.close()

 
