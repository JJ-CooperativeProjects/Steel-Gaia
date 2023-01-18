extends DisparoBase

var objetivo:Node2D
#Valores para el radio de apertura del disparo(Tolerancia)
export (Vector2) var amplitud_zona_impacto:Vector2 = Vector2(10,10)
export (Vector2) var altura_zona_imacto:Vector2 = Vector2(10,10)
##La distancia mínima en la que el misil deja de dirigirse al objetivo.
export (float) var distancia_minima_desvariar:float = 90

enum estados {DIRIGIDO,LINEAL}
var estado:int = estados.DIRIGIDO

var vector_objetivo:Vector2 = Vector2.ZERO

func _ready():
	objetivo = Memoria.jugador
	var x_obj:float = objetivo.global_position.x
	var y_obj:float = objetivo.global_position.y
	
	vector_objetivo = Vector2(rand_range(x_obj-amplitud_zona_impacto.x,x_obj+ amplitud_zona_impacto.y),rand_range(y_obj-altura_zona_imacto.x,y_obj+altura_zona_imacto.y))
	$AreaDamage.connect("body_entered",self,"crear_explosion")

func mecanica(delta):
	var colision 
	match estado:
		estados.DIRIGIDO:
			if global_position.distance_to(objetivo.global_position) > distancia_minima_desvariar:
				var direction:Vector2 = vector_objetivo - global_position
				direction = direction.normalized()
				
				var rotateAmount = direction.cross(transform.y)
				
				rotate(rotateAmount * (randi()%6+2) * delta)
				
				
				movimiento = -transform.y.normalized() * (velocidad_bala/2)
				colision = move_and_collide(movimiento * delta)
			else:
#				rotate(deg2rad(-90))
#				$Sprite.rotation = 0
#				movimiento = Vector2(1,0).rotated(rotation)
				
				estado = estados.LINEAL
				movimiento.x = 1
		
		estados.LINEAL:
			colision = move_and_collide(movimiento.normalized()* delta * (velocidad_bala/2))
		
	if colision:
		crear_explosion(null)
		pass
	
	#print(estado)
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
