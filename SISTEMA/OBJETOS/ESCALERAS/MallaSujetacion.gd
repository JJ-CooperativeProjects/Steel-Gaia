extends Area2D
class_name MallaSujetadora
"""
CLASE BASE PARA CONSTRUIR MAYAS EN LAS QUE EL JUGADOR SE PUEDA AGARRAR.
"""
onready var tile:TileMap = $TileMap


#func _ready():
#
##	var celdas_usadas:Array = tile.get_used_cells()
##
##	for i in celdas_usadas:
##		var e:Sprite = escalera.instance()
##		e.global_position = tile.map_to_world(i)
##		add_child(e)
##
##	tile.visible = false
#	pass


func _on_MallaDeSujetacion_body_entered(body):
	body.en_malla = true
	print("jugador en zona de malla")
	pass # Replace with function body.


func _on_MallaDeSujetacion_body_exited(body):
	body.en_malla = false
	pass # Replace with function body.
