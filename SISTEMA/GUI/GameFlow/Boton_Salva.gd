extends TextureButton
class_name BotonSalva

"""
BOTON PARA LA PANTALLA DE CARGAR UNA PARTIDA.
"""
var ruta_archivo:String = ""


func _on_Boton_Salva_mouse_entered():
	self_modulate = Color("777777")
#	var tween:SceneTreeTween = create_tween()
#	tween.tween_property(self,"rect_scale",Vector2(1.15,1.15),0.12)
	
	pass # Replace with function body.



func _on_Boton_Salva_mouse_exited():
	self_modulate = Color.white
#	var tween:SceneTreeTween = create_tween()
#	tween.tween_property(self,"rect_scale",Vector2(1.0,1.0),0.12)
	pass # Replace with function body.


func _on_Boton_Salva_button_up():
	if not Memoria.nivel_actual:
		Memoria.CargarPartidaNombre(ruta_archivo)
	else:
		MenusGlobales.cerrando = true
		MenusGlobales.PonerMenu("")
		Memoria.CargarPartidaNombre(ruta_archivo)
		pass
	pass # Replace with function body.
