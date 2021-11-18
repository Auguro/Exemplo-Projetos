extends Area2D

#onready var player = get_parent().get_node("res://Scenes/Player.tscn")
const player = preload("res://Scenes/Player.tscn")

var velocidade = Vector2()
var direcao = Vector2.ZERO

func _ready():
	var jogador = player.instance()
	direcao = jogador.get_global_position()
	velocidade.angle_to(direcao)

func _physics_process(delta):
	translate(velocidade)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


