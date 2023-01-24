extends Node2D
class_name DisparadorTrampas
"""
CLASE PARA CREAR DSIPARADORES PARA LAS TRAMPAS. CONSISTE EN UN BOTON QUE 
AL PULSARLO SE ACTIVA LAS TRAMPAS QUE TIENE EN LA LISTA DE TRAMPAS.
"""
export (Array,NodePath) var trampas:Array = []
##Si se desea que las trampas se activen una a una con un lapso de tiempo entre ellas.
export (float) var tiempo_entre_trampas:float = 0.0
#Si el disparador sólo puede activarse una vez:
export (bool) var una_sola_vez:bool = false
var activado:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("stand")
	pass # Replace with function body.

func ActivarTrampas():
	#print("clic!")
	if !trampas.empty():
		for a in trampas:
			var t:Trampa = get_node_or_null(a) as Trampa
			if is_instance_valid(t):
				if t.lista_para_reactivar:
					t.Activar()
				else:
					continue
				if tiempo_entre_trampas > 0:
					yield(get_tree().create_timer(tiempo_entre_trampas),"timeout")
					continue


func _on_Area2D_body_entered(body):
	$AnimationPlayer.play("push")
	$AudioStreamPlayer2D.play()
		
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	$AnimationPlayer.play("push_up")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"push":
			if !activado:
				ActivarTrampas()
				
			if una_sola_vez:
				activado = true
				
			
			
	pass # Replace with function body.
