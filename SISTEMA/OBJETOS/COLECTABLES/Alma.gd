extends ObjetoColectable
class_name ObjetoColectableAlma

export (int, "AlmaNPC1","AlmaNPC2","AlmaNPC3","AlmaNPC4","AlmaNPC5") var tipo_alma:int = 0
export var velocidad = 0

func _ready():
	$AnimationPlayer.play("aceleracion")

func _physics_process(delta):
	global_position += global_position.direction_to(Memoria.jugador.global_position) * (velocidad * delta) 


func _on_Area2D_body_entered(body):
	print("alma toca")
	match tipo_alma:
		0:
			Memoria.almas_NPC1 += 1
			pass
		1:
			Memoria.almas_NPC2 += 1
			pass
		2:
			Memoria.almas_NPC3 += 1
			pass
		3:
			Memoria.almas_NPC4 += 1
			pass
	queue_free()
	pass # Replace with function body.
