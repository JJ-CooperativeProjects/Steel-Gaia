extends Habilidad

var ejecutado:bool = false #Solo puede ser ejecutado una sola vez durante un salto.

var input:String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	mi_ente = get_parent().get_parent()
	mef_ente = mi_ente.get_node("MEF")
	
	_agregar_estado("espera")
	_agregar_estado("salto_doble")
	_agregar_estado("termina")
	
	
	poner_estado_deferred("espera")
	call_deferred("DeshabilitarSelf")
	
	pass # Replace with function body.

func _input(event):
	if not ejecutado:
		match estado:
			estados.espera:
				if event.is_action_pressed("salto") and !mi_ente.is_on_wall() and mi_ente.get_energia() >= consumo_energia:
					if [mef_ente.estados.salto_cae, mef_ente.estados.salto_sube].has(mef_ente.estado):
						DeshabilitarMEF()
						get_parent().DesactivarHabilidadesDesactivables([self])
						HabilitarSelf()
						
						poner_estado_deferred(estados.salto_doble)
			
		return
	pass

func _physics_process(delta):
	mi_ente.Girar()
	
	match estado:
		estados.salto_doble:
			mi_ente.AplicarGravedad(delta)
			mi_ente.Caminar(delta)
			mi_ente.movimiento.y = mi_ente.move_and_slide_with_snap(mi_ente.movimiento + mi_ente.AjustarVectorImpulso(), mi_ente.vector_snap,Vector2.UP,true,4,mi_ente.SNAP_ANGULO).y

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _transiciones(delta):
	match estado:
		estados.salto_doble:
			if mi_ente.is_on_floor():
				return estados.termina

	if not mi_ente.is_on_floor():
		if mi_ente.movimiento.y > 0:
			return estados.termina
	
	mi_ente.direcciones = mi_ente.DireccionesTeclado()
#	if mi_ente.is_on_wall() and Input.is_action_just_pressed("salto"):
#		poner_estado_deferred(estados.termina)

func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.salto_doble:
			ejecutado = true
			
			mi_ente.set_energia(mi_ente.get_energia() - consumo_energia)
			mi_ente.movimiento = Vector2.ZERO
			mi_ente.SegundoSalto()
			mi_ente.EfectoSombra(0.01,self)
			pass
		
		estados.termina:
			mi_ente.ocupado = false
			poner_estado_deferred(estados.espera)
			call_deferred("HabilitarMEF","")
			input  = ""
			call_deferred("DeshabilitarSelf")
	pass

func Activar():
	ejecutado = false

func AfterCargar():
	mi_ente.connect("TerminaSalto", self, "Activar")
	pass
