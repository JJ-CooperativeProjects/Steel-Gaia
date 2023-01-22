extends Button
class_name BotonBase

"""
CLASE BASE PAR LOS BOTONES DE MENUS.
"""

onready var sonido_entrar:= preload("res://RECURSOS/SONIDOS/GUI/error_001.wav")
onready var sonido_aceptar:= preload("res://RECURSOS/SONIDOS/GUI/confirmation_002.wav")
onready var sonido_aceptar2:= preload("res://RECURSOS/SONIDOS/GUI/confirmation_001.wav")

func EmitirSonido(sonido):
	$AudioStreamPlayer.stream = sonido
	$AudioStreamPlayer.play(0.0)


func _on_BotonBase_mouse_entered():
	var t:SceneTreeTween = create_tween()
	t.tween_property(self,"rect_scale",Vector2(1.20,1.20),0.12)
	EmitirSonido(sonido_entrar)
	pass # Replace with function body.



func _on_BotonBase_mouse_exited():
	var t:SceneTreeTween = create_tween()
	t.tween_property(self,"rect_scale",Vector2(1.0,1.0),0.08)
	pass # Replace with function body.
