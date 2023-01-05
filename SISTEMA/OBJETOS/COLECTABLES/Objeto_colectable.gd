extends Node2D
class_name ObjetoColectable

signal es_recogido()	#emitida cuadno es recogido.


export (int) var cantidad:int = 1	#La cantidad de este objeto contenidos en él


"""
CLASE PARA CONSTRUIR OBJETOS QUE SE PUEDAN RECOGER EN EL ENTORNO.
"""


func _on_Orbe_es_recogido():
	Memoria.tiene_orbe = true
	queue_free()
	pass # Replace with function body.
