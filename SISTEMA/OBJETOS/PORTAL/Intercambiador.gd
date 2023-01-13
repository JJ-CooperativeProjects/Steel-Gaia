extends Node2D
class_name Intercambiador

"""
UN INTERCAMBIADOR O PORTAL SE ENCAGA DE CONECTAR UN NIVEL CON OTRO 
"""

##La ruta del nivel al que se conecta:
export (String, FILE) var ruta_proximo_nivel:String

##El nombre del nodo que se usará para llevar al jugador (seguramente otro intercambiador).
export (String) var id_spawn_point:String

##En caso de que este nodo se use para traer al jugador:
export (int,-1,1) var direccion_del_jugador:int = 1

##Si inicialmente está desactivado:
export (bool) var desactivado:bool = false

var nombre_original:String

func _ready():
	pass
	
	
		
##Metodo que inicializa el cambio de escena:
func Cambiar():
	if not desactivado:
		#Salvar los datos:
		Memoria.SalvarRapido()
		
		if !id_spawn_point == "":
			Memoria.spawn_point_id = id_spawn_point
		
		#Cambiar escena:
		Memoria.data_save = load("user://temp/SAVE_auto.tres")
		Memoria.cambiando = true
		CambioSuave.CambiarEscena(ruta_proximo_nivel)
	
	
	pass

func Salvar(data_vacio:Dictionary = {})->Dictionary:
	data_vacio.merge({
		"ruta_nodo": get_path(),
		"ruta_file": filename,
		"nombre": name,
		"global_position": global_position,
		
		"ruta_proximo_nivel": ruta_proximo_nivel,
		"id_spawn_point": id_spawn_point,
		"direccion_del_jugador": direccion_del_jugador,
		"desactivado": desactivado
	})
	
	if get_child_count() != 0:
		for n in get_children():
			var nodo:Node = n as Node
			
			if nodo.is_in_group("Persistentes"):
				if not data_vacio.has("hijos"):
					data_vacio["hijos"] = []
					
				data_vacio["hijos"].append(nodo.Salvar({})) 
	return data_vacio
	pass

func Cargar(data:Dictionary):
	#Actualizar propiedades:
	global_position = data.global_position
	ruta_proximo_nivel = data.ruta_proximo_nivel
	id_spawn_point = data.id_spawn_point
	direccion_del_jugador = data.direccion_del_jugador
	desactivado = data.desactivado
	
	add_to_group("Persistentes")
	
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
	
func AfterCargar():
	
	pass
