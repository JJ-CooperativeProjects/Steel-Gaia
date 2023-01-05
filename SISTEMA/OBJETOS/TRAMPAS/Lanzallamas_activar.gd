extends TrampaLanzallamas
class_name TrampaLanzallamasActivar
#Un lanzallamas apagado.



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func EnReady():
	$AnimationPlayer.play("apagado")
	pass

func Activar():
	lista_para_reactivar = false
	Pasar_A_Cargar()
	pass
