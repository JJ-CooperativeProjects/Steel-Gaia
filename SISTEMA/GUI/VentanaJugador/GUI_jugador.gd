extends CanvasLayer
class_name Gui_jugador




func set_vida(vitalidad:float,max_vitalidad:float):
	var tween:SceneTreeTween = create_tween()
	tween.tween_property($GUI/barra_vida,"value",float(vitalidad),0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	#$GUI/barra_vida.value = vitalidad
	pass
	
func set_energia(energia:float,max_energia:float):
	
	var tween:SceneTreeTween = create_tween()
	tween.tween_property($GUI/barra_energia,"value",energia,0.4)
	pass


func _on_barra_vida_value_changed(value):
	#print(value)
	pass # Replace with function body.


func _on_barra_energia_value_changed(value):
	
	pass # Replace with function body.
