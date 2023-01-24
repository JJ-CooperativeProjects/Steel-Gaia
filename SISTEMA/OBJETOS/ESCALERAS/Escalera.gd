extends MallaSujetadora
class_name Escalera
"""
CLASE QUE DEFINE UNA ESCALERA
"""

onready var area_centro:PackedScene = preload("res://SISTEMA/OBJETOS/ESCALERAS/AreaDetectarJugadorEscalera.tscn")


func _ready():
	var celdas_usadas:Array = tile.get_used_cells()

	for i in celdas_usadas:
		var e:Area2D = area_centro.instance()
		e.global_position = Vector2(tile.map_to_world(i).x+16,tile.map_to_world(i).y+16)
		add_child(e)

func _on_MallaDeSujetacion_body_entered(body):
	body.en_escalera = true
	print("jugador en escalera")
	pass # Replace with function body.


func _on_MallaDeSujetacion_body_exited(body):
	body.en_escalera = false
	pass # Replace with function body.
