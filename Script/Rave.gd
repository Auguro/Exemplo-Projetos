extends KinematicBody

const MOVE_SPEED = 6
const ALCANCE_DE_CONTATO = 3 #menor valor = Imp ter que estar mais perto do jogador para matar
const ALCANCE_DE_PERCEPCAO = 60 #maior valor = Imp detecta o jogador de mais longe
const COOLDOWN = 2 #tempo em segundos que o Imp tem que esperar para atacar de novo para ataques à distância
const DELAY_DE_ATAQUE = 1 #tempo em segundos entre o inicio da animação de ataque até a bola surgir, melhor ser igual a duração da animação de ataque
const MELEE_COOLDOWN = 1 #tempo em segundos que o Imp tem que esperar para atacar de novo para corpo-a-corpo
const HURT_COOLDOWN = 0.2 #tempo em segundos que o Imp fica incapacitado depois de levar dano, deve ser igual o tempo de animação de levar dano

onready var raycast = $RayCast
onready var raycast2 = $RayCast2
onready var anim_player = $AnimationPlayer

var player = null
var dead = false
var agro = false
var timer = null
var timer2 = null
var canShoot = true
var damage = 30
var incapacitated = false
var meleeTimer = null
var hurtTimer = null
var vida = 400
var hurtCooldown = false
var meleeCooldown = false
var quantBolas = 4

export(int, "melee", "ranged") var enemytipe  # 1 Ranged - 0 Melee

func _enter_tree():
	add_to_group("zombies")

func _ready():
	randomize()
	$paciencia.start()
 
func _physics_process(delta):
	if incapacitated || dead || player == null:
		return
	
	if !agro and hasPlayerVision():
		agro = true
	else:
		agro = false
	
	if enemytipe == 0: #MELEE
		var vec_to_player = player.translation - translation
		vec_to_player = vec_to_player.normalized()
		raycast.cast_to = vec_to_player * ALCANCE_DE_CONTATO
		raycast2.cast_to = vec_to_player * ALCANCE_DE_PERCEPCAO
		
		if agro:
			anim_player.play("Walk")
			move_and_collide(vec_to_player * MOVE_SPEED * delta, 0)
		
		if raycast.is_colliding():
			var coll = raycast.get_collider()
			if coll != null and coll.name == "Player":
				anim_player.play("Punch")
				#global.falhas += 1
				coll.hurt(damage)
				
				incapacitated = true
				meleeCooldown = true
				
				meleeTimer = Timer.new()
				meleeTimer.set_one_shot(true)
				meleeTimer.set_wait_time(MELEE_COOLDOWN)
				meleeTimer.connect("timeout", self, "meleeCooldownOver")
				add_child(meleeTimer)
				meleeTimer.start()
	
	elif enemytipe == 1: #RANGED
		
		if agro and canShoot:
			anim_player.play("Shoot")
			
			timer2 = Timer.new()
			timer2.set_one_shot(true)
			timer2.set_wait_time(DELAY_DE_ATAQUE)
			timer2.connect("timeout", self, "attack")
			add_child(timer2)
			timer2.start()
			
			canShoot = false
			
			timer = Timer.new()
			timer.set_one_shot(true)
			timer.set_wait_time(COOLDOWN)
			timer.connect("timeout", self, "timeoutComplete")
			add_child(timer)
			timer.start()
	
func hurt(dmg):
	vida -= dmg
	if vida <= 0:
		kill()
	else:
		anim_player.play("hurt")
		incapacitated = true
		hurtCooldown = true
		
		hurtTimer = Timer.new()
		hurtTimer.set_one_shot(true)
		hurtTimer.set_wait_time(HURT_COOLDOWN)
		hurtTimer.connect("timeout", self, "hurtCooldownOver")
		add_child(hurtTimer)
		hurtTimer.start()

func kill():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("Death")
	var alguemVivo = false
	for i in get_tree().get_nodes_in_group("zombies"):
		if !i.dead:
			alguemVivo = true
	if !alguemVivo:
		get_tree().change_scene("res://scenes/Mundo.tscn")
		global.provasCompletas += 1
		
		

func hasPlayerVision():
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast2.cast_to = vec_to_player * ALCANCE_DE_PERCEPCAO
	return raycast2.get_collider() == player
 
func set_player(p):
    player = p
	
func meleeCooldownOver():
	meleeCooldown = false
	uptadeIncapacitated()

func hurtCooldownOver():
	incapacitated = false
	uptadeIncapacitated()
	
func uptadeIncapacitated():
	if !(hurtCooldown and meleeCooldown):
		incapacitated = false
	
#-------------------------------------------------RANGED-----------------------------------------------------#

func attack():
	if !dead:
		for i in range(1, 5):
			var scene = load("res://scenes/DIRAttack.tscn")
			var scene_instance = scene.instance()
			scene_instance.set_name("DIRAttack")
			scene_instance.set_player(player)
			scene_instance.translation = ((player.translation - translation).normalized() * 0.35).rotated(Vector3(0, 1, 0), PI*(float(3)/4 - float(i)/4))
			scene_instance.translation.y = player.translation.y - translation.y 
			add_child(scene_instance)
		enemytipe = 0
		$paciencia.start()


func timeoutComplete():
	canShoot = true

func _on_paciencia_timeout():
	enemytipe = 1
