extends Sprite
class_name DashEffect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a = lerp(modulate.a,0,0.3)
	if modulate.a < 0.01:
		queue_free()
	pass
