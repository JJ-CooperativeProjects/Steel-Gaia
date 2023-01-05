extends KinematicBody2D

var movimiento:Vector2 = Vector2.ZERO
export (float) var velocidad_bala:float = 500

export (int) var max_rebotes:int  = 1
var rebotes:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	mecanica(delta)
	
#	pass

func mecanica(delta):
	var colision = move_and_collide(movimiento.normalized()* delta * velocidad_bala)
	
	if colision:

		
		var prox:Vector2 = Vector2(1,0).rotated(movimiento.bounce(colision.normal).angle())
		
		rotate(movimiento.angle_to(prox))
		movimiento = prox
		rebotes += 1
		
	
		if rebotes == max_rebotes:
			queue_free()
		pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if viewport == get_tree().root.get_viewport():
		queue_free()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
