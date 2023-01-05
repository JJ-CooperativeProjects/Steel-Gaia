extends Node2D
class_name TrayectoriasDisparosSierras

export (float) var velocidad:float

var objetivo

var trayectoria:Vector2 = Vector2.ZERO

func _ready():
	objetivo = Memoria.jugador
	
	#1
	var pos_inicio = $disparo_sierra_npc4.global_position
	
	var vec_f:Vector2 = objetivo.global_position
	var pos_final = Vector2(vec_f.x - 50, vec_f.y)
	
	var pos_intermedio = Vector2(pos_inicio.x,vec_f.y)
	
	$disparo_sierra_npc4.pos_inicio = pos_inicio
	$disparo_sierra_npc4.pos_final = pos_final
	$disparo_sierra_npc4.pos_intermedio = pos_intermedio
	
	#2
	pos_final = Vector2(vec_f.x +50, vec_f.y)
	pos_intermedio = Vector2(pos_inicio.x,vec_f.y)
	
	$disparo_sierra_npc5.pos_inicio = pos_inicio
	$disparo_sierra_npc5.pos_final = pos_final
	$disparo_sierra_npc5.pos_intermedio = pos_intermedio

	
