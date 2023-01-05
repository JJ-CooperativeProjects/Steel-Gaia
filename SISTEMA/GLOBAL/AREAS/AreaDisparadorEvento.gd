extends Area2D
class_name AreaDisparadorEvento

"""
CLASE QUE DEDICADA A ACTIVAR EVENTOS.
"""
##Si es activo, el evento podra ejecutarse. Si false no.
export (bool) var activo:bool = true	setget set_activo
##Si es persistente, se mantendrá siempre que se entre al nivel:
export (bool) var es_persistente:bool = true
##Si el evento puede repetirse:
export (bool) var es_repetible:bool = false 


##Poner algunos nodos relacionados con el evento:
export (Array,NodePath) var nodos_del_evento:Array

#Se pone a true cuando el evento terminó.
var evento_terminado:bool = false

func set_activo(valor:bool):
	activo = valor

func EsActivada():
	pass

func EsDesactivada():
	evento_terminado = true
	if not es_repetible:
		Memoria.persistentes_temporales_a_guardar.append(Salvar())
	
	pass

func _on_AreaDisparadorEvento_body_entered(body):
	if not evento_terminado:
		EsActivada()
	pass # Replace with function body.

func Salvar()->Dictionary:
	var data:Dictionary = {
		"ruta_nodo": get_path(),
		"ruta_file": filename,
		"global_position": global_position,
		"es_persistente": es_persistente,
		"es_repetible": es_repetible,
		"evento_terminado": evento_terminado
	}
	return data

func Cargar(data:Dictionary,nodo=null):
	if nodo:
		if data.es_persistente == true or data.evento_terminado != true:
			nodo.global_position = data.global_position
			nodo.es_persistente = data.es_persistente
			nodo.es_repetible = data.es_repetible
			nodo.evento_terminado = data.evento_terminado
			
			Memoria.nivel_actual.get_node("AREAS_EVENTOS").add_child(nodo)
	else:
		#Si no es permanente, lo borra del nivel:
		if data.es_persistente == false:
			if data.evento_terminado == true:
				queue_free()
				return
		
		if data.es_persistente == true or data.evento_terminado != true:
			global_position = data.global_position
			es_persistente = data.es_persistente
			es_repetible = data.es_repetible
			evento_terminado = data.evento_terminado
		
	pass
