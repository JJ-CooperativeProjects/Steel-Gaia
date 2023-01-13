extends Nivel

func _init():
	Memoria.nivel_actual = self

func _input(event):
	if event.is_action_pressed("salvar"):
		Memoria.SalvarNuevo("Prueba1")
#		var arreglo:Array = []
#		Memoria.data_save.MetodoBuscar(get_children(),self,arreglo)
#		print(arreglo)
	
	if event.is_action_pressed("cargar"):
		Memoria.CargarPartidaNombre("Prueba1")

func _ready():
	#Memoria.data_save = load("user://SISTEMA/GLOBAL/RESOURCES/SAVE_DATA/Saves/Temporal/SAVE_auto.tres")
	if Memoria.es_nuevo:
		CargarPartida()
	
	
"""
func CargarPartida():
	#Elimino todos los Persistentes:
	for i in get_tree().get_nodes_in_group("Persistentes"):
		i.queue_free()
	
	#Cargar globales:
	#----
	
	#Algunas referencias:
	var datos_hijos:Array = []
	var datos_de_nivel:Array
	
	#Verificar si este nivel existe en salva:
	var existe = Memoria.data_save.ObtenerNivelEnSalva(name)
	
	if existe !=null:
		datos_de_nivel = Memoria.data_save.niveles_visitados[existe].persistentes
		
		for i in datos_de_nivel:
			CargarPrevio(i)
		
	
	
	
	
	#Finaliza de cargar:
	Memoria.data_save = null
	Memoria.emit_signal("datos_cargados")
	print("partida cargada con exito!")
	pass

func CargarPrevio(data:Dictionary):
	#Creo un instancia:
	var yo:Node
	
	#Crear la instancia:
	yo = load(data["ruta_file"]).instance() as Node
	
	#Pongo la instancia en la posicion correcta del arbol:
	var ruta:String = data["ruta_nodo"]
	ruta = ruta.left(ruta.find_last("/"))
	get_node(ruta).add_child(yo)
	
	#actualizo las variables.
	yo.Cargar(data)
	
	pass
"""

