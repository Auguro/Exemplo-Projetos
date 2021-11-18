extends CanvasLayer

onready var aeeee = preload("res://Assets/Sprites/Fim/Aeeee/Normal.png")
onready var ahnao = preload("res://Assets/Sprites/Fim/Ahnao/Normal.png")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if(global.falhas > 3):
		$MarginContainer/HBoxContainer/VBoxContainer/Label.set("custom_colors/font_color", Color("#cf5b5b"))
		$MarginContainer/HBoxContainer/VBoxContainer/Label.set_text("Você rodou!")
		$MarginContainer/HBoxContainer/VBoxContainer/Button.set_normal_texture(ahnao)
	else:
		$MarginContainer/HBoxContainer/VBoxContainer/Label.set("custom_colors/font_color", Color("#74a875"))
		$MarginContainer/HBoxContainer/VBoxContainer/Label.set_text("Você passou de ano!")
		$MarginContainer/HBoxContainer/VBoxContainer/Button.set_normal_texture(aeeee)
	global.reset()
	save_game()
	
#res://Control.gd
func save_game():
	var save_game = File.new()
	save_game.open("res://Saves/savegame.save", File.WRITE)
	var save_dict = {
		"provasCompletas" : 0,
		"falhas" : 0
	}
	save_game.store_line(to_json(save_dict))
	save_game.close()

 
func reset():
	global.falhas = 0
	global.provasCompletas = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	reset()
	get_tree().change_scene("res://scenes/MainMenu.tscn")