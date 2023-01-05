extends Control
class_name Pantalla

"""
CLASE BASE PARA CONSTRUIR PANTALLAS Y MENUS
"""
export (String, FILE,"*.tscn") var proxima_pantalla 
export (float) var tiempo_de_espera:float = 5

var pantalla_previa = null

func cambiar_pantalla():
	pass


