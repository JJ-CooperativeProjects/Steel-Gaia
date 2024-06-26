extends Pantalla

func _unhandled_input(event):
	if event.is_action_released("atacar"):
		$BotonVolver.visible = true
		pass

func _ready():
	GuiJugador.visible = false
	
	
func MostrarDirector():
	$AnimationPlayer.play("director_visible")

func _on_BotonVolver_button_up():
	if not Memoria.modo_cinematica_activo:
		$BotonVolver.EmitirSonido($BotonVolver.sonido_aceptar2)
		if Memoria.juego_terminado:
			CambioSuave.CambiarEscena("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaMenuPrincipal.tscn")
			Memoria.juego_terminado = false
			return
			
		if not Memoria.nivel_actual:
			CambioSuave.CambiarEscena(Memoria.historial_pantallas.pop_back())

		else:
			MenusGlobales.PonerMenu(MenusGlobales.get_node("PantallaOpciones").get_path())
			$AnimationPlayer.stop(true)
	pass # Replace with function body.



func _on_PantallaCreditos_visibility_changed():
	if visible == true:
		$AnimationPlayer.play("scroll")
	pass # Replace with function body.
