extends Trampa

export (bool) var esta_cerrada:bool = false


func _ready():
	if esta_cerrada:
		$AnimationPlayer.play("cerrar")
	else:
		$AnimationPlayer.play("abrir")
	lista_para_reactivar = false

func Activar():
	if esta_cerrada:
		$AnimationPlayer.play("abrir")
		esta_cerrada = false
	
	else:
		$AnimationPlayer.play("cerrar")
		esta_cerrada = true
	# = false
	




func _on_AnimationPlayer_animation_finished(anim_name):
	#lista_para_reactivar = true
	pass # Replace with function body.
