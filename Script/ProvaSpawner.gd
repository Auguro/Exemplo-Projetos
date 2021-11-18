extends Node2D

const prova = preload("res://Scenes/Prova.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_prova():
	var spawners = get_children()
	var random = randi()%spawners.size()
	var instancia = prova.instance()
	instancia.position = spawners[random].position
	get_parent().add_child(instancia)
