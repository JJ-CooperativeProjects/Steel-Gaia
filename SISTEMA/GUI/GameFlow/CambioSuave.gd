extends CanvasLayer

export (float) var tiempo_transicion:float = 0.5
export (float) var tiempo_transicion_final:float = 0.2

onready var fondo:ColorRect = $ColorRect

#Si es completo, carga una nueva escena y borra el tree. Si es false, entonces usa load y carga la escena dentro del tree (esto es para no perder el arbol de la escena.)
func CambiarEscena(ruta_escena:String,tiempo_oscurecer:float = tiempo_transicion,tiempo_aclarar:float = tiempo_transicion_final):
	var tween:SceneTreeTween = get_tree().create_tween()
	tween.tween_property(fondo,"modulate",Color(0,0,0,1),tiempo_oscurecer)
	tween.connect("finished",self,"segundo_paso",[ruta_escena,tiempo_aclarar])
	
	Memoria.set_modo_cinematica(true)


func segundo_paso(ruta_escena,tiempo_aclarar:float):
	get_tree().change_scene(ruta_escena)
	
	if Memoria.cambiando or Memoria.es_nuevo:
		if not Memoria.is_connected("datos_cargados",self,"tercer_paso"):
			Memoria.connect("datos_cargados",self,"tercer_paso",[tiempo_aclarar])
		return
	var tween:SceneTreeTween = get_tree().create_tween()
	tween.tween_property(fondo,"modulate",Color(0,0,0,0),tiempo_aclarar)
	Memoria.set_modo_cinematica(false)
	

func tercer_paso(tiempo_aclarar:float):
	yield(get_tree().create_timer(0.5),"timeout")
	var tween:SceneTreeTween = get_tree().create_tween()
	tween.tween_property(fondo,"modulate",Color(0,0,0,0),tiempo_aclarar)
	Memoria.set_modo_cinematica(false)
