extends Habilidad

#HABILIDAD QUE LE DA AL ENTE LA POSIBILIDAD DE DESPLAZARSE VELOZMENTE



func _ready():
	mi_ente = get_parent().get_parent()
	mef_ente = mi_ente.get_node("MEF")
	
	#Estados:
	_agregar_estado("espera")
	_agregar_estado("dash")
	_agregar_estado("termina")

	
	poner_estado_deferred(estados.espera)
	
	

func _input(event):
		if [estados.espera].has(estado) and not mi_ente.ocupado:
			if Input.is_action_just_pressed("dash") and mi_ente.get_energia() >= consumo_energia:
				DeshabilitarMEF()
				get_parent().DesactivarHabilidadesDesactivables([self])
				HabilitarSelf()
				
				
				#si está en una pared:
				if mef_ente.estado == mef_ente.estados.en_pared:
					if mi_ente.direccion_mira == 1:
						mi_ente.GirarManualmente()
					else:
						mi_ente.GirarManualmente()
				
				mi_ente.ocupado = true
				poner_estado_deferred(estados.dash)
				
				pass


func _physics_process(delta):
	if [estados.dash].has(estado):
		mi_ente.movimiento = mi_ente.move_and_slide(mi_ente.AjustarVectorImpulso(),Vector2.UP)

#Logica para cambiar de estados:
func _transiciones(delta):
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match estado:
		estados.dash:
			mi_ente.set_energia(mi_ente.get_energia() - consumo_energia)
			mi_ente.Dash()
			mi_ente.EfectoSombra(0.01,self)
		
		estados.termina:
			mi_ente.ocupado = false
			if mi_ente.is_on_wall() and Input.is_action_pressed("salto"):
				mef_ente.poner_estado_deferred("en_pared")
			else:
				mef_ente.poner_estado_deferred("quieto")
			call_deferred("HabilitarMEF","")
			poner_estado_deferred(estados.espera)
			call_deferred("DeshabilitarSelf")
			
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass



#AUXILIARES:


func _on_animacion_termina(animacion:String):
	match animacion:
		"CurvaDash":
			poner_estado_deferred(estados.termina)
			

func AfterCargar():
	mi_ente_anim = mi_ente.get_node("AnimEfectos")
	
	mi_ente_anim.connect("animation_finished",self,"_on_animacion_termina")
	
	DeshabilitarSelf()
