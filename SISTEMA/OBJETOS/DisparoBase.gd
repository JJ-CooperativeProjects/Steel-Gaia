extends KinematicBody2D
class_name DisparoBase

"""
CLASE PARA CONSTRUIR DISPAROS DESDE UN KINEMATIC
"""
export (float) var max_velocidad:int = 600
export (int) var max_rebotes:int  = 1

var movimiento:Vector2 = Vector2.ZERO
var rebotes:int = 0

export (float) var velocidad_bala:float = 0
var pos_origen:Vector2

func _ready():
	$AnimationPlayer.play("disparo")
	#movimiento.x = 1
	
func _physics_process(delta):
	mecanica(delta)


func mecanica(delta):
	var colision = move_and_collide(movimiento.normalized()* delta * velocidad_bala)
	
	if colision:

		var prox:Vector2 = Vector2(1,0).rotated(movimiento.bounce(colision.normal).angle())
		
		rotate(movimiento.angle_to(prox))
		movimiento = prox
		rebotes += 1
		
	
		if rebotes == max_rebotes:
			crear_explosion()
		

			
	
	pass


func crear_explosion():
	var explosion:MinaNeutral = load("res://UTILIZABLES/Trampas/MinaNeutral.tscn").instance()
	explosion.global_position = global_position
	explosion.activa = false
	
	Memoria.nivel_actual.add_child(explosion)
	explosion.explotar()
	queue_free()

func movimiento_sueva_a_rapido(coeficiente_velocidad:float = 5,max_velocidad:float = 500):
	pass

func golpea_un_enemigo(enemigo):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	pass # Replace with function body.
