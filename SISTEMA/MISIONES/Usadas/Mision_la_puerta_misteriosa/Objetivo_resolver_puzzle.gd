extends Objetivo

#Este objetivo gestiona todo lo relacionado con el orbe y los cubos
#Para resolver el puzzle.

var puerta:Intercambiador = null
var cerradura:Node2D = null


func _ready():
	Memoria.connect("datos_cargados",self,"AfterCargar")



func AfterCargar():
	if activo:
		puerta = Memoria.nivel_actual.get_node_or_null("AREAS_EVENTOS/Intercambiador_hacia_DinoBoss")

		if puerta:
			print("hay puerta")
			for i in get_children():
				i.queue_free()
			
			if get_child_count() == 0:
				cerradura = load("res://SISTEMA/OBJETOS/PUERTA_NIVEL_BOSS/PuertaNivelBoss.tscn").instance() as Node2D
				cerradura.global_position = puerta.get_node("Position2D").global_position
				call_deferred("add_child",cerradura)
				
				puerta.get_node("AreaDisparadorEvento_por_tecla").activo = false
				cerradura.connect("terminado",puerta.get_node("AreaDisparadorEvento_por_tecla"),"set_activo",[true])
				
				cerradura.connect("terminado",self,"emit_signal",["objetivo_terminado"])
				cerradura.mi_objetivo = self
		else:
			for i in get_children():
				i.queue_free()
		
func _on_Objetivo_objetivo_terminado():
	._on_Objetivo_objetivo_terminado()
	
	puerta.desactivado = false
	get_tree().paused = false
	cerradura.puzzle.queue_free()
	
	for i in get_children():
		i.queue_free()
