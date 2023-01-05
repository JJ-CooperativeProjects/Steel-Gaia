extends KinematicBody2D

var movimiento:Vector2 = Vector2.ZERO


func _physics_process(delta):
	movimiento.y += Memoria.gravedad * delta
	
	movimiento = move_and_slide(movimiento)
	pass
