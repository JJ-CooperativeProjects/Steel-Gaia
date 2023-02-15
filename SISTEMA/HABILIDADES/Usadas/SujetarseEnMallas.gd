extends Habilidad
#Habilidad que le permite al jugador sujetarse y moverse por mallas.

# Called when the node enters the scene tree for the first time.
func _ready():
	mi_ente = get_parent().get_parent()
	mef_ente = mi_ente.get_node("MEF")
	
	_agregar_estado("espera")
	_agregar_estado("en_malla")
	_agregar_estado("camina_malla")
	_agregar_estado("quieto_malla")
	_agregar_estado("posible_fin")
	_agregar_estado("termina")
	
	
	poner_estado_deferred("espera")
	call_deferred("DeshabilitarSelf")
	
	$MEF_movimientos_en_malla.ente = mi_ente
	$MEF_movimientos_en_malla.anim = mi_ente.get_node("AnimationPlayer")
	
	pass # Replace with function body.


func _input(event):
	if not mi_ente.ocupado:
		match estado:
			estados.espera:
				if event.is_action("ui_up"):
					if mi_ente.en_malla:
						mef_ente.poner_estado_deferred("quieto")
						call_deferred("DeshabilitarMEF")
						mef_ente.set_process_input(false)
						get_parent().DesactivarHabilidadesDesactivables([self])
						HabilitarSelf()
				
						poner_estado_deferred(estados.en_malla)
						$MEF_movimientos_en_malla.set_process(true)
						$MEF_movimientos_en_malla.set_physics_process(true)

			estados.en_malla:
				if event.is_action_pressed("salto"):
					mef_ente.poner_estado_deferred("salto_inicia")
					poner_estado_deferred(estados.termina)

func _physics_process(delta):
	match estado:
		estados.en_malla,estados.posible_fin:
			mi_ente.CaminarMalla(delta)
			mi_ente.movimiento = mi_ente.move_and_slide(mi_ente.movimiento ,Vector2.UP)
			mi_ente.Girar()
			
			
			
	pass
#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.en_malla:
			if not mi_ente.en_malla:
				return estados.termina
			
			if  mi_ente.is_on_floor():
				return estados.posible_fin
				
			
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	mi_ente.direcciones = mi_ente.DireccionesTeclado()
	mi_ente.ProcessEnergia(delta)
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.en_malla:
			mi_ente.movimiento = Vector2.ZERO
			mi_ente.vector_impulsos = Vector2.ZERO
			
		estados.termina:
			mi_ente.movimiento = Vector2.ZERO
			mi_ente.vector_impulsos = Vector2.ZERO
			call_deferred("HabilitarMEF","")
			poner_estado_deferred(estados.espera)
			call_deferred("DeshabilitarSelf")
			$MEF_movimientos_en_malla.set_process(false)
			$MEF_movimientos_en_malla.set_physics_process(false)
		
		estados.posible_fin:
			var timer:SceneTreeTimer = get_tree().create_timer(0.1)
			timer.connect("timeout",self,"Salir")
	pass

func Salir():
	if mi_ente.is_on_floor():
		poner_estado_deferred(estados.termina)
	elif mi_ente.en_malla:
		poner_estado_deferred(estados.en_malla)
	else:
		poner_estado_deferred(estados.termina)
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass

func set_process(valor:bool):
	.set_process(valor)
	
	#$MEF_movimientos_en_malla.set_process(valor)
	pass

func set_physics_process(valor:bool):
	.set_physics_process(valor)
	
	#$MEF_movimientos_en_malla.set_physics_process(valor)
	pass
