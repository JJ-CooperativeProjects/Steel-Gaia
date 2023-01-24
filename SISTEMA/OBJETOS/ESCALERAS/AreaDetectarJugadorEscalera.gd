extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AreaDetectarJugadorEscalera_body_entered(body):
	print("el jugador está en un punto de escalera")
	Memoria.punto_escalera = global_position
	pass # Replace with function body.
