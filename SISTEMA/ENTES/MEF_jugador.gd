extends MEF_base
# Called when the node enters the scene tree for the first time.



var doble_tap:Array = []
var combo_count:int = 0

var consumo_energia_escopeta:float = 40
var consumo_energia_doble_salto:float = 20
var consumo_energia_dash:float = 30

var puede_escopeta:bool = true
var puede_dash:bool = true
var puede_doble_salto:bool = true

onready var ente:Jugador = owner
func _ready():
	_agregar_estado("quieto")
	_agregar_estado("correr")
	_agregar_estado("atacar1")
	_agregar_estado("atacar2")
	_agregar_estado("escopeta")	#Disparo
	_agregar_estado("en_escalera")
	_agregar_estado("en_pared")
	_agregar_estado("hit")
	_agregar_estado("dash")
	_agregar_estado("salto_inicia")
	_agregar_estado("salto_sube")
	_agregar_estado("salto_cae")
	_agregar_estado("segundo_salto")
	_agregar_estado("segundo_salto_cae")
	_agregar_estado("salto_termina")
	
	
	poner_estado_deferred("quieto")
	
	#Conectar señales desues de que se cargue la escena.
	Memoria.connect("datos_cargados",self,"AfterCargar")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if not ente.ocupado:
		#Ataque1:
		if ["quieto","correr","salto_sube","salto_cae","segundo_salto","segundo_salto_cae","atacar1","atacar2"].has(estado):
			if event.is_action_pressed("atacar"):
				if [estados.atacar1].has(estado):
					combo_count = 2
				elif [estados.atacar2].has(estado):
					combo_count = 1
				else:
					poner_estado_deferred(estados.atacar1) 
			elif event.is_action_pressed("escopeta") and ente.energia >= consumo_energia_escopeta and puede_escopeta:
				poner_estado_deferred(estados.escopeta) 
		
		#Salto:
		if event.is_action_pressed("salto") and ente.is_on_floor():
			poner_estado_deferred(estados.salto_inicia)
	
func _physics_process(delta):
	if ![estados.en_pared,estados.dash,estados.atacar1,estados.atacar2,estados.escopeta, estados.en_escalera].has(estado):
		ente.AplicarGravedad(delta)
		ente.Caminar(delta)
	elif [estados.atacar1,estados.atacar2].has(estado):
		ente.AplicarGravedadAtaque(delta)
#	elif [estados.en_escalera].has(estado):
#		ente.CaminarEscalera(delta)
		pass
	else:
		ente.CaminarPared(delta)
	
	if [estados.dash].has(estado):
		ente.movimiento = ente.move_and_slide(ente.AjustarVectorImpulso(),Vector2.UP)
		
#	elif [estados.en_escalera].has(estado):
#		ente.movimiento = ente.move_and_slide(ente.movimiento ,Vector2.UP)
	else:
		ente.movimiento.y = ente.move_and_slide_with_snap(ente.movimiento + ente.AjustarVectorImpulso(),ente.vector_snap,Vector2.UP,true,4,ente.SNAP_ANGULO).y
	
	if [estados.quieto, estados.correr, estados.salto_cae, estados.salto_sube, estados.segundo_salto, estados.segundo_salto_cae, estados.en_escalera].has(estado):
		ente.Girar()
#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.quieto:
			if !ente.Quieto():
				return estados.correr

		estados.salto_inicia:
			if !ente.is_on_floor():
				return estados.salto_sube
		
		estados.salto_sube:
			if Input.is_action_just_released("salto"):
				ente.tween_salto.stop()
				ente.movimiento.y = lerp(ente.movimiento.y,0,0.23)
			
#			if Input.is_action_just_pressed("salto") and !ente.is_on_wall() and puede_doble_salto and ente.get_energia() >= consumo_energia_doble_salto:
#				return estados.segundo_salto
		
		estados.salto_cae,estados.salto_sube:
			if ente.is_on_floor():
				return estados.quieto
		
#			if Input.is_action_just_pressed("salto") and !ente.is_on_wall() and puede_doble_salto and ente.get_energia() >= consumo_energia_doble_salto:
#				return estados.segundo_salto
				
#		estados.segundo_salto_cae:
#			if ente.is_on_floor():
#				return estados.quieto
		
		estados.atacar1:
#			#if ente.anim.current_animation_position > ente.anim.current_animation_length/2:
#			if Input.is_action_just_pressed("atacar"): 
#				combo_count = 2
			if Input.is_action_just_pressed("escopeta"):
				combo_count = -1
#
		estados.atacar2:
#			#if ente.anim.current_animation_position > ente.anim.current_animation_length/2:
#				if Input.is_action_just_pressed("atacar"): 
#					combo_count = 1
				if Input.is_action_just_pressed("escopeta"):
					combo_count = -1
		
		estados.escopeta:
			pass
		
#		estados.en_escalera:
#			if !ente.en_escalera:
#				return estados.quieto
			
			#ûede saltar:
			if Input.is_action_just_pressed("salto"):
				return estados.salto_inicia
			#puede hacer dash:
#			if Input.is_action_just_pressed("dash") and puede_dash and ente.get_energia() >= consumo_energia_dash:
#				return estados.dash
				
		estados.en_pared:
			if Input.is_action_just_pressed("salto"):
				return estados.salto_inicia
			
#			if ente.direccion_mira == 1:
#				if Input.is_action_just_pressed("dash") and puede_dash and ente.get_energia() >= consumo_energia_dash:
#					ente.GirarManualmente()
#					return estados.dash
#			else:
#				if Input.is_action_just_pressed("dash") and puede_dash and ente.get_energia() >= consumo_energia_dash:
#					ente.GirarManualmente()
#					return estados.dash
				
			if !ente.FueraDePared():
				return estados.quieto
	
#	if ["quieto", "correr","salto_cae","salto_sube","segundo_salto","segundo_salto_cae"].has(estado):
##		if Input.is_action_just_pressed("dash") and puede_dash and ente.get_energia() >= consumo_energia_dash:
##			return estados.dash
#
##		if Input.is_action_just_pressed("salto") and ente.is_on_floor():
##				return estados.salto_inicia
#		pass
	#Agarrarse en pared:
	if ["correr","salto_sube","salto_cae","segundo_salto","segundo_salto_cae","dash"].has(estado) and !ente.is_on_floor():
		if ente.is_on_wall() and Input.is_action_just_pressed("salto"):
			return estados.en_pared
	
	#Agarrarse a escalera:
#	if !["atacar1", "atacar2","escopeta", "en_escalera", "en_pared", "muerte", "hit", "dash", "salto_termina"].has(estado) and ente.en_escalera:
#		if Input.is_action_just_pressed("ui_up"):
#			return estados.en_escalera
		pass
	
				
	if estado != estados.quieto:
		if ente.Quieto() and ![estados.salto_inicia, estados.salto_termina,estados.dash,estados.atacar1,estados.atacar2,estados.escopeta,estados.en_escalera].has(estado) and ente.is_on_floor():
			return estados.quieto
	
	if !ente.is_on_floor():
		if ![estados.en_pared,estados.dash, estados.salto_cae,estados.segundo_salto,estados.segundo_salto_cae,estados.atacar1,estados.atacar2,estados.escopeta, estados.en_escalera].has(estado)and ente.movimiento.y > 0:
			return estados.salto_cae
#		elif [estados.segundo_salto].has(estado) and ente.movimiento.y > 0:
#			return estados.segundo_salto_cae
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	#ente.get_node("Label").text = str([ente.is_on_floor(), ente.is_on_ceiling(),ente.is_on_wall()])
	ente.get_node("Label").text = str(estado)#str(ente.FueraDePared())
	ente.direcciones = ente.DireccionesTeclado()
	
	ente.ProcessEnergia(delta)
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto:
			ente.anim.play("quieto")
			ente.ReiniciarVectorSnap()
		
		estados.correr:
			ente.anim.play("corre")
		
		estados.salto_inicia:
			ente.movimiento = Vector2.ZERO
			ente.Saltar()
			#ente.SegundoSalto()
		
		estados.salto_sube:
			ente.anim.play("salto_sube")
			pass
		
		estados.salto_cae:
			ente.anim.play("salto_cae")
			pass
		
		estados.en_pared:
			ente.movimiento = Vector2.ZERO
		
#		estados.dash:
#			ente.set_energia(ente.get_energia() - consumo_energia_dash)
#			ente.Dash()
#			ente.EfectoSombra(0.01,self)
		
#		estados.segundo_salto:
#			ente.set_energia(ente.get_energia() - consumo_energia_doble_salto)
#			ente.movimiento = Vector2.ZERO
#			ente.SegundoSalto()
#			ente.EfectoSombra(0.01,self)
		
		estados.atacar1:
			ente.movimiento = Vector2.ZERO
			ente.anim.play("atacar1")
			
			if ente.is_on_floor():
				ente.get_node("AnimEfectos").stop(true)
				ente.get_node("AnimEfectos").play("impulso_ataque")
		
		estados.atacar2:
			ente.movimiento = Vector2.ZERO
			ente.anim.play("atacar2")
			if ente.is_on_floor():
				ente.get_node("AnimEfectos").stop(true)
				ente.get_node("AnimEfectos").play("impulso_ataque")
		
		estados.escopeta:
			ente.set_damage(ente.damage * rand_range(6,10))
			ente.set_energia(ente.get_energia()-consumo_energia_escopeta)
			ente.movimiento = Vector2.ZERO
			ente.anim.play("escopeta")
			ente.get_node("AnimEfectos").stop(true)
			ente.get_node("AnimEfectos").play("retroceso_escopeta")
		
#		estados.en_escalera:
#			ente.movimiento = Vector2.ZERO
#			ente.vector_impulsos = Vector2.ZERO
#			pass
		
		estados.muerte:
			ente.anim.play("muerte")
			DeshabilitarTodo()
			
			
			
			pass
	pass
	
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	match viejo:
		estados.salto_cae,estados.quieto:
			print(viejo)
			ente.emit_signal("TerminaSalto")
			pass
		
		
	
	pass

#Retorna true si se pulsa dos veces seguidas la tecla que se especifica:
func DobleTap(input:String)->bool:
	if Input.is_action_just_pressed(input):
		if doble_tap.empty():
			doble_tap.append(input)
			var timer:SceneTreeTimer = get_tree().create_timer(0.3)
			timer.connect("timeout",self,"tap_clear")
		elif doble_tap[0] == input:
			doble_tap.append(input)
		else:
			doble_tap.clear()

	if doble_tap.size() > 1:
		doble_tap.clear()
		return true
	return false

func LogicaMorir(cantida_dagno,quien):
	var ente = get_parent() as Ente
	#print(cantida_dagno)
	ente.set_vitalidad(ente.get_vitalidad() - cantida_dagno) 
	
	if ente.vitalidad <= 0:
		#print("Ha muerto el jugador muerte!!")
		
		
		poner_estado_deferred(estados.muerte)


func DeshabilitarTodo():
	set_physics_process(false)
	set_process(false)
		
	for i in ente.get_node("HABILIDADES").get_children():
		var hab:= i as Habilidad

		hab.set_process_input(false)
		hab.set_process(false)
		hab.set_physics_process(false)

func PonerSaltoCiclo():
	ente.anim.play("salto_cae_ciclo")


func AfterCargar():
	ente.get_node("AnimEfectos").connect("animation_finished",self,"_on_animacion_termina")
	ente.anim.connect("animation_finished",self,"_on_animacion_termina")
#SEÑALES========================================================================
func tap_clear():
	doble_tap.clear()
	
func _on_animacion_termina(animacion:String):
	match animacion:
#		"CurvaDash":
#			if ![estados.en_pared].has(estado):
#				poner_estado_deferred(estados.quieto)
		
		"atacar1","atacar2":
			if combo_count == 2:
				combo_count = 0
				poner_estado_deferred(estados.atacar2)
				return
			elif combo_count == 1:
				combo_count = 0
				poner_estado_deferred(estados.atacar1)
				return
			elif combo_count == -1:
				combo_count = 0
				if puede_escopeta and ente.get_energia() >= consumo_energia_escopeta: 
					poner_estado_deferred(estados.escopeta)
					return
			poner_estado_deferred(estados.quieto)
			pass
		
		"escopeta":
			ente.set_damage(5)
			poner_estado_deferred(estados.quieto)
	pass

func _on_sm_termina():
	pass
