extends AreaDisparadorEvento
##Para activar al miniboss





func EsActivada():
	if not evento_terminado:
		var miniboss:MiniBoss = load("res://SISTEMA/ENTES/Usados/MiniBoss/MiniBoss.tscn").instance()
		miniboss.global_position = $Position2D.global_position
		Memoria.nivel_actual.get_node("ENEMIGOS").call_deferred("add_child",miniboss)
		miniboss.connect("es_destruido",self,"abrir_puertas")
		
		for i in nodos_del_evento:
			get_node(i).Activar()
			
		EsDesactivada()
	pass

func abrir_puertas():
	for i in nodos_del_evento:
		get_node(i).Activar()
	
	if not es_repetible:
		queue_free()
	


