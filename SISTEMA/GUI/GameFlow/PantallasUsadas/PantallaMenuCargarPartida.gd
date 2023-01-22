extends Pantalla

export (String) var directorio_salvas:String

func _ready():
	pass

func _on_BotonVolver_button_up():
	if not Memoria.modo_cinematica_activo:
		$BotonVolver.EmitirSonido($BotonVolver.sonido_aceptar2)
		if not Memoria.nivel_actual:
			CambioSuave.CambiarEscena(Memoria.historial_pantallas.pop_back())

		else:
			MenusGlobales.PonerMenu(MenusGlobales.get_node("PantallaMenuRapido").get_path())

	
	
	pass # Replace with function body.


func _on_PantallaMenuCargarPartida_visibility_changed():
	if visible == true:
		ObtenerSalvas()
		pass
	pass # Replace with function body.

func LimpiarGrid():
	for i in $ScrollContainer/Grid.get_children():
		i.queue_free()

func ObtenerSalvas():
	LimpiarGrid()
	var dir:Directory = Directory.new()
	if dir.open(directorio_salvas) == OK:
		dir.list_dir_begin(true)
		
		var file:String = dir.get_next()
		while file != "":
			if dir.current_is_dir():
				print("Found directory: " + file)
			else:
				#print("Found file: " + file)
				
				#Si el archivo es un png:
				if file.right(file.rfind("png")) == "png":
					print(file)
					var texture:Texture
					#Cargo la textura:
					if dir.file_exists("user://SAVES/"+ file):
						texture = Memoria.CargarImagen("user://SAVES/"+ file)
					else:
						print("No puede cargar la foto!")
						break
					#
					var ruta_salva:String = file.left(file.rfind(".png"))
					print (ruta_salva)
					
					#Crea el boton:
					#verificar si existe una salva original:
					var f:File = File.new()
					if f.file_exists("user://SAVES/" + ruta_salva + ".tres"):
						var boton_salva:BotonSalva = load("res://SISTEMA/GUI/GameFlow/Boton_Salva.tscn").instance()
						boton_salva.ruta_archivo = ruta_salva
						boton_salva.texture_normal = texture
						
						$ScrollContainer/Grid.add_child(boton_salva)
					else:
						Memoria.consola_debug.PonerEnConsola(["No se ha encotrado el archivo ", ruta_salva])
					
			file = dir.get_next()


	else:
		print("no existe el directorio de salvas!")
	pass
