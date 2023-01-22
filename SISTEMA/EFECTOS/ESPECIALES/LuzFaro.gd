extends Node2D
class_name LuzFaro

export (float) var tiempo_max_entre_flash:float = 4.0
func _ready():
	var timer:SceneTreeTimer = get_tree().create_timer(rand_range(0.5,tiempo_max_entre_flash *2))
	timer.connect("timeout",self,"Encender")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func Encender():
	var efectos:Array = ["efecto", "efecto 1"]
	var efecto_seleccionado:String = efectos[randi()% efectos.size()]
	print(efecto_seleccionado)
	$AnimationPlayer.play(efecto_seleccionado)

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"efecto", "efecto 1":
			var timer:SceneTreeTimer = get_tree().create_timer(rand_range(1.0,tiempo_max_entre_flash))
			timer.connect("timeout",self,"Encender")
	pass # Replace with function body.
