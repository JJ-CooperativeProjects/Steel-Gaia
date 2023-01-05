extends MEF_NPC1
"""
Esta maquina de estados solo controla al NPC cuando está en estado de ALERTA.
"""
var estado_receptor:String = ""	#Al creaerse, se pone el estado del NPC en el momento que se crea.
var objetivo:Jugador = null

# Called when the node enters the scene tree for the first time.
func _ready():
	match estado_receptor:
		estados.quieto:
			pass
		
	pass # Replace with function body.


#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.quieto:
			#Detectar si el jugador está en la misma dirección que él:
			pass
	return null
	
func _physics_process(delta):
	#GRAVEDAD:
	ente.AplicarGravedad(delta)
	
	#MOVIMIENTO:
	ente.movimiento.y = ente.move_and_slide_with_snap(ente.movimiento + ente.AjustarVectorImpulso(),ente.vector_snap,Vector2.UP,true,4,ente.SNAP_ANGULO).y

#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	#GIRAR:
	if ente.estado == ente.estados.TRANQUILO:
		if [estados.caminar].has(estado):
			ente.Girar_por_rayo()
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):

			

	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass
	


	

##SEÑALES-----------------------------------------
func on_timer_caminar_off():
	match estado:
		estados.quieto:
			if ente.estado == ente.estados.TRANQUILO:
				poner_estado_deferred("cargar_camina")
		
		estados.caminar:
			poner_estado_deferred("descargar_quieto")
		
		
			
	pass
func _on_animacion_termina(animacion:String):
	match animacion:
		"cargar_camina":
			#print("ha terminado de cargar")
			pass
			
		"descargar_quieto":
			poner_estado_deferred("quieto")
	
	pass

func _on_sm_termina():
	pass
