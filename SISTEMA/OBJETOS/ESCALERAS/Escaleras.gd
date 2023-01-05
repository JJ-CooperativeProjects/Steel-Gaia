extends Area2D
class_name Escalera
"""
CLASE BASE PARA LAS ESCALERAS
"""
onready var escalera:PackedScene = preload("res://SISTEMA/OBJETOS/ESCALERAS/Escalera_sprite.tscn")
onready var tile:TileMap = $TileMap


func _ready():
	
	var celdas_usadas:Array = tile.get_used_cells()
	
	for i in celdas_usadas:
		var e:Sprite = escalera.instance()
		e.global_position = tile.map_to_world(i)
		add_child(e)
		
	tile.visible = false
	pass

func _on_Escaleras_body_entered(body):
	body.en_escalera = true
	print("jugador en zona de escalera")
	pass # Replace with function body.


func _on_Escaleras_body_exited(body):
	body.en_escalera = false
	pass # Replace with function body.
