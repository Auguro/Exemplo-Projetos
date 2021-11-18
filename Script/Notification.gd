extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const DURATION = 5

var shown = false
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func appear():
	$AnimationPlayer.play("Appear")
	shown = true

func disappear():
	$AnimationPlayer.play("Disappear")
	shown = false
	
func notify():
	if not shown:
		appear()
	else:
		timer.queue_free()
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	timer.set_wait_time(DURATION)
	add_child(timer) #to process
	timer.start()
	
func _on_timer_timeout():
	disappear()