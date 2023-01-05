extends EfectoEspecialControlado






func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.


func _on_AreaDetectarSuelos_body_entered(body):
	var explosion = load("res://SISTEMA/OBJETOS/TRAMPAS/MinaNeutral.tscn").instance() as MinaNeutral
	
	explosion.global_position = global_position
	explosion.estado = MinaNeutral.estados.APAGADA
	yield(get_tree(),"idle_frame")
	Memoria.nivel_actual.add_child(explosion)
	explosion.explotar()
	get_parent().queue_free()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	get_parent().queue_free()
	pass # Replace with function body.
