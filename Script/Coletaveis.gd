extends Spatial

onready var ammo = preload("res://Assets/Textures/coletaveis/ammo.png")
onready var armor = preload("res://Assets/Textures/coletaveis/armor.png")
onready var health = preload("res://Assets/Textures/coletaveis/health.png")
onready var shotgun = preload("res://Assets/Textures/coletaveis/shotgun.png")
onready var sprite = $Sprite3D

var ehammo = false
var eharmor = false
var ehhealth = false
var ehshotgun = false

export(int, "ammo", "armor", "health", "shotgun") var type # 0 ammo - 1 armor - 2 health - 3 shotgun

func _ready():
	if type == 0:
		sprite.set_texture(ammo)
		ehammo = true
	elif type == 1:
		sprite.set_texture(armor)
		eharmor = true
	elif type == 2:
		sprite.set_texture(health)
		ehhealth = true
	elif type == 3:
		sprite.set_texture(shotgun)
		ehshotgun = true

func _on_StaticBody_body_entered(body):
	if "Player" in body.name:
		if type == 0:
			DoomGlobal.ammo += 12
		elif type == 1:
			DoomGlobal.armor += 100
		elif type == 2:
			DoomGlobal.health += 100
		elif type == 3:
			DoomGlobal.ammo += 12
			body.set_temShotgun()
			body.textoMunicao.visible = true
		queue_free()
