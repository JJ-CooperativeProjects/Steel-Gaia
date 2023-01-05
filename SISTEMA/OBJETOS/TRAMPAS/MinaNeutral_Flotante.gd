extends MinaNeutral


func _arranque():
	$AnimationPlayer.play("aparecer")
	

func _set_ready():
	_on_ZonaActivacion_body_entered(Memoria.jugador)
