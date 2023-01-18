extends Node2D


func _input(event):
	if event.is_action_pressed("F1"):
		var d:Resource = load("res://dic_ejemplo.tres")
		
		d.dic = Salvar({})
		
		var e:int = ResourceSaver.save("res://prueba.tres",d)
		if e==OK:
			print("salvado")
			
			##Proceder a cargar:
			var salva:Resource = load("res://prueba.tres")
			
			#borro los persistentes:
			for i in get_tree().get_nodes_in_group("Persistentes"):
				i.queue_free()
				
			#Cargo:
			CargarPrevio(salva.dic)
			
func Salvar(data_vacio:Dictionary)->Dictionary:
	data_vacio.merge( {
		"nivel_arbol": get_path().get_name_count(),
		"ruta_nodo":get_path(),
		"ruta_file": filename,
		"nombre":name,
	})
	
	if get_child_count() != 0:
		for n in get_children():
			var nodo:Node = n as Node
			
			if nodo.is_in_group("Persistentes"):
				if not data_vacio.has("hijos"):
					data_vacio["hijos"] = []
					
				data_vacio["hijos"].append(nodo.Salvar({})) 

	return data_vacio

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
			get_node(ruta).add_child(yo)
			yo.Cargar(d)
	
	
