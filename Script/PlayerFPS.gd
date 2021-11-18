extends KinematicBody

const MOVE_SPEED = 8
const MOUSE_SENS = 0.5

onready var anim_player = $AnimationPlayer
onready var raycast = $RayCast
onready var area = $Area
onready var spriteGun = $CanvasLayer/Control/Sprite
onready var spriteShotgun = $CanvasLayer/Control/Sprite2
onready var textoVida = $CanvasLayer/Control/Vida
onready var textoArmadura = $CanvasLayer/Control/Armadura
onready var textoMunicao = $CanvasLayer/Control/Municao

var temShotgun = true#testar
var shotgun = false
var canChange = true

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
	#DoomGlobal.health = 100
	#DoomGlobal.armor = 0
	#DoomGlobal.ammo = 0
	#textoMunicao.visible = false

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
 
func _process(delta):
	if Input.is_action_pressed("Sair"):
		get_tree().quit()
	if Input.is_action_pressed("Recomecar"):
		get_tree().reload_current_scene()#testar
	
 
func _physics_process(delta):
	textoVida.set_text(str(DoomGlobal.health))
	textoArmadura.set_text(str(DoomGlobal.armor))
	textoMunicao.set_text(str(DoomGlobal.ammo))
	
	var move_vec = Vector3()
	if Input.is_action_pressed("FrenteFPS"):
		move_vec.z -= 1
	if Input.is_action_pressed("AtrasFPS"):
		move_vec.z += 1
	if Input.is_action_pressed("EsquerdaFPS"):
		move_vec.x -= 1
	if Input.is_action_pressed("DireitaFPS"):
		move_vec.x += 1
	if Input.is_action_pressed("changeGun"):
		if canChange:
			changeGun()
			canChange = false
	else:
		canChange = true
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * MOVE_SPEED * delta)
   
	if Input.is_action_pressed("C") and !anim_player.is_playing():
		if shotgun and temShotgun:#testar
			if DoomGlobal.ammo > 0:#testar
				DoomGlobal.ammo -= 1#testar
				anim_player.play("shootShotgun")
				for body in area.get_overlapping_bodies():
					if body.has_method("hasPlayerVision") and body.has_method("hurt") and body != self:
						if body.hasPlayerVision():
							body.hurt(70)
		else:
			anim_player.play("shoot")
			var coll = raycast.get_collider()
			if coll != null and coll.has_method("hurt"):
				coll.hurt(40)

func changeGun():
	if temShotgun:#testar
		if shotgun:
			spriteShotgun.set_visible(false)
			spriteGun.set_visible(true)
			
			shotgun = false
		else:
			spriteShotgun.set_visible(true)
			spriteGun.set_visible(false)
			
			shotgun = true
 

func hurt(dano):#testar
	if DoomGlobal.armor == 0:
		DoomGlobal.health -= dano
		if DoomGlobal.health <= 0:
			DoomGlobal.health = 100
			DoomGlobal.armor = 0
			DoomGlobal.ammo = 0
			textoMunicao.visible = false
			DoomGlobal.dead()
	else:
		DoomGlobal.armor -= dano
		if DoomGlobal.armor < 0:
			DoomGlobal.health += DoomGlobal.armor
			DoomGlobal.armor = 0
	

func set_temShotgun():#testar
	temShotgun = true