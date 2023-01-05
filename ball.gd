extends KinematicBody2D


var velocidad_movimiento:float = 200
var movimiento:Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	rotate(deg2rad(20))
	movimiento = Vector2(1,0).rotated(deg2rad(20))
	pass # Replace with function body.


func _physics_process(delta):
	var col = move_and_collide(movimiento * delta * velocidad_movimiento,false)
	
	if col:
		
		var prox:Vector2 = Vector2(1,0).rotated(movimiento.bounce(col.normal).angle())
		
		rotate(movimiento.angle_to(prox))
		movimiento = prox
	pass
