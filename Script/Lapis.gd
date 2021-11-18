extends KinematicBody2D

var max_speed = 200
var acceleration = 2000
var motion = Vector2()
var direction = Vector2()
var vida = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var axis = get_input_axis()
	var state
	if axis == Vector2.ZERO:
		apply_friction(acceleration * delta)
	else:
		apply_movement(axis * acceleration * delta)
	motion = move_and_slide(motion)
	if motion != Vector2.ZERO:
		state = "Walk"
	else:
		state = "Idle"
	animation(state)
	
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if(axis != Vector2.ZERO):
		direction.x = axis.x
		direction.y = axis.y
	return axis.normalized()
	
	
func apply_friction(friction):
	if motion.length() > friction:
		motion -= motion.normalized() * friction
	else:
		motion = Vector2.ZERO
	
func apply_movement(movement):
	motion += movement
	motion = motion.clamped(max_speed)
	
func animation(state):
	match direction:
		Vector2(-1,0):
			if $AnimationPlayer.current_animation != (state + "Side"):
				if $Pivot.scale.x == 1:
					$Pivot.scale.x = -1
				$AnimationPlayer.play(state + "Side")
		Vector2(1,0):
			if $AnimationPlayer.current_animation != (state + "Side"):
				if $Pivot.scale.x == -1:
					$Pivot.scale.x = 1
				$AnimationPlayer.play(state + "Side")
		Vector2(0,-1):
			if $AnimationPlayer.current_animation != (state + "Up"):
				$AnimationPlayer.play(state + "Up")
		Vector2(0,1):
			if $AnimationPlayer.current_animation != (state + "Down"):
				$AnimationPlayer.play(state + "Down")

func hurt():
	if vida != 1:
		vida -=1
	else:
		die()

func die():
	global.falhas += 1
	get_tree().change_scene("res://scenes/Mundo.tscn")