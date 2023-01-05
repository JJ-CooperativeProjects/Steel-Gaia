extends Pantalla

func _ready():
	var timer:SceneTreeTimer = get_tree().create_timer(tiempo_de_espera)
	timer.connect("timeout",self,"cambiar_pantalla")
	
	pass


func cambiar_pantalla():
	CambioSuave.CambiarEscena(proxima_pantalla)
	pass
