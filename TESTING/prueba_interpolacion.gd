extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Curve) var cuerva:Curve
var time:float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time <= 1.0:
		position.y += cuerva.interpolate(time) * -20
		time += (delta)*2
		return
	time = 0
	pass
