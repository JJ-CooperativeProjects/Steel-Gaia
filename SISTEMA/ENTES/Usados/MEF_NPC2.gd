extends MEF_base
"""
NPC 2
"""

onready var ente:Enemigo = owner
onready var anim:AnimationPlayer = ente.get_node("Viewport/control_base2/AnimationPlayer")
onready var base_anim:Node2D = ente.get_node("Viewport/control_base2")

var objetivo_en_area:bool = false
var objetivo_a_cohetes:bool = false

var golpes_acumulados:int = 0

func _ready():
	_agregar_estado("quieto")
	_agregar_estado("patrullar")
	_agregar_estado("ataque_laser")
	_agregar_estado("ataque_misiles")
	_agregar_estado("pensar")
	
	poner_estado_deferred(estados.patrullar)
	
	anim.connect("animation_finished",self,"_on_animacion_termina")
	ente.connect("RecibeDamage",self,"RecibeDamage")

func _physics_process(delta):
	
	match estado:
		estados.patrullar,estados.pensar:
			ente.vector_impulsos.x = (base_anim.velocidad_x)
			pass
	
	#GRAVEDAD:
	ente.AplicarGravedad(delta)
	
	#MOVIMIENTO:
	ente.movimiento.y = ente.move_and_slide_with_snap(ente.movimiento + ente.AjustarVectorImpulso(),ente.vector_snap,Vector2.UP,true,4,ente.SNAP_ANGULO).y
	pass

#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.patrullar:
			#Controla la direccion:
			ente.Girar_por_rayo()
			
			#Si está mirando al objetivo y está lejos, intenta atacar con cohetes:
			if ente.MirarObjetivoConRayo(ente.objetivo) and ente.ObjetivoDelante(ente.objetivo):
				return estados.pensar
	
			
	
	
	
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	ente.get_node("Label_debug").text = str(ente.direccion_mira)
	
	ente.MirarObjetivoConRayo(ente.objetivo)
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto:
			ente.movimiento = Vector2.ZERO
			ente.vector_impulsos = Vector2.ZERO
			anim.play("quieto")
		
		estados.patrullar:
			anim.play("caminar")
			
			if objetivo_en_area:
				var timer:SceneTreeTimer = get_tree().create_timer(rand_range(3,6))
				timer.connect("timeout",self,"PensarAtaque")
			pass
		
		estados.ataque_laser:
			ente.movimiento = Vector2.ZERO
			ente.vector_impulsos = Vector2.ZERO
			anim.play("ataque_super_laser")
		
		estados.ataque_misiles:
			ente.movimiento = Vector2.ZERO
			ente.vector_impulsos = Vector2.ZERO
			anim.play("Missile_shoot")
		
		estados.pensar:
			var timer:SceneTreeTimer = get_tree().create_timer(rand_range(1.2,3.5))
			timer.connect("timeout",self,"PensarAtaque")
		
		estados.muerte:
			ente.emit_signal("Muere")
			ente.movimiento = Vector2.ZERO
			ente.vector_impulsos = Vector2.ZERO
			anim.play("Death")
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass

#AUXILIARES:
func PensarAtaque():
	match estado:
		estados.patrullar,estados.pensar:
			ente.MirarObjetivo(ente.objetivo)
			if objetivo_en_area:
				poner_estado_deferred("ataque_laser")
				return
			elif ente.MirarObjetivoConRayo(ente.objetivo):
				poner_estado_deferred("ataque_misiles")
				return
			
			poner_estado_deferred("patrullar")
			
	pass

func AnimDisparar():
	anim.play("Shoot_New")

func RecibeDamage(cantidad:float,quie:Node2D):
	match estado:
		estados.patrullar:
			golpes_acumulados += randi()%10
			
			#Segun la cantidad de golpes recibidos, existe una posibilidad más grande de atacar.
			if randi()%100 < golpes_acumulados:
				golpes_acumulados = 0
				PensarAtaque()

func Desaparecer():
	#Crea las almas:
	var rand:int =randi()%4+1
	var objetos_drops:Array = ente.posibles_objetos_soltar
	for i in objetos_drops:
		for a in rand:
			var objeto:ObjetoColectable = load(i).instance()
			objeto.global_position = Vector2(rand_range(ente.global_position.x-10,ente.global_position.x+10),rand_range(ente.global_position.y-10,ente.global_position.y+10))
			Memoria.nivel_actual.get_node("OBJETOS").call_deferred("add_child",objeto)
	#Crea la explosion:
	var explosion:Particles2D = ente.explosion_morir.instance()
	explosion.global_position = ente.global_position
	Memoria.nivel_actual.add_child(explosion)
	explosion._inicio(12,80,40)
	ente.queue_free()

func ChequeoFueraPantalla():
	if fuera_de_pantalla:
		#Si está en el aire lo elimina:
		if not ente.is_on_floor():
			ente.emit_signal("Muere")
			ente.queue_free()
			return
		
		#Si está en suelo, pasa a estado de suspensión:
		ente.get_node("VisibilityNotifier_version_modificada").ProcesarNodos(true)
		
func LogicaMorir(cantida_dagno,quien):
	var ente = get_parent() as Ente
	#print(cantida_dagno)
	ente.set_vitalidad(ente.get_vitalidad() - cantida_dagno) 
	
	if ente.vitalidad <= 0:

		poner_estado_deferred(estados.muerte)
##SEÑALES:==================================================
func _on_animacion_termina(animacion:String):
	match animacion:
		"Shoot_New","Missile_shoot":
			poner_estado_deferred("patrullar")
		
	pass

#Un jugador entra en la zona de vision:
func _on_Area_detecta_jugador_body_entered(body):
	objetivo_en_area = true
	
	match estado:
		estados.patrullar:
			var timer:SceneTreeTimer = get_tree().create_timer(rand_range(1.2,3.5))
			timer.connect("timeout",self,"PensarAtaque")
	pass # Replace with function body.


func _on_Area_detecta_jugador_body_exited(body):
	objetivo_en_area = false
	pass # Replace with function body.


func _on_VisibilityNotifier_version_modificada_screen_exited():
	print("NPC 2 fuera de pantalla")
	fuera_de_pantalla = true
	
	var timer:SceneTreeTimer = get_tree().create_timer(3.0)
	timer.connect("timeout",self,"ChequeoFueraPantalla")
	
	pass # Replace with function body.


func _on_VisibilityNotifier_version_modificada_screen_entered():
	print("NPC2 entra en pantalla")
	fuera_de_pantalla = false
	
	ente.get_node("VisibilityNotifier_version_modificada").ProcesarNodos(false)
	
	pass # Replace with function body.
