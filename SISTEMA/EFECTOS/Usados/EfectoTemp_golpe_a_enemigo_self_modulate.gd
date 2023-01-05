extends EfectoTemporal

func Activar():
	$AnimationPlayer.play("Efecto")
	pass
	
func Terminar():
	mi_objetivo.self_modulate = Color.white
	mi_objetivo.puede_recibir_damage = true
	queue_free()
	pass

func _process(delta):
	if mi_objetivo!= null:
		mi_objetivo.self_modulate = $Sprite.modulate
