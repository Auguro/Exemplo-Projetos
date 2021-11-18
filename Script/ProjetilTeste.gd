extends KinematicBody2D

var velocity = Vector2(0, 0)
	
func _ready():
	if global.provasCompletas > 3:
		$Normal.hide()
		$Infectado.show()

func _physics_process(delta):
	move_and_slide(velocity * delta)

func setVelocity(vel):
	velocity = vel

func _on_Area2D_body_entered(body):
	if "Lapis" in body.name:
		body.hurt()
		queue_free()


func _on_Area2D_body_exited(body):
	if "Parede" in body.name:
		queue_free()
