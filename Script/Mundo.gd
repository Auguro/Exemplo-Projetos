extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$CanvasLayer/GUI/HBoxContainer/VBoxContainer/ProvasCompletas.set_text($CanvasLayer/GUI/HBoxContainer/VBoxContainer/ProvasCompletas.get_text() + str(global.provasCompletas))
	$CanvasLayer/GUI/HBoxContainer/VBoxContainer/Falhas.set_text($CanvasLayer/GUI/HBoxContainer/VBoxContainer/Falhas.get_text() + str(global.falhas))
	if(global.falhas > 3 || global.provasCompletas > 5):
		get_tree().change_scene("res://scenes/Fim.tscn")
	set_camera_limits()
	$ProvaSpawner.spawn_prova()
	$CanvasLayer/GUI/Flecha.set_prova($Prova.position)
	$CanvasLayer/GUI/Flecha.set_player($YSort/Estudante)
	$YSort/Estudante/Flecha.set_prova($Prova.position)

func set_camera_limits():
    var map_limits = $TileMap.get_used_rect()
    var map_cellsize = $TileMap.cell_size
    $YSort/Estudante/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
    $YSort/Estudante/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
    $YSort/Estudante/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
    $YSort/Estudante/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y