extends Node
class_name GestorMisiones

signal objeto_recogido(id_objeto,cantidad) #emitida cuando un objeto es adquirido por el jugador.
signal objeto_soltado(id_objeto,cantidad) #emitida cuando un objeto es soltado y puede afectar una mision.
"""
CLASE UNICA, que se encarga de gestionar las misiones. va en Autoload.
"""
var misiones_terminadas:Array

func _input(event):
	if event.is_action("interactuar"):
		GuardarMisiones()

##Retorna un arreglo con todas las misiones
func GuardarMisiones()->Array:

	var arreglo_misiones:Array = []
	for m in get_children():
		var mision:Mision = m as Mision
		
		for o in mision.get_children():
			var objetivo:Objetivo = o as Objetivo
			objetivo.owner = mision
		
		
		var scene:PackedScene = PackedScene.new()
		var result:int = scene.pack(mision) 
	
		if result == OK:
			arreglo_misiones.append(scene)
			
		print("MisionesSalvadas!")
	
	return arreglo_misiones
	return []
	
	pass

func CargarMisiones(data:BaseSaveData)->bool:
	for m in get_children():
		m.queue_free()
	
	for d in data.misiones:
		#var mision:Mision = d.instance()
		add_child(d.instance(),true)
		
	return true
	pass
