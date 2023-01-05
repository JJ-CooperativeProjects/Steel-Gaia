extends Plataforma
class_name PlataformaMovil
"""
UN TIPO ESPECIAL DE PLATAFORMA QUE SE PUEDE CONFIGURAR PARA HACER MOVIMIENTOS VERTICALES Y HORIZONTALES. 
"""
##
enum tipos_movimientos{HORIZONTAL,VERTICAL}
export (tipos_movimientos) var tipo_movimiento = tipos_movimientos.HORIZONTAL

##Si la animación debe ser en bucle. Una plataforma con bucle, regresará a la posicion inicial
# despues de llegar al destino y se mantendrá así infinitamente.
export (bool) var es_bucle:bool = true

##Sentido en que comenzará a moverse:
# -1 = izquierda, si es horizontal o arriba si es vertical
# 1 = derecha, si es horizontal o abajo si es vertical
export (int, "-1","1") var sentido:int = 1 
##Tiempo de duración de una ronda:
export (float) var tiempo_recorrido:float = 5.5

##Tiempo de espera antes de empezar a moverse en segundos:
export (float) var tiempo_espera:float = 2.5

##Máxima distancia que recorrerá, donde se considera que llegó al destino. (dejar en cero si se va a mover por path.)
export (float) var max_distancia:float = 0


var llego_destino:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#Configurar:
	var timer:SceneTreeTimer = get_tree().create_timer(tiempo_espera)
	timer.connect("timeout",self,"mover_plataforma")
			
		
	pass # Replace with function body.

func mover_plataforma():
	var tween:SceneTreeTween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	match tipo_movimiento:
		tipos_movimientos.HORIZONTAL:
			if not llego_destino:
				if sentido == 1:
					tween.tween_property(self,"position:x", position.x + max_distancia, tiempo_recorrido)
					tween.connect("finished",self, "llego_final")
				
				else:
					tween.tween_property(self,"position:x", position.x - max_distancia, tiempo_recorrido)
					tween.connect("finished",self, "llego_final")
			else:
				if sentido == 1:
					tween.tween_property(self,"position:x", position.x - max_distancia, tiempo_recorrido)
					tween.connect("finished",self, "llego_final")
				else:
					tween.tween_property(self,"position:x", position.x + max_distancia, tiempo_recorrido)
					tween.connect("finished",self, "llego_final")
		
		tipos_movimientos.VERTICAL:
			if not llego_destino:
				if sentido == 1:
					tween.tween_property(self,"position:y", position.y + max_distancia, tiempo_recorrido)
					tween.connect("finished",self, "llego_final")
				else:
					tween.tween_property(self,"position:y", position.y - max_distancia, tiempo_recorrido)
					tween.connect("finished",self, "llego_final")
			else:
				if sentido == 1:
					tween.tween_property(self,"position:y", position.y - max_distancia, tiempo_recorrido)
					tween.connect("finished",self, "llego_final")
				else:
					tween.tween_property(self,"position:y", position.y + max_distancia, tiempo_recorrido)
					tween.connect("finished",self, "llego_final")
func llego_final():
	llego_destino = true if not llego_destino else false
	
	var timer:SceneTreeTimer = get_tree().create_timer(tiempo_espera)
	timer.connect("timeout",self,"mover_plataforma")

