extends Area2D
class_name AreaDetectarObstaculos

signal efectuar_deteccion_de_colision(detecto)
var cuerpos:int = 0
"""
COMPONENTE UTILIZADO POR EL MINIBOSS PARA DETECTAR LUGARES DONDE PODER 
PONER LAS TRAMPAS.
"""

func _ready():
	var timer:SceneTreeTimer = get_tree().create_timer(0.1)
	timer.connect("timeout",self,"no_hay_cuerpos")	
	pass

func no_hay_cuerpos():
	emit_signal("efectuar_deteccion_de_colision",cuerpos)

func _on_AreaDetectarObstaculos_body_entered(body):
	cuerpos = 1
	emit_signal("efectuar_deteccion_de_colision",cuerpos)
	queue_free()
	pass # Replace with function body.
