extends Area2D

const projetil = preload("res://Scenes/ProjetilTeste.tscn")
const ERROR_COOLDOWN = 1 #tempo de espera para poder digitar novamente depois de errar
const ATTACK_COOLDOWN = 0.5 #tempo de espera em segundos para o boss atacar
const BETWEEN_ATTACKS = 1 #tempo entre ataques

onready var label = $Control/RichTextLabel
onready var label2 = $Control/RichTextLabel2
onready var label3 = $Control/RichTextLabel3
onready var textLine = $Control/LineEdit
onready var animationPlayer = $AnimationPlayer


var palavra
var palavrasFaceis = ["Rodo", "Mesa", "Cama", "Fada", "Lixo", "Bola", "Sapo",
"Tatu", "Mola", "Vela", "Lata", "Dedo", "Vaca", "Rosa", "Bota"]
var palavrasDificeis = ["Admodesta", "Alarido", "Alcunha", "Ardiloso", "Belicioso",
"Dilapidar", "Engordar", "Fenecimento", "Frugal", "Homizio", "Insolente", "Pachorrento"]
var vidas = 3
var posicao = 0
var test
var player
var errorTimer = null
var canType = true
var attackTimer = null
var betweenAttacks
var combo = 0
var fase = 1
var i = 0

func _enter_tree():
	add_to_group("bosses")

func _ready():
	if global.provasCompletas > 3:
		fase = 2
		$Fase1.hide()
		$Fase2.show()
	if fase == 1:
		palavra = shuffleList(palavrasFaceis)
	else:
		palavra = shuffleList(palavrasDificeis)
		
	textLine.grab_focus()
	#ProjectSettings.set("display/window/stretch/mode", 2d)
	startAttackTimer()
	
func dead():
	global.provasCompletas += 1
	get_tree().change_scene("res://scenes/Mundo.tscn")
	
func set_player(p):
	player = p

func _on_LineEdit_text_changed(new_text):
	
	if canType:
		if new_text.to_lower() == label2.text.to_lower()[label2.get_visible_characters()]:
			label2.set_visible_characters(label2.get_visible_characters() + 1)
			if label2.get_visible_characters() == label2.text.length():
				vidas = vidas - 1
				posicao += 1
				randomize()
				var aleatoria = randi()%palavra.size()
				label.set_text(palavra[aleatoria])
				label2.set_text(palavra[aleatoria])
				label3.set_text(palavra[aleatoria])
				label2.set_visible_characters(0)
				if (posicao+1) == 5:
					global.provasCompletas += 1
					get_tree().change_scene("res://scenes/Mundo.tscn")
		else:
			label2.set_visible_characters(0)
			label3.visible = true
			canType = false
			
			errorTimer = Timer.new()
			errorTimer.set_one_shot(true)
			errorTimer.set_wait_time(ERROR_COOLDOWN)
			errorTimer.connect("timeout", self, "errorCooldownOver")
			add_child(errorTimer)
			errorTimer.start()
	textLine.text = ""

func errorCooldownOver():
	canType = true
	label3.visible = false

func startAttackTimer():
	$AnimationPlayer.play("Idle")
	attackTimer = Timer.new()
	attackTimer.set_one_shot(false)
	attackTimer.set_wait_time(ATTACK_COOLDOWN/2)
	attackTimer.connect("timeout", self, "attackCooldownOver")
	add_child(attackTimer)
	attackTimer.start()

func attackCooldownOver():
	$AnimationPlayer.play("Attack")
	if i < 9 + combo:
		#betweenAttacks = Timer.new()
		#betweenAttacks.set_wait_time(BETWEEN_ATTACKS)
		#betweenAttacks.connect("timeout", self, "attackCooldownOver")
		var instancia = projetil.instance()
		instancia.position.x = 250
		instancia.position.y = 90
		instancia.setVelocity(angleToVector(0.5 - float(i)/float(8 + combo), 12000 * fase))
		add_child(instancia)
		i += 1
	else:
		i = 0
		if(combo==1):
			combo = 0
		else:
			combo = 1
		$AnimationPlayer.play("Idle")
	#for i in range(9 + combo):
	#	var instancia = projetil.instance()
	#	instancia.position.x = 250
	#	instancia.position.y = 90
	#	instancia.setVelocity(angleToVector(0.5 - float(i)/(8 + combo), 8000))
	#	add_child(instancia)
	
		
func betweenAttacksOver():
	i += 1

func angleToVector(angle, speed): #ângulo tem que ser em radianos sem o PI, por que o PI já ta na função
	if combo == 1:
		return Vector2(speed * -sin(angle * PI), speed * cos(angle * PI))
	else:
		return Vector2(speed * sin(angle * PI), speed * cos(angle * PI))

func shuffleList(list):
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        randomize()
        var x = randi()%indexList.size()
        shuffledList.append(list[x])
        indexList.remove(x)
        list.remove(x)
    return shuffledList