extends Intercambiador
#Peculiaridades de la puerta del boss:
func _ready():
	Memoria.connect("datos_cargados",self,"AfterCargar")
	#$AreaDisparadorEvento_por_tecla.connect("teclas_pulsadas",self,"Cambiar")



func AfterCargar():
	if desactivado:
#		var cerradura:= load("res://SISTEMA/OBJETOS/PUERTA_NIVEL_BOSS/PuertaNivelBoss.tscn").instance() as Node2D
#
#		cerradura.global_position = get_node("Position2D").global_position
#		Memoria.nivel_actual.call_deferred("add_child",cerradura)
		
#		$AreaDisparadorEvento_por_tecla.activo = false
#		cerradura.connect("terminado",$AreaDisparadorEvento_por_tecla,"set_activo",[true])
		pass
	$AreaDisparadorEvento_por_tecla.connect("teclas_pulsadas",self,"Cambiar")
	pass
