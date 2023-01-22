extends MenuBotones


func _on_BotonContinuar_button_up():
	if not Memoria.modo_cinematica_activo:
		$VBoxContainer/BotonContinuar.EmitirSonido($VBoxContainer/BotonContinuar.sonido_aceptar2)
		var minijuego:Puzzle = Memoria.nivel_actual.get_node_or_null("CanvasLayer/Puzzle")
		get_parent().visible = false
		
		if minijuego:
			minijuego.pause_mode = Node.PAUSE_MODE_PROCESS
			
		#
		else:
			if not Memoria.juego_pausado:
				get_tree().paused = false
	
	pass # Replace with function body.


func _on_BotonSalirMenu_pressed():
	if not Memoria.modo_cinematica_activo:
		$VBoxContainer/BotonContinuar.EmitirSonido($VBoxContainer/BotonContinuar.sonido_aceptar2)
		Memoria.nivel_actual = null
		get_tree().root.get_node("/root/MenusGlobales").get_node("PantallaMenuRapido").visible = false
		get_tree().paused =false
		CambioSuave.CambiarEscena("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaMenuPrincipal.tscn")
		
		GuiJugador.visible = false
	pass # Replace with function body.
