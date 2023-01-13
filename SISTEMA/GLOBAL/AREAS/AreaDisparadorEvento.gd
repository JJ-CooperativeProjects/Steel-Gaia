extends Area2D
class_name AreaDisparadorEvento

"""
CLASE QUE DEDICADA A ACTIVAR EVENTOS.
"""
##Si es activo, el evento podra ejecutarse. Si false no.
export (bool) var activo:bool = true	setget set_activo
##Si es persistente, se mantendrá siempre que se entre al nivel (se guarda):
export (bool) var es_persistente:bool = true
##Si el evento puede repetirse:
export (bool) var es_repetible:bool = false 

##Poner algunos nodos relacionados con el evento:
export (Array,NodePath) var nodos_del_evento:Array

#Se pone a true cuando el evento terminó. Si el evento ya se usó, y no es repetible, se borrara de la escena al cargar.
var evento_terminado:bool = false

var nombre_original:String #Almacena el nombre original de este nodo, para luego cuando cargue eliminar algun diplicado.

func _ready():
	pass

func set_activo(valor:bool):
	activo = valor

func EsActivada():
	pass

func EsDesactivada():
	evento_terminado = true
#	if not es_repetible:
#		Memoria.persistentes_temporales_a_guardar["eventos"].append(Salvar())
	
	pass

func _on_AreaDisparadorEvento_body_entered(body):
	if not evento_terminado:
		EsActivada()
	pass # Replace with function body.


func Salvar(data_vacio:Dictionary = {})->Dictionary:
	data_vacio.merge( {
		"ruta_nodo":get_path(),
		"ruta_file": filename,
		"nombre":name,
		"position": position,
		
		"activo": activo,
		"es_persistente": es_persistente,
		"es_repetible": es_repetible,
		"nodos_del_evento": nodos_del_evento,
		"evento_terminado": evento_terminado,
		"shape": $CollisionShape2D.shape,
		"shape_position": $CollisionShape2D.position

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
	activo = data.activo
	es_persistente = data.es_persistente
	es_repetible = data.es_repetible
	nodos_del_evento = data.nodos_del_evento
	evento_terminado = data.evento_terminado
	nombre_original = data.nombre
	position = data.position
	$CollisionShape2D.shape = data.shape
	$CollisionShape2D.position = data.shape_position
	
	
	prints(name,"Cargado!")
	#Memoria.consola_debug.PonerEnConsola([name, "Cargado!"])
	
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


func _on_AreaDisparadorEvento_tree_entered():
	#verifico si es un sub hijo, en cuyo caso elimino el anterior:
	var padre:Node = get_parent()
	if padre:
		for n in padre.get_children():
			if n.name == nombre_original:
				n.queue_free()
				break
	pass # Replace with function body.
