extends KinematicBody2D

export (Vector2) var vector_pluss:Vector2 = Vector2.ZERO

var movimiento:Vector2 = Vector2.ZERO



func _ready():
	$mov_pluss.play("movimiento_levitar")
	pass

func _process(delta):
	pass
func _physics_process(delta):
	#movimiento.y += Memoria.gravedad * delta
#	var data:Dictionary = ScriptsGlobales._movimiento_suavisado_de_A_a_B(global_position, get_global_mouse_position(), 120,5, 50)
#	movimiento = data.vector
#	movimiento = move_and_slide(movimiento+vector_pluss)
	
#	var data:Dictionary = ScriptsGlobales._movimiento_suavisado_de_huida(global_position, get_global_mouse_position(), 120, 300)
#	movimiento = data.vector
#	movimiento = move_and_slide(movimiento)
	
	movimiento = ScriptsGlobales._movimiento_suavisado_de_huida_volar(global_position,get_global_mouse_position(), 2, 3,50).vector
	movimiento = move_and_slide(movimiento)
	pass
