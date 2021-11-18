extends KinematicBody

const SHOT_SPEED = 3
const PODER_DE_PERSEGUICAO = 0.01 #valor maior = curvas mais agudas

onready var raycast = $RayCast
onready var raycast2 = $RayCast2
onready var anim_player = $AnimationPlayer


var player = null
var exploding = false
var timer = null
var speedVector = Vector3(0, 0, 0)
var damage = 10
var vida = 1

func _ready():
	randomize()
 
func _physics_process(delta):
	if player == null || exploding:
		return
	
	hasPlayerVision()
	
	var vec_to_player = player.translation - (get_parent().translation + translation)
	raycast.cast_to = vec_to_player.normalized() * 0.5
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.hurt(damage)
			kill()
		else:
			kill()
	
	speedVector = speedVector + (vec_to_player * PODER_DE_PERSEGUICAO)
	speedVector = speedVector.normalized()
	
	var vector = speedVector * SHOT_SPEED * delta
	vector.y = 0;
	
	move_and_collide(vector)

func hurt(dmg):
	vida -= dmg
	if vida <= 0:
		kill()

func kill():
	exploding = true;
	$CollisionShape.disabled = true
	anim_player.play("Explode")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.3)
	timer.connect("timeout", self, "despawn")
	add_child(timer)
	timer.start()

func hasPlayerVision():
	var vec_to_player = player.translation - (get_parent().translation + translation)
	vec_to_player = vec_to_player.normalized()
	raycast2.cast_to = vec_to_player * 7
	return raycast2.get_collider() == player
	
func despawn():
	queue_free()
 
func set_player(p):
    player = p
