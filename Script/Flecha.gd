extends Sprite

var player = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var prova_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if(player != null):
		look_at(prova_pos - player.position + position)
	else:
		look_at(prova_pos)

func set_prova(pos):
	prova_pos = pos
	
func set_player(p):
	player = p