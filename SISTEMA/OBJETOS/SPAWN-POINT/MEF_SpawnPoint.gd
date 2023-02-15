extends MEF_base


var timer_inicio:SceneTreeTimer
var timer_rondas:SceneTreeTimer

func _ready():
	_agregar_estado("esperando")
	_agregar_estado("proxima_ronda")
	_agregar_estado("esperando_ronda")
	_agregar_estado("instanciar")
	_agregar_estado("apagado")
	
	poner_estado_deferred("esperando")
	pass

#Logica para cambiar de estados:
func _transiciones(delta):
	
	return null
	
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	
	pass
	
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.esperando:
			timer_inicio = get_tree().create_timer(get_parent().tiempo_arranque)
			timer_inicio.connect("timeout",get_parent(),"Logica")
			
			poner_estado_deferred(estados.proxima_ronda)
			
			
		
		estados.proxima_ronda:
			if get_parent().tiempo_entre_rondas > 0:
				timer_rondas = get_tree().create_timer(get_parent().tiempo_entre_rondas)
				timer_rondas.connect("timeout",get_parent(),"Logica")
				
			poner_estado_deferred(estados.esperando_ronda)
		
		estados.esperando_ronda:
			timer_rondas = get_tree().create_timer(get_parent().tiempo_entre_rondas)
			timer_rondas.connect("timeout",get_parent(),"Logica")
			
			poner_estado_deferred(estados.proxima_ronda)
			pass
		
		estados.apagado:
			DesconectarTimers()
	pass

func DesconectarTimers():
	if is_instance_valid(timer_inicio):
		if timer_inicio.is_connected("timeout",get_parent(),"Logica"):
			timer_inicio.disconnect("timeout",get_parent(),"Logica")
	
	if is_instance_valid(timer_rondas):
		if timer_rondas.is_connected("timeout",self,"poner_estado_deferred"):
			timer_rondas.disconnect("timeout",self,"poner_estado_deferred")

#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass
