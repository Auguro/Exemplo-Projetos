extends Node

var health = 100
var ammo = 0
var armor = 0
var podepassa = false

func _ready():
	pass # Replace with function body.

func dead():
	global.falhas += 1
	get_tree().change_scene("res://scenes/Mundo.tscn")
