extends AreaDisparadorEvento
class_name AreaActivarTrampas
"""
UNA CLASE QUE ACTIVA TRAMPAS.
"""
func EsActivada():
	for i in nodos_del_evento:
		var nodo:= get_node(i) as Trampa
		
		if nodo:
			if nodo.lista_para_reactivar:
				nodo.Activar()
	evento_terminado = true
	pass
