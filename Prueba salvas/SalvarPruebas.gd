extends Node

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


func Cargar(data:Dictionary):
	#Actualizar propiedades:
	#bla-bla
	prints(name,"Cargado!")
	#Memoria.consola_debug.PonerEnConsola([name,"Cargado!"])
	
	#Veo si tengo hijos:
	if data.has("hijos"):
		var hijos_data:Array = data["hijos"]
		
		for d in hijos_data:
			#creo instancia:
			var hijo:Node = load(d["ruta_file"]).instance() as Node
			
			call_deferred("add_child",hijo)#add_child(hijo)
			hijo.name = d["nombre"]
			hijo.Cargar(d)
	
	
	
	pass
