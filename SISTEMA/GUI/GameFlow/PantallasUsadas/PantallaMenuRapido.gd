extends Pantalla

func MostrarOcultarMenu():
	if Memoria.nivel_actual:
		var minijuego:Puzzle = Memoria.nivel_actual.get_node_or_null("CanvasLayer/Puzzle")
		visible = true if visible == false else false
		
		if minijuego:
			if visible:
				minijuego.pause_mode = Node.PAUSE_MODE_STOP
			
			else:
				minijuego.pause_mode = Node.PAUSE_MODE_PROCESS
			
		#
		else:
			if not Memoria.juego_pausado:
				get_tree().paused = true if get_tree().paused == false else false
