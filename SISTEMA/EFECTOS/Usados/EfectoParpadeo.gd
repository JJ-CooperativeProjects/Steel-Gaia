extends EfectoTemporal


func Activar():
	$AnimationPlayer.play("Efecto")
	pass

func Terminar():
	mi_objetivo.modulate = Color.white
	mi_objetivo.puede_recibir_damage = true
	queue_free()
	pass

func _process(delta):
	if mi_objetivo!= null:
		mi_objetivo.modulate = $Sprite.modulate
