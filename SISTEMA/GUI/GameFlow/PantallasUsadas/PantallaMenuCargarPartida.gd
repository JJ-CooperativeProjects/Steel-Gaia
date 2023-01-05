extends Pantalla



func _on_BotonVolver_button_up():
	if not Memoria.modo_cinematica_activo:
		if not Memoria.nivel_actual:
			CambioSuave.CambiarEscena(Memoria.historial_pantallas.pop_back())

		else:
			visible = false
	
	
	pass # Replace with function body.
