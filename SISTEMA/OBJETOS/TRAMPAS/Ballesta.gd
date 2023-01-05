extends Trampa

export (int)var rondas:int = 1

##Si es ciclica, el tiempo entre una activacion y la otra:
export (float, 0.3,10.0,0.1) var tiempo_entre_ciclos:float = 1
onready var pua = preload("res://SISTEMA/OBJETOS/TRAMPAS/disparo_ballesta.tscn")

enum estados{ESPERANDO,APAGADO,ACTIVANDOSE,DISPARANDO,DESACTIVANDOSE,MUERTE}
var estado:int


# Called when the node enters the scene tree for the first time.
func _ready():
	estado = estados.ESPERANDO if activa else estados.APAGADO
	pass # Replace with function body.

func Activar():
	lista_para_reactivar = false
	estado = estados.ESPERANDO
	_on_ZonaActivacion_body_entered(Memoria.jugador)
	

func Desactivar():
	if es_bucle:
		estado = estados.ESPERANDO
		_on_ZonaActivacion_body_entered(Memoria.jugador)

func _on_ZonaActivacion_body_entered(body):
	if en_pantalla:
		match estado:
			estados.ESPERANDO:
				estado = estados.ACTIVANDOSE
				#
				if Memoria.jugador.global_position.x > global_position.x:
					$Sprite.scale.x = 1
				else:
					$Sprite.scale.x = -1
				#
				var tween:SceneTreeTween = get_tree().create_tween()
				tween.tween_property($Sprite,"position:y",$Sprite.position.y-10,0.05)
				var timer:SceneTreeTimer = get_tree().create_timer(0.45)
				yield(timer,"timeout")
				var t2:SceneTreeTween = get_tree().create_tween()
				t2.tween_property($Sprite,"position:y",$Sprite.position.y-37,0.12).set_ease(Tween.EASE_IN)
				
				estado = estados.DISPARANDO
				var ti2:SceneTreeTimer = get_tree().create_timer(0.52)
				yield(ti2,"timeout")
				
				var count:int = 1
				for i in range(rondas*3):
					var new_pua = pua.instance()
					var disparador:Position2D = $Sprite.get_node("p" + str(count))
					new_pua.global_position = disparador.global_position
					
					if $Sprite.scale.x == 1:
						new_pua.movimiento = Vector2(1,0).rotated($Sprite.rotation)
					else:
						new_pua.movimiento = Vector2(-1,0).rotated(-$Sprite.rotation)
					Memoria.nivel_actual.add_child(new_pua)
					if count == 3:
						count = 1
					else:
						count += 1
					var ti3:SceneTreeTimer = get_tree().create_timer(0.25)
					
					yield(ti3,"timeout")
					
				#
				estado = estados.DESACTIVANDOSE
				var t4:SceneTreeTween = get_tree().create_tween()
				t4.tween_property($Sprite,"position:y",$Sprite.position.y+47,0.08).set_ease(Tween.EASE_IN)
				yield(t4,"finished")
				
				var ti:SceneTreeTimer = get_tree().create_timer(tiempo_entre_ciclos)
				yield(ti,"timeout")
				
				estado = estados.ESPERANDO
				lista_para_reactivar = true
				Desactivar()
				pass
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	en_pantalla = false
	#print("fuera de pantalla")
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_entered():
	en_pantalla = true
	#print("entra en pantalla")
	pass # Replace with function body.
