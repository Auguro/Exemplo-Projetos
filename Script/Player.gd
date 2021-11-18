extends KinematicBody2D

var velocidade = Vector2()
var direcao = 4
const speed = 1000

func _ready():
	$Camera2D/VBoxContainer/ProvasCompletas.set_text($Camera2D/VBoxContainer/ProvasCompletas.get_text() + str(global.provasCompletas))
	$Camera2D/VBoxContainer/Falhas.set_text($Camera2D/VBoxContainer/Falhas.get_text() + str(global.falhas))
	get_tree().call_group("bosses", "set_player", self)

func _process(delta):
    if Input.is_action_pressed("Sair"):
        get_tree().quit()

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		velocidade.x = -speed
		$AnimatedSprite.play("WalkEsquerda")
		direcao = 2
		
	elif Input.is_action_pressed("ui_right"):
		velocidade.x = speed
		$AnimatedSprite.play("WalkDireita")
		direcao = 1
	else:
		velocidade.x = 0
		if (direcao == 1):
			$AnimatedSprite.play("Direita")
		elif (direcao == 2):
			$AnimatedSprite.play("Esquerda")
	
	if Input.is_action_pressed("ui_up"):
		velocidade.y = -speed
		$AnimatedSprite.play("WalkUp")
		direcao = 3
	elif Input.is_action_pressed("ui_down"):
		velocidade.y = speed
		$AnimatedSprite.play("WalkDown")
		direcao = 4
	else:
		velocidade.y = 0
		if (direcao == 3):
			$AnimatedSprite.play("Up")
		elif (direcao == 4):
			$AnimatedSprite.play("Down")
	
	
	velocidade = move_and_slide(velocidade)
