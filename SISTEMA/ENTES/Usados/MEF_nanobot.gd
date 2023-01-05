extends MEF_base


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ente:Enemigo = get_parent()
var turnos:int = 0	#La cantidad de movimientos antes de decidir atacar.
var cargando:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_agregar_estado("en_aire")
	_agregar_estado("quieto")
	_agregar_estado("moviendose")
	_agregar_estado("cargando")
	_agregar_estado("ataque_salto")
	
	poner_estado_deferred("quieto")
	pass # Replace with function body.


#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.moviendose:
			ente.Caminar(delta)
			
			if ente.is_on_wall():
				return estados.quieto
		
		estados.ataque_salto:
			ente.CaminarAtaqueSalto(delta)
			
	#retorna en el aire:
	if !ente.is_on_floor() and ![estados.ataque_salto].has(estado):
		return estados.en_aire
		
	elif ente.Quieto() and ![estados.cargando,estados.muerte].has(estado):
		return estados.quieto
		
	return null
	
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	ente.get_node("Label_debug").text = estado + " " + str(turnos)
	pass

func _physics_process(delta):
	#GRAVEDAD:
	ente.AplicarGravedad(delta)
	
	#MOVIMIENTO:
	ente.movimiento.y = ente.move_and_slide_with_snap(ente.movimiento + ente.AjustarVectorImpulso(),ente.vector_snap,Vector2.UP,true,4,ente.SNAP_ANGULO).y
	
	
	pass
	
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto:
			#Decdide los pasos que quiere caminar:
			if turnos <= 0:
				turnos = randi()% 100+20
			
			#Existe la posibilidad de que empiece a cargar...
			if !cargando:
				var t:int = range(turnos)[randi()%turnos]
				if t <= 1:
					cargando = true
					ente.modulate = Color.blue
					var timer_cargar:SceneTreeTimer = get_tree().create_timer(rand_range(0.5,1.2))
					timer_cargar.connect("timeout",self,"pasar_ataque_salto")
					
				
			var timer_caminar:SceneTreeTimer = get_tree().create_timer(rand_range(1.2,3.0))
			timer_caminar.connect("timeout",self,"pasar_a_moverse")

		estados.moviendose:
			ente.Impulso()
			ente.direccion_mira = [-1,1][randi()%2]
			pass
		
		estados.ataque_salto:
			ente.MirarObjetivo(Memoria.jugador)
			#ente.Impulso()
			ente.Saltar()
			
		estados.muerte:
			ente.queue_free()
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	match viejo:
		estados.ataque_salto:
			cargando = false
			ente.modulate = Color.white
	pass


#SEÑALES:
func pasar_a_moverse():
	if ente.is_on_floor():
		poner_estado_deferred("moviendose")
		turnos -= 1

func pasar_ataque_salto():
	if ente.is_on_floor():
		poner_estado_deferred("ataque_salto")
