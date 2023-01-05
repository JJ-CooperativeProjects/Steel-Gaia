extends "res://SISTEMA/OBJETOS/TRAMPAS/Ballesta_Pared_dercha.gd"

func _on_ZonaActivacion_body_entered(body):
	if en_pantalla:
		match estado:
			estados.ESPERANDO:
				estado = estados.ACTIVANDOSE
				#

				#
				var tween:SceneTreeTween = get_tree().create_tween()
				tween.tween_property($Sprite,"position:x",$Sprite.position.x+10,0.05)
				var timer:SceneTreeTimer = get_tree().create_timer(0.45)
				yield(timer,"timeout")
				var t2:SceneTreeTween = get_tree().create_tween()
				t2.tween_property($Sprite,"position:x",$Sprite.position.x+17,0.12).set_ease(Tween.EASE_IN)
				
				estado = estados.DISPARANDO
				var ti2:SceneTreeTimer = get_tree().create_timer(0.52)
				yield(ti2,"timeout")
				
				var count:int = 1
				for i in range(rondas*3):
					var new_pua = pua.instance()
					var disparador:Position2D = $Sprite.get_node("p" + str(count))
					new_pua.global_position = disparador.global_position
					
					if $Sprite.scale.x == 1:
						new_pua.movimiento = Vector2(1,0).rotated($Sprite.rotation)
					else:
						new_pua.movimiento = Vector2(-1,0).rotated(-$Sprite.rotation)
					Memoria.nivel_actual.add_child(new_pua)
					if count == 3:
						count = 1
					else:
						count += 1
					var ti3:SceneTreeTimer = get_tree().create_timer(0.25)
					
					yield(ti3,"timeout")
					
				#
				estado = estados.DESACTIVANDOSE
				var t4:SceneTreeTween = get_tree().create_tween()
				t4.tween_property($Sprite,"position:x",$Sprite.position.x-27,0.08).set_ease(Tween.EASE_IN)
				yield(t4,"finished")
				
				var ti:SceneTreeTimer = get_tree().create_timer(tiempo_entre_ciclos)
				yield(ti,"timeout")
				
				estado = estados.ESPERANDO
				lista_para_reactivar = true
				Desactivar()
				pass
	pass # Replace wit
