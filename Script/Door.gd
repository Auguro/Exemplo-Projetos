extends MeshInstance



func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if DoomGlobal.podepassa:
		if "Player" in body.name:
			global.provasCompletas += 1
			global.fases = 2
			get_tree().change_scene("res://scenes/Mundo.tscn")
