extends Area2D

func recibe_damage(damage):
	if get_parent().puede_recibir_damage:
		get_parent().emit_signal("RecibeDamage",damage,null)
