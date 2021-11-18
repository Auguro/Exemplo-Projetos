extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var frames = 19 * 6

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(frames):
		$AnimationPlayer.frame = i
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
