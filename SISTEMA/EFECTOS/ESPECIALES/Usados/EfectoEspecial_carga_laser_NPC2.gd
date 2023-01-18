extends EfectoEspecial

signal disparo()

onready var super_laser:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/DISPAROS/disparo_super_laser.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func CrearDisparoLaser():
	var i_disparo:Disparo = super_laser.instance()
	
	i_disparo.global_position = $Position2D.global_position
	i_disparo.movimiento = Vector2(-scale.x,0)
	Memoria.nivel_actual.add_child(i_disparo)
	
