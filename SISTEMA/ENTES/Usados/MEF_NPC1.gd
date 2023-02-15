extends MEF_base
class_name MEF_NPC1

onready var ente:Enemigo = owner
onready var efecto_golpe_escudo:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/EfectoEspecial_golpe_escudo.tscn")

#Timempos min/max que el npc toma para alternar entre quieto y caminar.
export (float) var tiempo_minimo_espera:float = 3
export (float) var tiempo_maximo_espera:float = 6
var timer_caminar:SceneTreeTimer = null	#Un timer que usa para alternar entre quieto y caminar.

var timer_fuera_pantalla:SceneTreeTimer = null

export (float) var coeficiente_correr:float = 0.25	#Se controla por curva. Establece la velocidad de la animación de correr.

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_agregar_estado("quieto")
	_agregar_estado("cargar_camina")
	_agregar_estado("descargar_quieto")
	_agregar_estado("caminar")	

	
	_agregar_estado("ataque")
	_agregar_estado("bloquear")
	_agregar_estado("preparar_para_correr")
	_agregar_estado("corriendo")
	_agregar_estado("chocar")
	_agregar_estado("detener_corrida")
	_agregar_estado("run_descargar")
	_agregar_estado("desactivado") #Estado fuera de area

	
	
	poner_estado_deferred("quieto")
	yield(get_tree(),"idle_frame")
	ente.anim.connect("animation_finished",self,"_on_animacion_termina")
	pass # Replace with function body.


#Logica para cambiar de estados:
func _transiciones(delta):
	
	match estado:
		estados.quieto:
			#Mecanica para girar cuando tiene un objetivo delante:
			if ente.estado == ente.estados.ALERTA:
				if Objetivo_a_espaladas():
					return estados.cargar_camina
		
		estados.caminar:
			if ente.estado == ente.estados.TRANQUILO:
				ente.Caminar(delta)
			elif ente.estado == ente.estados.ALERTA:
				return estados.descargar_quieto
		
		estados.corriendo:
			ente.anim.play("corriendo",-1,coeficiente_correr)
			ente.CorrerSprint(coeficiente_correr)
			
			#Si detecta una colision, estremece la escena y para la animación...
			if ente.get_node("Cuerpo/rayo_frente").is_colliding():
				return estados.chocar
		
		
			
	return null
	
func _physics_process(delta):
	#GRAVEDAD:
	ente.AplicarGravedad(delta)
	
	#MOVIMIENTO:
	ente.movimiento.y = ente.move_and_slide_with_snap(ente.movimiento + ente.AjustarVectorImpulso(),ente.vector_snap,Vector2.UP,true,4,ente.SNAP_ANGULO).y

#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	ente.get_node("Label_debug").text = estado
	#GIRAR:
	if ente.estado == ente.estados.TRANQUILO:
		if [estados.caminar].has(estado):
			ente.Girar_por_rayo()
	
	if ente.estado == ente.estados.ALERTA:
		ente.MirarObjetivoConRayo(Memoria.jugador)
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto:
			ente.anim.play("quieto")
			timer_caminar = get_tree().create_timer(rand_range(tiempo_minimo_espera,tiempo_maximo_espera))
			timer_caminar.connect("timeout",self,"on_timer_caminar_off")
		
		estados.cargar_camina:
			ente.anim.play("cargar_camina")
		
		estados.caminar:
			ente.anim.play("caminar")
			timer_caminar = get_tree().create_timer(rand_range(tiempo_minimo_espera,tiempo_maximo_espera))
			timer_caminar.connect("timeout",self,"on_timer_caminar_off")
		
		estados.descargar_quieto:
			ente.velocidad_actual_x = 0
			ente.movimiento.x = 0
			ente.anim.play("descargar_quieto")
			
		estados.ataque:
			ente.anim.play("ataque")
		
		estados.preparar_para_correr:
			ente.anim.play("preparar_para_correr")
		
		estados.corriendo:
			coeficiente_correr = 0.25
			var tween:SceneTreeTween = get_tree().create_tween()
			tween.tween_property(self,"coeficiente_correr",3.2,3.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			
		estados.chocar:
			ente.movimiento = Vector2.ZERO
			ente.anim.play("bloquear")
			Memoria.camara_actual.sacudir(15,3,4)
			
			var timer:SceneTreeTimer = get_tree().create_timer(2.0)
			timer.connect("timeout",self,"poner_quieto")
		
		estados.muerte:
			var explosion:Particles2D = ente.explosion_morir.instance()
			explosion.global_position = ente.global_position
			Memoria.nivel_actual.add_child(explosion)
			explosion._inicio(8,70,60)
			ente.queue_free()
		
		estados.bloquear:
			ente.anim.play("bloquear")
			Memoria.SacudirCamara(3,0,20,20,Vector2(20,20))
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass
	
#Devuelve true si el objetivo está a las espaldas y no al frente
func Objetivo_a_espaladas()->bool:
	if (ente.objetivo.global_position.x > ente.global_position.x and ente.direccion_mira == -1) or (ente.objetivo.global_position.x < ente.global_position.x and ente.direccion_mira == 1):
		return true
	return false

func poner_quieto():
	if not [estados.ataque,estados.bloquear].has(estado):
		poner_estado_deferred("quieto")
	 

func LogicaMorir(cantida_dagno,quien):
	if ente.LogicaMirarJugador():
		var ente = get_parent() as Ente
		#print(cantida_dagno)
		ente.set_vitalidad(ente.get_vitalidad() - cantida_dagno) 
		
		if ente.vitalidad <= 0:
			#print("muerte!!")
			#Crea las almas:
			var rand:int =randi()%4+1
			var objetos_drops:Array = ente.posibles_objetos_soltar
			for i in objetos_drops:
				for a in rand:
					var objeto:ObjetoColectable = load(i).instance()
					objeto.global_position = Vector2(rand_range(ente.global_position.x-10,ente.global_position.x+10),rand_range(ente.global_position.y-10,ente.global_position.y+10))
					Memoria.nivel_actual.get_node("OBJETOS").call_deferred("add_child",objeto)
			
			poner_estado_deferred(estados.muerte)
	else:
		if [estados.quieto].has(estado):
			poner_estado_deferred("bloquear")
			
			#Aplicar pequeño impulso de repulsion:
			var tween:SceneTreeTween = create_tween()
			ente.vector_impulsos.x = -20.0
			tween.tween_property(ente,"vector_impulsos:x",0.0,0.2)
			
#			if is_instance_valid(quien): 
#				if quien.get("pos_pugnos"):
#					sonido.global_position = quien.pos_pugnos.global_position
#					pass
		if not ente.get_node("Cuerpo/Position2D/Escudo/CollisionShape2D").disabled:
			#Poner sonido de golpe:
			var sonido:EfectoEspecial = efecto_golpe_escudo.instance()
			var pos:Position2D = ente.get_node("Cuerpo/pos_golpes_escudo")
			sonido.global_position = Vector2(rand_range(pos.global_position.x-10,pos.global_position.x+10),rand_range(pos.global_position.y-10,pos.global_position.y+10))
			
			Memoria.nivel_actual.add_child(sonido)
##SEÑALES-----------------------------------------
func on_timer_caminar_off():
	match estado:
		estados.quieto:
			if ente.estado == ente.estados.TRANQUILO:
				poner_estado_deferred("cargar_camina")
			elif ente.estado == ente.estados.ALERTA:
				if not ente.jugador_cerca:
					poner_estado_deferred("preparar_para_correr")
				else:
					timer_caminar = get_tree().create_timer(3.0)
					timer_caminar.connect("timeout",self,"on_timer_caminar_off")
		
		estados.caminar:
			poner_estado_deferred("descargar_quieto")

	pass

func _on_animacion_termina(animacion:String):
	match animacion:
		"cargar_camina":
			if ente.estado == ente.estados.TRANQUILO:
				poner_estado_deferred("caminar")
			elif ente.estado == ente.estados.ALERTA:
				if Objetivo_a_espaladas():
					ente.Girar()
				
				if ente.jugador_cerca:
					poner_estado_deferred("ataque")
					return
					
				poner_estado_deferred("descargar_quieto")
		
		"descargar_quieto","bloquear":
			poner_estado_deferred("quieto")
		
		"ataque":
			poner_estado_deferred("quieto") 
		
		"preparar_para_correr":
			poner_estado_deferred("corriendo")
			pass
	pass

func _on_sm_termina():
	pass


func _on_Area_detectar_jugador_body_entered(body):
	if body is Jugador:
		if ente.objetivo == null:
			ente.objetivo = body
			if ente.estado == ente.estados.TRANQUILO:
				ente.estado = ente.estados.ALERTA
		else:
			if ente.estado == ente.estados.TRANQUILO:
				ente.estado = ente.estados.ALERTA
	pass # Replace with function body.


func _on_Area2_jugador_cerca_body_entered(body):
	if not body == ente.objetivo:
		ente.objetivo = body
		
	ente.jugador_cerca = true
	
	pass # Replace with function body.


func _on_Area2_jugador_cerca_body_exited(body):
	ente.jugador_cerca = false
	pass # Replace with function body.

#Hace daño:
func _on_Area2D_body_entered(body):
	body.emit_signal("RecibeDamage",ente.damage,ente)
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_entered():
	ente.get_node("Cuerpo/rayo_mirar_jugador").enabled = true
	set_physics_process(true)
	set_process(true)
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	ente.get_node("Cuerpo/rayo_mirar_jugador").enabled = false
	ente.estado = ente.estados.TRANQUILO
	ente.objetivo = null
	
	if timer_fuera_pantalla == null:
		timer_fuera_pantalla = get_tree().create_timer(4.0)
		timer_fuera_pantalla.connect("timeout",self,"desactivar_npc")
	pass # Replace with function body.

func desactivar_npc():
	#print("el NPC1 ha sido desactivado!")
	poner_estado_deferred(estados.quieto)
	timer_fuera_pantalla = null
	ente.movimiento.x = 0
	ente.vector_impulsos.x = 0
