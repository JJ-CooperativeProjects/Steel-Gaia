extends MinaNeutral


func _arranque():
	if activa:
		estado = estados.ENCENDIDA
	$AnimationPlayer.play("aparecer")
	

func _set_ready():
	_on_ZonaActivacion_body_entered(Memoria.jugador)
