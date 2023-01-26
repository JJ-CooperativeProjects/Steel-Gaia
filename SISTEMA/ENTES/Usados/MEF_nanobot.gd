extends MEF_base


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ente:Enemigo = get_parent()
var turnos:int = 0	#La cantidad de movimientos antes de decidir atacar.
var cargando:bool = false

var cayendo:bool =false

# Called when the node enters the scene tree for the first time.
func _ready():
	_agregar_estado("en_aire")
	_agregar_estado("quieto")
	_agregar_estado("moviendose")
	_agregar_estado("cargando")
	_agregar_estado("ataque_salto")
	
	poner_estado_deferred("quieto")
	
	get_parent().get_node("AnimationPlayer").connect("animation_finished",self,"_on_animacion_termina")
	pass # Replace with function body.


#Logica para cambiar de estados:
func _transiciones(delta):

	match estado:
		estados.moviendose:
			ente.Caminar(delta)
			
			if ente.is_on_wall() or ente.Quieto():
				return estados.quieto
		
		estados.ataque_salto:
			ente.CaminarAtaqueSalto(delta)
			
			if ente.is_on_floor():
				return estados.quieto
			
		estados.en_aire:
			if ente.is_on_floor():
				return estados.quieto
		
			
			
	
	if !ente.is_on_floor() and ![estados.ataque_salto].has(estado):
		return estados.en_aire
	

	return null
	
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	
	
	#Girar:
	var sentido:int = ente.movimiento.normalized().x
	ente.get_node("Label_debug").text = estado + " " + str(sentido)
	ente.CambiarSentido(sentido)
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
			cayendo = false
			ente.movimiento = Vector2.ZERO
			print(estado)
			ente.anim.play("quieto")
			#Decdide los pasos que quiere caminar:
			if turnos <= 150:
				turnos += randi()%80+10
			
			#Existe la posibilidad de que empiece a cargar...
			if !cargando:
				if turnos >= 150:
					turnos = 0
					#ente.modulate = Color.blue
					poner_estado_deferred("cargando")
					return
				
			var timer_caminar:SceneTreeTimer = get_tree().create_timer(rand_range(0.1,0.7))
			timer_caminar.connect("timeout",self,"pasar_a_moverse")

		estados.moviendose:
			ente.anim.play("camina")
			ente.Impulso()
			ente.direccion_mira = [-1,1][randi()%2]
			
			var timer_caminar:SceneTreeTimer = get_tree().create_timer(rand_range(0.3,1.6))
			timer_caminar.connect("timeout",self,"pasar_a_quieto")
			pass
		
		estados.cargando:
			cargando = true
			ente.anim.play("cargando")
			var timer_cargar:SceneTreeTimer = get_tree().create_timer(rand_range(1.5,3.0))
			timer_cargar.connect("timeout",self,"pasar_ataque_salto")
		
		estados.ataque_salto:
			cargando = false
			ente.anim.play("saltar")
			ente.MirarObjetivo(Memoria.jugador)
			#ente.Impulso()
			ente.Saltar()
		
		estados.en_aire:
			cayendo = true
			
		estados.muerte:
			var i_efecto:EfectoEspecial = ente.efecto_muerte.instance()
			i_efecto.global_position = ente.global_position
			Memoria.nivel_actual.add_child(i_efecto)
			ente.queue_free()
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	match viejo:
		estados.ataque_salto:
			cargando = false
			#ente.modulate = Color.white
	pass



#SEÑALES:
func pasar_a_moverse():
	if estado != estados.cargando:
		if ente.is_on_floor():
			poner_estado_deferred("moviendose")
		

func pasar_a_quieto():
	if estado != estados.cargando:
		poner_estado_deferred("quieto")

func pasar_ataque_salto():
	if ente.is_on_floor():
		poner_estado_deferred("ataque_salto")

func _on_animacion_termina(animacion:String):
	
	pass
