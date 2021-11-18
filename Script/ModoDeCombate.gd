extends Node2D

var materias = ["matematica", "fisica", "biologia", "portugues"]
var x 

func _ready():
	randomize()
	
func sorteadorProva():
	x = randi()%3
	print (x)
	if (materias[x] == "matematica"):
		get_tree().change_scene("res://scenes/Portugues.tscn")
	elif (materias[x] == "fisica"):
		if global.fases == 1:
			get_tree().change_scene("res://scenes/IntroducaoAComputacao.tscn")
		elif global.fases == 2:
			get_tree().change_scene("res://scenes/Level3.tscn")


func _on_Area2D_body_entered(body):
	if "Estudante" in body.name:
		sorteadorProva();
		
