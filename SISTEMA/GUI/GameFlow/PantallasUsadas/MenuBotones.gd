extends ScrollContainer
class_name MenuBotones

"""
CLASE BASE PARA MENUS DE BOTONES
"""


#Comenzar partida:
func _on_BotonEmpezarPartida_button_up():
	if not Memoria.modo_cinematica_activo:
		$VBoxContainer/BotonEmpezarPartida.EmitirSonido($VBoxContainer/BotonEmpezarPartida.sonido_aceptar)
		Memoria.historial_pantallas.clear()
		CambioSuave.CambiarEscena("res://UTILIZABLES/Niveles/Usados/PuebasPrototipo/Nivel_1.tscn")
		
		#Volumen:
		AudioManagerGlobal.BajarVolumenMaster(0.5)

	pass # Replace with function body.


func _on_BotonCargarPartida_button_up():
	
	if not Memoria.modo_cinematica_activo:
		$VBoxContainer/BotonCargarPartida.EmitirSonido($VBoxContainer/BotonCargarPartida.sonido_aceptar2)
		if not Memoria.nivel_actual:
			Memoria.historial_pantallas.append("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaMenuPrincipal.tscn")
			CambioSuave.CambiarEscena("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaMenuCargarPartida.tscn")
			
		
		else:
			get_tree().root.get_node("/root/MenusGlobales").PonerMenu("PantallaMenuCargarPartida")
	
	pass # Replace with function body.


func _on_BotonOpciones_button_up():
	if not Memoria.modo_cinematica_activo:
		$VBoxContainer/BotonOpciones.EmitirSonido($VBoxContainer/BotonOpciones.sonido_aceptar2)
		if not Memoria.nivel_actual:
			Memoria.historial_pantallas.append("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaMenuPrincipal.tscn")  
			CambioSuave.CambiarEscena("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaOpciones.tscn")
		else:
			get_tree().root.get_node("/root/MenusGlobales").PonerMenu("PantallaOpciones")
		
	pass # Replace with function body.


func _on_BotonSalirJuego_button_up():
	if not Memoria.modo_cinematica_activo:
		$VBoxContainer/BotonSalirJuego.EmitirSonido($VBoxContainer/BotonSalirJuego.sonido_aceptar2)
		get_tree().quit()

	pass # Replace with function body.


