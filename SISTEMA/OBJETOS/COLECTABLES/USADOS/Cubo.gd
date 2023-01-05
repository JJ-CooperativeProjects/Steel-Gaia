extends ObjetoColectable


func _ready():
	$Sprite/AnimationPlayer.play("efect1")

func _on_Cubo_es_recogido():
	if Memoria.cubos < 10:
		Memoria.cubos += 1
	queue_free()
	pass # Replace with function body.
