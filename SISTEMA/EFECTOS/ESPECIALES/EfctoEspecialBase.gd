extends Node2D
class_name EfectoEspecial
"""
CLASE PARA DEFINIR LOS EFECTOS ESPECIALES
"""
signal efecto_termina()



func _ready():
	$AnimationPlayer.play("efecto")


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"efecto":
			emit_signal("efecto_termina")
			queue_free()
	pass # Replace with function body.
