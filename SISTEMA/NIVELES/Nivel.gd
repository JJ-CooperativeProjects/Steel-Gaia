extends Node2D
class_name Nivel
"""
BASE PARA CONSTRUIR NIVELES
"""

func _init():
	Memoria.nivel_actual = self

func _input(event):
	if event.is_action_pressed("salvar"):
		Memoria.consola_debug.PonerEnConsola(["Salvando..."])
		Memoria.SalvarNuevo("Prueba1")
	
	if event.is_action_pressed("cargar"):
		Memoria.CargarPartidaNombre("Prueba1")
	
	if event.is_action_pressed("escape"):
		Memoria.consola_debug.PonerEnConsola(["Se pulso escape desde el nivel"])

func _unhandled_input(event):
	if event.is_action_pressed("F1"):
		#print(2423423)
		Memoria.jugador.get_node("MEF").GenerarInputPressed("atacar")
		$CanvasLayer/Control/ColorRect.visible = true if $CanvasLayer/Control/ColorRect.visible == false else false

		Memoria.debug = true if $CanvasLayer/Control/ColorRect.visible else false
		$CanvasLayer/Control/Label.visible = !Memoria.debug
		pass

func _ready():
	#Activa los efectos especiales:
	
	$BACK/ParallaxBackground.visible = true
	$BACK/Canvas.visible = true
	GuiJugador.visible = true
	
	#CARGAR:
	
	if Memoria.es_nuevo or Memoria.cambiando:
		CargarPartida()
	else:
		var timer := get_tree().create_timer(0.1)
		timer.connect("timeout",self,"pos_cargado")
	
	#Volumen:
	AudioManagerGlobal.SubirVolumenMaster()
	AudioManagerGlobal.audio_master.stop()
	
	pass

func Salvar(data_vacio:Dictionary)->Dictionary:
	data_vacio.merge( {
		"ruta_nodo":get_path(),
		"ruta_file": filename,
		"nombre":name,
	})
	
	if get_child_count() != 0:
		for n in get_children():
			var nodo:Node = n as Node
			
			##Entro un nivel:
			for i in nodo.get_children():
				if i.is_in_group("Persistentes"):
					if not data_vacio.has("hijos"):
						data_vacio["hijos"] = []
						
					data_vacio["hijos"].append(i.Salvar({})) 

	return data_vacio

func CargarPartida():
	#Cargo:
	#verificar si ya existe:
	var existe = Memoria.data_save.ObtenerNivelEnSalva(name)
	
	if existe != null:
		#cargo las misiones:
		GestorMisiones_global.CargarMisiones(Memoria.data_save)
		
		#borro los persistentes:
		for i in get_tree().get_nodes_in_group("Persistentes"):
			i.queue_free()
		
		yield(get_tree(),"idle_frame")
		CargarPrevio(Memoria.data_save.niveles_visitados[existe])
	
	
		var timer := get_tree().create_timer(0.1)
		timer.connect("timeout",self,"PosCarga")
	
	else:
		Memoria.emit_signal("datos_cargados")
	
func CargarPrevio(data:Dictionary):
	if data.get("hijos"):
		for d in data["hijos"]:
			#Creo un instancia:
			var yo:Node
	
			#Crear la instancia:
			yo = load(d["ruta_file"]).instance() as Node
			
			#Pongo la instancia en la posicion correcta del arbol:
			var ruta:String = d["ruta_nodo"]
			ruta = ruta.left(ruta.find_last("/"))
			get_node(ruta).call_deferred("add_child",yo)#add_child(yo)
			yo.name = d["nombre"]
			
			print(yo.name)
			
			if (yo.get("nombre_original")):
				yo.nombre_original = d["nombre"]
			
			yo.connect("ready",yo,"Cargar",[d])
			#yo.Cargar(d)
	
func PosCarga():
	#Corregir los nombres:
	var persistentes:Array = get_tree().get_nodes_in_group("Persistentes")
	
	for e in persistentes:
		var nodo:Node = e as Node
		
			
		if nodo.name.find("@") >= 0:
			var nombre:String = nodo.name.left(nodo.name.find_last("@"))
			nombre = nombre.right(nombre.find("@")+1)
			e.name = nombre
			#print (nombre)
			pass
	
	#FIN
	Memoria.emit_signal("datos_cargados")
	
	#Si es un cambio, salva nuevamente para garantizar que aparezca en esta abitación la próxima vez.
	if Memoria.cambiando:
		#Salvar los datos:
		Memoria.SalvarRapido()
		
	Memoria.es_nuevo = false
	Memoria.cambiando = false
	Memoria.data_save = null

func pos_cargado():
	Memoria.emit_signal("datos_cargados")
