extends Enemigo
class_name MiniBoss


onready var area_minas:PackedScene = preload("res://SISTEMA/GLOBAL/AREAS/AreaDetectarObstaculos_para_mina_neutral.tscn")


var detectados:int = -1
#Metodo que elige un tipo de magia para crear en el escenario:
func invocar():
	DeterminarMinasNeutrales(10,10)
	pass

#func _input(event):
#	if event.is_action_released("escopeta"):
#		DeterminarMinasNeutrales(10,40)

func determinar_punto_moverse(current_camara:Camera2D)->Vector2:
	var vec:Vector2 = Vector2.ZERO
	
	var pos_center:Vector2 = current_camara.get_camera_screen_center()
	
	if global_position.x > pos_center.x:
		vec = Vector2(pos_center.x-200,rand_range(pos_center.y-150,pos_center.y+150))
	else:
		vec = Vector2(pos_center.x+200,rand_range(pos_center.y-150,pos_center.y+150))
	
	return vec

#Metodo que analiza el entorno para crear minas neutrales mágicas.
#Max_repeticiones =  la cantidad de veces que el algoritmo buscará espacios vacios.
func DeterminarMinasNeutrales(cantidad:int = 5,max_repeticiones:int = 20, max_alto:float = 100, max_ancho:float = 300):
	pass

func CrearMina():
	var centro:Vector2 = Memoria.jugador.global_position
	var punto_aleatorio:Vector2 = Vector2(rand_range(centro.x - 200,centro.x + 200),rand_range(centro.y - 150, centro.y + 150))
	
	var nuevo_detector:AreaDetectarObstaculos = area_minas.instance()
	nuevo_detector.global_position = punto_aleatorio
	Memoria.nivel_actual.call_deferred("add_child",nuevo_detector)

func set_vitalidad(valor:int):
	vitalidad = valor
	if is_inside_tree():
		$CanvasLayer/GUI_miniboss/barra_vida.value = vitalidad


