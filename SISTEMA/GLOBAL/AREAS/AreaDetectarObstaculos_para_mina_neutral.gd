extends AreaDetectarObstaculos

onready var mina_neutral_flotante:PackedScene = preload("res://SISTEMA/OBJETOS/TRAMPAS/MinaNeutral_Flotante.tscn")

func _ready():
	var timer:SceneTreeTimer = get_tree().create_timer(0.12)
	timer.connect("timeout",self,"no_hay_cuerpos")	
	pass

func no_hay_cuerpos():
	#Crear la mina
	var mina:MinaNeutral = mina_neutral_flotante.instance()
	mina.global_position = global_position
	Memoria.nivel_actual.add_child(mina)
	
func _on_AreaDetectarObstaculos_body_entered(body):
	queue_free()
	pass # Replace with function body.
