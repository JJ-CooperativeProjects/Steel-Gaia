extends Particles2D
class_name EfectoEspecialControlado

signal comienza_efecto()
signal termina_efecto()

"""
CLASE PARA CREAR EFECTOS CON PARTICUALES CUNTROLADO POR ANIMACION. 
EMITE CIERTAS SEÑALES PARA MANEJAR EL CONTROL.
"""

func _ready():
	$AnimationPlayer.play("inicio_efecto")
	emit_signal("comienza_efecto")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"inicio_efecto":
			emit_signal("termina_efecto")
			#print("termima efecto")
			queue_free()
	pass # Replace with function body.
