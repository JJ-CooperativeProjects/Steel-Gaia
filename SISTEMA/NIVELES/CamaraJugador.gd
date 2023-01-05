extends Position2D

var mi_jugador = null
var vector_pluss:Vector2


func _ready():
	Memoria.camara_actual = $Camera2D
#func _input(event):
#	if event.is_action_released("atacar"):
#		$Camera2D.sacudir(50)
func _process(delta):
	var coe_x:float = stepify(lerp(vector_pluss.x,mi_jugador.movimiento.x,0.002),0.1)
	var coe_y:float 
	if mi_jugador.movimiento.y <= 0:
		coe_y= stepify(lerp(vector_pluss.y,mi_jugador.movimiento.y,0.023),0.1)
	else:
		coe_y= stepify(lerp(vector_pluss.y,mi_jugador.movimiento.y,0.02),0.1)
	vector_pluss = Vector2(clamp(coe_x,-50,50),clamp(coe_y,-1,50))#clamp(coe_y,-1,1))

	#prints(coe_x,coe_y)
	if $Camera2D.trauma:
		$Camera2D.trauma =  max ($Camera2D.trauma - ($Camera2D.decaimiento * delta), 0)
		
		global_position = mi_jugador.global_position + vector_pluss + $Camera2D.comenzar()
		return
	global_position = mi_jugador.global_position + vector_pluss
