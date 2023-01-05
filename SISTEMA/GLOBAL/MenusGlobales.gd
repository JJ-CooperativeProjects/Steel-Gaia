extends CanvasLayer

onready var fondo:ColorRect = $ColorRect

var el_menu
func PonerMenu(menu):
	el_menu = menu
	$AnimationPlayer.play("efecto_d")
#	var tween:SceneTreeTween = get_tree().create_tween()
#	tween.tween_property(fondo,"modulate",Color(0,0,0,1),0.5)
#	tween.connect("finished",self,"segundo_paso",[menu])
	

func segundo_paso(menu):
	get_node(menu).visible = true
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "efecto_d":
		get_node(el_menu).visible = true
		$AnimationPlayer.play("efecto_inv")
	if anim_name == "efecto_inv":
		pass
	pass # Replace with function body.
