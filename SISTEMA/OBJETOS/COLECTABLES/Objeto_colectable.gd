extends Node2D
class_name ObjetoColectable

signal es_recogido()	#emitida cuadno es recogido.

export (String) var ID:String #Tiene que ser un valor unico que lo diferencie de todos los colectables.
export (int) var cantidad:int = 1	#La cantidad de este objeto contenidos en él


"""
CLASE PARA CONSTRUIR OBJETOS QUE SE PUEDAN RECOGER EN EL ENTORNO.
"""




#Patron de salvar cargar:
func Salvar(data_vacio:Dictionary)->Dictionary:
	data_vacio.merge( {
		"nivel_arbol": get_path().get_name_count(),
		"ruta_nodo":get_path(),
		"ruta_file": filename,
		"nombre":name,
		"global_position": global_position,
		"cantidad": cantidad
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
	global_position = data.get("global_position")
	cantidad = data.get("cantidad")
	
	prints(name,"Cargado!")
	
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


func _on_ObjetoColectable_es_recogido():
	#Para las misiones que requieren este objeto:
	GestorMisiones_global.emit_signal("objeto_recogido",ID,cantidad)
	print(ID)
	
	queue_free()
	pass # Replace with function body.


