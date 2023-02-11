extends MEF_base

onready var ente:Ente 
onready var anim:AnimationPlayer

func _ready():
	_agregar_estado("espera")
	_agregar_estado("quieto_escalera")
	_agregar_estado("camina_escalera")

	poner_estado_deferred(estados.espera)
	
	set_process(false)
	set_physics_process(false)


func _transiciones(delta):
	match estado:
		estados.espera,estados.quieto_escalera:
			if !ente.QuietoEnEscalera():
				return estados.camina_escalera
			
		estados.camina_escalera:
			if ente.QuietoEnEscalera():
				return estados.quieto_escalera
			
	#ente.get_node("Label").text = estado
	
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto_escalera:
			anim.play("malla_quieto")

		
		estados.camina_escalera:
			anim.play("malla_caminar_up_down")
