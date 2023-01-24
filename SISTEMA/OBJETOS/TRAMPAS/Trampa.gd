extends Node2D
class_name Trampa
"""
CLASE BASE PARA CONSTRUIR TRAMPAS
"""

export (float) var damage:float = 10
#Si la trampa está activa o no. Una trampa no activa, no realiza ningun efecto.
export (bool) var activa:bool = true
##Si es en bucle, cuando se active, permanecerá en un ciclo infinito y no se apagará.
export (bool) var es_bucle:bool = false

onready var zona_activacion:Area2D = $ZonaActivacion

##Se utiliza para ejecutar la logica de la trampa. FUera de pantalla todo estará desactivado.
var en_pantalla:bool = false
var lista_para_reactivar:bool = true

func Activar():
	pass

func Desactivar():
	pass

func Salvar(data_vacio:Dictionary = {})->Dictionary:
	data_vacio.merge( {
		"ruta_nodo":get_path(),
		"ruta_file": filename,
		"nombre":name,
		"global_position": global_position,
		
		"activa": activa,
		"es_bucle":es_bucle,
		"lista_para_reactivar": lista_para_reactivar
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
	global_position = data.global_position
	activa = data.activa
	es_bucle = data.es_bucle
	lista_para_reactivar = data.lista_para_reactivar
	
	
	
	prints(name,"Cargado!")
	
	#Veo si tengo hijos:
	if data.has("hijos"):
		var hijos_data:Array = data["hijos"]
		
		for d in hijos_data:
			
			#creo instancia:
			var hijo:Node = load(d["ruta_file"]).instance() as Node
			
			call_deferred("add_child",hijo)#add_child(hijo)
			
			hijo.name = d["nombre"]
			hijo.nombre_original = d["nombre"]
			hijo.Cargar(d)
	pass
