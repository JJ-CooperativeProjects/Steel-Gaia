extends RigidBody2D
class_name NanoBola




# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(rand_range(-30,30),rand_range(-30,30))
	$AnimationPlayer.play("normal")
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	#Activar abrir:
	#print("abriendo...")
	
	var timer:SceneTreeTimer = get_tree().create_timer(rand_range(0.6,0.8))
	timer.connect("timeout",self,"abrir_bola")

func abrir_bola():
	gravity_scale = 0
	mode = RigidBody2D.MODE_STATIC
	$AnimationPlayer.play("abrir")
	pass
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"abrir":
			var nanobot:NanoBot = load("res://SISTEMA/ENTES/Usados/NanoBot.tscn").instance() as NanoBot 
			nanobot.global_position = global_position
			Memoria.nivel_actual.get_node("TRAMPAS/NANOS").add_child(nanobot)
			
			$AnimationPlayer.play("electros")
		"electros":
			queue_free()
	pass # Replace with function body.
