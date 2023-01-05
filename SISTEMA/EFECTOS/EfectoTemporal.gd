extends Efecto
class_name EfectoTemporal
"""
UN EFECTO TEMPORAL ES UN EFECTO QUE DURA UN DETERMINADO TIEMPO.
"""
export (float) var tiempo_duracion:float = 1.2

func _ready():
	Activar()
	var timer:SceneTreeTimer = get_tree().create_timer(tiempo_duracion)
	timer.connect("timeout",self,"Terminar")
	

func Terminar():
	queue_free()
