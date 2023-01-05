extends DisparoBase

var objetivo:Node2D

enum estados {DIRIGIDO,LINEAL}
var estado:int = estados.DIRIGIDO

var vector_objetivo:Vector2 = Vector2.ZERO

func _ready():
	objetivo = Memoria.jugador
	var x_obj:float = objetivo.global_position.x
	var y_obj:float = objetivo.global_position.y
	
	vector_objetivo = Vector2(rand_range(x_obj-200,x_obj+200),rand_range(y_obj-100,y_obj+100))

func mecanica(delta):
	var colision 
	match estado:
		estados.DIRIGIDO:
			if global_position.distance_to(objetivo.global_position) > 90:
				var direction:Vector2 = vector_objetivo - global_position
				direction = direction.normalized()
				
				var rotateAmount = direction.cross(transform.y)
				
				rotate(rotateAmount * (randi()%6+2) * delta)
				
				
				movimiento = -transform.y.normalized() * (velocidad_bala/2)
				colision = move_and_collide(movimiento * delta)
			else:
				rotate(deg2rad(-90))
				$Sprite.rotation = 0
				movimiento = Vector2(1,0).rotated(rotation)
				estado = estados.LINEAL
		
		estados.LINEAL:
			colision = move_and_collide(movimiento.normalized()* delta * (velocidad_bala/2))
		
		
	
	
	if colision:
		crear_explosion()
		pass
	
	#print(estado)
	pass
