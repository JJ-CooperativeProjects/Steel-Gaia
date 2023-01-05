extends Intercambiador
#Peculiaridades de la puerta del boss:
func _ready():
	#yield(get_tree().create_timer(2),"timeout")
	if desactivado:
		var cerradura:= load("res://SISTEMA/OBJETOS/PUERTA_NIVEL_BOSS/PuertaNivelBoss.tscn").instance() as Node2D
		
		cerradura.global_position = get_node("Position2D").global_position
		Memoria.nivel_actual.call_deferred("add_child",cerradura)
		
		cerradura.connect("terminado",$AreaDisparadorEvento_por_tecla,"set_activo",[true])
