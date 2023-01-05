extends Node2D
class_name Trampa
"""
CLASE BASE PARA CONSTRUIR TRAMPAS
"""
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
