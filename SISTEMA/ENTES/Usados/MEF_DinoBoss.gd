extends MEF_base

signal entra_en_combate()

var ente:DinoBoss = get_parent()



var pasos_alante:int = 0
var pasos_atras:int = 0
var pasos_acumulados:int = 0

var pos_inicio:Vector2

var animacion_actual_pasos:String = ""

var decide_atacar:bool = false

var llamas:int  = 0

var nodo_control:Node

var tiempo_entre_bolas:float = 0.5
var contador_bolas:int = 0

var efectos_creados:Array #Un arreglo que almacena referencia a todos los efectos creados, para luego si muere el Boss eliminarlos.

var frustrado:bool = false
var enfurecido:bool = false #Se pone a true para la segunda fase cuadno pierde la mitad de lavida.

func _ready():
	_agregar_estado("desconectado")
	_agregar_estado("bajando")
	_agregar_estado("puesto")
	_agregar_estado("encender")
	_agregar_estado("idle")
	_agregar_estado("ataque_pisoton_morder")
	_agregar_estado("paso_alante")
	_agregar_estado("paso_atras")
	_agregar_estado("determinar_ataque")
	_agregar_estado("regresar_pose_inicio")
	_agregar_estado("ataque_llamas_cerca")
	_agregar_estado("ataque_llamas_super")
	_agregar_estado("ataque_misiles")
	_agregar_estado("ataque_zarpazo")
	
	#yield(get_tree(),"idle_frame")
	poner_estado_deferred(estados.desconectado)
	call_deferred("UltimaConfiguracion")
	
#Logica para cambiar de estados:
func _transiciones(delta):
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	ente.get_node("Label_debug").text = str(pasos_acumulados) + "_"+ str([pasos_alante,pasos_atras]) + estado + " " + animacion_actual_pasos
	pass
	
func _physics_process(delta):
	if [estados.paso_alante, estados.paso_atras, estados.ataque_pisoton_morder,estados.regresar_pose_inicio].has(estado):
		ente.movimiento.x = ente.control.velocidad_movimiento
		ente.movimiento = ente.move_and_slide(ente.movimiento)
		
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.desconectado:
			ente.anim_dino.play("desconectado")
		
		estados.bajando:
			ente.anim_dino.play("bajando")
			
		estados.encender:
			ente.anim_dino.play("encender")
		
		estados.puesto:
			ente.anim_dino.play("puesto")
			poner_estado_deferred(estados.encender)
		
		estados.idle:
			emit_signal("entra_en_combate")
			#pasos_acumulados = 0
			ente.anim_dino.play("idle")
			
			if decide_atacar:
				pass
			else:
				if !ente.get_node("RayCast2D").is_colliding():
					poner_estado_deferred("regresar_pose_inicio")
					return
					
				DeterminarAlanteAtras()
			
		estados.paso_alante:
			#si no ha dado pasos, significa que acaba de salir:
			if pasos_acumulados == 0:
				ente.anim_dino.play("paso_quieto_a_alante_derecha")
			
			#si no, si es impar, significa que le toca al pie izquierdo.
			elif pasos_alante % 2 != 0:
				ente.anim_dino.play("paso_alante_izquierda")
			else:
				ente.anim_dino.play("paso_alante_derecha")
				
			pasos_alante += 1
			pasos_atras -= 1 
			pasos_acumulados += 1
			pass
		
		estados.paso_atras:
			#si no ha dado pasos, significa que acaba de salir:
			if pasos_acumulados == 0:
				ente.anim_dino.play("paso_quieto_a_atras_derecha")
			
			#si no, si es impar, significa que le toca al pie izquierdo.
			elif pasos_atras % 2 != 0:
				ente.anim_dino.play("paso_atras_izquierda")
			else:
				ente.anim_dino.play("paso_atras_derecha")
				
			pasos_atras += 1
			pasos_alante -= 1 
			pasos_acumulados += 1
			pass
		
		estados.determinar_ataque:
			pasos_acumulados = 0
			poner_estado_deferred("ataque_llamas_cerca")
			return
			var at:int 
			if ente.vitalidad > ente.max_vitalidad/2:
				at = 0
			else:
				at = randi()% 2+1
			match at:
				0:
					if not ente.get_node("Rayo_frente").is_colliding():
						poner_estado_deferred("ataque_pisoton_morder")
					else:
						poner_estado_deferred(estados.regresar_pose_inicio)
						#Esta regresando porque no pudo atacar, entonces estará frustrado...
						frustrado = true
				1:
					poner_estado_deferred("ataque_llamas_cerca")
				2:
					poner_estado_deferred("ataque_llamas_super")
			
			#limpiar la lista de efectos invalidos:
			efectos_creados.clear()
		
		estados.ataque_llamas_cerca:
			ente.anim_dino.play("ataque_cerca_llamas_arranque")
			
		estados.ataque_pisoton_morder:
			ente.anim_dino.play("ataque_pisoton_morder")
		
		estados.regresar_pose_inicio:
			ir_a_pose_inicio()
			pass
		
		estados.ataque_zarpazo:
			ente.anim_dino.play("ataque_cerca_con_garras")
			
		estados.ataque_llamas_super:
			ente.anim_dino.play("ataque_cerca_llamas_global")
		
		estados.muerte:
			var explosion:Particles2D = ente.explosion_morir.instance()
			explosion.global_position = ente.global_position
			Memoria.nivel_actual.add_child(explosion)
			explosion._inicio(30,270,270)
			ente.emit_signal("Muere")
			
			for i in efectos_creados:
				if is_instance_valid(i):
					i.call_deferred("queue_free")
			
			ente.queue_free()
			pass
	
	#
	if ente.vitalidad < ente.max_vitalidad/2 and enfurecido == false:
		enfurecido = true
		ente.anim_dino.playback_speed = 1.45
		ente.control.modulate = Color(0.96875, 0.397339, 0.397339)
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	match viejo:
		estados.encender:
			Memoria.modo_cinematica_activo = false
	pass

##########
func LogicaMorir(cantida_dagno,quien):
	var ente = get_parent() as Ente
	#print(cantida_dagno)
	ente.set_vitalidad(ente.get_vitalidad() - (cantida_dagno / 5)) 
	
	if ente.vitalidad <= 0:
		#print("muerte!!")
		poner_estado_deferred(estados.muerte)
		
func ir_a_pose_inicio()->bool:
	if ente.global_position.x < pos_inicio.x:
		if animacion_actual_pasos == "paso_atras_derecha_rapido":
			ente.anim_dino.play("paso_atras_izquierda_rapido",-1,1.0)
		else:
			ente.anim_dino.play("paso_atras_derecha_rapido",-1,1.0)
		
		return false
	
	else:
		
		poner_estado_deferred(estados.idle)
	return true

func DeterminarAlanteAtras():
	#Determinar ir alante o ir atras:
	if pasos_acumulados < 6:
		if pasos_alante < 4:
			if randi()%100 < 50:
				poner_estado_deferred(estados.paso_alante)
			else:
				if pasos_atras < 3:
					poner_estado_deferred(estados.paso_atras)
				else:
					poner_estado_deferred(estados.paso_alante)
		elif pasos_atras < 2:
			poner_estado_deferred(estados.paso_atras)
		else:
			poner_estado_deferred(estados.determinar_ataque)
			pass
	else:
		poner_estado_deferred(estados.determinar_ataque)
		pass

func DeterminarVolverReposo():
	match animacion_actual_pasos:
			
			"paso_atras_derecha","paso_quieto_a_atras_derecha","paso_atras_derecha_rapido":
				ente.anim_dino.play("retorno_atras_a_quieto_derecha")
				pass
			"paso_atras_izquierda","paso_atras_izquierda_rapido":
				ente.anim_dino.play("retorno_atras_a_quieto_izquierda")
				pass
			
			"paso_alante_derecha","paso_quieto_a_alante_derecha" :
				ente.anim_dino.play("retorno_alante_a_quieto_derecha")
				pass
			
			"paso_alante_izquierda":
				ente.anim_dino.play("retorno_alante_a_quieto_izquierda")
				pass
			
			_:
				poner_estado_deferred(estados.idle)

func DeterminarLanzarMisiles():
	if ente.vitalidad < ente.max_vitalidad/2:
		if randi()%100 <= 80:
			ente.anim_dino.play("ataque_misiles_suelo")
			poner_estado_deferred(estados.ataque_misiles)
			return
			
	if randi()%100 <= 30:
		ente.anim_dino.play("ataque_misiles_suelo")
		poner_estado_deferred(estados.ataque_misiles)

	pass
	
func DispararMisilesDirigidos():
	ente.anim_dino.play("ataque_misiles_general")
	poner_estado_deferred(estados.ataque_misiles)
	
func PasarEfectoPaso2():
	ente.anim_dino.play("ataque_cerca_llamas_paso2")
	
func CrearLlama():
	var llama = load("res://SISTEMA/EFECTOS/ESPECIALES/Usados/EfectoEspecial_llamas_ataque_suelo_dinoboss.tscn").instance() as Node2D
	llama.global_position = Vector2(ente.control.pos_llamas.global_position.x - (30 * llamas),ente.control.pos_llamas.global_position.y)
	nodo_control.add_child(llama)
	llamas += 1
	efectos_creados.append(llama)
	
	#print("p")
	pass

func AlgoritmoBolasFuego():
	if contador_bolas < ente.numero_llamas_superataque:
		var current_camara:Camera2D = Memoria.camara_actual
		var view:Viewport = get_tree().root
		var bola = load("res://SISTEMA/EFECTOS/ESPECIALES/BolaDeFuegoQueCae.tscn").instance() as KinematicBody2D
		#prints(view.size.x, current_camara.zoom.x, view.size.x  * current_camara.zoom.x)
		var punto_final:Vector2 = ente.get_node("Rayo_bolas_fuego").get_collision_point()
		
		var rango_x:float = rand_range(punto_final.x,ente.get_node("Rayo_bolas_fuego").global_position.x)
		
		var altura:float = current_camara.get_camera_screen_center().y - 200
		
		var limite_derecha:float = current_camara.get_camera_screen_center().x +300
		var limite_izquierda:float = current_camara.get_camera_screen_center().x -300
		
		var rango_x_camara_derecha = rand_range(current_camara.get_camera_screen_center().x -300,ente.get_node("Rayo_bolas_fuego").global_position.x)
		var rango_x_camara_izquierda:float = rand_range(punto_final.x,limite_derecha)
		
		var pos:Vector2
		if rango_x >= limite_izquierda and rango_x <= limite_derecha: 
			pos = Vector2(rango_x, altura)
		
		elif rango_x > limite_derecha:
			pos = Vector2(rango_x_camara_izquierda, altura)
		elif rango_x < limite_izquierda:
			pos = Vector2(rango_x_camara_derecha, altura)
			
		bola.global_position = pos
		
		
		Memoria.nivel_actual.add_child(bola)
		
		if estado == estados.ataque_llamas_super:
			var timer:SceneTreeTimer = get_tree().create_timer(tiempo_entre_bolas)
			timer.connect("timeout",self,"AlgoritmoBolasFuego")
		contador_bolas += 1
	else:
		ente.anim_dino.play("ataque_cerca_llamas_global_fin")
	pass

func UltimaConfiguracion():
	ente.anim_dino.connect("animation_finished",self,"_on_animacion_termina")
	pos_inicio = ente.global_position
	
	ente.control.connect("disparar_misil",ente,"DispararMisiles")
	ente.control.connect("disparar_misil_dirigido",ente,"DispararMisilDirigido")
	ente.control.connect("suelo_listo_levantarse",self,"DeterminarLanzarMisiles")
	ente.control.connect("crear_llama",self,"CrearLlama")
	ente.control.connect("crear_bolas_fuego",self,"AlgoritmoBolasFuego")

	#Añade al nivel un nodo que controlará todos los efectos del boss:
	if not Memoria.nivel_actual.get_node_or_null("EFECTIS_BOSS"):
		nodo_control = Node.new()
		nodo_control.name = "EFECTOS_BOSS"
		Memoria.nivel_actual.add_child(nodo_control)
############################################################
func _on_animacion_termina(animacion:String):
	match animacion:
		"bajando":
				poner_estado_deferred(estados.encender)
		"encender","ataque_misiles_suelo","ataque_misiles_general", "ataque_cerca_con_garras","ataque_cerca_llamas_paso2", "ataque_cerca_llamas_global_fin":
			poner_estado_deferred(estados.idle)
			llamas = 0
			contador_bolas = 0
			return
		"ataque_pisoton_morder":
			poner_estado_deferred(estados.regresar_pose_inicio)
		
		"ataque_cerca_llamas_arranque":
			var efecto_absorver_llamas = load("res://SISTEMA/EFECTOS/ESPECIALES/Efecto_absorver_fuego_dinoboss.tscn").instance() as EfectoEspecialControlado
			efecto_absorver_llamas.connect("middle_efecto",self,"PasarEfectoPaso2")
			
			efecto_absorver_llamas.global_position = ente.control.pos_boca.global_position
			nodo_control.add_child(efecto_absorver_llamas)
			
			efectos_creados.append(efecto_absorver_llamas)
			return
	
	#VERIFICAR SI ES UNA ANIMACION DE CAMINAR:
	if animacion.find("paso") != -1:
		animacion_actual_pasos = animacion
		ente.movimiento = Vector2.ZERO
	else:
		animacion_actual_pasos = ""
		
	#VERIFICAR SI ESTA RETORNANDO A LA POSICION ORIGINAL:
	if estado == estados.regresar_pose_inicio:
		if animacion.find("retorno") == -1:
			#si está frustrado, intentará atacar a la minima:
			if frustrado:
				if not ente.get_node("Rayo_frente").is_colliding():
					poner_estado_deferred(estados.determinar_ataque)
					return
			
			var ir = ir_a_pose_inicio()
			if ir:
				DeterminarVolverReposo()
		else:
			poner_estado_deferred(estados.idle)
		return
	
	
	
	#CHEQUEAR SI HA DADO LOS PASOS NECESARIOS:
	if pasos_acumulados >= 6:
#		if animacion.find("retorno") != -1:
#			poner_estado_deferred(estados.determinar_ataque)
#			return
#		DeterminarVolverReposo()
		pasos_acumulados = 0
		poner_estado_deferred(estados.determinar_ataque)
		
	elif [estados.paso_alante,estados.paso_atras].has(estado):
		#Existe la posibilidad de lanzar misiles si el jugador está alejado.
		if ente.global_position.distance_to(Memoria.jugador.global_position) > 200:
			if randi()%100 < 12:
				DispararMisilesDirigidos()
				return
		
		#Determiar meter un zarpazo:
		elif ente.global_position.distance_to(Memoria.jugador.global_position)<120:
			if randi()%100 < 40:
				poner_estado_deferred("ataque_zarpazo")
				return
		#Determina caminar atras-alante
		DeterminarAlanteAtras()
		
	pass
