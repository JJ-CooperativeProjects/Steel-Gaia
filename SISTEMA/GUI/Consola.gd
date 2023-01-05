extends Panel


export (Dictionary) var codes:Dictionary

func _ready():
	Memoria.consola = self

func _input(event):
	if visible:
		if event.is_action_pressed("ui_accept"):
			#Verificar si el codigo es correcto:
			var cod:String = $LineEdit.text
			
			if codes.has(cod):
				call_deferred(codes[cod])
				#print("vida full")
			
			$LineEdit.text = ""
			visible = false
			get_tree().paused = false


func SetVidaJugadorFull():
	Memoria.jugador.set_vitalidad(Memoria.jugador.max_vitalidad)


func _on_Consola_focus_entered():
	#print("foco")
	pass # Replace with function body.


func _on_Consola_visibility_changed():
	if visible == true:
		get_tree().paused = true
		grab_focus()
	pass # Replace with function body.
