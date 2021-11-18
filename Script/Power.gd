extends Area

const speed = 2
const velocity = Vector3()

onready var anim_player = $AnimationPlayer
onready var raycast = $Raycast

var player = null

func _ready():
	anim_player.play("Idle")
	

func _physics_process(delta):
	if player == null:
		return
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	translate(vec_to_player * speed * delta)


func _on_VisibilityNotifier_screen_exited():
	queue_free()

func set_player(p):
    player = p
