extends Pantalla
#Pantalla Opciones


func _on_BotonVolver_button_up():
	if not Memoria.modo_cinematica_activo:
		if not Memoria.nivel_actual:
			CambioSuave.CambiarEscena(Memoria.historial_pantallas.pop_back())

		else:
			MenusGlobales.PonerMenu(MenusGlobales.get_node("PantallaMenuRapido").get_path())
		pass # Replace with function body.


func _on_BotonMostrarCreditos_pressed():
	if not Memoria.modo_cinematica_activo:
		if not Memoria.nivel_actual:
			Memoria.historial_pantallas.append("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaOpciones.tscn")
			CambioSuave.CambiarEscena("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaCreditos.tscn")

		else:
			get_tree().root.get_node("/root/MenusGlobales").PonerMenu("PantallaCreditos")
	
	pass # Replace with function body.
