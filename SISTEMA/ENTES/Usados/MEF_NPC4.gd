extends MEF_base

var ente:Enemigo = get_parent()
var dentro_de_camara:bool = false

var objetivo:Jugador = null
func _ready():
	_agregar_estado("quieto")
	_agregar_estado("quieto_ataque")
	_agregar_estado("patrulla")
	_agregar_estado("ataque")
	_agregar_estado("ataque_sierras")
	
	yield(get_tree(),"idle_frame")
	#ente.get_node("Cuerpo/AnimatedSprite").connect("animation_finished",self,"emit_signal",["animacion_termina"])
	ente.get_node("movimientos").connect("animation_finished",self,"emit_signal",["animacion_termina"])
	poner_estado_deferred("patrulla")
	pass

func _physics_process(delta):
	match estado:
		estados.quieto:
			var dic:Dictionary = Memoria._movimiento_suavisado_de_A_a_B(ente.global_position,Vector2(ente.global_position.x,ente.posicion_inicio.y),ente.velocidad_movimiento,3,10)
			ente.move_and_slide(dic.vector)
			
			if dic.llego_al_objetivo:
				poner_estado_deferred("patrulla")
			
			
		estados.patrulla:
			ente.Patrullar()
		
		estados.quieto_ataque,estados.ataque_sierras:
			var new_vec:Vector2 = Vector2(round(ente.vector_impulsos.x),round(ente.vector_impulsos.y))
			ente.movimiento = ente.move_and_slide(new_vec)
	pass
	
#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.quieto_ataque, estados.ataque_sierras:
			if objetivo != null:
				if (objetivo.global_position.x > ente.global_position.x and ente.direccion_mira == -1) or (objetivo.global_position.x < ente.global_position.x and ente.direccion_mira == 1):
					ente.Girar()
					
			pass
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	#print(ente.movimiento)
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto:
			ente.anims.play("quieto")
			#ente.modulate = Color.white
			ente.vector_impulsos = Vector2.ZERO
			ente.Levitar()
		
		estados.patrulla:
			ente.anims.play("patrulla")
			#ente.modulate = Color.aqua
			ente.vector_impulsos = Vector2.ZERO
			
			if dentro_de_camara:
				var timer:SceneTreeTimer = get_tree().create_timer(10,20)
				timer.connect("timeout",self,"pasar_quieto_atacar")
			
		estados.quieto_ataque:
			ente.anims.play("ataque")
			ente.Levitar()
			objetivo = Memoria.jugador
			#ente.modulate = Color.red
			
			var timer:SceneTreeTimer = get_tree().create_timer(rand_range(1.5,2.5))
			timer.connect("timeout",self,"pasar_ataque_sierras")
			pass
		
		estados.ataque_sierras:
			ente.vector_impulsos = Vector2.ZERO
			ente.anims.play("despues_ataque")
			ente.DispararSierras()
			
			var timer:SceneTreeTimer = get_tree().create_timer(rand_range(2,2))
			timer.connect("timeout",self,"pasar_a_quieto")
			
		
		estados.muerte:
			var explosion:Particles2D = ente.explosion_morir.instance()
			explosion.global_position = ente.global_position
			Memoria.nivel_actual.add_child(explosion)
			explosion._inicio(4,38,38)
			ente.queue_free()
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass

func pasar_quieto_atacar():
	if estado == estados.patrulla:
		poner_estado_deferred("quieto_ataque")
	pass

func pasar_ataque_sierras():
	if estado == estados.quieto_ataque:
		poner_estado_deferred("ataque_sierras")
		
func pasar_a_quieto():
	poner_estado_deferred("quieto")

#SEÑALES-----------------------------------
func _on_animacion_termina(animacion:String):
	
	pass


func _on_VisibilityNotifier2D_screen_entered():
	dentro_de_camara = true
	var timer:SceneTreeTimer = get_tree().create_timer(rand_range(1.5,2.0))
	timer.connect("timeout",self,"pasar_a_quieto")
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	dentro_de_camara = false
	pass # Replace with function body.
